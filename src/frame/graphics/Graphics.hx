package frame.graphics;

import haxe.io.Bytes;
import frame.system.Window;
import frame.backend.Backend;

class Graphics {
    public static inline function setClearColor(color:Color) {
        Backend.gpu.setClearColor(color);
    }

    static var currentRenderPass = -1;
    public static inline function begin(id:Int, window:Window, colorTarget:Texture = null, depthTarget:Texture = null) {
        currentRenderPass = id;
        
        Backend.gpu.beginRenderPass(@:privateAccess window.backendID, currentRenderPass, colorTarget, depthTarget);
    }

    public static inline function end() {
        Backend.gpu.endRenderPass(currentRenderPass);
        currentRenderPass = -1;
    }

    public static inline function setVertexUniform(slot:Int, bytes:Bytes) {
        Backend.gpu.setVertexUniformData(slot, bytes);
    } 

    public static inline function setFragmentUniform(slot:Int, data:Bytes) {
        Backend.gpu.setFragmentUniformData(slot, data);
    }

    public static inline function draw(vertices:Int, instances:Int) {
        Backend.gpu.drawPrimitives(vertices, instances);
    }

    public static inline function drawIndexed(indices:Int, instances:Int) {     
        Backend.gpu.drawIndexedPrimitives(indices, instances);
    }
}