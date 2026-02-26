import Toybox.Lang;

class DirectionResultHandler /* implements GatewayHandlerInterface */ {
    private var _update as (Method(destinationResult as DirectionResult) as Void);

    function initialize(update as (Method(destinationResult as DirectionResult) as Void)) {
        _update = update;
    }

    function handleData(gatewayResult as GatewayResultData) as Void {
        var resultList = [] as Array<DirectionModel>;
        var data = gatewayResult.data as Array<Dictionary>;
        for (var i = 0; i < data.size(); i++) {
            var element = data[i];
            var destinationName = element["destinationName"] as String;
            var destinations = element["destinations"] as Array<String>;
            var stationStopPointIds = element["stationStopPointIds"] as Array<String>;
            resultList.add(new DirectionModel(destinationName, destinations, stationStopPointIds));
        }
        
        _update.invoke(resultList);
    }

    function error(message as String) as Void {
        _update.invoke(new GatewayResultKO(message));
    }
}