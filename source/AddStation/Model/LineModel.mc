import Toybox.Lang;

class LineModel extends IdNameModel {
    var pictoColor as String;
    var pictoTextColor as String;

    function initialize(id as String, name as String, pictoColor as String, pictoTextColor as String) {
        IdNameModel.initialize(id, name);
        self.pictoColor = pictoColor;
        self.pictoTextColor = pictoTextColor;
    }

    function toString() as String {
        return "LineModel {id => " + id + ", name => " + name + ", pictoColor => " + pictoColor + ", pictoTextColor => " + pictoTextColor + "}";
    }
}
