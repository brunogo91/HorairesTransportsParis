import Toybox.Lang;

class SchedulesResultData {
    var schedules as Array<Schedule>;

    function initialize(schedules as Array<Schedule>) {
        self.schedules = schedules;
    }

    function toString() {
        return "SchedulesResultData {schedules => " + schedules + "}";
    }
}
