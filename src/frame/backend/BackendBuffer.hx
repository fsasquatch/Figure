package frame.backend;

#if js
typedef BackendBuffer = js.html.webgl.Buffer;
#else
typedef BackendBuffer = frame.native.Frame.NativeBuffer;
#end
