package frame.backend;

#if js
typedef BackendTexture = js.html.webgl.Texture;
#else
typedef BackendTexture = frame.native.Frame.NativeTexture;
#end
