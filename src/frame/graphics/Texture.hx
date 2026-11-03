package frame.graphics;

import frame.backend.Backend;
import frame.backend.BackendTexture;

enum abstract TextureUsage(Int) to Int {
    var Color = 0;
    var DepthStencil = 1;
}

enum abstract TextureFormat(Int) to Int {
    var R8G8B8_Unorm = 0;
    var D24_Unorm = 1;
}

enum abstract TextureType(Int) to Int {
    var Tex2D = 0;
    var Cube = 1;
}

abstract Texture(BackendTexture) to BackendTexture {
    public extern inline overload function new(file:String) {
        this = Backend.gpu.loadTextureFromFile(file);
    }

    public extern inline overload function new(bytes:haxe.io.Bytes, width:Int, height:Int, mips:Int, layers:Int, type:TextureType) {
        this = Backend.gpu.loadTextureFromBytes(bytes, width, height, mips, layers, type);
    }

    public extern inline overload function new(width:Int, height:Int, format:TextureFormat, usage:TextureUsage, mips:Int, layers:Int, type:TextureType) {
        this = Backend.gpu.createTexture(width, height, format, usage, mips, layers, type);
    }

    public inline function use(sampler:Sampler) {
        Backend.gpu.setFragmentSampler(this, sampler);
    }

    public inline function destroy() {
        Backend.gpu.unloadTexture(this);
    }
}