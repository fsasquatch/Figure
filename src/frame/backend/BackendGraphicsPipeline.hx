package frame.backend;

#if js
typedef BackendGraphicsPipeline = js.html.webgl.Program;
#else
typedef BackendGraphicsPipeline = frame.native.Frame.NativeGraphicsPipeline;
#end
