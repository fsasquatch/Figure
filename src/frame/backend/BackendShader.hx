package frame.backend;

#if js
typedef BackendShader = js.html.webgl.Shader;
#else
typedef BackendShader = frame.native.Frame.NativeShader;
#end
