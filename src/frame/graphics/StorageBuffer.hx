package frame.graphics;

import frame.backend.Backend;
import haxe.io.Bytes;

abstract StorageBuffer(Int) to Int {
    public inline function new(size:Int)  {
        this = Backend.gpu.createStorageBuffer(size);
    }

    public inline function load(data:Bytes) {
        Backend.gpu.loadStorageBuffer(this, data);
    }

    public inline function use() {
        Backend.gpu.setStorageBuffer(this);
    }

    public inline function destroy() {
        Backend.gpu.unloadStorageBuffer(this);
    }
}
