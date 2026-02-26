import Toybox.Lang;

typedef GatewayHandlerInterface as interface {
    function handleData(gatewayResult as GatewayResultData) as Void;
    function error(message as String) as Void;
};
