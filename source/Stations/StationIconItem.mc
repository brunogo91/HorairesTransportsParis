import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Math;
import Toybox.Timer;
import Toybox.Time;

class StationIconItem extends WatchUi.CustomMenuItem {
    private var _res as ResourceId;
    private var _text as ResourceId;
    public function initialize(text as ResourceId, rez as ResourceId, identifier as Lang.Object) {
        CustomMenuItem.initialize(identifier, {});
        _res = rez;
        _text = text;
    }

    // this function is called each requestUpdate triggered un CustomMenu (every seconds)
    public function draw(dc as Dc) as Void {
        var imgResource = Application.loadResource(_res) as BitmapResource;
        if (isFocused()) {
            dc.drawBitmap(0, (dc.getHeight() - imgResource.getHeight()) / 2, imgResource);
            var stationText = new WatchUi.TextArea({
                :text => Application.loadResource(_text),
                :font => [Graphics.FONT_TINY, Graphics.FONT_XTINY],
                :justification => Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER,
                // :locX => dc.getWidth() / 2,
                :locX => imgResource.getWidth() + 5,
                :locY => 0,
                :width => dc.getWidth() - imgResource.getWidth() + 5,
                :height => dc.getHeight(),
            });
            stationText.draw(dc);
        } else {
            dc.drawBitmap(0, (dc.getHeight() - imgResource.getHeight()) / 2, imgResource);
        }
    }
}
