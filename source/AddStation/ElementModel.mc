import Toybox.Lang;

class Element {
    var id as String;
    var name as String;

    function initialize(id as String, name as String) {
        self.id = id;
        self.name = name;
    }

    function toString() {
        return "Element {id => " + id + ", name => " + name + "}";
    }
}
