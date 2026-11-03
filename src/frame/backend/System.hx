package frame.backend;

#if js
typedef System = frame.backend.system.WebSystem;
#else
typedef System = frame.backend.system.NativeSystem;
#end
