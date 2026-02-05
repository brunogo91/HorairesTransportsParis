import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class StationListView extends WatchUi.View {
    private var _modifyMode as Boolean;
    private var _displayed as Boolean;
    private var _modifyMenu as StationModifyMenu?;
    private var _nbStations as Number;

    function initialize() {
        View.initialize();
        _modifyMode = false;
        _displayed = false;
        _nbStations = 0;
    }

    function modifyMode() as Void {
        _modifyMode = true;
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }

    function onBack() as Void {
        if (!_modifyMode) {
            WatchUi.popView(WatchUi.SLIDE_RIGHT);
        }
        _modifyMode = false;
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }

    function onDelete(itemDeleted as Number) as Void {
        var deleted = _modifyMenu.deleteItem(itemDeleted);
        if (deleted == true) {
            _nbStations--;
        }
        if (_nbStations == 0) {
            onBack();
        } else {
            WatchUi.requestUpdate();
        }
    }

    function onShow() as Void {
        _displayed = false; // redraw on display
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        if (_displayed) {
            return;
        }
        _displayed = true;
        if (_modifyMode) {
            pushModifyMenu();
        } else {
            pushMenu();
        }
    }

    function pushMenu() as Void {
        var menu = new StationMenu();
        var stations = StorageAccess.getStations();
        for (var i = 0; i < stations.size(); i++) {
            menu.addItem(new StationMenuItem(stations[i]));
        }
        menu.addItem(new StationIconItem(Rez.Strings.addStation, Rez.Drawables.AddIcon, :addStation));
        if (stations.size() > 0) {
            menu.addItem(new StationIconItem(Rez.Strings.removeStation, Rez.Drawables.BinIcon, :modify));
        }

        WatchUi.pushView(
            menu,
            new StationMenuInputDelegate(self.method(:modifyMode), self.method(:onBack)),
            WatchUi.SLIDE_IMMEDIATE
        );
    }

    function pushModifyMenu() as Void {
        _modifyMenu = new StationModifyMenu();
        var stations = StorageAccess.getStations();
        _nbStations = stations.size();
        for (var i = 0; i < stations.size(); i++) {
            _modifyMenu.addItem(new StationMenuItem(stations[i]));
        }
        WatchUi.pushView(
            _modifyMenu,
            new StationModifyMenuInputDelegate(self.method(:onBack), self.method(:onDelete)),
            WatchUi.SLIDE_IMMEDIATE
        );
    }
}
