import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Application.Storage;

class StationSelectionSelectMenuInputDelegate extends WatchUi.Menu2InputDelegate {
    protected var _stationSelection as StationSelection;
    protected var _stationGateway as StationSelectionGateway;
    protected var _progressBar as ProgressBar;

    function initialize(stationSelection as StationSelection) {
        Menu2InputDelegate.initialize();
        _stationSelection = stationSelection;
        _stationGateway = new StationSelectionGateway();
        _progressBar = new WatchUi.ProgressBar((Application.loadResource(Rez.Strings.loading)) as String, null);
    }
}
class StationModeSelectMenuInputDelegate extends StationSelectionSelectMenuInputDelegate {
    private var _onUpdate as Method(lineResult as LineResult) as Void;

    function initialize(stationSelection as StationSelection, onUpdate as Method(lineResult as LineResult) as Void) {
        StationSelectionSelectMenuInputDelegate.initialize(stationSelection);
        _onUpdate = onUpdate;
    }

    function onSelect(item as MenuItem) as Void {
        WatchUi.pushView(_progressBar, null, WatchUi.SLIDE_LEFT);
        _stationSelection.setMode(item.getId() as String);
        _stationGateway.makeStationRequest(LINES_SEARCH, _stationSelection, new LineResultHandler(_onUpdate));
    }

    function onBack() {
        _stationSelection.setMode(null);
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}
class StationLineSelectMenuInputDelegate extends StationSelectionSelectMenuInputDelegate {
    private var _onUpdate as Method(idNameResult as IdNameResult) as Void;

    function initialize(stationSelection as StationSelection, onUpdate as Method(idNameResult as IdNameResult) as Void) {
        StationSelectionSelectMenuInputDelegate.initialize(stationSelection);
        _onUpdate = onUpdate;
    }

    function onSelect(item as MenuItem) as Void {
        WatchUi.pushView(_progressBar, null, WatchUi.SLIDE_LEFT);
        _stationSelection.setLineId(item.getId() as String);
        _stationSelection.setLineName(item.getLabel());
        _stationGateway.makeStationRequest(STATIONS_SEARCH, _stationSelection, new IdNameResultHandler(_onUpdate));
    }

    function onBack() {
        _stationSelection.setLineId(null);
        _stationSelection.setLineName(null);
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}
class StationStationSelectMenuInputDelegate extends StationSelectionSelectMenuInputDelegate {
    private var _onUpdate as (Method(idNameResult as IdNameResult) as Void) or (Method(directionResult as DirectionResult) as Void);

    function initialize(
        stationSelection as StationSelection,
        onUpdate as (Method(idNameResult as IdNameResult) as Void) or (Method(directionResult as DirectionResult) as Void)
    ) {
        StationSelectionSelectMenuInputDelegate.initialize(stationSelection);
        _onUpdate = onUpdate;
    }

    function onSelect(item as MenuItem) as Void {
        WatchUi.pushView(_progressBar, null, WatchUi.SLIDE_LEFT);
        _stationSelection.setStationStopAreaId(item.getId() as String);
        _stationSelection.setStationName(item.getLabel());

        if (StationSelectMenuView.isDestinationMode(_stationSelection.mode)) {
            _stationGateway.makeStationRequest(DESTINATIONS_SEARCH, _stationSelection, new IdNameResultHandler(_onUpdate));
        } else {
            _stationGateway.makeStationRequest(DIRECTIONS_SEARCH, _stationSelection, new DirectionResultHandler(_onUpdate));
        }
    }

    function onBack() {
        _stationSelection.setStationStopAreaId(null);
        _stationSelection.setStationName(null);
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}

class DirectionSelectMenuInputDelegate extends WatchUi.Menu2InputDelegate {
    private var _onUpdate as (Method() as Void);
    private var _stationSelection as StationSelection;

    function initialize(stationSelection as StationSelection, onUpdate as Method() as Void) {
        Menu2InputDelegate.initialize();
        _onUpdate = onUpdate;
        _stationSelection = stationSelection;
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        _stationSelection.setDirection(item.getLabel());
        _stationSelection.setStationStopPointIds(item.getId() as Array<String>);
        _onUpdate.invoke();
    }
}

class DestinationSelectMenuInputDelegate extends WatchUi.Menu2InputDelegate {
    private var _onUpdate as (Method() as Void);
    private var _stationSelection as StationSelection;

    function initialize(stationSelection as StationSelection, onUpdate as (Method() as Void)) {
        Menu2InputDelegate.initialize();
        _onUpdate = onUpdate;
        _stationSelection = stationSelection;
    }

    function onSelect(item as MenuItem) as Void {
        _stationSelection.setDestinationId(item.getId() as String);
        _stationSelection.setDestinationName(item.getLabel());
        _onUpdate.invoke();
    }
}

class StationSelectMenuView extends WatchUi.View {
    private var _physicalMode as Array<PhysicalMode>;
    private var _stationSelection as StationSelection;

    static const drawablesList = {
        // "physical_mode:Bus" => Rez.Drawables.Bus,
        // "physical_mode:Funicular" => Rez.Drawables.Funicular,
        "physical_mode:Metro" => Rez.Drawables.Metro,
        // "physical_mode:Train" => Rez.Drawables.Train,
        "physical_mode:RapidTransit" => Rez.Drawables.Train,
        "physical_mode:LocalTrain" => Rez.Drawables.Train,
        "physical_mode:Tramway" => Rez.Drawables.Tramway,
    };

    function initialize() {
        View.initialize();
        _stationSelection = new StationSelection();
        var physicalModes =
            Application.loadResource(Rez.JsonData.physicalMode) as Dictionary<String, Array<PhysicalMode>>;
        _physicalMode = physicalModes["physical_modes"] as Array<PhysicalMode>;
    }

    public static function isDestinationMode(mode as String?) as Boolean {
        return "physical_mode:LocalTrain".equals(mode) || "physical_mode:RapidTransit".equals(mode);
    }

    function onLayout(dc as Dc) as Void {
        var menu = new Menu2({ :title => Rez.Strings.modeMenuTitle });
        for (var i = 0; i < _physicalMode.size(); i++) {
            var mode = _physicalMode[i] as PhysicalMode;
            var modeDrawable = new WatchUi.Bitmap({
                :rezId => drawablesList[mode["id"]],
                :locX => 0,
                :locY => WatchUi.LAYOUT_VALIGN_CENTER,
            });
            menu.addItem(new IconMenuItem(mode["name"], null, mode["id"], modeDrawable, null));
        }
        WatchUi.switchToView(
            menu,
            new StationModeSelectMenuInputDelegate(_stationSelection, self.method(:chooseLine)),
            WatchUi.SLIDE_IMMEDIATE
        );
    }

    function chooseLine(lineResult as LineResult) as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT); // Pop progressBar
        if (lineResult instanceof GatewayResultKO) {
            WatchUi.showToast(lineResult.message, { :icon => Rez.Drawables.warningToastIcon });
            return;
        }

        var pictoIconBuilder = new PictoIconFactory().pictoFromMode(_stationSelection.mode);
        var menu = new Menu2({ :title => Rez.Strings.lineMenuTitle });
        for (var i = 0; i < lineResult.size(); i++) {
            var line = lineResult[i];
            var picto = pictoIconBuilder.build(line.name, line.pictoColor, line.pictoTextColor);
            menu.addItem(new IconMenuItem("", null, line.id, picto, null));
        }
        WatchUi.pushView(
            menu,
            new StationLineSelectMenuInputDelegate(_stationSelection, self.method(:chooseStation)),
            WatchUi.SLIDE_RIGHT
        );
    }

    function chooseStation(idNameResult as IdNameResult) as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT); // Pop progressBar
        if (idNameResult instanceof GatewayResultKO) {
            WatchUi.showToast(idNameResult.message, { :icon => Rez.Drawables.warningToastIcon });
            return;
        }
        
        if (idNameResult.size() == 0) {
            WatchUi.showToast(Rez.Strings.errorNoStationMessage, { :icon => Rez.Drawables.warningToastIcon });
            return;
        }

        var menu = new Menu2({ :title => Rez.Strings.stationMenuTitle });
        for (var i = 0; i < idNameResult.size(); i++) {
            var line = idNameResult[i].name;
            menu.addItem(new MenuItem(line, null, idNameResult[i].id, null));
        }
        var callback = isDestinationMode(_stationSelection.mode)
            ? self.method(:chooseDestination)
            : self.method(:chooseDirection);
        WatchUi.pushView(
            menu,
            new StationStationSelectMenuInputDelegate(_stationSelection, callback),
            WatchUi.SLIDE_RIGHT
        );
    }

    function chooseDirection(directionResult as DirectionResult) as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT); // Pop progressBar
        if (directionResult instanceof GatewayResultKO) {
            WatchUi.showToast(directionResult.message, { :icon => Rez.Drawables.warningToastIcon });
            return;
        }
        if (directionResult.size() == 0) {
            WatchUi.showToast(Rez.Strings.errorNoDirectionMessage, { :icon => Rez.Drawables.warningToastIcon });
            return;
        }


        var menu = new Menu2({ :title => Rez.Strings.directionMenuTitle });
        for (var i = 0; i < directionResult.size(); i++) {
            var direction = directionResult[i];
            menu.addItem(new MenuItem(direction.destinationName, null, direction.stationStopPointIds, null));
        }
        WatchUi.pushView(
            menu,
            new DirectionSelectMenuInputDelegate(_stationSelection, method(:saveDirectionStationInfo)),
            WatchUi.SLIDE_RIGHT
        );
    }

    function chooseDestination(destinationResult as IdNameResult) as Void {
        WatchUi.popView(WatchUi.SLIDE_RIGHT); // Pop progressBar
        if (destinationResult instanceof GatewayResultKO) {
            WatchUi.showToast(destinationResult.message, { :icon => Rez.Drawables.warningToastIcon });
            return;
        }
        if (destinationResult.size() == 0) {
            WatchUi.showToast(Rez.Strings.errorNoStationMessage, { :icon => Rez.Drawables.warningToastIcon });
            return;
        }


        var menu = new Menu2({ :title => Rez.Strings.destinationMenuTitle });
        for (var i = 0; i < destinationResult.size(); i++) {
            var station = destinationResult[i];
            if (!station.id.equals(_stationSelection.stationStopAreaId)) {
                menu.addItem(new MenuItem(station.name, null, station.id, null));
            }
        }
        WatchUi.pushView(
            menu,
            new DestinationSelectMenuInputDelegate(_stationSelection, method(:saveDestinationStationInfo)),
            WatchUi.SLIDE_RIGHT
        );
    }

    function saveDirectionStationInfo() as Void {
        StorageAccess.addStation(_stationSelection, DIRECTION);
        returnToAccueil();
    }
    function saveDestinationStationInfo() as Void {
        StorageAccess.addStation(_stationSelection, DESTINATION);
        returnToAccueil();
    }

    function returnToAccueil() as Void {
        WatchUi.showToast(Rez.Strings.addedStation, { :icon => Rez.Drawables.positiveToastIcon });
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); // Direction
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); // Station
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); // Line
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); // Mode
        WatchUi.popView(WatchUi.SLIDE_RIGHT); // FitstView
        // System.exit();
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
    }
}
