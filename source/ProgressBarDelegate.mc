import Toybox.WatchUi;
import Toybox.Communications;

class ProgressBarDelegate extends WatchUi.BehaviorDelegate {
    private var _onBack as Method() as Void;

    function initialize(onBack as Method() as Void) {
        BehaviorDelegate.initialize();
        _onBack = onBack;
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        _onBack.invoke();
        return true;
    }
}