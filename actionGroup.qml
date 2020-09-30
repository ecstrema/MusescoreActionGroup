import QtQuick 2.9
import QtQuick.Controls 1.5
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3

import MuseScore 3.0
import Qt.labs.settings 1.0

MuseScore {
    menuPath : "Plugins.ActionGroup"
    version : "1.0"
    description : qsTr("Configure shortcuts for sequences of commands")
    requiresScore: false

    onRun : {
        window.visible = true
    }

    Window {
        id : window
        width : 400;
        minimumWidth : 300
        minimumHeight : 50
        height : 300
        visible : true
        color : "#333333"
        title: "Musescore Action Group"

        Settings {
            id : settings
            category : "plugin.commands.settings"
            property string metrics : ""
            // default commands
            property string commands : '[{"shortcut":"Ctrl+Alt+Shift+V","commands":"paste;reset-groupings;"},{"shortcut":"Ctrl+Shift+Alt+Backspace","commands":"select-similar;delete"},{"shortcut":"","commands":""}]'
        }

        ColumnLayout {
            anchors {
                fill: parent
                rightMargin: 4
                leftMargin: 4
                topMargin: 10
                bottomMargin: 10
            }

            spacing: 2

            Repeater {
                id: myRepeater
                model: ListModel {
                    id: myModel

                    function dataModel() {
                        var dm = []
                        for (var i = 0; i < myModel.count; ++i) {
                            dm.push(myModel.get(i))
                        }

                        return dm
                    }
                    function fromObject(obj) {
                        myModel.clear()
                        obj.forEach(function (ch) {
                            myModel.append( { "commands": ch.commands, "shortcut": ch.shortcut })
                        });
                    }

                }
                delegate: RowLayout {
                    id: commandsColumn

                    spacing: 4

                    TextField {
                        placeholderText: qsTr("Enter commands")
                        Layout.fillWidth: true
                        text: commands

                        onTextChanged: myModel.setProperty(index, "commands", text)
                    }
                    TextField {
                        placeholderText: qsTr("Enter Shortcut as text")
                        text: shortcut
                        onTextChanged: myModel.setProperty(index, "shortcut", text)
                    }
                    Button {
                        text: "remove"
                        onClicked: {
                            myModel.remove(index, 1)
                        }
                    }
                    Shortcut {
                        sequence: shortcut
                        context: Qt.ApplicationShortcut
                        // enabled: window.visible
                        onActivated: {
                            console.log("command to run: " + commands)
                            curScore.startCmd()
                            commands.split(';').forEach(function (command) {
                                cmd(command)
                            });
                            curScore.endCmd()
                        }
                    }
                }
            }
            Rectangle {
                height: 1
                Layout.fillWidth: true
                color: "white"
            }
            RowLayout {
                Button {
                    text: "add"
                    onClicked: myModel.append( { "commands": "", "shortcut": "" })
                }
                Rectangle {
                    Layout.fillWidth: true
                }

                Button {
                    text: "?"
                    onClicked: Qt.openUrlExternally("https://github.com/Marr11317/MuseScoreCmdGenerator/blob/master/All.txt");
                }
            }

            Rectangle {
                Layout.fillHeight: true
                // Layout.fillWidth: true

                // color: "#666"
                // MouseArea {
                //     anchors.fill: parent
                //     onClicked: console.log(JSON.stringify(myModel.dataModel()))
                // }
            }
        }

        onVisibleChanged : {
            if (visible) {
                var metrics = settings.metrics;
                if (metrics) {
                    metrics = JSON.parse(metrics);
                    window.x = metrics.x;
                    window.y = metrics.y;
                    window.width = metrics.width;
                    window.height = metrics.height;
                }
                var commands = settings.commands
                if (commands) {
                    commands = JSON.parse(commands)
                    myModel.fromObject(commands)
                }
            }
            else {
                var metrics = {
                    x : window.x,
                    y : window.y,
                    width : window.width,
                    height : window.height
                }
                settings.metrics = JSON.stringify(metrics);

                settings.commands = JSON.stringify(myModel.dataModel())
            }
        }
    }
}
