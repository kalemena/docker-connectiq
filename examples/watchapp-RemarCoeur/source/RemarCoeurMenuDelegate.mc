using Toybox.WatchUi;
using Toybox.System;

class RemarCoeurMenuDelegate extends WatchUi.MenuInputDelegate {

	var mView;

    function initialize( view ) {
        MenuInputDelegate.initialize();
        mView = view;
    }

    function onMenuItem(item) {
        if (item == :item_1) {
            // System.println("item 1");
            mView.nextSensor();
            WatchUi.requestUpdate();
        	return true;
            
        } else if (item == :item_2) {
            // System.println("item 2");
            mView.previousSensor();
            WatchUi.requestUpdate();
        	return true;
        }
    }

}