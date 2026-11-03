package frame.backend;

#if js
typedef Audio = frame.backend.audio.WebAudio;
#else 
typedef Audio = frame.backend.audio.NativeAudio;
#end
