import Toybox.Lang;

class StationInfo {
    var mode as String;
    var lineId as String;
    var lineName as String;
    var stationStopAreaId as String;
    var stationStopPointIds as Array<String>?;
    var stationName as String;
    var direction as String?;
    var destinationId as String?;
    var destinationName as String?;
    var searchType as SearchType;

    private function initialize(stationDictionary as StationDictionary) {
        self.mode = stationDictionary["mode"];
        self.lineId = stationDictionary["lineId"];
        self.lineName = stationDictionary["lineName"];
        self.stationStopAreaId = stationDictionary["stationStopAreaId"];
        self.stationStopPointIds = stationDictionary["stationStopPointIds"];
        self.stationName = stationDictionary["stationName"];
        self.direction = stationDictionary["direction"];
        self.destinationId = stationDictionary["destinationId"];
        self.destinationName = stationDictionary["destinationName"];
        self.searchType = stationDictionary["searchType"];
    }

    public static function fromStationDictionary(stationDictionary as StationDictionary) as StationInfo {
        var stationInfo = new StationInfo(stationDictionary);
        return stationInfo;
    }

    function toString() {
        return (
            "StationInfo {mode => " +
            mode +
            ", lineId => " +
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
            " , destinationId => " +
            destinationId +
            ", destinationName => " +
            destinationName +
            ", searchType => " +
            searchType +
            "}"
        );
    }
}
