import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class StationMenuItem extends WatchUi.CustomMenuItem {
    private var _title as String;
    private var _subtext as String;

    public function initialize(stationInfo as StationInfo) {
        CustomMenuItem.initialize(stationInfo, {});
        _title = stationInfo.stationName;
        if (DESTINATION.equals(stationInfo.searchType)) {
            _subtext =  "• " + stationInfo.destinationName;
        } else {
            _subtext = "> " + stationInfo.direction;
        }
    }

    // this function is called each requestUpdate triggered un CustomMenu (every seconds)
    public function draw(dc as Dc) as Void {
        var stationText = new WatchUi.Text({
            :text => _title,
            :font => Graphics.FONT_TINY,
            // :justification => Graphics.TEXT_JUSTIFY_LEFT,
            :locX => 0,
            :locY => 0,
            :width => dc.getWidth(),
            :height => dc.getHeight() / 2,
        });
        stationText.draw(dc);

        var destinationText = new WatchUi.Text({
            :text => _subtext,
            :font => Graphics.FONT_GLANCE,
            // :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER,
            :locX => 0,
            :locY => dc.getHeight() / 2,
            :width => dc.getWidth(),
            // :width => dc.getTextWidthInPixels(_subtext, Graphics.FONT_SYSTEM_TINY),
            :height => dc.getHeight() / 2,
        });
        destinationText.draw(dc);
    }

    public function getLabel() as String {
        return _title;
    }

    public function getSubLabel() as Lang.String or Lang.Dictionary<Lang.Symbol, Lang.String?> or Null {
        return _subtext;
    }
}
