using Toybox.System;
using Toybox.WatchUi;
using Toybox.SensorHistory;
using Toybox.Lang;
using Toybox.Graphics;
using Toybox.Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as Monitor;
using Toybox.Math as Math;

class watchfacegenesysanalogView extends WatchUi.WatchFace {

    var lowPowerMode = false;
    var lowPowerModeMin = null; // minutes when low power mode got set
    
    function initialize() {
        WatchFace.initialize();
    }
    	
    // Load your resources here
    function onLayout(dc) {
    	setLayout(Rez.Layouts.WatchFace(dc));
    }
    
    // Create a method to get the SensorHistoryIterator object
	function getIterator() {
	    // Check device for SensorHistory compatibility
	    if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getTemperatureHistory)) {
	        // Set up the method with parameters
	        return Toybox.SensorHistory.getTemperatureHistory({});
	    }
	    return null;
	}
    
    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }
    
    // Update the view
    function onUpdate(dc) {
		
        var clockTime  = System.getClockTime();
        
		// refresh only every minute
 		if(lowPowerMode) {
 			if(lowPowerModeMin != null && lowPowerModeMin == clockTime.min) {
 				return;
 			}
 			lowPowerModeMin = clockTime.min;
 		} else {
 			lowPowerModeMin = null;
 		}	
 		
 		refreshDisplay(dc, clockTime);		                
    }
    
    function refreshDisplay(dc, clockTime) {
    	// refresh
 		View.onUpdate(dc);
 		
 		var width      = dc.getWidth();
        var height     = dc.getHeight();
        var angleHour, angleMin, angleSec;
 		
		var hour = ((clockTime.hour % 12) * 60.0 + clockTime.min) / 60.0;        
        angleHour = ((hour * 5.0) / 60.0) * Math.PI * 2;
        // System.println("Hours=" + hour + " => " + angleHour );
        angleMin = ( clockTime.min / 60.0) * Math.PI * 2;
        // System.println("Minutes=" + clockTime.min + " => " + angleMin );
        angleSec = ( clockTime.sec / 60.0) * Math.PI * 2;
        // System.println("Seconds=" + clockTime.sec + " => " + angleSec + " = " + angleSec * 360 / (2 * Math.PI));
        
        // hour
    	drawHand(dc, width/2, height/2, angleHour, 0, 45, 10, 7);
		// minutes
    	drawHand(dc, width/2, height/2, angleMin, 0, 95, 7, 6);
		// seconds
		if(!lowPowerMode)
 		{       
        	drawHandRound(dc, width/2, height/2, angleSec, 112, 5, 4);
        	// dc.fillCircle(width/2, height/2, 4);                         
		}
		
		// Temperature
		var sensorIter = getIterator();
		if (sensorIter != null) {
		    // System.println(sensorIter.next().data);
		    dc.drawText(
		        dc.getWidth() / 2 + 30,
		        dc.getHeight() / 2 + 30,
		        Graphics.FONT_LARGE,
		        sensorIter.next().data.format("%02d"),
		        Graphics.TEXT_JUSTIFY_CENTER
		    );
		    dc.setPenWidth(1);
		    dc.drawCircle(dc.getWidth() / 2 + 45,dc.getHeight() / 2 + 40,2);
		}
    }
    
    function rotateAndDraw(dc, coords, cos, sin, centerX, centerY) {
    	var coordsRotated = new [coords.size()];

		for (var i = 0; i < coords.size(); i += 1)
        {
            var x = (coords[i][0] * cos) - (coords[i][1] * sin);
            var y = (coords[i][0] * sin) + (coords[i][1] * cos);
            coordsRotated[i] = [ centerX+x, centerY+y];
        }
        dc.fillPolygon(coordsRotated);
    }

    function drawHand(dc, centerX, centerY, angle, distIn, distOut, radius, width) {
		
		// Math
		var cos = Math.cos(angle);
		var sin = Math.sin(angle);
		
		// 2 x Arcs		
		var x1 = centerX + (distOut * sin);
        var y1 = centerY - (distOut * cos);
        var x2 = centerX + (distIn * sin);
        var y2 = centerY - (distIn * cos);
                 
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT); 
        dc.setPenWidth(width);
              
        var angleArcStart = - ((angle * 360 / (2 * Math.PI)) + 90); 
        dc.drawArc(x1, y1, radius, Graphics.ARC_CLOCKWISE, angleArcStart - 90, angleArcStart + 90);
        dc.drawArc(x2, y2, radius, Graphics.ARC_CLOCKWISE, angleArcStart + 90, angleArcStart + 270);
        
        // Circle
        //drawHandRound(dc, centerX, centerY, angle, distOut, radius, width);
        //drawHandRound(dc, centerX, centerY, angle, distIn, radius, width);
        
        // 2 x Bars
        var length = distOut-distIn+1;
        var coords = [[radius + width/2, -distIn], [radius + width/2, -distIn-length], [radius - width/2, -distIn-length], [radius - width/2, -distIn]];
        rotateAndDraw(dc, coords, cos, sin, centerX, centerY);
        
        coords = [[-radius + width/2, -distIn], [-radius + width/2, -distIn-length], [-radius - width/2, -distIn-length], [-radius - width/2, -distIn]];
        rotateAndDraw(dc, coords, cos, sin, centerX, centerY);
    }
    
    function drawHandRound(dc, centerX, centerY, angle, dist, radius, width) {
    	dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT); 
        dc.setPenWidth(width);
    
		var cos = Math.cos(angle);
		var sin = Math.sin(angle);
		var x = centerX + (dist * sin);
        var y = centerY - (dist * cos);
                        
        dc.drawCircle(x,y,radius);        
    }
    
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

	// The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
	    lowPowerMode = false;
	    WatchUi.requestUpdate();     
    }

	// Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
	    lowPowerMode = true;
	    WatchUi.requestUpdate();
    }

}

