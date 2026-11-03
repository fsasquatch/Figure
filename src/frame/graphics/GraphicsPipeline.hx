package frame.graphics;

import frame.backend.BackendShader;
import frame.backend.BackendGraphicsPipeline;
import frame.backend.Backend;

abstract GraphicsPipeline(BackendGraphicsPipeline) to BackendGraphicsPipeline {
    public inline function new(vs:BackendShader, fs:BackendShader, input:VertexStructure, enableDepth:Bool, blendState:BlendState) {
        this = Backend.gpu.loadGraphicsPipeline(vs, fs, input, enableDepth, blendState);
    }

    public inline function destroy() {
        Backend.gpu.unloadGraphicsPipeline(this);
    }

    public inline function use() {
        Backend.gpu.setGraphicsPipeline(this);
    }
}
