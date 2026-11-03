package frame.graphics;

import haxe.io.Bytes;
import frame.backend.Backend;
import frame.backend.BackendShader;

enum abstract ShaderType(Int) to Int {
    var Vertex = 0;
    var Fragment = 1;
    var Compute = 2;
}

abstract Shader(BackendShader) to BackendShader {
    public extern inline overload function new(file:String, type:ShaderType, info:ShaderInformation) {
        this = Backend.gpu.loadShaderFromFile(file, type, info); 
    }

    public extern inline overload function new(data:Bytes, type:ShaderType, info:ShaderInformation) {
        this = Backend.gpu.loadShaderFromBytes(data, data.length, type, info); 
    }

    public inline function destroy() {
        Backend.gpu.unloadShader(this);
    }
}
