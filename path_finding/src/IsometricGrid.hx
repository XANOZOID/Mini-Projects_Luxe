package;
typedef PosArr = Array<Float>;
/**
	Isometric translation formulas used and explanations can be found at:
		https://yal.cc/understanding-isometric-grids/
	- Disclaimer: This code is not associated with yal.cc, simply a Haxe implementation
  - See license on https://gist.github.com/forgotten-king
*/
class IsometricGrid{
    // Isometric cell width
    var _cellW : Int;
    // Isometric cell height
    var _cellH : Int;
    // Orthographic origin point for isogrid
    public var orthoX : Float;
    // Orthographic origin point for isogrid 
    public var orthoY : Float;
    // An array which is re-used to return two coordinates from one function
    var _position : PosArr;
    
    public function new( tWidth: Int, tHeight: Int, offX: Float, offY: Float ){
        _cellW = tWidth;
        _cellH = tHeight;
        orthoX = offX;
        orthoY = offY;
        _position = [0,0];
    }
    
    /// Translates a global coordinate to an isometric position
    inline function _toIso( x: Float, y: Float, arr:PosArr, off:Int = 0): PosArr{
        arr[off] = ((y - orthoY) / _cellH + (x - orthoX) / _cellW) / 2;
        arr[off+1] = ((y - orthoY) / _cellH - (x - orthoX) / _cellW) / 2;
        return arr;
    }
    
    public function toIso( x: Float, y: Float ) return _toIso(x,y, _position);    
    
    /// Translates an isometric coordinate to its global screen position
    inline function _fromIso( x: Float, y: Float, arr:PosArr, off:Int = 0): PosArr{
        arr[off] = orthoX + (x - y) * _cellW;
		arr[off+1] = orthoY + (x + y) * _cellH;
        return arr;
    }
    
    public function fromIso( x: Float, y: Float ) return _fromIso(x,y, _position);
    
    
    /**
		Takes an array of orthographic positions and translates them
		to this isometric grid.
		Format: [ x, y, x, y, ...x,y ]
		output: [ iso x, iso y, iso x, iso y, ... iso x,iso y]
	*/
    public function arrayToIso( points: PosArr ){
        var i = 0; 
        while( i < points.length ){
        	_toIso( points[i], points[i+1], points, i );
        	i += 2;
        }
    }
    
    /**
		Takes an array of isometric positions and translates them
		to theirf orthographic coordinates.
		Format: [ iso x, iso y, iso x, iso y, ... iso x,iso y]
		output: [ x, y, x, y, ...x,y ]
	*/
    public function arrayFromIso( points: PosArr ){
        var i = 0; 
        while( i < points.length ){
        	_fromIso( points[i], points[i+1], points, i );
        	i += 2;
        }
    }
}