package frame.backend.system;

class EmptySystem implements SystemApi {
    public function new() {}
    
    public function createWindow(width:Int, height:Int, title:String):Int {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function destroyWindow(window:Int) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function isWindowRunning(window:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setWindowRunning(window:Int, running:Bool) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function getWindowWidth(window:Int):Int {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function getWindowHeight(window:Int):Int {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setWindowSize(window:Int, w:Int, h:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function getWindowX(window:Int):Int {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function getWindowY(window:Int):Int {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setWindowPosition(window:Int, w:Int, h:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function getCurrentDisplay(window:Int):Int {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setCurrentDisplay(window:Int, display:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function getPrimaryDisplay():Int {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function isWindowFullscreen(window:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function toggleFullscreen(window:Int, borderless:Bool):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function isWindowMinimized(window:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function minimizeWindow(window:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function isWindowMaximized(window:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function maximizeWindow(window:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function restoreWindow(window:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function raiseWindow(window:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function isWindowResizable(window:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setWindowResizable(window:Int, resizable:Bool):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function wasWindowResized(window:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function isWindowFocused(window:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function focusWindow(window:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setWindowIcon(icon:String) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function pollWindowEvents():Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function handleWindowEvents(window:Int){
        throw new haxe.exceptions.NotImplementedException();
    }

    public function handleInputEvents() {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setFpsCap(fps:Int) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function enableFpsCap() {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function disableFpsCap() {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function isFpsCapped():Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function getDisplayContentScale(display:Int):Float {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function getWindowDisplayScale(window:Int):Float {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function getWindowPixelDensity(window:Int):Float {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function getPlatformName():String {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function showCursor() {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function hideCursor() {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function lockCursor(window:Int) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function unlockCursor(window:Int) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setClipboardText(text:String) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function getClipboardText():String {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function getFrameTime():Float {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function getElapsedTime():Float {
        throw new haxe.exceptions.NotImplementedException();
    }
    
    public function loadBytes(file:String):haxe.io.Bytes {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function loadText(file:String):String {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function writeBytes(file:String, content:haxe.io.Bytes) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function writeText(file:String, content:String) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function listFileEntries(location:String):Array<String> {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function fileExists(file:String):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function isDirectory(entry:String):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function isKeyDown(key:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function isKeyJustDown(key:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function isKeyReleased(key:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
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
        throw new haxe.exceptions.NotImplementedException();
    }

    public function isMouseButtonJustDown(button:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function isMouseButtonReleased(button:Int):Bool {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function getMousePositionX():Int {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function getMousePositionY():Int {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setMousePosition(window:Int, x:Int, y:Int) {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function getMouseWheelMovementX():Float {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function getMouseWheelMovementY():Float {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function setMouseCursor(cursor:Int) {
        throw new haxe.exceptions.NotImplementedException();
    }
}