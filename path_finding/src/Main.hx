package;

import haxe.Json;
import luxe.GameConfig;
import luxe.Screen;
import luxe.Sprite;
import luxe.Vector;
import luxe.Color;
import luxe.Input;
import luxe.components.sprite.SpriteAnimation;
import luxe.tween.Actuate;
import luxe.tween.MotionPath;
import luxe.tween.actuators.GenericActuator.IGenericActuator;
import luxe.tween.easing.Linear;
import phoenix.Texture.FilterType;

typedef LuxeBox = phoenix.geometry.QuadGeometry;

class Main extends luxe.Game 
{
	var gridSize = 32;
	var mouseBox: MouseBox;
	var player: Player;
	
	override public function config(_config:GameConfig):GameConfig {
		_config.preload.textures.push({
			id:"assets/player.png"
		});
		_config.preload.jsons.push({
			id:"assets/movement.json"
		});
	
		return super.config(_config);
	}
	
	override function ready() {
		Luxe.renderer.clear_color.set(0, 0.2, 0.9, 1);
		mouseBox = new MouseBox( createBox( 0, 0, gridSize, gridSize), gridSize, gridSize );
		createGrid();
		player = new Player();
	}
	
	function createGrid(){
		var white = new Color( 1, 1, 1, 1);
		var lines:Int = cast (Luxe.screen.width / gridSize);
		for ( i in 0...lines ){
			var x = i * gridSize;
			Luxe.draw.line({
				p0: new Vector( x, 0),
				p1: new Vector( x, cast Luxe.screen.height),
				color: white
			});
		}
		var lines:Int = cast (Luxe.screen.height / gridSize);
		for ( i in 0...lines ){
			var y = i * gridSize;
			Luxe.draw.line({
				p0: new Vector( 0, y ),
				p1: new Vector( cast Luxe.screen.width, y),
				color: white
			});
		}
	}

	override function onkeyup(e:KeyEvent) {
		if(e.keycode == Key.escape) Luxe.shutdown();
	}

	override function update(dt:Float) {
	}
	
	override function onmousemove( ev: MouseEvent ){	
		mouseBox.onmousemove(ev);
	}
	
	override function onmousedown( ev: MouseEvent ){
		player.add_point( new Vector( ev.x, ev.y) );
	}
	
	function createBox(x: Float, y: Float, width:Int, height: Int, color: Color = null): LuxeBox {
		if ( color == null ){ color = new Color(1, 0, 0, .05); }
		return Luxe.draw.box({
			x : 40, y : 40,
			w : cast width,
			h : cast height,
			color : color
		});
	}
}

class MouseBox {
	var _gridW: Float;
	var _gridH: Float;
	var _box: LuxeBox;
	
	public function new( box: LuxeBox, gridW: Float, gridH: Float ){
		_box = box;
		box.color.a = 0;
		box.color
			.tween( .525, { a: 1 } )
			.reflect()
			.repeat(-1);		
		_gridH = gridH;
		_gridW = gridW;
	}
	
	public function get_x():Float return _box.transform.pos.x;
	public function get_y():Float return _box.transform.pos.y;
	
	public function onmousemove( ev: MouseEvent ){
		_box.transform.pos.set_xy( Math.floor( ev.x / _gridW ) * _gridW,
			Math.floor( ev.y / _gridH ) * _gridH );
	}
}

class Player {
	var _sprite: Sprite;
	var _anim: SpriteAnimation;
	var _points: List<Vector>;
	var _path: MotionPath;
	
	public function new(){
		// Create our texture
		var texture = Luxe.resources.texture("assets/player.png");
			// Scale texture cleanly
        texture.filter_min = texture.filter_mag = FilterType.nearest;
		
		// Set player sprite
		_sprite = new Sprite({
			texture: texture,
			pos: new Vector( Luxe.screen.width / 2, Luxe.screen.height / 2),
			size: new Vector( 64, 64)
		});
		
		
		// Load animator
		var anim = _anim = _sprite.add( new SpriteAnimation({name:"anim"}) );
		anim.add_from_json_object( Luxe.resources.json('assets/movement.json').asset.json ); 
		anim.animation = "stand";
		anim.play();
		
		_path = new MotionPath();
		_path.line( 0, 100);
		_path.line( 0, 500);
		_path.line( 300, 200);
		_path.line( 200, 100 );
	}
	
	public function add_point( point: Vector ){
		
		//_path.line( point.x, point.y);
		var push = point.x / Luxe.screen.w ;
		
		//trace(' these are the starts: ( ${_path.x.start} , ${_path.y.start} ) -> ( ${_path.x.end} , ${_path.y.end} )' );
		_sprite.pos.set_xy( _path.x.calculate(1), _path.y.calculate(1) );
		Actuate.motionPath( _sprite.pos, 3, {x:_path.x, y: _path.y}, 
			true)
			.ease(Linear.easeNone);
	}
}