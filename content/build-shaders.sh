../tools/shadercross/bin/shadercross shaders/SpriteBatcher.hlsl -s HLSL -d SPIRV -t vertex -o compiled/shaders/SpriteBatcher.spv
../tools/shadercross/bin/shadercross shaders/SpriteBatcher.hlsl -s HLSL -d MSL -t vertex -o compiled/shaders/SpriteBatcher.msl
../tools/shadercross/bin/shadercross shaders/SpriteBatcher.hlsl -s HLSL -d DXIL -t vertex -o compiled/shaders/SpriteBatcher.dxil

../tools/shadercross/bin/shadercross shaders/Shapes.hlsl -s HLSL -d SPIRV -t fragment -o compiled/shaders/Shapes.spv
../tools/shadercross/bin/shadercross shaders/Shapes.hlsl -s HLSL -d MSL -t fragment -o compiled/shaders/Shapes.msl
../tools/shadercross/bin/shadercross shaders/Shapes.hlsl -s HLSL -d DXIL -t fragment -o compiled/shaders/Shapes.dxil

../tools/shadercross/bin/shadercross shaders/Textured.hlsl -s HLSL -d SPIRV -t fragment -o compiled/shaders/Textured.spv
../tools/shadercross/bin/shadercross shaders/Textured.hlsl -s HLSL -d MSL -t fragment -o compiled/shaders/Textured.msl
../tools/shadercross/bin/shadercross shaders/Textured.hlsl -s HLSL -d DXIL -t fragment -o compiled/shaders/Textured.dxil

../tools/shadercross/bin/shadercross shaders/PrimitiveBatcher.hlsl -s HLSL -d SPIRV -t vertex -o compiled/shaders/PrimitiveBatcher.spv
../tools/shadercross/bin/shadercross shaders/PrimitiveBatcher.hlsl -s HLSL -d MSL -t vertex -o compiled/shaders/PrimitiveBatcher.msl
../tools/shadercross/bin/shadercross shaders/PrimitiveBatcher.hlsl -s HLSL -d DXIL -t vertex -o compiled/shaders/PrimitiveBatcher.dxil

../tools/shadercross/bin/shadercross shaders/ShapeBatcher.hlsl -s HLSL -d SPIRV -t vertex -o compiled/shaders/ShapeBatcher.spv
../tools/shadercross/bin/shadercross shaders/ShapeBatcher.hlsl -s HLSL -d MSL -t vertex -o compiled/shaders/ShapeBatcher.msl
../tools/shadercross/bin/shadercross shaders/ShapeBatcher.hlsl -s HLSL -d DXIL -t vertex -o compiled/shaders/ShapeBatcher.dxil