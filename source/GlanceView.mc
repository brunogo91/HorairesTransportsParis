import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

(:glance)
class GlanceView extends WatchUi.GlanceView {
    function initialize() {
        GlanceView.initialize();
    }

    function onUpdate(dc) {
        var myText = new WatchUi.Text({
            // :text => WatchUi.loadResource(Rez.Strings.schedules) as String,
            :text => Rez.Strings.schedules,
            :font => Graphics.FONT_TINY,
            :locX => WatchUi.LAYOUT_HALIGN_LEFT,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER,
            :width => dc.getWidth(),
            :height => dc.getHeight(),
        });

        myText.draw(dc);
    }
}
