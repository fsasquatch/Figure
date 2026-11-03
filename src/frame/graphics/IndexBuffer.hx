package frame.graphics;

import haxe.io.Bytes;
import frame.backend.Backend;
import frame.backend.BackendBuffer;

abstract IndexBuffer(BackendBuffer) to BackendBuffer {
    public inline function new(data:Bytes, cycle:Bool = false) {
        this = Backend.gpu.loadIndexBuffer(data, cycle);
    }

    public inline function destroy() {
        Backend.gpu.unloadBuffer(this);
    }

    public inline function use() {
        Backend.gpu.setIndexBuffer(this);
    }
}