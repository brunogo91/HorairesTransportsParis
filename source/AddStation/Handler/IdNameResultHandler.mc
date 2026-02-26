import Toybox.Lang;

class IdNameResultHandler /* implements GatewayHandlerInterface */ {
    private var _update as (Method(lineResult as IdNameResult) as Void);

    function initialize(update as (Method(lineResult as IdNameResult) as Void)) {
        _update = update;
    }

    function handleData(gatewayResult as GatewayResultData) as Void {
        var resultList = [] as Array<IdNameModel>;
        var data = gatewayResult.data as Array<Dictionary>;
        for (var i = 0; i < data.size(); i++) {
            var element = data[i];
            var id = element["id"] as String;
            var name = element["name"] as String;
            resultList.add(new IdNameModel(id, name));
        }
        _update.invoke(resultList);
    }

    function error(message as String) as Void {
        _update.invoke(new GatewayResultKO(message));
    }
}