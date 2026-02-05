import Toybox.Lang;

class StationData {
    var result as Array<Element> or Array<DestinationResult>;

    function initialize(result as Array<Element> or Array<DestinationResult>) {
        self.result = result;
    }

    function toString() {
        return "StationResult {result => " + result + "}";
    }
}