import Toybox.Lang;

class LineResultHandler /* implements GatewayHandlerInterface */ {
    private var _update as (Method(lineResult as LineResult) as Void);

    function initialize(update as (Method(lineResult as LineResult) as Void)) {
        _update = update;
    }

    function handleData(gatewayResult as GatewayResultData) as Void {
        var resultList = [] as Array<LineModel>;
        var data = gatewayResult.data as Array<Dictionary>;
        for (var i = 0; i < data.size(); i++) {
            var line = data[i];
            var id = line["id"] as String;
            var name = line["name"] as String;
            var pictoColor = line["pictoColor"] as String;
            var pictoTextColor = line["pictoTextColor"] as String;
            resultList.add(new LineModel(id, name, pictoColor, pictoTextColor));
        }
        _update.invoke(resultList);
    }

    function error(message as String) as Void {
        _update.invoke(new GatewayResultKO(message));
    }
}