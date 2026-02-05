import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class StationModifyMenuInputDelegate extends WatchUi.Menu2InputDelegate {
    var _onBack as Method() as Void;
    var _onDelete as Method(indexDeleted as Number) as Void;

    function initialize(onBack as Method() as Void, onDelete as Method(itemDeleted as Number) as Void) {
        Menu2InputDelegate.initialize();
        _onBack = onBack;
        _onDelete = onDelete;
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var indexDeleted = StorageAccess.deleteStation(item.getId() as StationInfo);
        if (indexDeleted != -1) {
            _onDelete.invoke(indexDeleted);
        }
    }

    function onBack() as Void {
        _onBack.invoke();
    }
}

class StationModifyMenu extends WatchUi.CustomMenu {
    function initialize() {
        var myText = new WatchUi.Text({
            :text => Rez.Strings.stations,
            :font => Graphics.FONT_TINY,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER,
        });
        CustomMenu.initialize(65, Graphics.COLOR_BLACK, { :title => myText });
    }

    function drawForeground(dc as Graphics.Dc) as Void {
        WatchUi.CustomMenu.drawForeground(dc);
        var pencilResource = Application.loadResource(Rez.Drawables.deleteConfirmIcon);
        var pencil = new WatchUi.Bitmap({
            :bitmap => pencilResource,
            // :rezId => Rez.Drawables.deleteConfirmIcon,
            :locX => dc.getWidth() - pencilResource.getWidth() - 10,
            :locY => dc.getHeight() / 4 - pencilResource.getHeight() / 2 + 2,
        });
        pencil.draw(dc);
    }

    function getMyTitle() as String {
        return WatchUi.loadResource(Rez.Strings.stations) as String;
    }
}
