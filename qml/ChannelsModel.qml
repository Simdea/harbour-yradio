import QtQuick 2.0
import QtQuick.XmlListModel 2.0

XmlListModel {
    id: model
    source: "yle.xml"
    query: "/radio/channels/channel"    
    XmlRole { name: "name"; query: "name/string()"; isKey: true; }
    XmlRole { name: "url"; query: "url/string()" }
    XmlRole { name: "url_program"; query: "url/string()" }
    XmlRole { name: "url_songs"; query: "data/high/string()" }
    XmlRole { name: "stream_high"; query: "streams/stream[@quality='high']/string()" }
    XmlRole { name: "stream_medium"; query: "streams/stream[@quality='medium']/string()" }
    XmlRole { name: "stream_low"; query: "streams/stream[@quality='low']/string()" }
    XmlRole { name: "song_info_id"; query: "songInfo/string()" }
}