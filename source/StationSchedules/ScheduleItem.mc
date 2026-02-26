import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Math;
import Toybox.Timer;

class ScheduleItem extends WatchUi.CustomMenuItem {
    private var _schedule as Schedule;
    private var _title as String;
    private var _subtext as String;

    public function initialize(id as Object, schedule as Schedule) {
        CustomMenuItem.initialize(id, {});
        _schedule = schedule;
        _title = schedule.destination;
        _subtext = "";
    }

    // this function is called each requestUpdate triggered un CustomMenu (every seconds)
    public function draw(dc as Dc) as Void {
        var destTextColor = Graphics.COLOR_WHITE;
        var newTitle = _title;
        if ("notFinded".equals(_schedule.status)) {
            destTextColor = Graphics.COLOR_ORANGE;
            newTitle = "? " + _title;
        }

        var destinationText = new WatchUi.Text({
            :text => newTitle,
            :color => destTextColor,
            // :font => Graphics.FONT_XTINY,
            :font => Graphics.FONT_GLANCE,
            :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER,
            :locX => 0,
            :locY => dc.getHeight() / 4,
            // :width => dc.getWidth(),
            // :height => dc.getHeight(),
        });
        destinationText.draw(dc);

        var now = Time.now();
        var isBeforeNow = _schedule.departureTime.lessThan(now);
        var textColor = Graphics.COLOR_WHITE;
        if (_schedule.onPlatform == true) {
            textColor = Graphics.COLOR_GREEN;
        } else if (isBeforeNow || _schedule.isCancelled()) {
            textColor = Graphics.COLOR_RED;
        } else if (_schedule.isDelayed()) { // TODO DELAYED
            textColor = Graphics.COLOR_PINK;
        }

        var durationSecondes = _schedule.departureTime.subtract(now).value();
        var hours = durationSecondes / 3600;
        var hourToMin = durationSecondes % 3600;
        var min = hourToMin / 60;
        var sec = hourToMin % 60;
        var remaining = _schedule.isCancelled() ? Application.loadResource(Rez.Strings.cancelled) + " - " : "";
        remaining += isBeforeNow ? "-" : "";
        remaining += hours >= 1 ? Math.floor(hours) + "h" : "";
        remaining += min + "min" + sec + "s";
        _subtext = remaining + " - " + _schedule.hour();
        var remainingTimeText = new WatchUi.Text({
            :text => _subtext,
            :color => textColor,
            :font => Graphics.getVectorFont({ :face => "BionicBold", :size => dc.getFontHeight(Graphics.FONT_SMALL) }),
            // :font => Graphics.FONT_TINY,
            :justification => Graphics.TEXT_JUSTIFY_LEFT,
            :locX => 0,
            :locY => dc.getHeight() / 2 - 4,
            :height => dc.getHeight() / 2,
        });
        remainingTimeText.draw(dc);

    }

    public function getLabel() as String {
        return _title;
    }

    public function getSubLabel() as Lang.String or Lang.Dictionary<Lang.Symbol, Lang.String?> or Null {
        return _subtext;
    }
}
