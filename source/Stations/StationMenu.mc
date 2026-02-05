import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;

class StationMenuInputDelegate extends WatchUi.Menu2InputDelegate {
    private var _modifyMode as (Method() as Void);
    private var _onBack as (Method() as Void);

    function initialize(modifyMode as (Method() as Void), onBack as (Method() as Void)) {
        Menu2InputDelegate.initialize();
        _modifyMode = modifyMode;
        _onBack = onBack;
    }

    function onSelect(item as MenuItem) as Void {
        if (item.getId() == :addStation) {
            WatchUi.pushView(new StationSelectMenuView(), null, WatchUi.SLIDE_RIGHT);
            return;
        }
        if (item.getId() == :modify) {
            _modifyMode.invoke();
            return;
        }
        var view = new SchedulesView(item.getId() as StationInfo);
        WatchUi.pushView(view, null, WatchUi.SLIDE_RIGHT);
    }

    function onBack() as Void {
        _onBack.invoke();
    }
}

class StationMenu extends WatchUi.CustomMenu {
    function initialize() {
        var myText = new WatchUi.Text({
            :text => Rez.Strings.stations,
            :font => Graphics.FONT_TINY,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER,
        });
        CustomMenu.initialize(65, Graphics.COLOR_BLACK, { :title => myText });
    }

    function getMyTitle() as String {
        return WatchUi.loadResource(Rez.Strings.stations) as String;
    }
}
