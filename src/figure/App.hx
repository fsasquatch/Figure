package figure;

import frame.graphics.Color;
import frame.graphics.Graphics;
import frame.system.Time;
import frame.system.Window;
import frame.backend.Backend;
import figure.content.DefaultContent;
import figure.graphics.TextureSampler;

class App {
    public static var instance:App = null;

    public var windows:Array<Window>;
    public var activeModule:Module;

    var timeCounter:Float = 0;
    var timeStep:Float = 1 / 60;

    public function create() {
        activeModule.create();
    }
    
    public function fixedUpdate() {
        activeModule.fixedUpdate();
    }

    public function update(dt:Float) {
        activeModule.update(dt);
    }
    
    public function draw() {
        Graphics.setClearColor(Color.CORNFLOWERBLUE);
        Graphics.begin(0, App.instance.windows[0]);
        activeModule.draw();

        Graphics.end();
    }
    
    public function destroy() {
        activeModule.destroy();
    }

    public function new(width:Int, height:Int, title:String, module:Module, fps:Int = 60) {
        if(instance == null) instance = this;
        else throw "ERROR: Cannot create `App` twice!";

        Backend.setup();

        windows = new Array();
        windows[0] = new Window(width, height, title);
        Backend.system.setFpsCap(fps+2);
        Backend.system.enableFpsCap();

        TextureSampler.create();
        DefaultContent.loadShaderPipelines();

        activeModule = module;
        create();

        #if !js
        while(windows[0].isRunning) {
            #if (hl && debug)
            hl.Api.checkReload();
            #end

            while(Backend.system.pollWindowEvents()) {
                for(w in windows) {
                    if(!w.isRunning) continue;
                    w.handleEvents();
                    // TODO: Handle resizing
                }
                Backend.system.handleInputEvents();
            }


            var dt = Time.frameTime();
            timeCounter += dt;
            while(timeCounter > timeStep) {
                fixedUpdate();
                timeCounter -= timeStep;
            }

            update(dt);

            Backend.gpu.beginRender();
            draw();
            Backend.gpu.endRender();

            for(i in 0...windows.length) {
                if(i == 0) continue;
                if(!windows[i].isRunning) windows[i].destroy();
            }
        }

        destroy();
        DefaultContent.destroyShaderPipelines();
        TextureSampler.destroy();
        for(w in windows) w.destroy();
        #else
        js_update();
        #end
    }

    #if js
    function js_update() {
        Backend.system.handleInputEvents();
        update();
        draw();

        fixedUpdate();

        Browser.window.requestAnimationFrame((currentTime) -> {
            js_update();
        });
    }
    #end
}
