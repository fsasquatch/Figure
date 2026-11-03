package frame.backend;

#if js
typedef BackendSampler = js.html.webgl.Sampler;
#else
typedef BackendSampler = frame.native.Frame.NativeSampler;
#end
