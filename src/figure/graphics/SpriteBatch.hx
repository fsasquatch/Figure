package figure.graphics;

import haxe.io.Bytes;
import frame.graphics.Sampler;
import frame.graphics.Graphics;
import frame.graphics.StorageBuffer;
import frame.graphics.Texture;
import figure.content.DefaultContent;

// TODO: PrimitiveBatcher for web target & opengl
class SpriteBatch {
    public var data:Float32Array;
    public var dataBuffer:StorageBuffer;

    public var count:Int;
    public var maxCount = 16384*2;
    public final byteSize = 64;

    public function new() {
        count = 0;
        data = new Float32Array(maxCount * 16);
        dataBuffer = new StorageBuffer(maxCount * byteSize);
    }

    public function destroy() {
        dataBuffer.destroy();
    }

    public function upload() {
        dataBuffer.load(data.getData().bytes);
    }

    public function draw(texture:Texture, sampler:Sampler, viewProjectionData:Bytes) {
        DefaultContent.spriteBatchPipeline.use();
        dataBuffer.use();
        texture.use(sampler);
        Graphics.setVertexUniform(0, viewProjectionData); 
        Graphics.draw(count * 6, 1);
    }

    public function push(spr:Sprite){
        var i = count;
        data.set(i*16, spr.x);
        data.set((i*16)+1, spr.y);
        data.set((i*16)+2, spr.z);
        data.set((i*16)+3, spr.rotation);
        data.set((i*16)+4, spr.width);
        data.set((i*16)+5, spr.height);
        data.set((i*16)+6, spr.offsetX);
        data.set((i*16)+7, spr.offsetY);
        data.set((i*16)+8, spr.textureX);
        data.set((i*16)+9, spr.textureY);
        data.set((i*16)+10, spr.textureHeight);
        data.set((i*16)+11, spr.textureWidth);
        data.set((i*16)+12, spr.color.rF);
        data.set((i*16)+13, spr.color.gF);
        data.set((i*16)+14, spr.color.bF);
        data.set((i*16)+15, spr.color.aF);

        count++;
    }

    public function clear() {
        for(i in 0...data.length) {
            data.set(i, 0);
        }
        count = 0;
    }
}
