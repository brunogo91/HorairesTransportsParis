import Toybox.Time;
import Toybox.Lang;

class Schedule {
    var destination as String;
    var departureTime as Moment;
    var onPlatform as Boolean;
    var departureStatus as DepartureStatus;
    var status as String?;
    private var _hourFormat as String?;

    function initialize(
        destination as String,
        departureTime as Moment,
        onPlatform as Boolean,
        departureStatus as DepartureStatus,
        status as String?
    ) {
        self.destination = destination;
        self.departureTime = departureTime;
        self.onPlatform = onPlatform;
        self.departureStatus = departureStatus;
        self.status = status;
    }

    function hour() as String {
        if (_hourFormat == null) {
            var momentInfo = Gregorian.info(departureTime, Time.FORMAT_SHORT);
            _hourFormat = Lang.format("$1$:$2$:$3$", [
                momentInfo.hour.format("%02u"),
                momentInfo.min.format("%02u"),
                momentInfo.sec.format("%02u"),
            ]);
        }

        return _hourFormat;
    }

    function isCancelled() as Boolean {
        return CANCELLED.equals(departureStatus);
    }

    function isDelayed() as Boolean {
        return DELAYED.equals(departureStatus);
    }
}
