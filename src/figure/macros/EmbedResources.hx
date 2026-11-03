package figure.macros;

#if macro
import haxe.macro.Context;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import haxe.macro.Compiler;

class EmbedResources {
    public static function embed() {
        var lib = locateHaxelibPath();
        var path = Path.join([lib, "content", "compiled", "shaders"]);
        Context.addResource("SpriteBatcher.spv", File.getBytes(Path.join([path, "SpriteBatcher.spv"])));
        Context.addResource("SpriteBatcher.msl", File.getBytes(Path.join([path, "SpriteBatcher.msl"])));
        Context.addResource("SpriteBatcher.dxil", File.getBytes(Path.join([path, "SpriteBatcher.dxil"])));

        Context.addResource("Shapes.spv", File.getBytes(Path.join([path, "Shapes.spv"])));
        Context.addResource("Shapes.msl", File.getBytes(Path.join([path, "Shapes.msl"])));
        Context.addResource("Shapes.dxil", File.getBytes(Path.join([path, "Shapes.dxil"])));

        Context.addResource("Textured.spv", File.getBytes(Path.join([path, "Textured.spv"])));
        Context.addResource("Textured.msl", File.getBytes(Path.join([path, "Textured.msl"])));
        Context.addResource("Textured.dxil", File.getBytes(Path.join([path, "Textured.dxil"])));

        Context.addResource("PrimitiveBatcher.spv", File.getBytes(Path.join([path, "PrimitiveBatcher.spv"])));
        Context.addResource("PrimitiveBatcher.msl", File.getBytes(Path.join([path, "PrimitiveBatcher.msl"])));
        Context.addResource("PrimitiveBatcher.dxil", File.getBytes(Path.join([path, "PrimitiveBatcher.dxil"])));

        Context.addResource("ShapeBatcher.spv", File.getBytes(Path.join([path, "ShapeBatcher.spv"])));
        Context.addResource("ShapeBatcher.msl", File.getBytes(Path.join([path, "ShapeBatcher.msl"])));
        Context.addResource("ShapeBatcher.dxil", File.getBytes(Path.join([path, "ShapeBatcher.dxil"])));

        return null;
    }

    public static function locateHaxelibPath():String {
        for(path in Context.getClassPath()) {
            var parent = Path.directory(Path.removeTrailingSlashes(path));
            if(FileSystem.exists(Path.join([parent, "ce-comme-ca.txt"]))) {
                return parent;
            }
        }
        return null;
    }
}
#end
