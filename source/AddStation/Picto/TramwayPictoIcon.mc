import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class TramwayPictoIcon extends WatchUi.Drawable {
    private var _lineName as String;
    private var _color as String;
    // private var _textColor as String;
    private static const _lineHeight = 4 as Number;

    public function initialize(lineName as String, color as String, textColor as String) {
        Drawable.initialize({});
        _lineName = lineName;
        _color = color;
        // _textColor = textColor;
    }

    public function draw(dc as Dc) as Void {
        var middleWidth = dc.getWidth() / 2;
        var middleHeigth = dc.getHeight() / 2;
        var textDimensions = dc.getTextDimensions(_lineName, Graphics.FONT_SMALL);
        var demiHeightText = textDimensions[1] / 2;

        dc.setColor(_color.toNumberWithBase(16), Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, middleHeigth - demiHeightText - _lineHeight - 3, dc.getWidth(), _lineHeight);
        dc.fillRectangle(0, middleHeigth + demiHeightText + 1, dc.getWidth(), _lineHeight);
        dc.setColor(Graphics.COLOR_WHITE,  Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            middleWidth,
            middleHeigth,
            Graphics.FONT_SMALL,
            _lineName,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }
}
