import Toybox.Application.Properties;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class StorageAccess {
    private static const _stationKey = "station";
    private static const _appVersion = Properties.getValue("appVersion") as String;

    static function getStations() as Array<StationInfo> {
        var stations = Storage.getValue(_stationKey) as Array<StationDictionary>?;
        if (stations == null) {
            return [];
        }
        var stationsList = [] as Array<StationInfo>;
        for (var i = 0; i < stations.size(); i++) {
            var stationItem = StationInfo.fromStationDictionary(stations[i]);
            stationsList.add(stationItem);
        }
        return stationsList;
    }

    static function valuesEqual(val1 as String?, val2 as String?) as Boolean {
        if (val1 == null && val2 == null) {
            return true;
        }
        return val1 != null && val1.equals(val2);
    }

    static function deleteStation(stationInfo as StationInfo) as Number {
        var stations = Storage.getValue(_stationKey) as Array<StationDictionary>?;
        if (stations == null) {
            WatchUi.showToast(Rez.Strings.errorNoStationMessage, { :icon => Rez.Drawables.warningToastIcon });
            return -1;
        }

        for (var i = 0; i < stations.size(); i++) {
            var station = stations[i];
            if (
                valuesEqual(station["lineId"], stationInfo.lineId) &&
                valuesEqual(station["stationStopAreaId"], stationInfo.stationStopAreaId) &&
                valuesEqual(station["direction"], stationInfo.direction) &&
                valuesEqual(station["destinationId"], stationInfo.destinationId)
            ) {
                var deleted = stations.remove(stations[i]);
                if (!deleted) {
                    WatchUi.showToast(Rez.Strings.errorDeletingStation, { :icon => Rez.Drawables.warningToastIcon });
                    return -1;
                }
                Storage.setValue(_stationKey, stations as Array<Dictionary<String, String or SearchType or Null>>);
                return i;
            }
        }
        WatchUi.showToast(Rez.Strings.errorDeletingStation, { :icon => Rez.Drawables.warningToastIcon });
        return -1;
    }

    static function addStation(stationSelection as StationSelection, searchType as SearchType) as Void {
        var stations = Storage.getValue(_stationKey) as Array<StationDictionary>?;
        if (stations == null) {
            stations = [] as Array<StationDictionary>;
        }
        stations.add({
            "mode" => stationSelection.mode,
            "lineId" => stationSelection.lineId,
            "lineName" => stationSelection.lineName,
            "stationStopAreaId" => stationSelection.stationStopAreaId,
            "stationStopPointIds" => stationSelection.stationStopPointIds,
            "stationName" => stationSelection.stationName,
            "direction" => stationSelection.direction,
            "destinationId" => stationSelection.destinationId,
            "destinationName" => stationSelection.destinationName,
            "searchType" => searchType,
            "appVersion" => _appVersion
        } as StationDictionary);
        Storage.setValue(_stationKey, stations as Array<Dictionary>); // Not clear in documentation if it can store Array<Dictionary>
    }
}
