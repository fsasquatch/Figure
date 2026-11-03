package frame.backend;

#if js
typedef Gpu = frame.backend.gpu.WebGL;
#elseif useGL4 
typedef Gpu = frame.backend.gpu.GL4;
#else
typedef Gpu = frame.backend.gpu.NativeGpu;
#end
