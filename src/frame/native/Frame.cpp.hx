package frame.native;

import frame.graphics.Sampler;

@:include('frame.h')
@:native('SDL_GPUBuffer')
extern class _NativeBuffer {
}
typedef NativeBuffer = cpp.RawPointer<_NativeBuffer>;

@:include('frame.h')
@:native('SDL_GPUGraphicsPipeline')
@:structAccess
extern class _NativeGraphicsPipeline {
}
typedef NativeGraphicsPipeline = cpp.RawPointer<_NativeGraphicsPipeline>;

@:include('frame.h')
@:native('SDL_GPUShader')
@:structAccess
extern class _NativeShader{
}
typedef NativeShader = cpp.Struct<cpp.RawPointer<_NativeShader>>;

@:include('frame.h')
@:native('SDL_GPUSampler')
@:structAccess
extern class _NativeSampler {
}
typedef NativeSampler = cpp.Struct<cpp.RawPointer<_NativeSampler>>;

@:include('frame.h')
@:native('SDL_GPUTexture')
@:structAccess
extern class _NativeTexture {
}
typedef NativeTexture = cpp.Struct<cpp.RawPointer<_NativeTexture>>;

@:buildXml("<include name='${haxelib:figure}/build.xml'/>")
@:include('frame.h')
extern class Frame {
    @:native("frame_create_window") static function createWindow(width:Int, height:Int, title:String, debug:Bool, driver:String):Int;
    @:native("frame_destroy_window") static function destroyWindow(window:Int):Void;
    @:native("frame_is_window_running") static function isWindowRunning(window:Int):Bool;
    @:native("frame_set_window_running") static function setWindowRunning(window:Int, running:Bool):Void;
    @:native("frame_get_window_width") static function getWindowWidth(window:Int):Int;
    @:native("frame_get_window_height") static function getWindowHeight(window:Int):Int;
    @:native("frame_set_window_size") static function setWindowSize(window:Int, w:Int, h:Int):Bool;
    @:native("frame_get_window_x") static function getWindowX(window:Int):Int;
    @:native("frame_get_window_y") static function getWindowY(window:Int):Int;
    @:native("frame_set_window_position") static function setWindowPosition(window:Int, w:Int, h:Int):Bool;
    @:native("frame_get_current_display") static function getCurrentDisplay(window:Int):Int;
    @:native("frame_set_current_display") static function setCurrentDisplay(window:Int, display:Int):Bool;
    @:native("frame_get_primary_display") static function getPrimaryDisplay():Int;
    @:native("frame_is_window_fullscreen") static function isWindowFullscreen(window:Int):Bool;
    @:native("frame_toggle_fullscreen") static function toggleFullscreen(window:Int, borderless:Bool):Bool;
    @:native("frame_is_window_minimized") static function isWindowMinimized(window:Int):Bool;
    @:native("frame_minimize_window") static function minimizeWindow(window:Int):Bool;
    @:native("frame_is_window_maximized") static function isWindowMaximized(window:Int):Bool;
    @:native("frame_maximize_window") static function maximizeWindow(window:Int):Bool;
    @:native("frame_restore_window") static function restoreWindow(window:Int):Bool;
    @:native("frame_raise_window") static function raiseWindow(window:Int):Bool;
    @:native("frame_is_window_resizable") static function isWindowResizable(window:Int):Bool;
    @:native("frame_set_window_resizable") static function setWindowResizable(window:Int, resizable:Bool):Bool;
    @:native("frame_was_window_resized") static function wasWindowResized(window:Int):Bool;
    @:native("frame_is_window_focused") static function isWindowFocused(window:Int):Bool;
    @:native("frame_focus_window") static function focusWindow(window:Int):Bool;
    @:native("frame_set_window_icon") static function setWindowIcon(icon:String):Void;
    @:native("frame_poll_window_events") static function pollWindowEvents():Bool;
    @:native("frame_handle_window_events") static function handleWindowEvents(window:Int):Void;
    @:native("frame_handle_input_events") static function handleInputEvents():Void;
    @:native("frame_set_fps_cap") static function setFpsCap(fps:Int):Void;
    @:native("frame_enable_fps_cap") static function enableFpsCap():Void;
    @:native("frame_disable_fps_cap") static function disableFpsCap():Void;
    @:native("frame_is_fps_capped") static function isFpsCapped():Bool;
    @:native("frame_get_display_content_scale") static function getDisplayContentScale(display:Int):Single;
    @:native("frame_get_window_display_scale") static function getWindowDisplayScale(window:Int):Single;
    @:native("frame_get_window_pixel_density") static function getWindowPixelDensity(window:Int):Single; 
    @:noCompletion @:native("frame_get_platform_name") static function _getPlatformName():VoidPointer; 
    extern static inline function getPlatformName():String {
        return @:privateAccess _getPlatformName().toBytes().toString();
    }

    @:native("frame_is_cursor_shown") static function isCursorShown():Bool;
    @:native("frame_show_cursor") static function showCursor():Void;
    @:native("frame_hide_cursor") static function hideCursor():Void;
    @:native("frame_lock_cursor") static function lockCursor(window:Int):Void;
    @:native("frame_unlock_cursor") static function unlockCursor(window:Int):Void;

    @:native("frame_set_clipboard_text") static function setClipboardText(text:String):Void;
    @:noCompletion @:native("frame_get_clipboard_text") static function _getClipboardText():VoidPointer; 
    extern static inline function getClipboardText():String {
        return @:privateAccess _getClipboardText().toBytes().toString();
    }

    @:native("frame_get_frame_time") static function getFrameTime():Float;
    @:native("frame_get_elapsed_time") static function getElapsedTime():Float;

    @:native("frame_is_key_down") static function isKeyDown(key:Int):Bool;
    @:native("frame_is_key_just_down") static function isKeyJustDown(key:Int):Bool;
    @:native("frame_is_key_released") static function isKeyReleased(key:Int):Bool;

    // Gamepads

    @:native("frame_is_mouse_button_down") static function isMouseButtonDown(button:Int):Bool;
    @:native("frame_is_mouse_button_just_down") static function isMouseButtonJustDown(button:Int):Bool;
    @:native("frame_is_mouse_button_released") static function isMouseButtonReleased(button:Int):Bool; 

    @:native("frame_get_mouse_position_x") static function getMousePositionX():Int;
    @:native("frame_get_mouse_position_y") static function getMousePositionY():Int;
    @:native("frame_set_mouse_position") static function setMousePosition(window:Int, x:Int, y:Int):Void;
    @:native("frame_get_mouse_wheel_movement_x") static function getMouseWheelMovementX():Single;
    @:native("frame_get_mouse_wheel_movement_y") static function getMouseWheelMovementY():Single;
    @:native("frame_set_mouse_cursor") static function setMouseCursor(cursor:Int):Void;

    @:native("frame_begin_render") static function beginRender():Void;
    @:native("frame_end_render") static function endRender():Void;
    @:native("frame_set_clear_color") static function setClearColor(r:Single, g:Single, b:Single, a:Single):Void;
    @:native("frame_begin_render_pass") static function beginRenderPass(window:Int, renderPass:Int, color:NativeTexture, depth:NativeTexture):Void;
    @:native("frame_end_render_pass") static function endRenderPass(renderPass:Int):Void;

    @:native("frame_begin_copy_pass") static function beginCopyPass():Void;
    @:native("frame_end_copy_pass") static function endCopyPass():Void;

    @:native("frame_load_vertex_buffer") static function loadVertexBuffer(data:VoidPointer, size:Int, cycle:Bool):NativeBuffer;
    @:native("frame_load_index_buffer") static function loadIndexBuffer(data:VoidPointer, size:Int, cycle:Bool):NativeBuffer;
    @:native("frame_create_storage_buffer") static function createStorageBuffer(size:Int):Int;
    @:native("frame_load_storage_buffer") static function loadStorageBuffer(buffer:Int, data:VoidPointer, size:Int):Void;
    @:native("frame_unload_buffer") static function unloadBuffer(buffer:NativeBuffer):Void; 
    @:native("frame_unload_storage_buffer") static function unloadStorageBuffer(buffer:Int):Void;

    @:native("frame_create_texture") static function createTexture(width:Int, height:Int, format:Int, usage:Int, mip:Int, layers:Int, type:Int):NativeTexture; 
    @:native("frame_load_texture_from_bytes") static function loadTextureFromBytes(data:VoidPointer, width:Int, height:Int, mip:Int, layers:Int, type:Int):NativeTexture;
    @:native("frame_load_texture_from_file") static function loadTextureFromFile(file:String):NativeTexture;
    @:native("frame_unload_texture") static function unloadTexture(texture:NativeTexture):Void;

    @:native("frame_load_sampler") static function loadSampler(filter:SamplerFilter, mipmapMode:SamplerMipmapMode, addressMode:SamplerAddressMode, anisotropy:Int):NativeSampler;
    @:native("frame_unload_sampler") static function unloadSampler(sampler:NativeSampler):Void;

    @:native("frame_load_shader_from_bytes") static function loadShaderFromBytes(data:VoidPointer, size:Int, stage:Int, samplerCount:Int, uniformBufferCount:Int, storageBufferCount:Int, storageTextureCount:Int):NativeShader;
    @:native("frame_load_shader_from_file") static function loadShaderFromFile(file:String, stage:Int, samplerCount:Int, uniformBufferCount:Int, storageBufferCount:Int, storageTextureCount:Int):NativeShader;
    @:native("frame_unload_shader") static function unloadShader(shader:NativeShader):Void;

    @:native("frame_set_vertex_data_size") static function setVertexDataSize(size:Int):Void;
    @:native("frame_add_vertex_attribute") static function addVertexAttribute(elementFormat:Int, location:Int, offset:Int):Void;
    @:native("frame_load_graphics_pipeline") static function loadGraphicsPipeline(vertex:NativeShader, fragment:NativeShader, depthTest:Bool, enableBlend:Bool, srcColorBlendFactor:Int, dstColorBlendFactor:Int, colorBlendOp:Int, srcAlphaBlendFactor:Int, dstAlphaBlendFactor:Int, alphaBlendOp:Int):NativeGraphicsPipeline;
    @:native("frame_unload_graphics_pipeline") static function unloadGraphicsPipeline(pipeline:NativeGraphicsPipeline):Void;

    @:native("frame_set_graphics_pipeline") static function setGraphicsPipeline(pipeline:NativeGraphicsPipeline):Void;

    @:native("frame_set_vertex_buffer") static function setVertexBuffer(buffer:NativeBuffer):Void;
    @:native("frame_set_index_buffer") static function setIndexBuffer(buffer:NativeBuffer):Void;
    @:native("frame_set_storage_buffer") static function setStorageBuffer(buffer:Int):Void;

    @:native("frame_set_vertex_uniform_data") static function setVertexUniformData(slot:Int, data:VoidPointer, size:Int):Void;
    @:native("frame_set_fragment_uniform_data") static function setFragmentUniformData(slot:Int, data:VoidPointer, size:Int):Void;
    @:native("frame_set_fragment_sampler") static function setFragmentSampler(texture:NativeTexture, sampler:NativeSampler):Void;

    @:native("frame_draw_primitives") static function drawPrimitives(vertices:Int, instances:Int):Void;
    @:native("frame_draw_indexed_primitives") static function drawIndexedPrimitives(indices:Int, instances:Int):Void;
    
    @:native("frame_convert_png_to_qoi") static function convertPngToQoi(png:String, qoi:String):Void;
}
