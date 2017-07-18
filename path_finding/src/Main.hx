package;
import luxe.GameConfig;
import luxe.Input;
import luxe.Vector;
import luxe.Color;
import luxe.Sprite;

class Main extends luxe.Game {
    var isoGrid: IsometricGrid;
    var cellW: Int = cast 111/2;
    var cellH: Int = cast 65/2;
    var mouseSprite: Sprite;

    override function config(config:GameConfig) {

        config.window.title = 'luxe game';
        config.window.width = 960;
        config.window.height = 640;
        config.window.fullscreen = false;

        config.preload.textures.push({ id:'assets/iso_block_lg.png' });

        return config;

    } //config

    override function ready() {
            // Grid size variables
        var cells: Int = 9;
        var lineLength: Int = cells;

            // Create the grid tool
        isoGrid = new IsometricGrid( cellW, cellH, Luxe.screen.width/2, 0);
        isoGrid.orthoY -= isoGrid.fromIso(1,1)[1]*cells/2 - Luxe.screen.height/2;

        createGrid(cells, lineLength);

            // Set mouse sprite
        var image = Luxe.resources.texture("assets/iso_block_lg.png");
        var mousePos = isoGrid.fromIso( 4, 4 );
        mouseSprite = new Sprite({
            name: 'mouse',
            texture: image,
            pos : new Vector( mousePos[0], mousePos[1] ),
            origin: new Vector( image.width/2, image.height/2 - 3)
        });
        

    } //ready

    function createGrid(cells: Int, lineLength: Int){        
            // Create the grid lines
            // Vertical rules
        for( i in 0...cells + 1){
            var pos = isoGrid.fromIso( i, 0 );
            var v1 = new Vector( pos[0], pos[1] );
            pos = isoGrid.fromIso( i, lineLength );
            var v2 = new Vector( pos[0], pos[1] );
            Luxe.draw.line({
                p0 : v1,
                p1 : v2,
                color : new Color(0.5,0.2,0.2, 1)
            });
        }
            // Horizontal rules
        for( j in 0...cells + 1 ){
            var pos = isoGrid.fromIso( 0,j );
            var v1 = new Vector( pos[0], pos[1] );
            pos = isoGrid.fromIso( lineLength, j );
            var v2 = new Vector( pos[0], pos[1] );
            Luxe.draw.line({
                p0 : v1,
                p1 : v2,
                color : new Color(0.2,0.2,0.5, 1)
            });
        }
    }

    override function onkeyup(event:KeyEvent) {
        if(event.keycode == Key.escape) { Luxe.shutdown(); }
    } //onkeyup

    override function onmousemove( e: MouseEvent ){
        var isoP = isoGrid.toIso( e.x, e.y );
        var mousePos = isoGrid.fromIso( Math.floor(isoP[0]), Math.floor(isoP[1]) );
        mouseSprite.pos.set( mousePos[0], mousePos[1],0 ,0 ); 
        mouseSprite.depth = mouseSprite.pos.y;
    }

    override function onmousedown( e: MouseEvent ){
        var image = Luxe.resources.texture("assets/iso_block_lg.png");
        new Sprite({
            texture: image,
            pos : mouseSprite.pos.clone(),
            origin: new Vector( image.width/2, image.height/2 - 3),
            depth: mouseSprite.pos.y
        });
    }

    override function update(delta:Float) {

    } //update

} //Main
