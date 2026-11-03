package figure.macros;

#if (macro && !display)
import sys.io.File;
import haxe.io.Path;
import sys.FileSystem;

class ShaderCompiler {
    static var contentFolder = "content";
    static var vertex:Array<String> = [];
    static var fragment:Array<String> = [];
    static var compute:Array<String> = [];

    public static function compile() {
        // TODO: Change content folder if define `contentFolder` is set.
        if(FileSystem.exists(contentFolder)) {
            readFolder(contentFolder);
        }

        if(!FileSystem.exists(Path.join([contentFolder, "compiled"]))) FileSystem.createDirectory(Path.join([contentFolder, "compiled"]));

        buildSDLShaders();
        buildWebShaders();
        buildGLShaders();
    }

    public static function buildSDLShaders() {
        var out = Path.join([contentFolder, "compiled"]);
        for(file in vertex) {
            var o = file.split(".")[0];
            var t = o.split("/");
            var f = t[t.length-1];
            var process = new sys.io.Process(Path.join([figure.macros.EmbedResources.locateHaxelibPath(), "tools", "shadercross", "bin", "shadercross"]), [file, "-s", "HLSL", "-d", "SPIRV", "-t", "vertex", "-o", '$out/$f.spv']);
            if(process.stderr.readAll().length > 0) Sys.println(process.stderr.readAll().toString());
            process.close();
            var process = new sys.io.Process(Path.join([figure.macros.EmbedResources.locateHaxelibPath(), "tools", "shadercross", "bin", "shadercross"]), [file, "-s", "HLSL", "-d", "DXIL", "-t", "vertex", "-o", '$out/$f.dxil']);
            if(process.stderr.readAll().length > 0) Sys.println(process.stderr.readAll().toString());
            process.close();
            var process = new sys.io.Process(Path.join([figure.macros.EmbedResources.locateHaxelibPath(), "tools", "shadercross", "bin", "shadercross"]), [file, "-s", "HLSL", "-d", "MSL", "-t", "vertex", "-o", '$out/$f.msl']);
            if(process.stderr.readAll().length > 0) Sys.println(process.stderr.readAll().toString());
            process.close();
        }

        for(file in fragment) {
            var o = file.split(".")[0];
            var t = o.split("/");
            var f = t[t.length-1];
            var process = new sys.io.Process(Path.join([figure.macros.EmbedResources.locateHaxelibPath(), "tools", "shadercross", "bin", "shadercross"]), [file, "-s", "HLSL", "-d", "SPIRV", "-t", "fragment", "-o", '$out/$f.spv']);
            if(process.stderr.readAll().length > 0) Sys.println(process.stderr.readAll().toString());
            process.close();
            var process = new sys.io.Process(Path.join([figure.macros.EmbedResources.locateHaxelibPath(), "tools", "shadercross", "bin", "shadercross"]), [file, "-s", "HLSL", "-d", "DXIL", "-t", "fragment", "-o", '$out/$f.dxil']);
            if(process.stderr.readAll().length > 0) Sys.println(process.stderr.readAll().toString());
            process.close();
            var process = new sys.io.Process(Path.join([figure.macros.EmbedResources.locateHaxelibPath(), "tools", "shadercross", "bin", "shadercross"]), [file, "-s", "HLSL", "-d", "MSL", "-t", "fragment", "-o", '$out/$f.msl']);
            if(process.stderr.readAll().length > 0) Sys.println(process.stderr.readAll().toString());
            process.close();
        }

        for(file in compute) {
            var o = file.split(".")[0];
            var t = o.split("/");
            var f = t[t.length-1];
            var process = new sys.io.Process(Path.join([figure.macros.EmbedResources.locateHaxelibPath(), "tools", "shadercross", "bin", "shadercross"]), [file, "-s", "HLSL", "-d", "SPIRV", "-t", "compute", "-o", '$out/$f.spv']);
            if(process.stderr.readAll().length > 0) Sys.println(process.stderr.readAll().toString());
            process.close();
            var process = new sys.io.Process(Path.join([figure.macros.EmbedResources.locateHaxelibPath(), "tools", "shadercross", "bin", "shadercross"]), [file, "-s", "HLSL", "-d", "DXIL", "-t", "compute", "-o", '$out/$f.dxil']);
            if(process.stderr.readAll().length > 0) Sys.println(process.stderr.readAll().toString());
            process.close();
            var process = new sys.io.Process(Path.join([figure.macros.EmbedResources.locateHaxelibPath(), "tools", "shadercross", "bin", "shadercross"]), [file, "-s", "HLSL", "-d", "MSL", "-t", "compute", "-o", '$out/$f.msl']);
            if(process.stderr.readAll().length > 0) Sys.println(process.stderr.readAll().toString());
            process.close();
        }
    }

    public static function buildWebShaders() {
    }

    public static function buildGLShaders() {
    }

    public static function readFolder(folder:String) {
        for(file in FileSystem.readDirectory(folder)) {
            if(FileSystem.isDirectory(Path.join([folder, file]))) {
                readFolder(Path.join([folder, file]));
            } else {
                var spl = file.split(".")[1];
                if(spl == "vert") {
                    vertex.push(Path.join([folder, file]));
                } else if(spl == "frag") {
                    fragment.push(Path.join([folder, file]));
                } else if(spl == "comp") {
                    compute.push(Path.join([folder, file]));
                }
            }
        }
    }
}
#end