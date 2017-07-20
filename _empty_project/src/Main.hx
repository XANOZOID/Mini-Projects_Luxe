package;
import luxe.GameConfig;

class Main extends luxe.Game 
{
	var showMouse = true;

	override public function config(_config:GameConfig):GameConfig {
		return super.config(_config);
	}
	
	override function ready() {
		Luxe.renderer.clear_color.set(0, 0.2, 0.9, 1);
	}
	
	override function onkeyup(e:KeyEvent) {
		if(e.keycode == Key.escape) Luxe.shutdown();
	}

	override function update(dt:Float) {
	}
	
	override function onmousemove( ev: MouseEvent ){	
	}
	
	override function onmousedown( ev: MouseEvent ){
	}
}

function showMouse(show:bool){
	#if web
		var gameStyle = js.Browser.document.getElementById("app").style;
		if( show ){ style.cursor = 'none'; }
		else{ style.cursor = ''; }
	#else
		sdl.SDL.showCursor( show );
	#end
}