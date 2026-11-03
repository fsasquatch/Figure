package frame.backend;

import haxe.io.Bytes;
import frame.graphics.*;
import frame.graphics.Sampler;

interface GpuApi {
    public function beginRender():Void;
    public function endRender():Void;
    public function setClearColor(c:Color):Void;
    public function beginRenderPass(window:Int, id:Int, colorTarget:BackendTexture, depthTarget:BackendTexture):Void;
    public function endRenderPass(id:Int):Void;

    public function loadVertexBuffer(data:Bytes, cycle:Bool):BackendBuffer;
    public function loadIndexBuffer(data:Bytes, cycle:Bool):BackendBuffer;
    public function unloadBuffer(buffer:BackendBuffer):Void;
    public function createStorageBuffer(size:Int):Int;
    public function loadStorageBuffer(buffer:Int, data:Bytes):Void; 
    public function unloadStorageBuffer(buffer:Int):Void;

    public function createTexture(width:Int, height:Int, format:Int, usage:Int, mip:Int, layers:Int, type:Int):BackendTexture;
    public function loadTextureFromFile(file:String):BackendTexture;
    public function loadTextureFromBytes(bytes:haxe.io.Bytes, width:Int, height:Int, mip:Int, layers:Int, type:Int):BackendTexture;
    public function unloadTexture(texture:BackendTexture):Void;

    public function loadSampler(filter:SamplerFilter, mipmap:SamplerMipmapMode, addressMode:SamplerAddressMode, anisotropy:Int):BackendSampler;
    public function unloadSampler(sampler:BackendSampler):Void;

    public function loadShaderFromFile(file:String, type:Int, info:frame.graphics.ShaderInformation):BackendShader;
    public function loadShaderFromBytes(data:haxe.io.Bytes, size:Int, type:Int, info:frame.graphics.ShaderInformation):BackendShader;
    public function unloadShader(shader:BackendShader):Void;

    public function loadGraphicsPipeline(vertexShader:BackendShader, fragementShader:BackendShader, inputStructure:VertexStructure, depthTest:Bool, blendState:BlendState):BackendGraphicsPipeline;
    public function unloadGraphicsPipeline(pipeline:BackendGraphicsPipeline):Void;

    public function setGraphicsPipeline(pipeline:BackendGraphicsPipeline):Void;

    public function setVertexBuffer(buffer:BackendBuffer):Void;
    public function setIndexBuffer(buffer:BackendBuffer):Void;
    public function setStorageBuffer(buffer:Int):Void;
    
    public function setVertexUniformData(slot:Int, data:haxe.io.Bytes):Void;
    public function setFragmentUniformData(slot:Int, data:haxe.io.Bytes):Void; 
    public function setFragmentSampler(texture:BackendTexture, sampler:BackendSampler):Void;

    public function drawPrimitives(vertices:Int, instances:Int):Void;
    public function drawIndexedPrimitives(indices:Int, instances:Int):Void;
}
