import Toybox.Lang;
import Toybox.Application.Properties;
import Toybox.Communications;

class AbstractGateway {
    private const _userpassword = Properties.getValue("server_credential") as String;

    function makeRequest(
        url as String,
        params as Dictionary,
        handler as GatewayHandlerInterface
    ) as Void {
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
                "Authorization" => "Basic " + _userpassword,
            },
            :context => handler as Object,
        };
        Communications.makeWebRequest(url, params, options, method(:onReceive));
    }

    // handlerObject as Object because makeWebRequest doesn't accept typedef (interface) as parameter
    function onReceive(
        responseCode as Number,
        data as GatewayData?,
        handlerObject as Object // as GatewayHandlerInterface
    ) as Void {
        var handler = handlerObject as GatewayHandlerInterface;
        if (responseCode == 200) {
            if (data == null) {
                handler.error("Oups, la requête a planté");
            } else {
                try {
                    if ("success".equals(data["status"])) {
                        handler.handleData(new GatewayResultData(data["data"]));
                    } else {
                        var errMessage = data["message"] != null ? data["message"] : "Error received from API";
                        handler.error(errMessage);
                    }
                } catch (ex) {
                    handler.error(ex.getErrorMessage());
                }
            }
        } else {
            var message = "Problème de communication avec le serveur. Code " + responseCode;
            if (responseCode == Communications.BLE_HOST_TIMEOUT) {
                message = Application.loadResource(Rez.Strings.errorTimeout) as String;
            }
            handler.error(message);
        }
    }
}
