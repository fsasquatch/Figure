package frame.system;

import frame.backend.BackendWindow;
import frame.backend.Backend;

class Window {
    public var width(get, set):Int;
    public var height(get, set):Int;
    public var title:String;

    public var isRunning(get, set):Bool;

    public var currentDisplay(get, null):Int;
    
    public var x(get, set):Int;
    public var y(get, set):Int;

    public var borderless:Bool = true;
    public var fullscreen(get, set):Bool;
    public var resizable(get, set):Bool;

    public var minimized(get, set):Bool;
    public var maximized(get, set):Bool;
    public var focused(get, set):Bool;

    /*
        This is broken.
    */
    public var onResize:()->Void;

    var backendID:BackendWindow;

    public function new(width:Int, height:Int, title:String) {
        backendID = Backend.system.createWindow(width, height, title);
    }

    public function destroy() {
        Backend.system.destroyWindow(backendID);
    }

    function get_isRunning():Bool {
        return Backend.system.isWindowRunning(backendID);
    }

    function set_isRunning(value:Bool) {
        Backend.system.setWindowRunning(backendID, value);
        return isRunning;
    }

    public function handleEvents() {
        Backend.system.handleWindowEvents(backendID);
    }

    public function setWindowSize(width:Int, height:Int) {
        Backend.system.setWindowSize(backendID, width, height);
    }
 
    public function setCurrentDisplay(display:Int) {
        Backend.system.setCurrentDisplay(backendID, display);
    }

    public function setCurrentPosition(x:Int, y:Int) {
        Backend.system.setWindowPosition(backendID, x, y);
    }

    public function isFullscreen():Bool {
        return Backend.system.isWindowFullscreen(backendID);
    }

    public function toggleFullscreen() {
        Backend.system.toggleFullscreen(backendID, borderless);
    }

    public function isMinimized():Bool {
        return Backend.system.isWindowMinimized(backendID);
    }

    public function minimize() {
        Backend.system.minimizeWindow(backendID);
    }

    public function isMaximized():Bool {
        return Backend.system.isWindowMaximized(backendID);
    } 

    public function maximize() {
        Backend.system.maximizeWindow(backendID);
    }

    public function isFocused():Bool {
        return Backend.system.isWindowFocused(backendID);
    }

    public function focus() {
        Backend.system.focusWindow(backendID);
    }

    public function restore() {
        Backend.system.restoreWindow(backendID);
    }

    public function lockCursor() {
        Backend.system.lockCursor(backendID);
    }

    public function unlockCursor() {
        Backend.system.unlockCursor(backendID);
    }

    public function showCursor() {
        Backend.system.showCursor();
    }

    public function hideCursor() {
        Backend.system.hideCursor();
    }

    function get_width() {
        return Backend.system.getWindowWidth(backendID);
    }

    function set_width(v:Int){
        Backend.system.setWindowSize(backendID, v, height);
        return width;
    }

    function get_height() {
         return Backend.system.getWindowHeight(backendID);
    }

    function set_height(v:Int){
        Backend.system.setWindowSize(backendID, width, v);
        return height;
    }

    function get_currentDisplay() {
        return Backend.system.getCurrentDisplay(backendID);
    }

    function get_x() {
        return Backend.system.getWindowX(backendID);
    }
    
    function set_x(v:Int) {
        Backend.system.setWindowPosition(backendID, v, x);
        return x;
    }

    function get_y() {
        return Backend.system.getWindowY(backendID);
    }

    function set_y(v:Int) {
        Backend.system.setWindowPosition(backendID, x, v);
        return y;
    }

    function get_resizable() {
        return Backend.system.isWindowResizable(backendID);
    }

    function set_resizable(v:Bool) {
        Backend.system.setWindowResizable(backendID, v);
        return resizable;
    }

    function get_fullscreen() {
        return isFullscreen();
    }

    function set_fullscreen(v:Bool) {
        if(v == true && fullscreen == false) toggleFullscreen();
        if(v == true && fullscreen == true) return fullscreen;
        if(v == false && fullscreen == false) return fullscreen;
        if(v == false && fullscreen == true) toggleFullscreen();

        return fullscreen;
    }

    function get_minimized() {
        return isMinimized();
    }

    function set_minimized(v:Bool) { 
        if(v == true) minimize();
        if(v == false) restore();
        return minimized;
    }

    function get_maximized() {
        return isMaximized();
    }

    function set_maximized(v:Bool) {
        if(v == true) maximize();
        if(v == false) restore();
        return maximized;
    }

    function get_focused() {
        return isFocused();
    }

    function set_focused(v:Bool) {
        if(v == true) focus();
        if(v == false) return focused;
        return focused;
    }
}