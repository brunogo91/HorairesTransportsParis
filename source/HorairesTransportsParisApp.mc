import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class HorairesTransportsParisApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    (:glance)
    function getGlanceView() {
        return [new GlanceView()];
    }

    // Return the initial view of your application here
    // This is the entry point of the app
    function getInitialView() {
        if (!System.getDeviceSettings().phoneConnected) {
            return [new ConnectPhoneView()];
        }
        return [new StationListView()];
    }
}

function getApp() as HorairesTransportsParisApp {
    return Application.getApp() as HorairesTransportsParisApp;
}
