package figure.content;

import frame.graphics.BlendState;
import frame.graphics.VertexStructure;
import frame.graphics.ShaderInformation;
import haxe.io.Bytes;
import haxe.Resource;
import frame.graphics.Shader;
import frame.graphics.GraphicsPipeline;

class DefaultContent { 
    public static var spriteBatchPipeline:GraphicsPipeline; 
    public static var shapesPipeline:GraphicsPipeline;
    public static var primitiveBatchPipeline:GraphicsPipeline;

    public static function loadShaderPipelines() {
        var sprRes:Bytes = null;
        var shpRes:Bytes = null;
        var texRes:Bytes = null;
        var prmRes:Bytes = null;
        var shpBatchRes:Bytes = null;
 
        #if (!console || !android || !io || !opengl)
        var os = Sys.systemName();
        // TODO: Allow for vulkan on windows?
        switch(os) {
            case "Windows":
                sprRes = Resource.getBytes("SpriteBatcher.dxil");
                shpRes = Resource.getBytes("Shapes.dxil");
                texRes = Resource.getBytes("Textured.dxil");
                prmRes = Resource.getBytes("PrimitiveBatcher.dxil");
                shpBatchRes = Resource.getBytes("ShapeBatcher.dxil");
            case "Linux":
                sprRes =  Resource.getBytes("SpriteBatcher.spv");
                shpRes = Resource.getBytes("Shapes.spv");
                texRes = Resource.getBytes("Textured.spv");
                prmRes = Resource.getBytes("PrimitiveBatcher.spv");
                shpBatchRes = Resource.getBytes("ShapeBatcher.spv");
            case "Mac":
                sprRes = Resource.getBytes("SpriteBatcher.msl");
                shpRes = Resource.getBytes("Shapes.msl");
                texRes = Resource.getBytes("Textured.msl");
                prmRes = Resource.getBytes("PrimitiveBatcher.msl");
                shpBatchRes = Resource.getBytes("ShapeBatcher.msl");
        }
        #elseif js
        #elseif opengl
        #elseif console
        // LOL why is this here
        #elseif android
        #elseif ios
        #end

        if(sprRes == null || shpRes == null || texRes == null || prmRes == null || shpBatchRes == null) 
            trace("ERROR: Failed to load default resources");

        // TODO: generate shader info from shadercross
        var shaderInfo:ShaderInformation= {
            samplers: 0,
            uniformBuffers: 1,
            storageBuffers: 1,
            storageTextures: 0
        }
        var spriteBatchShader = new Shader(sprRes, Vertex, shaderInfo); 
        var shapeBatchShader = new Shader(shpBatchRes, Vertex, shaderInfo);
        shaderInfo.storageBuffers = 0;
        var primitiveBatchShader = new Shader(prmRes, Vertex, shaderInfo);

        shaderInfo.uniformBuffers = 0;
        var shapesShader = new Shader(shpRes, Fragment, shaderInfo); 
        shaderInfo.samplers = 1;
        var texturedShader = new Shader(texRes, Fragment, shaderInfo);

        var vs = new VertexStructure();
        var blendState:BlendState = {
            enable: true,
            colorBlendOp: BlendOp.Add,
            alphaBlendOp: BlendOp.Add,
            srcColorBlendFactor: BlendFactor.SrcAlpha,
            dstColorBlendFactor: BlendFactor.OneMinusSrcAlpha,
            srcAlphaBlendFactor: BlendFactor.SrcAlpha,
            dstAlphaBlendFactor: BlendFactor.OneMinusSrcAlpha
        };
        spriteBatchPipeline = new GraphicsPipeline(spriteBatchShader, texturedShader, vs, false, blendState); 
        shapesPipeline = new GraphicsPipeline(shapeBatchShader, shapesShader, vs, false, blendState);

        vs.add("Position", Float4);
        vs.add("TexCoord", Float2);
        vs.add("Color", Float4);
        vs.add("Type", Float4);
        primitiveBatchPipeline = new GraphicsPipeline(primitiveBatchShader, texturedShader, vs, false, blendState);

        spriteBatchShader.destroy();
        shapesShader.destroy();
        texturedShader.destroy();
        primitiveBatchShader.destroy();
    }

    public static function destroyShaderPipelines() {
        spriteBatchPipeline.destroy();
        shapesPipeline.destroy();
        primitiveBatchPipeline.destroy();
    }
}
