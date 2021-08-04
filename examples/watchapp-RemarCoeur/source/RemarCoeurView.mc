using Toybox.WatchUi;
using Toybox.Lang;
using Toybox.SensorHistory;

class RemarCoeurView extends WatchUi.View {

	private var mTemperature;

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
    	me.mTemperature = "0";
		var myTimer = new Timer.Timer();
    	myTimer.start(method(:onRefreshTempSensor), 1000, true);
    }

    // Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        var output = View.findDrawableById("output");
        output.setText(me.mTemperature);
        
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

	private function getLatestTemperatureHistory() {
    	if ((Toybox has :SensorHistory) && (SensorHistory has :getTemperatureHistory)) {
	        var temperatureHistory = SensorHistory.getTemperatureHistory({:period =>10, :order => SensorHistory.ORDER_NEWEST_FIRST});
	        return temperatureHistory.next().data;
	    }
	    return null;
    }
    
    function onRefreshTempSensor() {
    	var temperature = me.getLatestTemperatureHistory();
		if (temperature == null) {
    		me.mTemperature = "0";
    	}    		
    	else {			
    		me.mTemperature =  temperature.format("%4.2f");
    	}
    	WatchUi.requestUpdate();
    }
}
