import Toybox.Lang;
import Toybox.Time;
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

    function parseDate(date as String) as Moment {
        var year = date.substring(0, 4).toNumber();
        var month = date.substring(5, 7).toNumber();
        var day = date.substring(8, 10).toNumber();
        var hours = date.substring(11, 13).toNumber();
        var minutes = date.substring(14, 16).toNumber();
        var second = date.substring(17, 19).toNumber();
        var options = {
            :year   => year,
            :month  => month,
            :day    => day,
            :hour   => hours,
            :minute => minutes,
            :second => second,
        };
        var moment = Gregorian.moment(options);
        return moment;
    }

    function handleData(data as Dictionary) as Array<Schedule> {
        var resultList = [] as Array<Schedule>;

        for (var i = 0; i < data.size(); i++) {
            var hor = data[i] as Dictionary;
            var destinationName = hor["destinationName"] as String;
            var expectedDepartureTime = hor["expectedDepartureTime"] as String;
            var vehicleAtStop = hor["vehicleAtStop"] as Boolean;
            var departureStatus = hor["departureStatus"] as DepartureStatus;
            var status = hor["status"] as String?; // notFinded
            var departureTime = parseDate(expectedDepartureTime);
            resultList.add(new Schedule(destinationName, departureTime, vehicleAtStop, departureStatus, status));
        }

        return resultList;
    }

    function responseCallback(gatewayResult as GatewayResult) as Void {
        if (gatewayResult instanceof GatewayResultKO) {
            _update.invoke(gatewayResult);
            return;
        }
        var parsedData = handleData(gatewayResult.data);
        var result = new SchedulesResultData(parsedData);
        _update.invoke(result);
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
        AbstractGateway.makeRequest(_url, params, method(:responseCallback));
    }

    function cancelRequest() as Void {
        Communications.cancelAllRequests(); // Not Enough Arguments Error
    }
}
