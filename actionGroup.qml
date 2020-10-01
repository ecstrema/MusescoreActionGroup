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
        title: qsTr("Musescore Action Group")

        Settings {
            id : settings
            category : "plugin.commands.settings"
            property string metrics : ""
            // default commands
            property string commands : '[{"commands":"paste;reset-groupings","shortcut":"Ctrl+Alt+Shift+V"},{"commands":"add-marcato;add-sforzato","shortcut":"|"},{"commands":"select-similar;delete","shortcut":"Ctrl+Shift+Alt+Backspace"},{"commands":"toggle-palette;inspector","shortcut":"Shift+F8"},{"commands":"","shortcut":""}]'
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

                    function setPropertyAndUpdate(index, property, value, emitter) {
                        setProperty(index, property, value)
                        if (emitter.activeFocus)
                            summary.text = JSON.stringify(data())
                    }

                    function data() {
                        var dm = []
                        for (var i = 0; i < myModel.count; ++i) {
                            dm.push(myModel.get(i))
                        }

                        return dm
                    }
                    function fromString(str) {
                        try {
                            var obj = JSON.parse(str)
                        }
                        catch (e) {
                            console.log("invalid JSON")
                            obj = [ { shortcut: "", commands: ""} ]
                        }
                        if (!obj) {
                            console.log("invalid JSON")
                            obj = [ { shortcut: "", commands: ""} ]
                        }
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
                        placeholderText: qsTr("Commands")
                        Layout.fillWidth: true
                        text: commands

                        onTextChanged: myModel.setPropertyAndUpdate(index, "commands", text, this)
                    }
                    TextField {
                        placeholderText: qsTr("Shortcut")
                        text: shortcut
                        onTextChanged: myModel.setPropertyAndUpdate(index, "shortcut", text, this)
                    }
                    Button {
                        text: qsTr("Delete")
                        onClicked: myModel.remove(index, 1)
                    }
                    Shortcut {
                        sequence: shortcut
                        context: Qt.ApplicationShortcut
                        // enabled: window.visible
                        onActivated: {
                            console.log("command to run: " + commands)
                            curScore.startCmd()
                            commands.split(';').forEach(function (command) {
                                cmd(command.trim())
                            });
                            curScore.endCmd()
                        }
                    }

                }
            }
            Rectangle {
                height: 1
                Layout.fillWidth: true
                color: "#666"
            }
            RowLayout {
                Button {
                    text: qsTr("New")
                    onClicked: myModel.append( { "commands": "", "shortcut": "" })
                    Shortcut {
                        sequence: "Ctrl+N"
                        onActivated: myModel.append( { "commands": "", "shortcut": "" })
                    }
                }
                Rectangle {
                    Layout.fillWidth: true
                }

                Button {
                    text: qsTr("Available commands...")
                    Shortcut {
                        sequence: "F1"
                        onActivated: myModel.append( { "commands": "", "shortcut": "" })
                    }
                    onClicked: Qt.openUrlExternally("https://github.com/Marr11317/MuseScoreCmdGenerator/blob/master/All.txt");
                }
            }

            TextArea {
                id: summary

                Layout.fillHeight: true
                Layout.fillWidth: true
                visible: false

                Connections {
                    id: textChangedConnection
                    target: summary
                    onTextChanged: {
                        if (summary.activeFocus)
                            myModel.fromString(summary.text)
                    }
                    enabled: true
                }
                Shortcut {
                    sequence: "Shift+F1"
                    onActivated: {
                        summary.visible = false
                        bottomFillRectangle.visible = true
                    }
                }
                Button {
                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                        bottomMargin: 4
                        rightMargin: 4
                    }
                    text: qsTr("Hide")
                    onClicked: {
                        summary.visible = false
                        bottomFillRectangle.visible = true
                    }
                }
            }

            Rectangle {
                id: bottomFillRectangle
                Layout.fillHeight: true
                Layout.fillWidth: true

                color: "#333"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        summary.visible = true
                        bottomFillRectangle.visible = false
                    }
                }
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
                    myModel.fromString(commands)
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

                settings.commands = JSON.stringify(myModel.data())
                console.log(settings.commands)
            }
        }
    }
}
