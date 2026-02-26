import Toybox.Lang;
import Toybox.Time;

class SchedulesResultHandler /* implements GatewayHandlerInterface */ {
    private var _update as (Method(schedulesResult as SchedulesResult) as Void);

    function initialize(update as (Method(schedulesResult as SchedulesResult) as Void)) {
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

    function handleData(gatewayResult as GatewayResultData) as Void {
        var resultList = [] as Array<Schedule>;

        var data = gatewayResult.data as Array<Dictionary>;
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

        _update.invoke(resultList);
    }

    function error(message as String) as Void {
        _update.invoke(new GatewayResultKO(message));
    }
}