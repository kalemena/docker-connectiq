using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.Sensor;
using Toybox.SensorHistory;
using Toybox.Graphics as Gfx;

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
                               "hPa",
                               "m" ];
                               
    hidden var mSensorFactor = [1, 1, 0.01, 1 ];

	private var mSensorValues = [ 0, 0, 0, 0 ];

    function initialize() {
        View.initialize();
        
        Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);
    	Sensor.enableSensorEvents(method(:onSensorHeartRate));
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

	function draw(dc) {
		
		for(var i = 0; i < 4; i += 1) {
        	var fieldTemplate = "output$1$";
			var myParams = [i];
			var fieldName = Lang.format(fieldTemplate, myParams);
    	
	        var output = View.findDrawableById(fieldName);
	        // mSensorLabel[i]
	        output.setText(me.mSensorValues[i] + " " + mSensorMetric[i]);
        }
		
	}

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	for(var i = 0; i < 4; i += 1) {
    		me.mSensorValues[i] = "0";
    	}
    	
    	onRefreshSensor();
    	//draw(dc);
    	
		var myTimer = new Timer.Timer();
    	myTimer.start(method(:onRefreshSensor), 5000, true);
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        draw(dc);        
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
    
    function onSensorHeartRate(sensorInfo) {
    	// System.println("Heart Rate: " + sensorInfo.heartRate);
    	var HR = sensorInfo.heartRate;
        if( HR != null ) {
            me.mSensorValues[0] = HR.toString();
        }
	}
    
    function onRefreshSensor() {
    	// System.println(".");
    
    	for(var i = 1; i < 4; i += 1) {
		    var sensorValue = me.getLatestSensorHistory(i);
		    
			if (sensorValue == null) {
	    		me.mSensorValues[i] = "0";
	    	}    		
	    	else {
	    		sensorValue = sensorValue * mSensorFactor[i];			
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
