using Toybox.WatchUi;

class RemarCoeurDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new RemarCoeurMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}