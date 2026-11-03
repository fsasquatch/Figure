package frame.graphics;

import haxe.io.Bytes;
import frame.backend.Backend;
import frame.backend.BackendBuffer;

abstract VertexBuffer(BackendBuffer) to BackendBuffer {
    public inline function new(data:Bytes, cycle:Bool = false) {
        this = Backend.gpu.loadVertexBuffer(data, cycle);
    }

    public inline function destroy() {
        Backend.gpu.unloadBuffer(this);
    }

    public inline function use() {
        Backend.gpu.setVertexBuffer(this);
    }
}