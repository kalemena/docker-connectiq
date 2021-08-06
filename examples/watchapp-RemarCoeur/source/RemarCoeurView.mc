using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.SensorHistory;

class RemarCoeurView extends WatchUi.View {

	hidden var mIndex = 0;
    hidden var mSensorSymbols = [:getHeartRateHistory,
                                 :getTemperatureHistory,
                                 :getPressureHistory,
                                 :getElevationHistory ];
                                 
    hidden var mSensorLabel = ["Heart",
                               "Temp",
                               "Pressure",
                               "Elevation" ];
                               
    hidden var mSensorMetric = ["bpm",
                               "°C",
                               "?",
                               "m" ];

	private var mSensorValues = [ 0, 0, 0, 0 ];

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	for(var i = 0; i < 4; i += 1) {
    		me.mSensorValues[i] = "0";
    	}
    	
		var myTimer = new Timer.Timer();
    	myTimer.start(method(:onRefreshSensor), 5000, true);
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        for(var i = 0; i < 4; i += 1) {
        	var fieldTemplate = "output$1$";
			var myParams = [i];
			var fieldName = Lang.format(fieldTemplate, myParams);
    	
	        var output = View.findDrawableById(fieldName);
	        // mSensorLabel[i]
	        output.setText(me.mSensorValues[i] + " " + mSensorMetric[i]);
        }
        
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

	private function getLatestSensorHistory(index) {
		if ( ( Toybox has :SensorHistory ) && ( Toybox.SensorHistory has mSensorSymbols[index] ) ) {
            var getMethod = new Lang.Method( Toybox.SensorHistory, mSensorSymbols[index] );
            var sensorHistory = getMethod.invoke( {:period =>10, :order => SensorHistory.ORDER_NEWEST_FIRST} );
	        return sensorHistory.next().data;
        }
	
	    return null;
    }
    
    function onRefreshSensor() {
    	// System.println(".");
    
    	for(var i = 0; i < 4; i += 1) {
		    var sensorValue = me.getLatestSensorHistory(i);
			if (sensorValue == null) {
	    		me.mSensorValues[i] = "0";
	    	}    		
	    	else {			
	    		me.mSensorValues[i] =  sensorValue.format("%4.2f");
	    	}
		}
    	
    	WatchUi.requestUpdate();
    }
    
    function nextSensor() {
        mIndex += 1;
        mIndex %= 4;
    }

    function previousSensor() {
        mIndex += 3;
        mIndex %= 4;
    }
}
