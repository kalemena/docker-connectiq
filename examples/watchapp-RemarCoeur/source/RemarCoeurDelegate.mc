using Toybox.WatchUi;

class RemarCoeurDelegate extends WatchUi.BehaviorDelegate {

	var mView;

    function initialize(view) {
        BehaviorDelegate.initialize();
        mView = view;
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new RemarCoeurMenuDelegate(mView), WatchUi.SLIDE_UP);
        return true;
    }

}