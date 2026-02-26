import Toybox.Lang;
import Toybox.Application.Properties;

class StationSelectionGateway extends AbstractGateway {
    private const _url = Properties.getValue("server_station_url") as String;

    function initialize() {
        AbstractGateway.initialize();
    }

    public function makeStationRequest(step as StepType, selectedItem as StationSelection, handler as GatewayHandlerInterface) as Void {
        var params = {
            "step" => step.toString(),
            "mode" => selectedItem.mode,
            "line" => selectedItem.lineId,
            "station" => selectedItem.stationStopAreaId,
        };
        AbstractGateway.makeRequest(_url, params, handler);
    } 
}