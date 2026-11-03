package frame.system;

import frame.backend.Backend;

class Time {
    public static function frameTime():Float {
        return Backend.system.getFrameTime();
    }

    public static function fps():Int {
        return Std.int(1 / frameTime());
    }
}