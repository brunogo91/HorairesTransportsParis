import Toybox.Lang;
import Toybox.Application.Properties;

class SchedulesGateway extends AbstractGateway {
    private const _url = Properties.getValue("server_schedules_url") as String;
    private var _update as (Method(schedulesResult as SchedulesResult) as Void);
    private var _selectedItem as StationInfo;

    function initialize(selectedItem as StationInfo, update as (Method(schedulesResult as SchedulesResult) as Void)) {
        AbstractGateway.initialize();
        _selectedItem = selectedItem;
        _update = update;
    }

    function getNextTrain() as Void {
        var params = {
            "station" => _selectedItem.stationStopAreaId,
            "line" => _selectedItem.lineId,
            "mode" => _selectedItem.mode,
            "searchType" => _selectedItem.searchType,
            // "direction" => _selectedItem.direction,
            "destination" => _selectedItem.destinationId,
        };
        var stationStopPointIds = _selectedItem.stationStopPointIds;
        if (stationStopPointIds != null) {
            for (var i = 0; i < stationStopPointIds.size(); i++) {
                params["stopPointIds[" + i + "]"] = stationStopPointIds[i];
            }
        }
        AbstractGateway.makeRequest(_url, params, new SchedulesResultHandler(_update));
    }

    function cancelRequest() as Void {
        Communications.cancelAllRequests(); // Not Enough Arguments Error
    }
}
