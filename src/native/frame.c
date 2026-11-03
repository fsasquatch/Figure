#include "frame.h"
#include <SDL3/SDL_gpu.h>
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#define frame_MAX_WINDOWS 12
#define frame_MAX_RENDERPASS 8

typedef struct frame_array {
    void* array;
    size_t element_size;
    size_t size;
    size_t used;
} frame_array;

typedef struct frame_internal_window {
    int window_width, window_height;
    const char* window_title;

    bool is_running;
    bool is_resizable;
    bool is_fullscreen;
    bool is_maximized;
    bool is_minimized;
    bool is_focused;
    bool was_resized;
    bool vsync;

    SDL_Window* sdl_window;
    SDL_WindowID sdl_window_id;
} frame_internal_window;

typedef struct frame_internal_application {
    frame_internal_window windows[frame_MAX_WINDOWS];
    bool exit;
    SDL_Surface* window_icon;

    bool debug;

    Uint64 last_ticks;
    Uint64 new_ticks;
    double frame_time;
    int window_fps_cap;
    bool is_fps_capped;

    bool current_key_state[512];
    bool previous_key_state[512];

    bool current_mouse_state[4];
    bool previous_mouse_state[4];
    int current_mouse_x;
    int current_mouse_y;
    float current_mouse_wheel_delta_x;
    float current_mouse_wheel_delta_y;
 
    SDL_Event event;
    
    bool gpu_device_created;
    SDL_GPUDevice* gpu_device;
    SDL_GPUTexture* swapchain_tex;
    SDL_GPUTexture* depth_texture;
    SDL_GPUCommandBuffer* command_buffer;
    SDL_GPUCopyPass* copy_pass;
    SDL_GPURenderPass* render_passes[frame_MAX_RENDERPASS];
    int active_render_pass;
    frame_array current_vertex_attribs;
} frame_internal_application;

static int window_counter = 0;
static bool frame_app_created = false;
frame_internal_application frame_app;

int vertex_data_size = 0;
SDL_FColor clear_color = {0, 0, 0, 1};
bool copy_pass_active = false;
Uint64 rendering_time_start;
Uint64 rendering_time_end;
SDL_GPUTextureFormat depth_texture_format = SDL_GPU_TEXTUREFORMAT_D24_UNORM;

SDL_GPUTransferBuffer* storage_transfer_buffers[32];
SDL_GPUBuffer* storage_buffers[32];
int storage_buffer_count = 0;

void frame_init_array(frame_array* a, size_t elem_size, size_t init_size);
void frame_free_array(frame_array* a);
void frame_push_int_to_array(frame_array* a, int element);
void frame_push_va_to_array(frame_array* a, SDL_GPUVertexAttribute element);

// ----------------------------
// SECTION: System 
// ----------------------------

int frame_create_window(int width, int height, const char* title, bool debug, const char* driver) {
    if(!frame_app_created) {
        frame_app = (frame_internal_application) {0};
        frame_app_created = true;
        frame_app.debug = debug;
        frame_init_array(&(frame_app.current_vertex_attribs), sizeof(SDL_GPUVertexAttribute), 3);
    }

    if(window_counter > frame_MAX_WINDOWS) {
        SDL_Log("Cannot create more than %d windows. To increase it change the define in dough_internal.h and recompile the library.", frame_MAX_WINDOWS);
        return -1;
    }

    int window_id = window_counter;
    window_counter++;

    frame_internal_window window = {0}; 
    window.window_width = width;
    window.window_height = height;
    window.window_title = title;

    if(!SDL_Init(SDL_INIT_VIDEO | SDL_INIT_GAMEPAD)) {
        SDL_Log("Failed to load SDL: %s", SDL_GetError());
    }

    int window_flags = SDL_WINDOW_OPENGL; 
    window.sdl_window = SDL_CreateWindow(window.window_title, window.window_width, window.window_height, window_flags);
    if(window.sdl_window == NULL) {
        SDL_Log("Failed to create window: %s", SDL_GetError());
    }
    window.sdl_window_id = SDL_GetWindowID(window.sdl_window);
    window.is_running = true; 

    if(!frame_app.gpu_device_created) {
        frame_app.gpu_device = SDL_CreateGPUDevice(SDL_GPU_SHADERFORMAT_SPIRV | SDL_GPU_SHADERFORMAT_MSL | SDL_GPU_SHADERFORMAT_DXIL, frame_app.debug, driver);
        frame_app.gpu_device_created = true;
        frame_app.depth_texture = SDL_CreateGPUTexture(frame_app.gpu_device, &(SDL_GPUTextureCreateInfo){
            .layer_count_or_depth=1,
            .format = SDL_GPU_TEXTUREFORMAT_D24_UNORM,
            .usage = SDL_GPU_TEXTUREUSAGE_DEPTH_STENCIL_TARGET,
            .width = window.window_width,
            .height = window.window_height,
            .num_levels = 1,
        });
    }
    if(frame_app.gpu_device == NULL) {
        SDL_Log("Failed to create GPU device: %s", SDL_GetError());
    }
    if(!SDL_ClaimWindowForGPUDevice(frame_app.gpu_device, window.sdl_window)) {
        SDL_Log("Failed to claim window for GPU device: %s", SDL_GetError());
    }

    // TODO: Implement switching between SDR, SDR_LINEAR, HDR
    SDL_GPUPresentMode presentMode = SDL_WindowSupportsGPUPresentMode(frame_app.gpu_device, window.sdl_window, SDL_GPU_PRESENTMODE_MAILBOX) ? SDL_GPU_PRESENTMODE_MAILBOX : SDL_GPU_PRESENTMODE_VSYNC;
    SDL_SetGPUSwapchainParameters(frame_app.gpu_device, window.sdl_window, SDL_GPU_SWAPCHAINCOMPOSITION_SDR, presentMode);

    frame_app.last_ticks = SDL_GetTicks(); // Does this need to be here?

    frame_app.windows[window_id] = window;
    return window_id;
}

void frame_destroy_window(int window_id) {
    SDL_WaitForGPUIdle(frame_app.gpu_device);

    if(frame_app.windows[window_id].sdl_window != NULL) {
        SDL_ReleaseWindowFromGPUDevice(frame_app.gpu_device, frame_app.windows[window_id].sdl_window);
        SDL_DestroyWindow(frame_app.windows[window_id].sdl_window);
    }

    // Should the array element be removed now?
    // Is that even a thing in c? I should learn c properly tbh
    // Or use a nicer c-like language :thonk:
    // Zig and Rust really look really good...
    // Update: No they don't
    // Update: I hate haxe.
    if(frame_app.exit) {
        for(int i = 0;i<=frame_MAX_WINDOWS;i++) {
            if(frame_app.windows[i].sdl_window != NULL) {
                SDL_DestroySurface(frame_app.window_icon);
                SDL_ReleaseGPUTexture(frame_app.gpu_device, frame_app.depth_texture);
                SDL_ReleaseGPUTexture(frame_app.gpu_device, frame_app.swapchain_tex);
                SDL_ReleaseWindowFromGPUDevice(frame_app.gpu_device, frame_app.windows[i].sdl_window);
                SDL_DestroyWindow(frame_app.windows[i].sdl_window);
            }
        }

        frame_free_array(&(frame_app.current_vertex_attribs));
        SDL_DestroyGPUDevice(frame_app.gpu_device);
        SDL_Quit();
    }
}

bool frame_is_window_running(int window_id) {
    return frame_app.windows[window_id].is_running;
}

void frame_set_window_running(int window_id, bool running) {
    frame_app.windows[window_id].is_running = running;
}

int frame_get_window_width(int window_id) {
    return frame_app.windows[window_id].window_width;
}

int frame_get_window_height(int window_id) {
    return frame_app.windows[window_id].window_height;
}

bool frame_set_window_size(int window_id, int width, int height) {
    return SDL_SetWindowSize(frame_app.windows[window_id].sdl_window, width, height);
}

int frame_get_window_x(int window_id) {
    int x, y = 0;
    SDL_GetWindowPosition(frame_app.windows[window_id].sdl_window, &x, &y);
    return x; 
}

int frame_get_window_y(int window_id) {
    int x, y = 0;
    SDL_GetWindowPosition(frame_app.windows[window_id].sdl_window, &x, &y);
    return y; 
}

bool frame_set_window_position(int window_id, int x, int y) {
    return SDL_SetWindowPosition(frame_app.windows[window_id].sdl_window, x, y);
}

int frame_get_current_display(int window_id) {
    return SDL_GetDisplayForWindow(frame_app.windows[window_id].sdl_window);
}

bool frame_set_current_display(int window_id, int display) {
    SDL_Rect rect = {0};
    SDL_GetDisplayUsableBounds(display, &rect);
    int x = rect.x + ((rect.w - frame_app.windows[window_id].window_width) / 2);
    int y = rect.y + ((rect.h - frame_app.windows[window_id].window_height) / 2);
    return SDL_SetWindowPosition(frame_app.windows[window_id].sdl_window, x, y);
}

int frame_get_primary_display() {
    if(frame_app.gpu_device == NULL) SDL_Log("f");
    return SDL_GetPrimaryDisplay();
}

bool frame_is_window_fullscreen(int window_id) {
    return frame_app.windows[window_id].is_fullscreen;
}

// TODO: Exclusive fullscreen mode
// Currently it always defaults to borderless
bool frame_toggle_fullscreen(int window_id, bool borderless) {
    frame_app.windows[window_id].is_fullscreen = !frame_app.windows[window_id].is_fullscreen;
    SDL_SetWindowFullscreen(frame_app.windows[window_id].sdl_window, frame_app.windows[window_id].is_fullscreen);
    SDL_SyncWindow(frame_app.windows[window_id].sdl_window);
    return true;
}

bool frame_is_window_minimized(int window_id) {
    return frame_app.windows[window_id].is_minimized; 
}

bool frame_minimize_window(int window_id) {
    return SDL_MinimizeWindow(frame_app.windows[window_id].sdl_window);
}

bool frame_is_window_maximized(int window_id) {
    return frame_app.windows[window_id].is_maximized;
}

bool frame_maximize_window(int window_id) {
    return SDL_MaximizeWindow(frame_app.windows[window_id].sdl_window);
}

bool frame_restore_window(int window_id) {
    return SDL_RestoreWindow(frame_app.windows[window_id].sdl_window);
}

bool frame_raise_window(int window_id) {
    return SDL_RaiseWindow(frame_app.windows[window_id].sdl_window);
}

bool frame_is_window_resizable(int window_id) {
    return frame_app.windows[window_id].is_resizable;
}

bool frame_set_window_resizable(int window_id, bool resizable) {
    frame_app.windows[window_id].is_resizable = resizable;
    return SDL_SetWindowResizable(frame_app.windows[window_id].sdl_window, resizable);
}

bool frame_was_window_resized(int window_id) {
    return frame_app.windows[window_id].was_resized;
}

bool frame_is_window_focused(int window_id) {
    return frame_app.windows[window_id].is_focused;
}

bool frame_focus_window(int window_id) {
    SDL_RaiseWindow(frame_app.windows[window_id].sdl_window);
    return true;
}

void frame_set_window_icon(const char* icon) {
    frame_app.window_icon = SDL_LoadSurface(icon);
    SDL_SetWindowIcon(frame_app.windows[0].sdl_window, frame_app.window_icon);
}

bool frame_poll_window_events() {
    return SDL_PollEvent(&frame_app.event);
}

void frame_handle_window_events(int window_id) {
    frame_app.windows[window_id].was_resized = false;
    
    if(frame_app.event.window.windowID == frame_app.windows[window_id].sdl_window_id) {
        switch(frame_app.event.type) {
            case SDL_EVENT_QUIT:
                frame_app.exit = true;
            case SDL_EVENT_WINDOW_CLOSE_REQUESTED:
                frame_app.windows[window_id].is_running = false;
            case SDL_EVENT_WINDOW_RESIZED:
                if(frame_app.event.window.data1 > 0 || frame_app.event.window.data2 > 0) frame_app.windows[window_id].was_resized = true;
            case SDL_EVENT_WINDOW_FOCUS_GAINED:
                frame_app.windows[window_id].is_focused = true;
            case SDL_EVENT_WINDOW_FOCUS_LOST:
                frame_app.windows[window_id].is_focused = false;
            default:
                break;
        }
    }
}

void frame_handle_input_events() {
    for(int i = 0; i <= 512; i++) frame_app.previous_key_state[i] = frame_app.current_key_state[i]; 
    for(int i = 0; i <= 4; i++) frame_app.previous_mouse_state[i] = frame_app.current_mouse_state[i]; 

    switch(frame_app.event.type) {
        case SDL_EVENT_KEY_DOWN:
            frame_app.current_key_state[frame_app.event.key.scancode] = true;
            break;
        case SDL_EVENT_KEY_UP:
            frame_app.current_key_state[frame_app.event.key.scancode] = false;
            break;
        case SDL_EVENT_MOUSE_BUTTON_DOWN:
            frame_app.current_mouse_state[frame_app.event.button.button] = true;
            break;
        case SDL_EVENT_MOUSE_BUTTON_UP:
            frame_app.current_mouse_state[frame_app.event.button.button] = false;
            break;
        case SDL_EVENT_MOUSE_WHEEL:
            frame_app.current_mouse_wheel_delta_x = frame_app.event.wheel.x;
            frame_app.current_mouse_wheel_delta_y = frame_app.event.wheel.y;
            break;
        case SDL_EVENT_MOUSE_MOTION:
            frame_app.current_mouse_x = frame_app.event.motion.x;
            frame_app.current_mouse_y = frame_app.event.motion.y;
            break;
    }
}

void frame_set_fps_cap(int fps) {
    frame_app.window_fps_cap = fps;
}

void frame_enable_fps_cap() {
    frame_app.is_fps_capped = true;
}

void frame_disable_fps_cap() {
    frame_app.is_fps_capped = false;
}

bool frame_is_fps_capped() {
    return frame_app.is_fps_capped;
}

float frame_get_display_content_scale(int display) {
    return SDL_GetDisplayContentScale(display);
}

float frame_get_window_display_scale(int window_id) {
    return SDL_GetWindowDisplayScale(frame_app.windows[window_id].sdl_window);
}

float frame_get_window_pixel_density(int window_id) {
    return SDL_GetWindowPixelDensity(frame_app.windows[window_id].sdl_window);
}

const char* frame_get_platform_name() {
    return SDL_GetPlatform();
}

bool frame_is_cursor_shown() {
    return SDL_CursorVisible();
}

void frame_show_cursor() {
    SDL_ShowCursor();
}

void frame_hide_cursor() {
    SDL_HideCursor();
}

void frame_lock_cursor(int window_id) {
    SDL_SetWindowMouseGrab(frame_app.windows[window_id].sdl_window, true);
}

void frame_unlock_cursor(int window_id) {
    SDL_SetWindowMouseGrab(frame_app.windows[window_id].sdl_window, false);
}

void frame_set_clipboard_text(const char* text) {
    SDL_SetClipboardText(text);
}

const char* frame_get_clipboard_text() {
    return SDL_GetClipboardText();
}

double frame_get_frame_time() {
    return frame_app.frame_time;
}

double frame_get_elapsed_time() {
    return -1;
}

bool frame_is_key_down(int key) {
    return frame_app.current_key_state[key];
}

bool frame_is_key_just_down(int key) {
    return frame_app.previous_key_state[key] == false && frame_app.current_key_state[key] == true;
}

bool frame_is_key_released(int key) {
    return frame_app.previous_key_state[key] == true && frame_app.current_key_state[key] == false;
}

// TODO: Gamepads

bool frame_is_mouse_button_down(int button) {
    return frame_app.current_mouse_state[button];
}

bool frame_is_mouse_button_just_down(int button) {
    return frame_app.previous_mouse_state[button] == false && frame_app.current_key_state[button] == true;
}

bool frame_is_mouse_button_released(int button) {
    return frame_app.previous_mouse_state[button] == true && frame_app.current_key_state[button] == false;
}

int frame_get_mouse_position_x() {
    return frame_app.current_mouse_x;
}

int frame_get_mouse_position_y() {
    return frame_app.current_mouse_y;
}

void frame_set_mouse_position(int window_id, int x, int y) {
    SDL_WarpMouseInWindow(frame_app.windows[window_id].sdl_window, x, y);
}

float frame_get_mouse_wheel_movement_x() {
    return frame_app.current_mouse_wheel_delta_x;
}

float frame_get_mouse_wheel_movement_y() {
    return frame_app.current_mouse_wheel_delta_y;
}

void frame_set_mouse_cursor(int cursor) {
    // TODO: System cursors
}

void frame_init_array(frame_array* a, size_t elem_size, size_t init_size) {
    a->array = SDL_malloc(init_size * elem_size);
    if(a->array == NULL) {
        SDL_Log("Failed to allocate array");
    }
    a->used = 0;
    a->size = init_size;
    a->element_size = elem_size;
}

void frame_free_array(frame_array* a) {
    SDL_free(a->array);
    a->array = NULL;
    a->used = a->size = 0;
}

void frame_push_int_to_array(frame_array* a, int element) {
    if(a->used == a->size) {
        a->size *= 2;
        a->array = SDL_realloc(a->array, a->size * a->element_size);
        if(a->array == NULL) {
            SDL_Log("Failed to reallocate array");
        }
    }
    SDL_memcpy(&((int*)a->array)[a->used], &element, a->element_size);    
    a->used++;
}

void frame_push_va_to_array(frame_array* a, SDL_GPUVertexAttribute element) {
    if(a->used == a->size) {
        a->size *= 2;
        a->array = SDL_realloc(a->array, a->size * a->element_size);
        if(a->array == NULL) {
            SDL_Log("Failed to reallocate array");
        }
    }
    SDL_memcpy(&((SDL_GPUVertexAttribute*)a->array)[a->used], &element, a->element_size);    
    a->used++;
}

// ----------------------------
// SECTION: GPU
// ----------------------------

void frame_begin_render() {
    frame_app.new_ticks = SDL_GetTicks();
    frame_app.frame_time = ((double)(frame_app.new_ticks - frame_app.last_ticks)) / 1000;
    frame_app.last_ticks = frame_app.new_ticks;

    rendering_time_start = SDL_GetTicksNS();
    frame_app.command_buffer = SDL_AcquireGPUCommandBuffer(frame_app.gpu_device);
    if(frame_app.command_buffer == NULL) {
        SDL_Log("Failed to acquire command buffer: %s", SDL_GetError());
    }
}

void frame_end_render() {
    SDL_SubmitGPUCommandBuffer(frame_app.command_buffer);

    // this is soooo stupid
    // UPDATE: is it?
    rendering_time_end = SDL_GetTicksNS();
    Uint64 diff = rendering_time_end - rendering_time_start;
    const Uint64 fps_cap = 1000000000 / frame_app.window_fps_cap;
    if(frame_app.is_fps_capped && diff < fps_cap) {
        Uint64 sleep_time = fps_cap - diff;
        SDL_DelayNS(sleep_time);

        diff = SDL_GetTicksNS();
    }
}

void frame_set_clear_color(float r, float g, float b, float a) {
    clear_color = (SDL_FColor){r, g, b, a};
}

void frame_begin_render_pass(int window_id, int render_pass_id, SDL_GPUTexture* color_target, SDL_GPUTexture* depth_target) {
    if(!SDL_WaitAndAcquireGPUSwapchainTexture(frame_app.command_buffer, frame_app.windows[window_id].sdl_window, &frame_app.swapchain_tex, NULL, NULL)) {
        SDL_Log("Failed to acquire swapchain texture: %s", SDL_GetError());
    }
    if(frame_app.swapchain_tex != NULL) {
        SDL_GPUColorTargetInfo colorTargetInfo = {0};
        colorTargetInfo.clear_color = clear_color; 
        if(color_target != NULL) colorTargetInfo.texture = color_target;
        else colorTargetInfo.texture = frame_app.swapchain_tex;
        colorTargetInfo.load_op =  SDL_GPU_LOADOP_CLEAR;
        colorTargetInfo.store_op = SDL_GPU_STOREOP_STORE;

        SDL_GPUDepthStencilTargetInfo depthTargetInfo = {0};
        if(depth_target != NULL) depthTargetInfo.texture = depth_target;
        else depthTargetInfo.texture = frame_app.depth_texture;
        depthTargetInfo.load_op = SDL_GPU_LOADOP_CLEAR;
        depthTargetInfo.clear_depth = 1;
        depthTargetInfo.store_op = SDL_GPU_STOREOP_STORE;

        frame_app.render_passes[render_pass_id] = SDL_BeginGPURenderPass(frame_app.command_buffer, &colorTargetInfo, 1, &depthTargetInfo);
    }
    frame_app.active_render_pass = render_pass_id;
}

void frame_end_render_pass(int render_pass_id) {
    if(frame_app.swapchain_tex != NULL) SDL_EndGPURenderPass(frame_app.render_passes[render_pass_id]);
    frame_app.active_render_pass = -1;
}

void frame_begin_copy_pass() {
    frame_app.command_buffer = SDL_AcquireGPUCommandBuffer(frame_app.gpu_device);
    frame_app.copy_pass = SDL_BeginGPUCopyPass(frame_app.command_buffer);
    copy_pass_active = true;
}

void frame_end_copy_pass() {
    SDL_EndGPUCopyPass(frame_app.copy_pass);
    SDL_SubmitGPUCommandBuffer(frame_app.command_buffer);
    copy_pass_active = false;
}

SDL_GPUBuffer* frame_load_vertex_buffer(void* data, int size, bool cycle) {
    SDL_GPUBuffer* vertex_buffer = SDL_CreateGPUBuffer(frame_app.gpu_device, &(SDL_GPUBufferCreateInfo){
        .usage = SDL_GPU_BUFFERUSAGE_VERTEX,
        .size = size
    });

    SDL_GPUTransferBuffer* transfer_buffer = SDL_CreateGPUTransferBuffer(frame_app.gpu_device, &(SDL_GPUTransferBufferCreateInfo) {
        .usage = SDL_GPU_TRANSFERBUFFERUSAGE_UPLOAD,
        .size = size
    });

    void* transfer_data = SDL_MapGPUTransferBuffer(frame_app.gpu_device, transfer_buffer, false);
    SDL_memcpy(transfer_data, data, size);
    SDL_UnmapGPUTransferBuffer(frame_app.gpu_device, transfer_buffer);

    if(cycle) {
        frame_app.copy_pass = SDL_BeginGPUCopyPass(frame_app.command_buffer);
        SDL_UploadToGPUBuffer(frame_app.copy_pass, &(SDL_GPUTransferBufferLocation) {
            .transfer_buffer = transfer_buffer,
            .offset = 0
        }, &(SDL_GPUBufferRegion) {
            .buffer = vertex_buffer,
            .offset = 0,
            .size = size
        }, true);
        SDL_EndGPUCopyPass(frame_app.copy_pass);
        SDL_ReleaseGPUTransferBuffer(frame_app.gpu_device, transfer_buffer);
        return vertex_buffer;
    }

    if(copy_pass_active) {
        SDL_UploadToGPUBuffer(frame_app.copy_pass, &(SDL_GPUTransferBufferLocation) {
            .transfer_buffer = transfer_buffer,
            .offset = 0
        }, &(SDL_GPUBufferRegion) {
            .buffer = vertex_buffer,
            .offset = 0,
            .size = size
        }, false);
    } else {
        frame_begin_copy_pass();
        SDL_UploadToGPUBuffer(frame_app.copy_pass, &(SDL_GPUTransferBufferLocation) {
            .transfer_buffer = transfer_buffer,
            .offset = 0
        }, &(SDL_GPUBufferRegion) {
            .buffer = vertex_buffer,
            .offset = 0,
            .size = size
        }, false);
        frame_end_copy_pass();
    }
    
    SDL_ReleaseGPUTransferBuffer(frame_app.gpu_device, transfer_buffer);

    return vertex_buffer;
}

SDL_GPUBuffer* frame_load_index_buffer(void* data, int size, bool cycle) {
    SDL_GPUBuffer* index_buffer = SDL_CreateGPUBuffer(frame_app.gpu_device, &(SDL_GPUBufferCreateInfo){
        .usage = SDL_GPU_BUFFERUSAGE_INDEX,
        .size = size
    });

    SDL_GPUTransferBuffer* transfer_buffer = SDL_CreateGPUTransferBuffer(frame_app.gpu_device, &(SDL_GPUTransferBufferCreateInfo) {
        .usage = SDL_GPU_TRANSFERBUFFERUSAGE_UPLOAD,
        .size = size
    });

    void* transfer_data = SDL_MapGPUTransferBuffer(frame_app.gpu_device, transfer_buffer, false);
    SDL_memcpy(transfer_data, data, size);
    SDL_UnmapGPUTransferBuffer(frame_app.gpu_device, transfer_buffer);

    if(cycle) {
        frame_app.copy_pass = SDL_BeginGPUCopyPass(frame_app.command_buffer);
        SDL_UploadToGPUBuffer(frame_app.copy_pass, &(SDL_GPUTransferBufferLocation) {
            .transfer_buffer = transfer_buffer,
            .offset = 0
        }, &(SDL_GPUBufferRegion) {
            .buffer = index_buffer,
            .offset = 0,
            .size = size
        }, true);
        SDL_EndGPUCopyPass(frame_app.copy_pass);
        SDL_ReleaseGPUTransferBuffer(frame_app.gpu_device, transfer_buffer);
        return index_buffer;
    }

    if(copy_pass_active) {
        SDL_UploadToGPUBuffer(frame_app.copy_pass, &(SDL_GPUTransferBufferLocation) {
            .transfer_buffer = transfer_buffer,
            .offset = 0
        }, &(SDL_GPUBufferRegion) {
            .buffer = index_buffer,
            .offset = 0,
            .size = size
        }, false);
    } else {
        frame_begin_copy_pass();
        SDL_UploadToGPUBuffer(frame_app.copy_pass, &(SDL_GPUTransferBufferLocation) {
            .transfer_buffer = transfer_buffer,
            .offset = 0
        }, &(SDL_GPUBufferRegion) {
            .buffer = index_buffer,
            .offset = 0,
            .size = size
        }, false);
        frame_end_copy_pass();
    }

    SDL_ReleaseGPUTransferBuffer(frame_app.gpu_device, transfer_buffer);
    
    return index_buffer;
}

int frame_create_storage_buffer(int size) {
    if(storage_buffer_count > 16) {
        // TODO: Check if any slot in the array is free and use that
        SDL_Log("Cannot create storage buffer");
        return -1;
    }

    int id = storage_buffer_count;
    storage_transfer_buffers[id] = SDL_CreateGPUTransferBuffer(frame_app.gpu_device, &(SDL_GPUTransferBufferCreateInfo) {
            .usage = SDL_GPU_TRANSFERBUFFERUSAGE_UPLOAD,
            .size = size
    });

    storage_buffers[id] = SDL_CreateGPUBuffer(frame_app.gpu_device, &(SDL_GPUBufferCreateInfo) {.usage = SDL_GPU_BUFFERUSAGE_GRAPHICS_STORAGE_READ, .size = size}); 

    storage_buffer_count++;
    return id;
}

void frame_load_storage_buffer(int buffer, void* data, int size) {
    void* transfer_data = SDL_MapGPUTransferBuffer(frame_app.gpu_device, storage_transfer_buffers[buffer], false);
    SDL_memcpy(transfer_data, data, size);
    SDL_UnmapGPUTransferBuffer(frame_app.gpu_device, storage_transfer_buffers[buffer]);

    if(copy_pass_active) {
        SDL_UploadToGPUBuffer(frame_app.copy_pass, &(SDL_GPUTransferBufferLocation) {
            .transfer_buffer = storage_transfer_buffers[buffer],
            .offset = 0
        }, &(SDL_GPUBufferRegion) {
            .buffer = storage_buffers[buffer],
            .offset = 0,
            .size = size
        }, true);
    } else {
        frame_app.copy_pass = SDL_BeginGPUCopyPass(frame_app.command_buffer);
        SDL_UploadToGPUBuffer(frame_app.copy_pass, &(SDL_GPUTransferBufferLocation) {
            .transfer_buffer = storage_transfer_buffers[buffer],
            .offset = 0
        }, &(SDL_GPUBufferRegion) {
            .buffer = storage_buffers[buffer],
            .offset = 0,
            .size = size
        }, true);
        SDL_EndGPUCopyPass(frame_app.copy_pass);
    }
} 

void frame_unload_buffer(SDL_GPUBuffer* buffer) {
    SDL_ReleaseGPUBuffer(frame_app.gpu_device, buffer);
}

void frame_unload_storage_buffer(int buffer) {
    SDL_ReleaseGPUBuffer(frame_app.gpu_device, storage_buffers[buffer]);
    SDL_ReleaseGPUTransferBuffer(frame_app.gpu_device, storage_transfer_buffers[buffer]); 
}

SDL_GPUTexture* frame_create_texture(int width, int height, int format, int usage, int mip, int layers, int type) {
    int tex_usage = usage == 0 ? SDL_GPU_TEXTUREUSAGE_COLOR_TARGET : SDL_GPU_TEXTUREUSAGE_DEPTH_STENCIL_TARGET;
    int tex_formt = format == 0 ? SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM : SDL_GPU_TEXTUREFORMAT_D24_UNORM;
    int tex_type = type == 0 ? SDL_GPU_TEXTURETYPE_2D : SDL_GPU_TEXTURETYPE_CUBE;

    return SDL_CreateGPUTexture(frame_app.gpu_device, &(SDL_GPUTextureCreateInfo) {
            .type = SDL_GPU_TEXTURETYPE_2D,
            .format = tex_formt,
            .usage = SDL_GPU_TEXTUREUSAGE_SAMPLER | tex_usage,
            .width = width,
            .height = height,
            .layer_count_or_depth = layers,
            .num_levels = mip
            });
}

SDL_GPUTexture* frame_load_texture_from_bytes(void* data, int width, int height, int mip, int layers, int type) {
    int tex_type = type == 0 ? SDL_GPU_TEXTURETYPE_2D : SDL_GPU_TEXTURETYPE_CUBE;
    SDL_GPUTexture* texture = SDL_CreateGPUTexture(frame_app.gpu_device, &(SDL_GPUTextureCreateInfo) {
        .type = tex_type,
        .format = SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM,
        .usage = SDL_GPU_TEXTUREUSAGE_SAMPLER,
        .width = width,
        .height = height,
        .layer_count_or_depth = layers,
        .num_levels = mip
    });

    int size = width * height * 4; // 4 because 1byte per pixel in R8G8B8A8
    SDL_GPUTransferBuffer* transfer_buffer = SDL_CreateGPUTransferBuffer(frame_app.gpu_device, &(SDL_GPUTransferBufferCreateInfo) {
        .usage = SDL_GPU_TRANSFERBUFFERUSAGE_UPLOAD,
        .size = size 
    });

    void* transfer_data = SDL_MapGPUTransferBuffer(frame_app.gpu_device, transfer_buffer, false);
    SDL_memcpy(transfer_data, data, size);
    SDL_UnmapGPUTransferBuffer(frame_app.gpu_device, transfer_buffer);

    if(copy_pass_active) {
        SDL_UploadToGPUTexture(frame_app.copy_pass, &(SDL_GPUTextureTransferInfo) {
            .transfer_buffer = transfer_buffer,
        }, &(SDL_GPUTextureRegion) {
            .texture = texture,
            .w = width,
            .h = height,
            .d = 1
        }, false);
    } else {
        frame_begin_copy_pass();
        SDL_UploadToGPUTexture(frame_app.copy_pass, &(SDL_GPUTextureTransferInfo) {
            .transfer_buffer = transfer_buffer,
        }, &(SDL_GPUTextureRegion) {
            .texture = texture,
            .w = width,
            .h = height,
            .d = 1
        }, false);
        if(mip > 1) SDL_GenerateMipmapsForGPUTexture(frame_app.command_buffer, texture);
        frame_end_copy_pass();
    }

    SDL_ReleaseGPUTransferBuffer(frame_app.gpu_device, transfer_buffer);

    return texture;
}

SDL_GPUTexture* frame_load_texture_from_file(const char* file) {
    int image_width, image_height;
    stbi_set_flip_vertically_on_load(0);
    void* image_data = stbi_load(file, &image_width, &image_height, NULL, 4);
    return frame_load_texture_from_bytes(image_data, image_width, image_height, 1, 1, 0);
}

void frame_unload_texture(SDL_GPUTexture* texture) {
    SDL_ReleaseGPUTexture(frame_app.gpu_device, texture);
}

SDL_GPUSampler* frame_load_sampler(int filter, int mipmap_mode, int address_mode, int max_anisotropy) {
    int mag;
    int mip;
    int addr;
    bool enable_anisotropy = false;
    if(max_anisotropy > 0) enable_anisotropy = true;

    if(filter == 0) mag = SDL_GPU_FILTER_NEAREST;
    else if(filter == 1) mag = SDL_GPU_FILTER_LINEAR;
    else SDL_Log("ERROR: Invalid filter");

    if(mipmap_mode == 0) mip = SDL_GPU_SAMPLERMIPMAPMODE_NEAREST;
    else if(mipmap_mode == 1) mip = SDL_GPU_SAMPLERMIPMAPMODE_LINEAR;
    else SDL_Log("ERROR: Invalid mipmap mode");

    if(address_mode == 0) addr = SDL_GPU_SAMPLERADDRESSMODE_REPEAT;
    else if(address_mode == 1) addr = SDL_GPU_SAMPLERADDRESSMODE_CLAMP_TO_EDGE;
    else if(address_mode ==  2) addr = SDL_GPU_SAMPLERADDRESSMODE_MIRRORED_REPEAT;
    else SDL_Log("ERROR: Invalid mipmap mode");

    SDL_GPUSampler* sampler = SDL_CreateGPUSampler(frame_app.gpu_device, &(SDL_GPUSamplerCreateInfo) {
        .min_filter = mag,
        .mag_filter = mag,
        .mipmap_mode = mip,
        .address_mode_u = addr,
        .address_mode_v = addr,
        .address_mode_w = addr,
        .enable_anisotropy = enable_anisotropy,
        .max_anisotropy = max_anisotropy
    });
    return sampler;
}

void frame_unload_sampler(SDL_GPUSampler* sampler) {
    SDL_ReleaseGPUSampler(frame_app.gpu_device, sampler);
}

SDL_GPUShader* frame_load_shader_from_bytes(void* data, int size, int stage, Uint32 sampler_count, Uint32 uniform_buffer_count, Uint32 storage_buffer_count, Uint32 storage_texture_count) {
    SDL_GPUShaderStage s;
    if(stage == 0) s = SDL_GPU_SHADERSTAGE_VERTEX;
    else if(stage == 1) s = SDL_GPU_SHADERSTAGE_FRAGMENT;
    else {
        SDL_Log("Invalid shader stage");
        return NULL;
    }

    SDL_GPUShaderFormat backend_formats = SDL_GetGPUShaderFormats(frame_app.gpu_device);
    SDL_GPUShaderFormat format = SDL_GPU_SHADERFORMAT_INVALID;
    const char* entrypoint;

    if(backend_formats & SDL_GPU_SHADERFORMAT_SPIRV) {
        format = SDL_GPU_SHADERFORMAT_SPIRV;
        entrypoint = "main";
    } else if(backend_formats & SDL_GPU_SHADERFORMAT_MSL) {
        format = SDL_GPU_SHADERFORMAT_MSL;
        entrypoint = "main0";
    } else if(backend_formats & SDL_GPU_SHADERFORMAT_DXIL) {
        format = SDL_GPU_SHADERFORMAT_DXIL;
        entrypoint = "main";
    } else {
        SDL_Log("Unrecognized shader format!");
        return NULL;
    }

    SDL_GPUShaderCreateInfo shader_create_info = {
        .code = data,
        .code_size = size,
        .format = format,
        .stage = s,
        .num_samplers = sampler_count,
        .num_uniform_buffers = uniform_buffer_count,
        .num_storage_textures = storage_texture_count,
        .num_storage_buffers = storage_buffer_count
    };
    SDL_GPUShader* shader = SDL_CreateGPUShader(frame_app.gpu_device, &shader_create_info);
    if(shader == NULL) {
        SDL_Log("Failed to create shader: %s", SDL_GetError());
        return NULL;
    }
    
    return shader;
}

SDL_GPUShader* frame_load_shader_from_file(const char* file, int stage, Uint32 sampler_count, Uint32 uniform_buffer_count, Uint32 storage_buffer_count, Uint32 storage_texture_count) {
    size_t code_size;
    void* code = SDL_LoadFile(file, &code_size);
    if(code == NULL) {
        SDL_Log("Failed to load shader from file: %s", file);
        return NULL;
    }
    
    SDL_GPUShader* shader = frame_load_shader_from_bytes(code, code_size, stage, sampler_count, uniform_buffer_count, storage_buffer_count, storage_texture_count);
    SDL_free(code);

    return shader;
}

void frame_unload_shader(SDL_GPUShader* shader) {
    SDL_ReleaseGPUShader(frame_app.gpu_device, shader);
}

void frame_set_vertex_data_size(int size) {
    vertex_data_size = size;
}

void frame_add_vertex_attribute(int element_format, int location, int offset) {
    int format = SDL_GPU_VERTEXELEMENTFORMAT_FLOAT3;
    // TODO: Enum?
    switch(element_format) {
        case 0:
            format = SDL_GPU_VERTEXELEMENTFORMAT_FLOAT;
            break;
        case 1:
            format = SDL_GPU_VERTEXELEMENTFORMAT_FLOAT2;
            break;
        case 2:
            format = SDL_GPU_VERTEXELEMENTFORMAT_FLOAT3;
            break;
        case 3:
            format = SDL_GPU_VERTEXELEMENTFORMAT_FLOAT4;
            break;
        case 4:
            format = SDL_GPU_VERTEXELEMENTFORMAT_BYTE4;
            break;
        case 5:
            format = SDL_GPU_VERTEXELEMENTFORMAT_UBYTE4;
            break;
        case 6:
            format = SDL_GPU_VERTEXELEMENTFORMAT_INT;
            break;
        case 7:
            format = SDL_GPU_VERTEXELEMENTFORMAT_UINT;
            break;
        case 8:
            format = SDL_GPU_VERTEXELEMENTFORMAT_INT2;
            break;
        default:
            SDL_Log("%i", element_format);
    }

    frame_push_va_to_array(&(frame_app.current_vertex_attribs), (SDL_GPUVertexAttribute){
        .buffer_slot = 0,
        .location = location,
        .format = format,
        .offset = offset
    });
}

int frame_blend_factor(int factor) {
    int srcColorBlendFactor = SDL_GPU_BLENDFACTOR_INVALID;
    switch(factor) {
        case 0:
            srcColorBlendFactor = SDL_GPU_BLENDFACTOR_INVALID;
            break;
        case 1:
            srcColorBlendFactor = SDL_GPU_BLENDFACTOR_ZERO;
            break;
        case 2:
            srcColorBlendFactor = SDL_GPU_BLENDFACTOR_ONE;
            break;
        case 3:
            srcColorBlendFactor = SDL_GPU_BLENDFACTOR_SRC_COLOR;
            break;
        case 4:
            srcColorBlendFactor = SDL_GPU_BLENDFACTOR_ONE_MINUS_SRC_COLOR;
            break;
        case 5:
            srcColorBlendFactor = SDL_GPU_BLENDFACTOR_DST_COLOR;
            break;
        case 6:
            srcColorBlendFactor = SDL_GPU_BLENDFACTOR_ONE_MINUS_DST_COLOR;
            break;
        case 7:
            srcColorBlendFactor =  SDL_GPU_BLENDFACTOR_SRC_ALPHA;
            break;
        case 8:
            srcColorBlendFactor = SDL_GPU_BLENDFACTOR_ONE_MINUS_SRC_ALPHA;
            break;
        case 9:
            srcColorBlendFactor = SDL_GPU_BLENDFACTOR_DST_ALPHA;
            break;
        case 10:
            srcColorBlendFactor = SDL_GPU_BLENDFACTOR_ONE_MINUS_DST_ALPHA;
            break;
        case 11:
            srcColorBlendFactor = SDL_GPU_BLENDFACTOR_CONSTANT_COLOR;
            break;
        case 12:
            srcColorBlendFactor = SDL_GPU_BLENDFACTOR_ONE_MINUS_CONSTANT_COLOR;
            break;
        case 13:
            srcColorBlendFactor = SDL_GPU_BLENDFACTOR_SRC_ALPHA_SATURATE;
            break;
    }
    return srcColorBlendFactor;
}

int frame_blend_op(int op) {
    int ret = SDL_GPU_BLENDOP_INVALID;
    switch(op) {
        case 0:
            ret = SDL_GPU_BLENDOP_INVALID;
            break;
        case 1:
            ret = SDL_GPU_BLENDOP_ADD;
            break;
        case 2:
            ret = SDL_GPU_BLENDOP_SUBTRACT;
            break;
        case 3:
            ret = SDL_GPU_BLENDOP_REVERSE_SUBTRACT;
            break;
        case 4:
            ret = SDL_GPU_BLENDOP_MIN;
            break;
        case 5:
            ret = SDL_GPU_BLENDOP_MAX;
            break;
    }
    return ret;
}

// This api is so bad...
// Maybe I'll rewrite this
// Or not, no one's going to be using this except me sooo :)
SDL_GPUGraphicsPipeline* frame_load_graphics_pipeline(SDL_GPUShader* vertex_shader, SDL_GPUShader* fragment_shader, bool depth_test, bool enable_blend, int src_color_blend_factor, int dst_color_blend_factor, int color_blend_op, int src_alpha_blend_factor, int dst_alpha_blend_factor, int alpha_blend_op) {
    int srcColorBlendFactor = frame_blend_factor(src_color_blend_factor);
    int dstColorBlendFactor = frame_blend_factor(dst_color_blend_factor);
    int srcAlphaBlendFactor = frame_blend_factor(src_alpha_blend_factor);
    int dstAlphaBlendFactor = frame_blend_factor(dst_alpha_blend_factor);
    int colorBlendOp = frame_blend_op(color_blend_op);
    int alphaBlendOp = frame_blend_op(alpha_blend_op); 

    SDL_GPUGraphicsPipelineCreateInfo pipeline_create_info = {
        .vertex_shader = vertex_shader,
        .fragment_shader = fragment_shader,
        .vertex_input_state = {
            .num_vertex_buffers = 1,
            .vertex_buffer_descriptions = (SDL_GPUVertexBufferDescription[]) {
                {
                    .slot = 0,
                    .pitch = vertex_data_size,
                    .input_rate = SDL_GPU_VERTEXINPUTRATE_VERTEX
                }
            },
            .num_vertex_attributes = frame_app.current_vertex_attribs.used,
            .vertex_attributes = frame_app.current_vertex_attribs.array
        },
        .target_info = {
            .num_color_targets = 1,
            .color_target_descriptions= (SDL_GPUColorTargetDescription[]) {
                {
                    .format = SDL_GetGPUSwapchainTextureFormat(frame_app.gpu_device, frame_app.windows[0].sdl_window),
                    .blend_state = {
                        .enable_blend = enable_blend,
                        .src_color_blendfactor  = srcColorBlendFactor,
                        .dst_color_blendfactor  = dstColorBlendFactor,
                        .color_blend_op         = colorBlendOp,
                        .src_alpha_blendfactor  = srcAlphaBlendFactor,
                        .dst_alpha_blendfactor  = dstAlphaBlendFactor,
                        .alpha_blend_op         = alphaBlendOp,
                    }
                }
            },
            .has_depth_stencil_target = true,
            .depth_stencil_format= depth_texture_format
        },
        .primitive_type = SDL_GPU_PRIMITIVETYPE_TRIANGLELIST,
        .depth_stencil_state = {
            .enable_depth_test = depth_test,
            .enable_depth_write = depth_test,
            .compare_op = SDL_GPU_COMPAREOP_LESS,
        },
    };
    SDL_GPUGraphicsPipeline* pipeline = SDL_CreateGPUGraphicsPipeline(frame_app.gpu_device, &pipeline_create_info);

    frame_free_array(&frame_app.current_vertex_attribs);
    frame_init_array(&(frame_app.current_vertex_attribs), sizeof(SDL_GPUVertexAttribute), 3);

    return pipeline;
}

void frame_unload_graphics_pipeline(SDL_GPUGraphicsPipeline* pipeline) {
    SDL_ReleaseGPUGraphicsPipeline(frame_app.gpu_device, pipeline);
}

void frame_set_graphics_pipeline(SDL_GPUGraphicsPipeline* pipeline) {
    SDL_BindGPUGraphicsPipeline(frame_app.render_passes[frame_app.active_render_pass], pipeline);
}

// TODO: Handling multiple buffer bindings
// IDK what that means to be honest.
void frame_set_vertex_buffer(SDL_GPUBuffer* buffer) {
    SDL_BindGPUVertexBuffers(frame_app.render_passes[frame_app.active_render_pass], 0, &(SDL_GPUBufferBinding){.buffer = buffer, .offset = 0}, 1);
}

// TODO: Allow multiple formats
void frame_set_index_buffer(SDL_GPUBuffer* buffer) {
    SDL_BindGPUIndexBuffer(frame_app.render_passes[frame_app.active_render_pass], &(SDL_GPUBufferBinding){.buffer = buffer, .offset = 0}, SDL_GPU_INDEXELEMENTSIZE_16BIT);
}

void frame_set_storage_buffer(int buffer) {
    SDL_BindGPUVertexStorageBuffers(frame_app.render_passes[frame_app.active_render_pass], 0,  &storage_buffers[buffer],1);
}

void frame_set_vertex_uniform_data(int slot, void* data, int size) {
    SDL_PushGPUVertexUniformData(frame_app.command_buffer, slot, data, size);
}

void frame_set_fragment_uniform_data(int slot, void* data, int size) {
    SDL_PushGPUFragmentUniformData(frame_app.command_buffer, slot, data, size);
}

void frame_set_fragment_sampler(SDL_GPUTexture* texture, SDL_GPUSampler* sampler) {
    SDL_BindGPUFragmentSamplers(frame_app.render_passes[frame_app.active_render_pass], 0, &(SDL_GPUTextureSamplerBinding){.texture = texture, .sampler = sampler}, 1);
}

void frame_draw_primitives(int vertices, int instances) {
    SDL_DrawGPUPrimitives(frame_app.render_passes[frame_app.active_render_pass], vertices, instances, 0, 0);
}

void frame_draw_indexed_primitives(int indices, int instances) {
    SDL_DrawGPUIndexedPrimitives(frame_app.render_passes[frame_app.active_render_pass], indices, instances, 0, 0, 0);
}
