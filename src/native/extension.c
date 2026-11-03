#define HL_NAME(n) figure_##n
#include <hl.h>
#include "frame.h"

#define _GPU_BUFFER _ABSTRACT(sdl_gpubuffer)
#define _GPU_TEXTURE _ABSTRACT(sdl_gputexture)
#define _GPU_SAMPLER _ABSTRACT(sdl_gpusampler)
#define _GPU_SHADER _ABSTRACT(sdl_gpushader)
#define _GPU_GRAPHICS_PIPELINE _ABSTRACT(sdl_gpugraphicspipeline)

// ----------------------------
// SECTION: System 
// ----------------------------

HL_PRIM int HL_NAME(create_window)(int width, int height, vstring* title, bool debug, const char* driver) {
    return frame_create_window(width, height, hl_to_utf8(title->bytes), debug, driver);
}
DEFINE_PRIM(_I32, create_window, _I32 _I32 _STRING _BOOL _STRING);

HL_PRIM void HL_NAME(destroy_window)(int window_id) {
   frame_destroy_window(window_id);
}
DEFINE_PRIM(_VOID, destroy_window, _I32);

HL_PRIM bool HL_NAME(is_window_running)(int window_id) {
    return frame_is_window_running(window_id);
}
DEFINE_PRIM(_BOOL, is_window_running, _I32);

HL_PRIM void HL_NAME(set_window_running)(int window_id, bool running) {
    frame_set_window_running(window_id, running);
}
DEFINE_PRIM(_VOID, set_window_running, _I32 _BOOL);

HL_PRIM int HL_NAME(get_window_width)(int window_id) {
    return frame_get_window_width(window_id);
}
DEFINE_PRIM(_I32, get_window_width, _I32);

HL_PRIM int HL_NAME(get_window_height)(int window_id) {
    return frame_get_window_height(window_id);
}
DEFINE_PRIM(_I32, get_window_height, _I32);

HL_PRIM bool HL_NAME(set_window_size)(int window_id, int width, int height) {
    return frame_set_window_size(window_id, width, height);
}
DEFINE_PRIM(_BOOL, set_window_size, _I32 _I32 _I32);

HL_PRIM int HL_NAME(get_window_x)(int window_id) {
    return frame_get_window_x(window_id);
}
DEFINE_PRIM(_I32, get_window_x, _I32);

HL_PRIM int HL_NAME(get_window_y)(int window_id) {
    return frame_get_window_y(window_id);
}
DEFINE_PRIM(_I32, get_window_y, _I32);

HL_PRIM bool HL_NAME(set_window_position)(int window_id, int x, int y) {
    return frame_set_window_position(window_id, x, y);
}
DEFINE_PRIM(_BOOL, set_window_position, _I32 _I32 _I32);

HL_PRIM int HL_NAME(get_current_display)(int window_id) {
    return frame_get_current_display(window_id);
}
DEFINE_PRIM(_I32, get_current_display, _I32);

HL_PRIM bool HL_NAME(set_current_display)(int window_id, int display) {
    return frame_set_current_display(window_id, display);
}
DEFINE_PRIM(_BOOL, set_current_display, _I32 _I32);

HL_PRIM int HL_NAME(get_primary_display)() {
    return frame_get_primary_display();
}
DEFINE_PRIM(_I32, get_primary_display, _NO_ARG);

HL_PRIM bool HL_NAME(is_window_fullscreen)(int window_id) {
    return frame_is_window_fullscreen(window_id);
}
DEFINE_PRIM(_BOOL, is_window_fullscreen, _I32);

HL_PRIM bool HL_NAME(toggle_fullscreen)(int window_id, bool borderless) {
    return frame_toggle_fullscreen(window_id, borderless);
}
DEFINE_PRIM(_BOOL, toggle_fullscreen, _I32 _BOOL);

HL_PRIM bool HL_NAME(is_window_minimized)(int window_id) {
    return frame_is_window_minimized(window_id);
}
DEFINE_PRIM(_BOOL, is_window_minimized, _I32);

HL_PRIM bool HL_NAME(minimize_window)(int window_id) {
    return frame_minimize_window(window_id);
}
DEFINE_PRIM(_BOOL, minimize_window, _I32);

HL_PRIM bool HL_NAME(is_window_maximized)(int window_id) {
    return frame_is_window_maximized(window_id);
}
DEFINE_PRIM(_BOOL, is_window_maximized, _I32);

HL_PRIM bool HL_NAME(maximize_window)(int window_id) {
    return frame_maximize_window(window_id);
}
DEFINE_PRIM(_BOOL, maximize_window, _I32);

HL_PRIM bool HL_NAME(restore_window)(int window_id) {
    return frame_restore_window(window_id);
}
DEFINE_PRIM(_BOOL, restore_window, _I32);

HL_PRIM bool HL_NAME(raise_window)(int window_id) {
    return frame_raise_window(window_id);
}
DEFINE_PRIM(_BOOL, raise_window, _I32);

HL_PRIM bool HL_NAME(is_window_resizable)(int window_id) {
    return frame_is_window_resizable(window_id);
}
DEFINE_PRIM(_BOOL, is_window_resizable, _I32);

HL_PRIM bool HL_NAME(set_window_resizable)(int window_id, bool resizable) {
    return frame_set_window_resizable(window_id, resizable);
}
DEFINE_PRIM(_BOOL, set_window_resizable, _I32 _BOOL);

HL_PRIM bool HL_NAME(was_window_resized)(int window_id) {
    return frame_was_window_resized(window_id);
}
DEFINE_PRIM(_BOOL, was_window_resized, _I32);

HL_PRIM bool HL_NAME(is_window_focused)(int window_id) {
    return frame_is_window_focused(window_id);
}
DEFINE_PRIM(_BOOL, is_window_focused, _I32);

HL_PRIM bool HL_NAME(focus_window)(int window_id) {
    return frame_focus_window(window_id);
}
DEFINE_PRIM(_BOOL, focus_window, _I32);

HL_PRIM void HL_NAME(set_window_icon)(vstring* icon) {
    frame_set_window_icon(hl_to_utf8(icon->bytes));
}
DEFINE_PRIM(_VOID, set_window_icon, _STRING);

HL_PRIM bool HL_NAME(poll_window_events)() {
    return frame_poll_window_events();
}
DEFINE_PRIM(_BOOL, poll_window_events, _NO_ARG);

HL_PRIM void HL_NAME(handle_window_events)(int window_id) {
    frame_handle_window_events(window_id);
}
DEFINE_PRIM(_VOID, handle_window_events, _I32);

HL_PRIM void HL_NAME(handle_input_events)() {
    frame_handle_input_events();
}
DEFINE_PRIM(_VOID, handle_input_events, _NO_ARG);

HL_PRIM void HL_NAME(set_fps_cap)(int fps) {
    frame_set_fps_cap(fps);
}
DEFINE_PRIM(_VOID, set_fps_cap, _I32);

HL_PRIM void HL_NAME(enable_fps_cap)() {
    frame_enable_fps_cap();
}
DEFINE_PRIM(_VOID, enable_fps_cap, _NO_ARG);

HL_PRIM void HL_NAME(disable_fps_cap)() {
    frame_disable_fps_cap();
}
DEFINE_PRIM(_VOID, disable_fps_cap, _NO_ARG);

HL_PRIM bool HL_NAME(is_fps_capped)() {
    return frame_is_fps_capped(); 
}
DEFINE_PRIM(_BOOL, is_fps_capped, _NO_ARG);

HL_PRIM float HL_NAME(get_display_content_scale)(int display) {
    return frame_get_display_content_scale(display);
}
DEFINE_PRIM(_F32, get_display_content_scale, _I32);

HL_PRIM float HL_NAME(get_window_display_scale)(int window_id) {
    return frame_get_window_display_scale(window_id);
}
DEFINE_PRIM(_F32, get_window_display_scale, _I32);

HL_PRIM float HL_NAME(get_window_pixel_density)(int window_id) {
    return frame_get_window_pixel_density(window_id);
}
DEFINE_PRIM(_F32, get_window_pixel_density, _I32);

HL_PRIM vbyte* HL_NAME(get_platform_name)() {
    const uchar* utext = (uchar *)frame_get_platform_name();

    hl_buffer* b = hl_alloc_buffer();
    hl_buffer_str(b, utext);
    vbyte* string = (vbyte *)hl_buffer_content(b, NULL);

    return string;
}
DEFINE_PRIM(_BYTES, get_platform_name, _NO_ARG);

HL_PRIM bool HL_NAME(is_cursor_shown)() {
    return frame_is_cursor_shown();
}
DEFINE_PRIM(_BOOL, is_cursor_shown, _NO_ARG);

HL_PRIM void HL_NAME(show_cursor)() {
    frame_show_cursor();
}
DEFINE_PRIM(_VOID, show_cursor, _NO_ARG);

HL_PRIM void HL_NAME(hide_cursor)() {
    frame_hide_cursor();
}
DEFINE_PRIM(_VOID, hide_cursor, _NO_ARG);

HL_PRIM void HL_NAME(lock_cursor)(int window_id) {
    frame_lock_cursor(window_id);
}
DEFINE_PRIM(_VOID, lock_cursor, _I32);

HL_PRIM void HL_NAME(unlock_cursor)(int window_id) {
    frame_unlock_cursor(window_id);
}
DEFINE_PRIM(_VOID, unlock_cursor, _I32);

HL_PRIM void HL_NAME(set_clipboard_text)(vstring* text) {
    frame_set_clipboard_text(hl_to_utf8(text->bytes));
}
DEFINE_PRIM(_VOID, set_clipboard_text, _STRING);

HL_PRIM vbyte* HL_NAME(get_clipboard_text)() {
    const uchar* utext = (uchar *)frame_get_clipboard_text();

    hl_buffer* b = hl_alloc_buffer();
    hl_buffer_str(b, utext);
    vbyte* string = (vbyte *)hl_buffer_content(b, NULL);

    return string;
}
DEFINE_PRIM(_BYTES, get_clipboard_text, _NO_ARG);

HL_PRIM double HL_NAME(get_frame_time)() {
    return frame_get_frame_time(); 
}
DEFINE_PRIM(_F64, get_frame_time, _NO_ARG);

HL_PRIM double HL_NAME(get_elapsed_time)() {
    return frame_get_elapsed_time();
}
DEFINE_PRIM(_F64, get_elapsed_time, _NO_ARG);

HL_PRIM bool HL_NAME(is_key_down)(int key) {
    return frame_is_key_down(key);
}
DEFINE_PRIM(_BOOL, is_key_down, _I32);

HL_PRIM bool HL_NAME(is_key_just_down)(int key) {
    return frame_is_key_just_down(key);
}
DEFINE_PRIM(_BOOL, is_key_just_down, _I32);

HL_PRIM bool HL_NAME(is_key_released)(int key) {
    return frame_is_key_released(key);
}
DEFINE_PRIM(_BOOL, is_key_released, _I32);

// GAMEPADS

HL_PRIM bool HL_NAME(is_mouse_button_down)(int button) {
    return frame_is_mouse_button_down(button);
}
DEFINE_PRIM(_BOOL, is_mouse_button_down, _I32);

HL_PRIM bool HL_NAME(is_mouse_button_just_down)(int button) {
    return frame_is_mouse_button_just_down(button);
}
DEFINE_PRIM(_BOOL, is_mouse_button_just_down, _I32);

HL_PRIM bool HL_NAME(is_mouse_button_released)(int button) {
    return frame_is_mouse_button_released(button);
}
DEFINE_PRIM(_BOOL, is_mouse_button_released, _I32);

HL_PRIM int HL_NAME(get_mouse_position_x)() {
    return frame_get_mouse_position_x();
}
DEFINE_PRIM(_I32, get_mouse_position_x, _NO_ARG);

HL_PRIM int HL_NAME(get_mouse_position_y)() {
    return frame_get_mouse_position_y();
}
DEFINE_PRIM(_I32, get_mouse_position_y, _NO_ARG);

HL_PRIM void HL_NAME(set_mouse_position)(int window_id, int x, int y) {
    frame_set_mouse_position(window_id, x, y);
}
DEFINE_PRIM(_VOID, set_mouse_position, _I32 _I32 _I32);

HL_PRIM float HL_NAME(get_mouse_wheel_movement_x)() {
    return frame_get_mouse_wheel_movement_x();
}
DEFINE_PRIM(_F32, get_mouse_wheel_movement_x, _NO_ARG);

HL_PRIM float HL_NAME(get_mouse_wheel_movement_y)() {
    return frame_get_mouse_wheel_movement_y();
}
DEFINE_PRIM(_F32, get_mouse_wheel_movement_y, _NO_ARG);

HL_PRIM void HL_NAME(set_mouse_cursor)(int cursor) {
    frame_set_mouse_cursor(cursor);
}
DEFINE_PRIM(_VOID, set_mouse_cursor, _I32);

// ----------------------------
// SECTION: GPU
// ----------------------------

HL_PRIM void HL_NAME(begin_render)() {
    frame_begin_render();
}
DEFINE_PRIM(_VOID, begin_render, _NO_ARG);

HL_PRIM void HL_NAME(end_render)() {
    frame_end_render();
}
DEFINE_PRIM(_VOID, end_render, _NO_ARG);

HL_PRIM void HL_NAME(set_clear_color)(float r, float g, float b, float a) {
    frame_set_clear_color(r, g, b, a);
}
DEFINE_PRIM(_VOID, set_clear_color, _F32 _F32 _F32 _F32);

HL_PRIM void HL_NAME(begin_render_pass)(int window_id, int render_pass_id, SDL_GPUTexture* color, SDL_GPUTexture* depth) {
    frame_begin_render_pass(window_id, render_pass_id, color, depth);
}
DEFINE_PRIM(_VOID, begin_render_pass, _I32 _I32 _GPU_TEXTURE _GPU_TEXTURE);

HL_PRIM void HL_NAME(end_render_pass)(int render_pass_id) {
    frame_end_render_pass(render_pass_id);
}
DEFINE_PRIM(_VOID, end_render_pass, _I32);

HL_PRIM void HL_NAME(begin_copy_pass)() {
    frame_begin_copy_pass();
}
DEFINE_PRIM(_VOID, begin_copy_pass, _NO_ARG);

HL_PRIM void HL_NAME(end_copy_pass)() {
    frame_end_copy_pass();
}
DEFINE_PRIM(_VOID, end_copy_pass, _NO_ARG);

HL_PRIM SDL_GPUBuffer* HL_NAME(load_vertex_buffer)(void* data, int size, bool cycle) {
    return frame_load_vertex_buffer(data, size, cycle);
}
DEFINE_PRIM(_GPU_BUFFER, load_vertex_buffer, _BYTES _I32 _BOOL);

HL_PRIM SDL_GPUBuffer* HL_NAME(load_index_buffer)(void* data, int size, bool cycle) {
    return frame_load_index_buffer(data, size, cycle);
}
DEFINE_PRIM(_GPU_BUFFER, load_index_buffer, _BYTES _I32 _BOOL);

HL_PRIM int HL_NAME(create_storage_buffer)(int size) {
    return frame_create_storage_buffer(size);
}
DEFINE_PRIM(_I32, create_storage_buffer, _I32);

HL_PRIM void HL_NAME(load_storage_buffer)(int buffer, void* data, int size) {
    frame_load_storage_buffer(buffer, data, size);
}
DEFINE_PRIM(_VOID, load_storage_buffer, _I32 _BYTES _I32);

HL_PRIM void HL_NAME(unload_buffer)(SDL_GPUBuffer* buffer) {
    frame_unload_buffer(buffer);
}
DEFINE_PRIM(_VOID, unload_buffer, _GPU_BUFFER);

HL_PRIM void HL_NAME(unload_storage_buffer)(int buffer) {
    frame_unload_storage_buffer(buffer);
}
DEFINE_PRIM(_VOID, unload_storage_buffer, _I32);

HL_PRIM SDL_GPUTexture* HL_NAME(create_texture)(int width, int height, int format, int usage, int mip, int layers, int type) {
    return frame_create_texture(width, height, format, usage, mip, layers, type);
}  
DEFINE_PRIM(_GPU_TEXTURE, create_texture, _I32 _I32 _I32 _I32 _I32 _I32 _I32);

HL_PRIM SDL_GPUTexture* HL_NAME(load_texture_from_bytes)(void* data, int width, int height, int mip, int layers, int type) {
    return frame_load_texture_from_bytes(data, width, height, mip, layers, type);
}
DEFINE_PRIM(_GPU_TEXTURE, load_texture_from_bytes, _BYTES _I32 _I32 _I32 _I32 _I32);

HL_PRIM SDL_GPUTexture* HL_NAME(load_texture_from_file)(vstring* file) {
    return frame_load_texture_from_file(hl_to_utf8(file->bytes));
}
DEFINE_PRIM(_GPU_TEXTURE, load_texture_from_file, _STRING);

HL_PRIM void HL_NAME(unload_texture)(SDL_GPUTexture* texture) {
    frame_unload_texture(texture);
}
DEFINE_PRIM(_VOID, unload_texture, _GPU_TEXTURE);

HL_PRIM SDL_GPUSampler* HL_NAME(load_sampler)(int filter, int mipmap, int address, int anisotropy) {
    return frame_load_sampler(filter, mipmap, address, anisotropy); 
}
DEFINE_PRIM(_GPU_SAMPLER, load_sampler, _I32 _I32 _I32 _I32);

HL_PRIM void HL_NAME(unload_sampler)(SDL_GPUSampler* sampler) {
    frame_unload_sampler(sampler);
}
DEFINE_PRIM(_VOID, unload_sampler, _GPU_SAMPLER);

HL_PRIM SDL_GPUShader* HL_NAME(load_shader_from_bytes)(void* data, int size, int stage, Uint32 sampler_count, Uint32 uniform_buffer_count, Uint32 storage_buffer_count, Uint32 storage_texture_count) {
    return frame_load_shader_from_bytes(data, size, stage, sampler_count, uniform_buffer_count, storage_buffer_count, storage_texture_count);
}
DEFINE_PRIM(_GPU_SHADER, load_shader_from_bytes, _BYTES _I32 _I32 _I32 _I32 _I32 _I32);

HL_PRIM SDL_GPUShader* HL_NAME(load_shader_from_file)(vstring* file, int stage, Uint32 sampler_count, Uint32 uniform_buffer_count, Uint32 storage_buffer_count, Uint32 storage_texture_count) {
    return frame_load_shader_from_file(hl_to_utf8(file->bytes), stage, sampler_count, uniform_buffer_count, storage_buffer_count, storage_texture_count);
}
DEFINE_PRIM(_GPU_SHADER, load_shader_from_file, _STRING _I32 _I32 _I32 _I32 _I32);

HL_PRIM void HL_NAME(unload_shader)(SDL_GPUShader* shader) {
    frame_unload_shader(shader);
}
DEFINE_PRIM(_VOID, unload_shader, _GPU_SHADER);

HL_PRIM void HL_NAME(set_vertex_data_size)(int size) {
    frame_set_vertex_data_size(size);
}
DEFINE_PRIM(_VOID, set_vertex_data_size, _I32);

HL_PRIM void HL_NAME(add_vertex_attribute)(int element_format, int location, int offset) {
    frame_add_vertex_attribute(element_format, location, offset);
}
DEFINE_PRIM(_VOID, add_vertex_attribute, _I32 _I32 _I32);

HL_PRIM SDL_GPUGraphicsPipeline* HL_NAME(load_graphics_pipeline)(SDL_GPUShader* vertex, SDL_GPUShader* fragment, bool depth_test, bool enable_blend, int src_color_blend_factor, int dst_color_blend_factor, int color_blend_op, int src_alpha_blend_factor, int dst_alpha_blend_factor, int alpha_blend_op) {
    return frame_load_graphics_pipeline(vertex, fragment, depth_test, enable_blend, src_color_blend_factor, dst_color_blend_factor, color_blend_op, src_alpha_blend_factor, dst_alpha_blend_factor, alpha_blend_op);
}
DEFINE_PRIM(_GPU_GRAPHICS_PIPELINE, load_graphics_pipeline, _GPU_SHADER _GPU_SHADER _BOOL _BOOL _I32 _I32 _I32 _I32 _I32 _I32);

HL_PRIM void HL_NAME(unload_graphics_pipeline)(SDL_GPUGraphicsPipeline* pipeline) {
    frame_unload_graphics_pipeline(pipeline);
}
DEFINE_PRIM(_VOID, unload_graphics_pipeline, _GPU_GRAPHICS_PIPELINE);

HL_PRIM void HL_NAME(set_graphics_pipeline)(SDL_GPUGraphicsPipeline* pipeline) {
    frame_set_graphics_pipeline(pipeline);
}
DEFINE_PRIM(_VOID, set_graphics_pipeline, _GPU_GRAPHICS_PIPELINE);

HL_PRIM void HL_NAME(set_vertex_buffer)(SDL_GPUBuffer* buffer) {
    frame_set_vertex_buffer(buffer);
}
DEFINE_PRIM(_VOID, set_vertex_buffer, _GPU_BUFFER);

HL_PRIM void HL_NAME(set_index_buffer)(SDL_GPUBuffer* buffer) {
    frame_set_index_buffer(buffer);
}
DEFINE_PRIM(_VOID, set_index_buffer, _GPU_BUFFER);

HL_PRIM void HL_NAME(set_storage_buffer)(int buffer) {
    frame_set_storage_buffer(buffer);
}
DEFINE_PRIM(_VOID, set_storage_buffer, _I32);

HL_PRIM void HL_NAME(set_vertex_uniform_data)(int slot, void* data, int size) {
    frame_set_vertex_uniform_data(slot, data, size);
}
DEFINE_PRIM(_VOID, set_vertex_uniform_data, _I32 _BYTES _I32);

HL_PRIM void HL_NAME(set_fragment_uniform_data)(int slot, void* data, int size) {
    frame_set_fragment_uniform_data(slot, data, size);
}
DEFINE_PRIM(_VOID, set_fragment_uniform_data, _I32 _BYTES _I32);

HL_PRIM void HL_NAME(set_fragment_sampler)(SDL_GPUTexture* texture, SDL_GPUSampler* sampler) {
    frame_set_fragment_sampler(texture, sampler);
}
DEFINE_PRIM(_VOID, set_fragment_sampler, _GPU_TEXTURE _GPU_SAMPLER);

HL_PRIM void HL_NAME(draw_primitives)(int vertices, int instances) {
    frame_draw_primitives(vertices, instances);
}
DEFINE_PRIM(_VOID, draw_primitives, _I32 _I32);

HL_PRIM void HL_NAME(draw_indexed_primitives)(int indices, int instances) {
    frame_draw_indexed_primitives(indices, instances);
}
DEFINE_PRIM(_VOID, draw_indexed_primitives, _I32 _I32);

// ----------------------------
// SECTION: STORAGE & CONTENT
// ----------------------------
HL_PRIM void HL_NAME(convert_png_to_qoi)(vstring* file, vstring* out) {
    frame_convert_png_to_qoi(hl_to_utf8(file->bytes), hl_to_utf8(out->bytes));
}
DEFINE_PRIM(_VOID, convert_png_to_qoi, _STRING _STRING);