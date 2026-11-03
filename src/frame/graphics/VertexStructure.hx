package frame.graphics;

enum abstract VSElement(Int) to Int {
    var Float = 0;
    var Float2 = 1;
    var Float3 = 2;
    var Float4 = 3;
    var Byte4 = 4;
    var UByte4 = 5;
    var Int = 6;
    var UInt = 7;
    var Int2 = 8;
}

class VertexStructure {
    public var elements:Map<String, {e:VSElement, l:Int, o:Int}>;
    public var size:Int;

    var counter = 0;

    var bytesSizes:Map<VSElement, Int> = [
        Float2 => 2 * 4,
        Float3 => 3 * 4,
        Float4 => 4 * 4,
        Float => 1 * 4,
        Byte4 => 4,
        UByte4 => 4,
        Int => 4,
        Int2 => 4 * 2,
        UInt => 4,
    ];

    public function new() {
        elements = new Map();
    }

    public function add(name:String, type:VSElement) {
        this.elements.set(name, {e:type, l: counter, o:size});
        size += bytesSizes[type];
        counter++;
    }

    public function remove(name:String) { 
        size -= bytesSizes[elements[name].e];
        this.elements.remove(name);
    }
}
