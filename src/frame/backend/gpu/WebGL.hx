package frame.backend.gpu;

import js.html.webgl.GL2;
import frame.backend.system.WebSystem;
import js.Browser;
import js.html.CanvasElement;
import js.html.webgl.WebGL2RenderingContext;
import frame.graphics.*;
import frame.graphics.Sampler;
import haxe.io.Bytes;

class WebGL implements GpuApi {
    var gl:WebGL2RenderingContext;
    var bgColor = Color.BLACK;
    // Shader inputs
    var shaderAttributes:Map<GraphicsPipeline, Map<String, Int>> = [];
    // Ordered list of uniforms
    var shaderVertexUniforms:Map<GraphicsPipeline, Array<Int>> = [];
    var shaderFragmentUniforms:Map<GraphicsPipeline, Array<Int>> = [];

    public function new() {
        var canvas:CanvasElement = cast Browser.document.getElementById("webgl");
        gl = canvas.getContextWebGL2();
    }

    public function beginRender() {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function endRender() {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setClearColor(c:Color) {
        bgColor = c;
    }

    public function beginRenderPass(window:Int, id:Int, colorTarget:BackendTexture, depthTarget:BackendTexture) {
        gl.viewport(0, 0, WebSystem.glCanvas.width, WebSystem.glCanvas.height); 
        gl.clearColor(bgColor.rF, bgColor.gF, bgColor.bF, bgColor.aF);
        gl.clear(GL2.COLOR_BUFFER_BIT);

        // This has to be handled by the pipeline config...?
        gl.clearDepth(1.0);
        gl.enable(GL2.DEPTH_TEST);
        gl.depthFunc(GL2.LEQUAL);
    }

    public function endRenderPass(id:Int) {
    }

    public function beginCopyPass() {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function endCopyPass() {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function loadVertexBuffer(data:Bytes, cycle:Bool):BackendBuffer {
        var vb = gl.createBuffer();
        gl.bindBuffer(GL2.ARRAY_BUFFER, vb);
        gl.bufferData(GL2.ARRAY_BUFFER, data.getData(), GL2.STATIC_DRAW);
        return vb;
    }

    public function loadIndexBuffer(data:Bytes, cycle:Bool):BackendBuffer {
        var ib = gl.createBuffer();
        gl.bindBuffer(GL2.ELEMENT_ARRAY_BUFFER, ib);
        gl.bufferData(GL2.ELEMENT_ARRAY_BUFFER, data.getData(), GL2.STATIC_DRAW); 
        return ib;
    }

    public function createStorageBuffer(size:Int):Int {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function loadStorageBuffer(buffer:Int, data:Bytes) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function unloadBuffer(buffer:BackendBuffer) {
        gl.deleteBuffer(buffer);
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
        var t = type == 0 ? GL2.VERTEX_SHADER : GL2.FRAGMENT_SHADER;
        var shader = gl.createShader(t);
        gl.shaderSource(shader, data.toString());
        gl.compileShader(shader);

        if(!gl.getShaderParameter(shader, GL2.COMPILE_STATUS)) {
            Browser.alert('ERROR: Could not compile shader: \n' + gl.getShaderInfoLog(shader));
            gl.deleteShader(shader);
            return null;
        }

        return shader;
    }

    public function unloadShader(shader:BackendShader) {
        gl.deleteShader(shader);
    }

    public function loadGraphicsPipeline(v:BackendShader, f:BackendShader, vs:VertexStructure, enableDepth:Bool, blendState:BlendState):BackendGraphicsPipeline {
        var program = gl.createProgram();
        gl.attachShader(program, v);
        gl.attachShader(program, f);
        gl.linkProgram(program);

        if(!gl.getProgramParameter(program, GL2.LINK_STATUS)) {
            Browser.alert('ERROR: Could not link program: \n' + gl.getProgramInfoLog(program));
            return null;
        }

        // TODO:
        // Get all the attributes and uniform

        return program;
    }

    public function unloadGraphicsPipeline(pipeline:BackendGraphicsPipeline) {
        gl.deleteProgram(pipeline);
    }

    public function setGraphicsPipeline(pipeline:BackendGraphicsPipeline) {
        gl.useProgram(pipeline);

        // TODO:
        // Get all the inputs for this specific pipeline
        // Enable them
    }

    public function setVertexBuffer(buffer:BackendBuffer) {
        gl.bindBuffer(GL2.ARRAY_BUFFER, buffer); 
    }

    public function setIndexBuffer(buffer:BackendBuffer) {
        gl.bindBuffer(GL2.ELEMENT_ARRAY_BUFFER, buffer);
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
        gl.drawElements(GL2.TRIANGLES, vertices, GL2.UNSIGNED_SHORT, 0);
    }

    public function drawIndexedPrimitives(indices:Int, instances:Int) {
        throw new haxe.exceptions.NotImplementedException();
    }
}
