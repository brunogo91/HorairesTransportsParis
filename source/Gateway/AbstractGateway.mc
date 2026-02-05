import Toybox.Lang;
import Toybox.Application.Properties;
import Toybox.Communications;

class AbstractGateway {
    function makeRequest(
        url as String,
        params as Dictionary,
        callback as (Method(gatewayResult as GatewayResult) as Void)
    ) as Void {
        var userpassword = Properties.getValue("server_credential");

        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON,
                "Authorization" => "Basic " + userpassword,
            },
            :context => callback,
        };

        Communications.makeWebRequest(url, params, options, method(:onReceive));
    }

    function onReceive(
        responseCode as Number,
        data as GatewayData?,
        callback as (Method(gatewayResult as GatewayResult) as Void)
    ) as Void {
        var result;
        if (responseCode == 200) {
            if (data == null) {
                result = new GatewayResultKO("Oups, la requête a planté");
            } else {
                try {
                    if ("success".equals(data["status"])) {
                        result = new GatewayResultData(data["data"]);
                    } else {
                        var errMessage = data["message"] != null ? data["message"] : "Error received from API";
                        result = new GatewayResultKO(errMessage);
                    }
                } catch (ex) {
                    result = new GatewayResultKO(ex.getErrorMessage());
                }
            }
        } else {
            var message = "Error with response code : " + responseCode;
            if (responseCode == Communications.BLE_HOST_TIMEOUT) {
                message = Application.loadResource(Rez.Strings.errorTimeout) as String;
            }
            result = new GatewayResultKO(message);
        }
        callback.invoke(result);
    }
}
