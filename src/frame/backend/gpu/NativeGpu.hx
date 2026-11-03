package frame.backend.gpu;

import haxe.io.Bytes;
import frame.native.Frame;
import frame.graphics.*;
import frame.graphics.Sampler;

class NativeGpu implements GpuApi {
    public function new() {}

    public function beginRender() {
        Frame.beginRender();
    }

    public function endRender() {
        Frame.endRender();
    }

    public function setClearColor(c:Color) {
        Frame.setClearColor(c.rF, c.gF, c.bF, c.aF);
    }

    public function beginRenderPass(window:Int, id:Int, colorTarget:BackendTexture, depthTarget:BackendTexture) {
        Frame.beginRenderPass(window, id, colorTarget, depthTarget);
    }

    public function endRenderPass(id:Int) {
        Frame.endRenderPass(id);
    }

    public function beginCopyPass() {
        Frame.beginCopyPass();
    }

    public function endCopyPass() {
        Frame.endCopyPass();
    }

    public function loadVertexBuffer(data:Bytes, cycle:Bool):BackendBuffer {
        return Frame.loadVertexBuffer(data, data.length, cycle);
    }

    public function loadIndexBuffer(data:Bytes, cycle:Bool):BackendBuffer {
        return Frame.loadIndexBuffer(data, data.length, cycle);
    }

    public function createStorageBuffer(size:Int):Int {
        return Frame.createStorageBuffer(size);
    }

    public function loadStorageBuffer(buffer:Int, data:Bytes) {
        Frame.loadStorageBuffer(buffer, data, data.length);
    }

    public function unloadBuffer(buffer:BackendBuffer) {
        Frame.unloadBuffer(buffer);
    }

    public function unloadStorageBuffer(buffer:Int) {
        Frame.unloadStorageBuffer(buffer);
    }

    public function loadTextureFromFile(file:String):BackendTexture {
        return Frame.loadTextureFromFile(file);
    }

    public function createTexture(width:Int, height:Int, format:Int, usage:Int, mip:Int, layers:Int, type:Int):BackendTexture {
        return Frame.createTexture(width, height, format, usage, mip, layers, type);
    }

    public function loadTextureFromBytes(bytes:haxe.io.Bytes, width:Int, height:Int, mip:Int, layers:Int, type:Int):BackendTexture {
        return Frame.loadTextureFromBytes(bytes, width, height, mip, layers, type);
    }

    public function unloadTexture(t:BackendTexture) {
        Frame.unloadTexture(t);
    }

    public function loadSampler(filter:SamplerFilter, mipmapMode:SamplerMipmapMode, addressMode:SamplerAddressMode, anisotropy:Int):BackendSampler {
        return Frame.loadSampler(filter, mipmapMode, addressMode, anisotropy);
    }

    public function unloadSampler(sampler:BackendSampler) {
        return Frame.unloadSampler(sampler);
    }

    public function loadShaderFromFile(file:String, type:Int, info:frame.graphics.ShaderInformation):BackendShader {
        return Frame.loadShaderFromFile(file, type, info.samplers, info.uniformBuffers, info.storageBuffers, info.storageTextures);
    }

    public function loadShaderFromBytes(data:haxe.io.Bytes, size:Int, type:Int, info:frame.graphics.ShaderInformation):BackendShader {
        return Frame.loadShaderFromBytes(data, size, type, info.samplers, info.uniformBuffers, info.storageBuffers, info.storageTextures);
    }

    public function unloadShader(shader:BackendShader) {
        Frame.unloadShader(shader);
    }

    public function loadGraphicsPipeline(v:BackendShader, f:BackendShader, vs:VertexStructure, enableDepth:Bool, blendState:BlendState):BackendGraphicsPipeline {
        Frame.setVertexDataSize(vs.size);
        for(e in vs.elements) {
            Frame.addVertexAttribute(e.e, e.l, e.o);
        }
        return Frame.loadGraphicsPipeline(v, f, enableDepth, blendState.enable, blendState.srcColorBlendFactor, blendState.dstColorBlendFactor, blendState.colorBlendOp, blendState.srcAlphaBlendFactor, blendState.dstAlphaBlendFactor, blendState.alphaBlendOp);
    }

    public function unloadGraphicsPipeline(pipeline:BackendGraphicsPipeline) {
        Frame.unloadGraphicsPipeline(pipeline);
    }

    public function setGraphicsPipeline(pipeline:BackendGraphicsPipeline) {
        Frame.setGraphicsPipeline(pipeline);
    }

    public function setVertexBuffer(buffer:BackendBuffer) {
        Frame.setVertexBuffer(buffer);
    }

    public function setIndexBuffer(buffer:BackendBuffer) {
        Frame.setIndexBuffer(buffer);
    }

    public function setStorageBuffer(buffer:Int) {
        Frame.setStorageBuffer(buffer);
    }

    public function setVertexUniformData(slot:Int, data:haxe.io.Bytes) {
        Frame.setVertexUniformData(slot, data, data.length);
    }

    public function setFragmentUniformData(slot:Int, data:haxe.io.Bytes) {
        Frame.setFragmentUniformData(slot, data, data.length);
    }

    public function setFragmentSampler(texture:BackendTexture, sampler:BackendSampler) {
        Frame.setFragmentSampler(texture, sampler);
    }

    public function drawPrimitives(vertices:Int, instances:Int) {
        Frame.drawPrimitives(vertices, instances);
    }

    public function drawIndexedPrimitives(indices:Int, instances:Int) {
        Frame.drawIndexedPrimitives(indices, instances);
    }
}
