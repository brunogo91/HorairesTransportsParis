import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.Time;

class SchedulesMenu extends WatchUi.CustomMenu {
    private var _updateTimer as Timer.Timer;
    private var _stationName as String;

    function initialize(stationName as String) {
        _stationName = stationName;
        CustomMenu.initialize(60, Graphics.COLOR_BLACK, {}); // {:title => titleText, :theme => WatchUi.MENU_THEME_RED, :dividerType => null, :titleItemHeight => 10}
        _updateTimer = new Timer.Timer();
        _updateTimer.start(method(:updateTime), 1000, true);
    }

    function getMyTitle() as String {
        var momentInfo = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dateString = Lang.format("$1$:$2$:$3$", [
            momentInfo.hour.format("%02u"),
            momentInfo.min.format("%02u"),
            momentInfo.sec.format("%02u"),
        ]);
        return dateString + "\n" + _stationName;
    }

    function drawTitle(dc as Graphics.Dc) as Void {
        var titleText = new WatchUi.TextArea({
            :text => getMyTitle(),
            :justification => Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
            :font => [Graphics.FONT_TINY, Graphics.FONT_XTINY],
            :locX => WatchUi.LAYOUT_HALIGN_LEFT,
            :locY => WatchUi.LAYOUT_VALIGN_TOP,
            :width => dc.getWidth(),
            :height => dc.getHeight(),
        });
        titleText.draw(dc);
    }

    // The requestUpdate refresh also the items (CustomItem)
    function updateTime() as Void {
        WatchUi.requestUpdate();
    }

    function onHide() as Void {
        CustomMenu.onHide();
        _updateTimer.stop();
    }
}
