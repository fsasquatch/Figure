package figure.macros;

#if (macro && !display)
import haxe.macro.Context;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import haxe.macro.Compiler;

class HDLL {
    public static function copyToBuild() {
        Context.onAfterGenerate(() -> {
            var lib = EmbedResources.locateHaxelibPath();
            var output = Path.directory(haxe.macro.Compiler.getOutput());

            if(!FileSystem.exists(Path.join([output, "figure.hdll"]))) {
                File.copy(Path.join([lib, "build", "figure.hdll"]), Path.join([output, "figure.hdll"]));
            }
        });    
    }
}
#end
