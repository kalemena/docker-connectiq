using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;

class Background extends WatchUi.Drawable {

    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };

        Drawable.initialize(dictionary);
    }

    function draw(dc) {
    	var width      = dc.getWidth();
        var height     = dc.getHeight();
    
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_WHITE);
        dc.fillRectangle(0, 30, width, height-60);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.drawRectangle(-1, 30, width+2, height-60);
    }

}
