package frame.system;

import frame.backend.Backend;

class Keyboard {
    public static function isDown(key:Keys):Bool {
        return Backend.system.isKeyDown(key);
    }

    public static function isPressed(key:Keys):Bool {
        return Backend.system.isKeyJustDown(key);
    }

    public static function isReleased(key:Keys):Bool {
        return Backend.system.isKeyReleased(key);
    }
}