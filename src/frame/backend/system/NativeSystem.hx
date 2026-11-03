package frame.backend.system;

import frame.system.Keys;
import sys.FileSystem;
import sys.io.File;
import frame.native.Frame;

class NativeSystem implements SystemApi {
    var scancodeKeyMap:Map<Keys, Int> = [];

    public function new() {}

    public function createWindow(width:Int, height:Int, title:String):Int {
        setupKeys();
        #if debug
        return Frame.createWindow(width, height, title, true, null);
        #else
        // TODO: Allow for choosing between vulkan and d3d12 for windows?
        return Frame.createWindow(width, height, title, false, null);
        #end
        return -1;
    }
    
    function setupKeys() {
        for(i in 4...39) scancodeKeyMap.set(i-3, i);
        scancodeKeyMap.set(ENTER, 40);
        scancodeKeyMap.set(ESCAPE, 41);
        scancodeKeyMap.set(BACKSPACE, 42);
        scancodeKeyMap.set(TAB, 43);
        scancodeKeyMap.set(SPACE, 44);
        scancodeKeyMap.set(MINUS, 45);
        scancodeKeyMap.set(EQUALS, 46);
        scancodeKeyMap.set(LEFT_BRACKET, 47);
        scancodeKeyMap.set(RIGHT_BRACKET, 48);
        scancodeKeyMap.set(BACKSLASH, 49);
        scancodeKeyMap.set(SEMICOLON, 51);
        scancodeKeyMap.set(APOSTROPHE, 52);
        scancodeKeyMap.set(GRAVE, 53);
        scancodeKeyMap.set(COMMA, 54);
        scancodeKeyMap.set(PERIOD, 55);
        scancodeKeyMap.set(SLASH, 56);
        scancodeKeyMap.set(F1, 58);
        scancodeKeyMap.set(F2, 59);
        scancodeKeyMap.set(F3, 60);
        scancodeKeyMap.set(F4, 61);
        scancodeKeyMap.set(F5, 62);
        scancodeKeyMap.set(F6, 63);
        scancodeKeyMap.set(F7, 64);
        scancodeKeyMap.set(F8, 65);
        scancodeKeyMap.set(F9, 66);
        scancodeKeyMap.set(F10, 67);
        scancodeKeyMap.set(F11, 68);
        scancodeKeyMap.set(F12, 69);
        scancodeKeyMap.set(RIGHT, 79);
        scancodeKeyMap.set(LEFT, 80);
        scancodeKeyMap.set(DOWN, 81);
        scancodeKeyMap.set(UP, 82);
        scancodeKeyMap.set(LEFT_CTRL, 224);
        scancodeKeyMap.set(LEFT_SHIFT, 225);
        scancodeKeyMap.set(LEFT_ALT, 226);
        scancodeKeyMap.set(RIGHT_CTRL, 228);
        scancodeKeyMap.set(RIGHT_SHIFT, 229);
        scancodeKeyMap.set(RIGHT_ALT, 230);
    }

    public function destroyWindow(window:Int) {
        Frame.destroyWindow(window);
    }

    public function isWindowRunning(window:Int):Bool {
        return Frame.isWindowRunning(window);
    }

    public function setWindowRunning(window:Int, running:Bool) {
        Frame.setWindowRunning(window, running);
    }

    public function getWindowWidth(window:Int):Int {
        return Frame.getWindowWidth(window);
    }

    public function getWindowHeight(window:Int):Int {
        return Frame.getWindowHeight(window);
    }

    public function setWindowSize(window:Int, w:Int, h:Int):Bool {
        return Frame.setWindowSize(window, w, h);
    }

    public function getWindowX(window:Int):Int {
        return Frame.getWindowX(window);
    }

    public function getWindowY(window:Int):Int {
        return Frame.getWindowY(window);
    }

    public function setWindowPosition(window:Int, w:Int, h:Int):Bool {
        return Frame.setWindowPosition(window, w, h);
    }

    public function getCurrentDisplay(window:Int):Int {
        return Frame.getCurrentDisplay(window);
    }

    public function setCurrentDisplay(window:Int, display:Int):Bool {
        return Frame.setCurrentDisplay(window, display); 
    }

    public function getPrimaryDisplay():Int {
        return Frame.getPrimaryDisplay();
    }

    public function isWindowFullscreen(window:Int):Bool {
        return Frame.isWindowFullscreen(window);
    }

    public function toggleFullscreen(window:Int, borderless:Bool):Bool {
        return Frame.toggleFullscreen(window, borderless);
    }

    public function isWindowMinimized(window:Int):Bool {
        return Frame.isWindowMinimized(window);
    }

    public function minimizeWindow(window:Int):Bool {
        return Frame.minimizeWindow(window);
    }

    public function isWindowMaximized(window:Int):Bool {
        return Frame.isWindowMaximized(window);
    }

    public function maximizeWindow(window:Int):Bool {
        return Frame.maximizeWindow(window);
    }

    public function restoreWindow(window:Int):Bool {
        return Frame.restoreWindow(window);
    }

    public function raiseWindow(window:Int):Bool {
        return Frame.raiseWindow(window);
    }

    public function isWindowResizable(window:Int):Bool {
        return Frame.isWindowResizable(window);
    }

    public function setWindowResizable(window:Int, resizable:Bool):Bool {
        return Frame.setWindowResizable(window, resizable);
    }

    public function wasWindowResized(window:Int):Bool {
        return Frame.wasWindowResized(window);
    }

    public function isWindowFocused(window:Int):Bool {
        return Frame.isWindowFocused(window);
    }

    public function focusWindow(window:Int):Bool {
        return Frame.focusWindow(window);
    }

    public function setWindowIcon(icon:String) {
        Frame.setWindowIcon(icon); // Only sets it for the main window
    }

    public function pollWindowEvents():Bool {
        return Frame.pollWindowEvents();
    }

    public function handleWindowEvents(window:Int){
        Frame.handleWindowEvents(window);
    }

    public function handleInputEvents() {
        Frame.handleInputEvents();
    }

    public function setFpsCap(fps:Int) {
        Frame.setFpsCap(fps);
    }

    public function enableFpsCap() {
        Frame.enableFpsCap();
    }

    public function disableFpsCap() {
        Frame.disableFpsCap();
    }

    public function isFpsCapped():Bool {
        return Frame.isFpsCapped();
    }

    public function getDisplayContentScale(display:Int):Float {
        return Frame.getDisplayContentScale(display);
    }

    public function getWindowDisplayScale(window:Int):Float {
        return Frame.getWindowDisplayScale(window);
    }

    public function getWindowPixelDensity(window:Int):Float {
        return Frame.getWindowPixelDensity(window);
    }

    public function getPlatformName():String {
        return Frame.getPlatformName();
    }

    public function showCursor() {
        Frame.showCursor();
    }

    public function hideCursor() {
        Frame.hideCursor();
    }

    public function lockCursor(window:Int) {
        Frame.lockCursor(window);
    }

    public function unlockCursor(window:Int) {
        Frame.unlockCursor(window);
    }

    public function setClipboardText(text:String) {
        Frame.setClipboardText(text);
    }

    public function getClipboardText():String {
        return Frame.getClipboardText();
    }

    public function getFrameTime():Float {
        return Frame.getFrameTime();
    }

    public function getElapsedTime():Float {
        return Frame.getElapsedTime();
    }
    
    public function loadBytes(file:String):haxe.io.Bytes {
        return File.getBytes(file);
    }

    public function loadText(file:String):String {
        return File.getContent(file);
    }

    public function writeBytes(file:String, content:haxe.io.Bytes) {
        File.saveBytes(file, content); 
    }

    public function writeText(file:String, content:String) {
        File.saveContent(file, content);
    }

    public function listFileEntries(location:String):Array<String> {
        return FileSystem.readDirectory(location);
    }

    public function fileExists(file:String):Bool {
        return FileSystem.exists(file);
    }

    public function isDirectory(entry:String):Bool {
        return FileSystem.isDirectory(entry);
    }

    public function isKeyDown(key:Int):Bool {
        return Frame.isKeyDown(scancodeKeyMap[key]);
    }

    public function isKeyJustDown(key:Int):Bool {
        return Frame.isKeyJustDown(scancodeKeyMap[key]);
    }

    public function isKeyReleased(key:Int):Bool {
        return Frame.isKeyReleased(scancodeKeyMap[key]);
    }

    public function isGamepadAvailable(gamepad:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    } 

    public function getGamepadName(gamepad:Int):String {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function isGamepadButtonDown(gamepad:Int, button:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function isGamepadButtonJustDown(gamepad:Int, button:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function isGamepadButtonReleased(gamepad:Int, button:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function getGamepadAxisCount(gamepad:Int):Int {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function getGamepadAxisMovement(gamepad:Int, axis:Int):Float {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setGamepadVibration(gamepad:Int, leftMotor:Float, rightMotor:Float, durationSec:Float) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function isMouseButtonDown(button:Int):Bool {
        return Frame.isMouseButtonDown(button);
    }

    public function isMouseButtonJustDown(button:Int):Bool {
        return Frame.isMouseButtonJustDown(button);
    }

    public function isMouseButtonReleased(button:Int):Bool {
        return Frame.isMouseButtonReleased(button);
    }

    public function getMousePositionX():Int {
        return Frame.getMousePositionX();
    }

    public function getMousePositionY():Int {
        return Frame.getMousePositionY();
    }

    public function setMousePosition(window:Int, x:Int, y:Int) {
        return Frame.setMousePosition(window, x, y);
    }

    public function getMouseWheelMovementX():Float {
        return Frame.getMouseWheelMovementX();
    }

    public function getMouseWheelMovementY():Float {
        return Frame.getMouseWheelMovementY();
    }

    public function setMouseCursor(cursor:Int) {
        Frame.setMouseCursor(cursor);
    }
}