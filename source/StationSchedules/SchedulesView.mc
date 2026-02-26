import Toybox.Attention;
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Time;
// import Toybox.Timer;

class SchedulesMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _reload as Method() as Void;
    private var _back as Method() as Void;

    function initialize(reload as Method() as Void, back as Method() as Void) {
        Menu2InputDelegate.initialize();
        _reload = reload;
        _back = back;
    }

    function onSelect(item as MenuItem) as Void {
        // todo : try to differentiate tap and select
        _reload.invoke();
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        _back.invoke();
    }
}

class SchedulesView extends WatchUi.View {
    enum SchedulesViewState {
        STARTING,
        WAITING,
        LOADED,
        FINISH,
        EXITED,
    }

    private var _schedulesResult as SchedulesResult?;
    private var _viewState as SchedulesViewState;
    private var _selectedItem as StationInfo;
    private var _schedulesGateway as SchedulesGateway;
    private var _progressDisplayed as Boolean;
    // private var _updateTimer as Timer.Timer; // reload schedules regulary

    function initialize(selectedItem as StationInfo) {
        View.initialize();
        _selectedItem = selectedItem;
        _viewState = STARTING;
        _progressDisplayed = false;
        // _schedulesGateway = new SchedulesGateway(selectedItem, self.method(:updateSchedules));
        _schedulesGateway = new SchedulesGateway(selectedItem, SchedulesView.method(:updateSchedules));
        _schedulesGateway.getNextTrain();
        // _updateTimer = new Timer.Timer();
        // _updateTimer.start(method(:reloadSchedules), 20000, true);
    }

    function updateSchedules(schedulesResult as SchedulesResult) as Void {
        if (_viewState == EXITED) {
            return;
        }
        _viewState = LOADED;
        _schedulesResult = schedulesResult;
        if (_progressDisplayed == true) {
            WatchUi.popView(WatchUi.SLIDE_RIGHT); // pop progressBar
            _progressDisplayed = false;
        }
    }

    function reloadSchedules() as Void {
        _viewState = STARTING;
        WatchUi.popView(WatchUi.SLIDE_RIGHT); // pop displayed schedules
        _schedulesGateway.getNextTrain();
    }

    function back() as Void {
        // _schedulesGateway.cancelRequest();
        // _updateTimer.stop();
        _viewState = EXITED;
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }

    function onUpdate(dc as Dc) as Void {
        if (_viewState == WAITING || _viewState == FINISH) {
            return;
        }

        if (_viewState == STARTING && _progressDisplayed == false) {
            _viewState = WAITING;
            var progressBar = new WatchUi.ProgressBar(Application.loadResource(Rez.Strings.loading) as String, null);
            WatchUi.pushView(progressBar, new ProgressBarDelegate(method(:back)), WatchUi.SLIDE_LEFT);
            _progressDisplayed = true;
            return;
        }

        // LOADED case
        _viewState = FINISH;
        Attention.backlight(true);
        Attention.vibrate([new Attention.VibeProfile(50, 250)]);

        if (_schedulesResult instanceof GatewayResultKO) {
            WatchUi.showToast(_schedulesResult.message, { :icon => Rez.Drawables.warningToastIcon });
            WatchUi.popView(WatchUi.SLIDE_RIGHT); // pop progressBar
            return;
        }

        dc.clear();
        // View.onUpdate(dc);
        if (_schedulesResult != null && _schedulesResult.size() > 0) {
            makeCustomMenu(dc, _schedulesResult);
        } else {
            displayNoMoreTrain(dc);
        }
    }

    function makeCustomMenu(dc as Dc, schedules as Array<Schedule>) as Void {
        var customMenu = new SchedulesMenu(_selectedItem.stationName);
        for (var i = 0; i < schedules.size(); i++) {
            var schedule = schedules[i] as Schedule;
            var item = new ScheduleItem(schedule.departureTime.value(), schedule);
            customMenu.addItem(item);
        }
        WatchUi.pushView(
            customMenu,
            new SchedulesMenuDelegate(SchedulesView.method(:reloadSchedules), SchedulesView.method(:back)),
            WatchUi.SLIDE_RIGHT
        );
    }

    function displayNoMoreTrain(dc as Dc) as Void {
        var myTextArea = new WatchUi.TextArea({
            :text => Application.loadResource(Rez.Strings.noMoreTrain) + _selectedItem.stationName,
            :font => [Graphics.FONT_TINY, Graphics.FONT_XTINY],
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER,
            :width => dc.getWidth(),
            :height => dc.getHeight(),
        });
        myTextArea.draw(dc);
    }
}
