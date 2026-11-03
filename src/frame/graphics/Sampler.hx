package frame.graphics;

import frame.backend.Backend;
import frame.backend.BackendSampler;

enum abstract SamplerFilter(Int) to Int {
    var Nearest = 0;
    var Linear = 1;
}

enum abstract SamplerMipmapMode(Int) to Int {
    var Nearest = 0;
    var Linear = 1;
}

enum abstract SamplerAddressMode(Int) to Int {
    var Repeat = 0;
    var MirroredRepeat = 1;
    var ClampToEdge = 2; 
}

abstract Sampler(BackendSampler) to BackendSampler {
    public function new(filter:SamplerFilter, mipmap:SamplerMipmapMode, address:SamplerAddressMode, maxAnisotropy:Int) {
        this = Backend.gpu.loadSampler(filter, mipmap, address, maxAnisotropy);
    }

    public function destroy() {
        Backend.gpu.unloadSampler(this);
    }
}
