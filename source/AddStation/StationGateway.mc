import Toybox.Lang;
import Toybox.Application.Properties;

class StationGateway extends AbstractGateway {
    private var _update as (Method(lineResult as StationResult) as Void);
    private var _selectedItem as StationSelection;
    private const _url = Properties.getValue("server_station_url") as String;

    function initialize(selectedItem as StationSelection, update as (Method(lineResult as StationResult) as Void)) {
        AbstractGateway.initialize();
        _selectedItem = selectedItem;
        _update = update;
    }

    function handleDataLineStation(gatewayResult as GatewayResult) as Void {
        if (gatewayResult instanceof GatewayResultKO) {
            _update.invoke(gatewayResult);
            return;
        }
        var resultList = [] as Array<Element>;
        var data = gatewayResult.data as ElementDictionary;
        for (var i = 0; i < data.size(); i++) {
            var element = data[i] as Dictionary;
            var id = element["id"] as String;
            var name = element["name"] as String;
            resultList.add(new Element(id, name));
        }
        var result = new StationData(resultList);
        _update.invoke(result);
    }

    function handleDataDirection(gatewayResult as GatewayResult) as Void {
        if (gatewayResult instanceof GatewayResultKO) {
            _update.invoke(gatewayResult);
            return;
        }
        var result = new StationData(gatewayResult.data["directions"] as Array<DestinationResult>);
        _update.invoke(result);
    }

    public function makeStationRequest(
        callbackHandler as (Method(gatewayResult as GatewayResult) as Void)
    ) as Void {
        var params = {
            "mode" => _selectedItem.mode,
            "line" => _selectedItem.lineId,
            "station" => _selectedItem.stationStopAreaId,
        };

        AbstractGateway.makeRequest(_url, params, callbackHandler);
    }

    public function lineAndStationResquest() as Void {
        makeStationRequest(method(:handleDataLineStation));
    }

    public function directionResquest() as Void {
        makeStationRequest(method(:handleDataDirection));
    }

    public function routeStationRequest() as Void {
        makeStationRequest(method(:handleDataLineStation));
    }
}
