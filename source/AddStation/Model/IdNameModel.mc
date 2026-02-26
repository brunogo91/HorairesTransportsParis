import Toybox.Lang;

class IdNameModel {
    var id as String;
    var name as String;

    function initialize(id as String, name as String) {
        self.id = id;
        self.name = name;
    }

    function toString() {
        return "IdNameModel {id => " + id + ", name => " + name + "}";
    }
}
