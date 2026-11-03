package frame.backend.gpu;

import frame.graphics.*;
import frame.graphics.Sampler;
import haxe.io.Bytes;

class EmptyGpu implements GpuApi {
    public function new() {}

    public function beginRender() {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function endRender() {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setClearColor(c:Color) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function beginRenderPass(window:Int, id:Int, colorTarget:BackendTexture, depthTarget:BackendTexture) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function endRenderPass(id:Int) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function beginCopyPass() {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function endCopyPass() {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function loadVertexBuffer(data:Bytes, cycle:Bool):BackendBuffer {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function loadIndexBuffer(data:Bytes, cycle:Bool):BackendBuffer {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function createStorageBuffer(size:Int):Int {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function loadStorageBuffer(buffer:Int, data:Bytes) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function unloadBuffer(buffer:BackendBuffer) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function unloadStorageBuffer(buffer:Int) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function loadTextureFromFile(file:String):BackendTexture {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function createTexture(width:Int, height:Int, format:Int, usage:Int, mip:Int, layers:Int, type:Int):BackendTexture {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function loadTextureFromBytes(bytes:haxe.io.Bytes, width:Int, height:Int, mip:Int, layers:Int, type:Int):BackendTexture {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function unloadTexture(t:BackendTexture) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function loadSampler(filter:SamplerFilter, mipmapMode:SamplerMipmapMode, addressMode:SamplerAddressMode, anisotropy:Int):BackendSampler {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function unloadSampler(sampler:BackendSampler) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function loadShaderFromFile(file:String, type:Int, info:frame.graphics.ShaderInformation):BackendShader {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function loadShaderFromBytes(data:haxe.io.Bytes, size:Int, type:Int, info:frame.graphics.ShaderInformation):BackendShader {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function unloadShader(shader:BackendShader) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function loadGraphicsPipeline(v:BackendShader, f:BackendShader, vs:VertexStructure, enableDepth:Bool, blendState:BlendState):BackendGraphicsPipeline {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function unloadGraphicsPipeline(pipeline:BackendGraphicsPipeline) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setGraphicsPipeline(pipeline:BackendGraphicsPipeline) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setVertexBuffer(buffer:BackendBuffer) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setIndexBuffer(buffer:BackendBuffer) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setStorageBuffer(buffer:Int) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setVertexUniformData(slot:Int, data:haxe.io.Bytes) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setFragmentUniformData(slot:Int, data:haxe.io.Bytes) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setFragmentSampler(texture:BackendTexture, sampler:BackendSampler) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function drawPrimitives(vertices:Int, instances:Int) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function drawIndexedPrimitives(indices:Int, instances:Int) {
        throw new haxe.exceptions.NotImplementedException();
    }
}