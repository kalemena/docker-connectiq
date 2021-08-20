using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;

class Background extends WatchUi.Drawable {

	var mColors = [ Graphics.COLOR_BLUE,
                    Graphics.COLOR_GREEN,
                    Graphics.COLOR_ORANGE,
                    Graphics.COLOR_PURPLE ];

    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };

        Drawable.initialize(dictionary);
    }

    function draw(dc) {
    	var width      = dc.getWidth();
        var height     = dc.getHeight();
        
        var hMin = 36;
        var hSize = 40;
        
        for(var i = 0; i < 4; i += 1) {
        	var hPos = hMin + (hSize) * i;
        	
        	dc.setColor(mColors[i], Graphics.COLOR_WHITE);
        	dc.fillRectangle(0, hPos, width, hSize);
        
        	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        	dc.drawRectangle(-1, hPos, width+2, hSize);
        }           
    }

}
