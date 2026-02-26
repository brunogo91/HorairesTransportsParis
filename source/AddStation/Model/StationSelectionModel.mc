import Toybox.Lang;

class StationSelection {
    var mode as String?;
    var lineId as String?;
    var lineName as String?;
    var stationStopAreaId as String?;
    var stationStopPointIds as Array<String>?;
    var stationName as String?;
    var direction as String?;
    var destinationId as String?;
    var destinationName as String?;

    function initialize() {}

    function setMode(mode as String?) as Void {
        self.mode = mode;
    }

    function setLineId(lineId as String?) as Void {
        self.lineId = lineId;
    }

    function setLineName(lineName as String?) as Void {
        self.lineName = lineName;
    }

    function setStationStopAreaId(stationStopAreaId as String?) as Void {
        self.stationStopAreaId = stationStopAreaId;
    }

    function setStationStopPointIds(stationStopPointIds as Array<String>) as Void {
        self.stationStopPointIds = stationStopPointIds;
    }

    function setStationName(stationName as String?) as Void {
        self.stationName = stationName;
    }

    function setDirection(direction as String) as Void {
        self.direction = direction;
    }

    function setDestinationId(destinationId as String) as Void {
        self.destinationId = destinationId;
    }

    function setDestinationName(destinationName as String) as Void {
        self.destinationName = destinationName;
    }

    function toString() {
        return (
            "StationSelection {mode => " +
            mode +
            ", line => " +
            lineId +
            ", lineName => " +
            lineName +
            ", stationStopAreaId => " +
            stationStopAreaId +
            ", stationStopPointIds => " +
            stationStopPointIds +
            ", stationName => " +
            stationName +
            ", direction => " +
            direction +
            ", destinationId => " +
            destinationId +
            ", destinationName => " +
            destinationName +
            "}"
        );
    }
}
