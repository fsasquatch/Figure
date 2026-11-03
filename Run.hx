import sys.io.Process;
import sys.thread.Thread;
import sys.FileSystem;
import sys.io.File;

function main() {
    var args = Sys.args();
    var cwd = args[args.length-1];
    Sys.setCwd(cwd);


    switch(args[0]) {
        case "watch":
            var hxml = args[1];
            watch(hxml);
        case "setup":
        case "build":
    }
}

function watch(hxml:String) {
    if(!FileSystem.exists(hxml)) {
        Sys.println("[ERROR] Couldn't find HXML");
        return;
    }

    var checkFolder = '';
    var buildFolder = '';
    var buildFile = '';

    var fileContent = File.getContent(hxml);
    var split = fileContent.split("\n");
    for(line in split) {
        if(StringTools.contains(line, "-cp")) checkFolder = line.split(" ")[1];
        else if(StringTools.contains(line, "-hl")) {
            var tmp = line.split(" ")[1];
            var spl = tmp.split("/");
            buildFile = spl[spl.length-1];
            buildFolder = StringTools.replace(tmp, buildFile, "");
        }
    }
}