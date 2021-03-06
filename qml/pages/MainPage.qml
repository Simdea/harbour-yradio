import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0
import ".."

Page {
    id: page

    property RadioPlayer player: null;
    property ChannelsPage channels: null;

    // Create an attached page of the channels for quick access, this might be a Favorites in the future, lets see how it goes...
    // we do it here as the pageStack is still busy on the onCompleted signal for some odd reason.
    onStatusChanged: {
        if (status===PageStatus.Active && pageStack.depth===1 && channels===null) {
            channels=channelsPage.createObject(root, {currentChannelIndex: root.channelId });
            pageStack.pushAttached(channels);
        }
    }

    ProgramPage {
        id: programPage
        channel: root.currentChannel
    }

    SilicaFlickable {
        id: mainFlickable
        anchors.fill: parent
        anchors.bottomMargin: playPanel.expanded ? playPanel.visibleSize : 0;

        VerticalScrollDecorator { flickable: mainFlickable }

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(settingsPage);
            }
            MenuItem {
                text: qsTr("Channels")
                onClicked: pageStack.push(channels);
            }            
            MenuItem {
                text: qsTr("Programs")
                onClicked: {
                    console.debug("Pushing program page")
                    // pageStack.push(programPage, { channel: root.currentChannel } );
                    pageStack.push(programPage);
                    programPage.reset();
                    console.debug("Program page pushed");
                }
                enabled: root.currentChannel===null ? false : root.currentChannel.hasProgram;
            }            
            busy: player.buffering
        }
        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingMedium
            PageHeader {
                title: "Y-Radio"
            }

            BackgroundItem {
                id: noChannelSelected
                visible: root.currentChannel===null;
                width: parent.width
                height: l.height
                Label {
                    id: l
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("Select a channel to listen to")
                    font.pixelSize: Theme.fontSizeExtraLarge
                    wrapMode: Text.WordWrap
                    width: parent.width/2
                }
                onClicked: pageStack.push(channelsPage);
            }

            BackgroundItem {
                visible: root.currentChannel!==null;
                width: parent.width
                height: cl.height
                Label {
                    id: cl
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: root.currentChannel===null ? '' : root.currentChannel.name;
                    font.pixelSize: Theme.fontSizeLarge
                    wrapMode: Text.WordWrap
                    width: parent.width/2
                }
                onClicked: {
                    pageStack.push(channelsPage);
                }
            }

            SongInfo {
                id: songInfo;
                visible: infoId!==''
                infoId: root.currentChannel===null ? '' : root.currentChannel.songInfoId;
                showArtistImage: root.loadArtistImage;
                onInfoIdChanged: {
                    if (infoId!=='')
                        loadInitialInfo();
                }
                enabled: player.playing && infoId!=='';
                onClicked: {
                    playPanel.show();
                }
            }
        }
    }
    DockedPanel {
        id: playPanel
        width: parent.width
        height: dpc.height + Theme.paddingLarge*2;
        dock: Dock.Bottom
        open: root.currentChannel===null ? false : true;

        Column {
            id: dpc
            width: parent.width
            spacing: Theme.paddingSmall;
            IconButton {
                anchors.horizontalCenter: parent.horizontalCenter
                icon.source: player.playing || player.connecting ? "image://theme/icon-l-pause" : "image://theme/icon-l-play"
                enabled: player.url ? true: false;
                onClicked: {
                    player.toggle();                    
                }
            }

            ProgressBar {
                id: buffering
                anchors.horizontalCenter: parent.horizontalCenter;
                value: player.bufferpercent;
                width: parent.width/1.5
                visible: true;
                opacity: player.buffering ? 1.0 : 0.0;
                minimumValue: 0;
                maximumValue: 100;
                Behavior on opacity { NumberAnimation { duration: 750; } }
            }
        }
    }
}


