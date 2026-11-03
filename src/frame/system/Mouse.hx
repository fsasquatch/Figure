package frame.system;

import frame.backend.Backend;

// TODO: Mouse pos delta
class Mouse {
    public static function isButtonDown(button:MouseButtons) {
        Backend.system.isMouseButtonDown(button);
    }

    public static function isButtonJustDown(button:MouseButtons) {
        Backend.system.isMouseButtonJustDown(button);
    }

    public static function isButtonReleased(button:MouseButtons) {
        Backend.system.isMouseButtonReleased(button);
    }

    public static function getPositionX():Float {
        return Backend.system.getMousePositionX();
    }

    public static function getPositionY():Float {
        return Backend.system.getMousePositionY();
    }

    public static function getWheelMovementX():Float {
        return Backend.system.getMouseWheelMovementX();
    }

    public static function getWheelMovementY():Float {
        return Backend.system.getMouseWheelMovementY();
    }
}