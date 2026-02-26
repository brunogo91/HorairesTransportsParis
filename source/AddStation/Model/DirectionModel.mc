import Toybox.Lang;

class DirectionModel {
    var destinationName as String;
    var destinations as Array<String>;
    var stationStopPointIds as Array<String>;

    function initialize(destinationName as String, destinations as Array<String>, stationStopPointIds as Array<String>) {
        self.destinationName = destinationName;
        self.destinations = destinations;
        self.stationStopPointIds = stationStopPointIds;
    }

    function toString() {
        return "DirectionModel {destinationName => " + destinationName + ", destinations => " + destinations + ", stationStopPointIds => " + stationStopPointIds + "}";
    }
}
