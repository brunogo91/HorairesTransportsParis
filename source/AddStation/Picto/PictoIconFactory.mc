import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class PictoIconFactory {

    function initialize () {}

    function pictoFromMode(mode as String) as PictoIconBuilder {
        switch (mode) {
            case "physical_mode:Metro":
                return new MetroPictoIconBuilder();
            case "physical_mode:Tramway":
                return new TramwayPictoIconBuilder();
            case "physical_mode:RapidTransit":
            case "physical_mode:LocalTrain":
                return new TrainPictoIconBuilder();
            default:
                return new MetroPictoIconBuilder();
        }
    }
}

typedef PictoIconBuilder as interface {
    function build(lineName as String, color as String, textColor as String) as WatchUi.Drawable;
};

class MetroPictoIconBuilder {
    function build(lineName as String, color as String, textColor as String) as WatchUi.Drawable {
        return new MetroPictoIcon(lineName, color, textColor);
    }
}

class TramwayPictoIconBuilder {
    function build(lineName as String, color as String, textColor as String) as WatchUi.Drawable{
        return new TramwayPictoIcon(lineName, color, textColor);
    }
}

class TrainPictoIconBuilder {
    function build(lineName as String, color as String, textColor as String) as WatchUi.Drawable {
        return new TrainPictoIcon(lineName, color, textColor);
    }
}
