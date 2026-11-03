package frame.system;

import frame.backend.Backend;
#if js
import js.html.XMLHttpRequest;
import js.html.XMLHttpRequestResponseType;
import js.lib.Promise;
import js.html.Event;
#end

/**
    Do not use this for loading content in your games.
**/
class File {
    public static function loadBytes(file:String):#if !js haxe.io.Bytes #else Promise<haxe.io.Bytes> #end{
#if !js
        return Backend.system.loadBytes(file);
#else
        return new Promise(
        function(resolve, reject) {
            var req = new XMLHttpRequest();
            req.open("GET", file, true);
            req.responseType = XMLHttpRequestResponseType.ARRAYBUFFER;
            req.onreadystatechange = function () {
                if(req.readyState == XMLHttpRequest.DONE) {
                    var response:js.lib.ArrayBuffer = req.response;
                    var bytes = Bytes.ofData(response);
                    resolve(bytes);
                }
            }
            req.onerror = function(e:Event) {
                trace("Could not load file: " + file);
            }
            req.send();
        });
#end
    }

    public static function loadText(file:String):#if !js String #else Promise<String> #end{
#if !js
        return Backend.system.loadText(file);
#else
        return new Promise(
        function(resolve, reject) {
            var req = new XMLHttpRequest();
            req.open("GET", file, true);
            req.onreadystatechange = function () {
                if(req.readyState == XMLHttpRequest.DONE) {
                    resolve(req.response);
                }
            }
            req.onerror = function(e:Event) {
                trace("Could not load file: " + file);
            }
            req.send();
        });
#end
    }

    public static function writeBytes(file:String, content:haxe.io.Bytes) {
        Backend.system.writeBytes(file, content);
    }

    public static function writeText(file:String, content:String) {
        Backend.system.writeText(file, content);
    }

    public static function listFileEntries(location:String):Array<String> {
        return Backend.system.listFileEntries(location);
    }

    public static function fileExists(file:String):Bool {
        return Backend.system.fileExists(file);
    }

    public static function isDirectory(entry:String):Bool {
        return Backend.system.isDirectory(entry);
    }

    #if (hl || cpp)
    public static function convertPngToQoi(png:String, qoi:String) {
        return frame.native.Frame.convertPngToQoi(png, qoi);
    }
    #end
}