import Toybox.Lang;

typedef StationDictionary as {
    "mode" as String,
    "lineId" as String,
    "lineName" as String,
    "stationStopAreaId" as String,
    "stationStopPointIds" as Array<String>?,
    "stationName" as String,
    "direction" as String?,
    "destinationId" as String?,
    "destinationName" as String?,
    "searchType" as SearchType,
    "appVersion" as String
} ;