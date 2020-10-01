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
                            console.log("invalid JSON: " + e)
                            return
                        }
                        if (!obj) {
                            console.log("no JSON output received JSON")
                            return
                        }
                        myModel.clear()
                        obj.forEach(function (ch) {
                            myModel.append( { "commands": ch.commands, "shortcut": ch.shortcut } )
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
                        Layout.fillWidth: true
                        placeholderText: qsTr("Shortcut")
                        text: shortcut
                        onTextChanged: myModel.setPropertyAndUpdate(index, "shortcut", text, this)

                        property var modifiers: ({ 0x02000000: "Shift", 0x04000000: "Ctrl", 0x08000000: "Alt", 0x10000000: "Meta", 0x20000000: "Keypad", 0x40000000: "GroupSwitch" })
                        property var keys: ({
                            0x01000000: "Escape", 0x01000001: "Tab", 0x01000002: "Backtab", 0x01000003: "Backspace", 0x01000004: "Return", 0x01000005: "Enter", 0x01000006: "Insert", 0x01000007: "Delete", 0x01000008: "Pause", 0x01000009: "Print", 0x0100000a: "SysReq", 0x0100000b: "Clear", 0x01000010: "Home", 0x01000011: "End", 0x01000012: "Left", 0x01000013: "Up", 0x01000014: "Right", 0x01000015: "Down", 0x01000016: "PageUp", 0x01000017: "PageDown", 0x01000020: "Shift", 0x01000021: "Control", 0x01000022: "Meta", 0x01000023: "Alt", 0x01001103: "AltGr", 0x01000024: "CapsLock", 0x01000025: "NumLock", 0x01000026: "ScrollLock", 0x01000030: "F1", 0x01000031: "F2", 0x01000032: "F3", 0x01000033: "F4", 0x01000034: "F5", 0x01000035: "F6", 0x01000036: "F7", 0x01000037: "F8", 0x01000038: "F9", 0x01000039: "F10", 0x0100003a: "F11", 0x0100003b: "F12", 0x0100003c: "F13", 0x0100003d: "F14", 0x0100003e: "F15", 0x0100003f: "F16", 0x01000040: "F17", 0x01000041: "F18", 0x01000042: "F19", 0x01000043: "F20", 0x01000044: "F21", 0x01000045: "F22", 0x01000046: "F23", 0x01000047: "F24", 0x01000048: "F25", 0x01000049: "F26", 0x0100004a: "F27", 0x0100004b: "F28", 0x0100004c: "F29", 0x0100004d: "F30", 0x0100004e: "F31", 0x0100004f: "F32", 0x01000050: "F33", 0x01000051: "F34", 0x01000052: "F35", 0x01000053: "Super_L", 0x01000054: "Super_R", 0x01000055: "Menu", 0x01000056: "Hyper_L", 0x01000057: "Hyper_R", 0x01000058: "Help", 0x01000059: "Direction_L", 0x01000060: "Direction_R", 0x20: "Space", 0x21: "Exclam", 0x22: "QuoteDbl", 0x23: "NumberSign", 0x24: "Dollar", 0x25: "Percent", 0x26: "Ampersand", 0x27: "Apostrophe", 0x28: "ParenLeft", 0x29: "ParenRight", 0x2a: "Asterisk", 0x2b: "Plus", 0x2c: "Comma", 0x2d: "Minus", 0x2e: "Period", 0x2f: "Slash", 0x30: "0", 0x31: "1", 0x32: "2", 0x33: "3", 0x34: "4", 0x35: "5", 0x36: "6", 0x37: "7", 0x38: "8", 0x39: "9", 0x3a: "Colon", 0x3b: "Semicolon", 0x3c: "Less", 0x3d: "Equal", 0x3e: "Greater", 0x3f: "Question", 0x40: "At", 0x41: "A", 0x42: "B", 0x43: "C", 0x44: "D", 0x45: "E", 0x46: "F", 0x47: "G", 0x48: "H", 0x49: "I", 0x4a: "J", 0x4b: "K", 0x4c: "L", 0x4d: "M", 0x4e: "N", 0x4f: "O", 0x50: "P", 0x51: "Q", 0x52: "R", 0x53: "S", 0x54: "T", 0x55: "U", 0x56: "V", 0x57: "W", 0x58: "X", 0x59: "Y", 0x5a: "Z", 0x5b: "BracketLeft", 0x5c: "Backslash", 0x5d: "BracketRight", 0x5e: "AsciiCircum", 0x5f: "Underscore", 0x60: "QuoteLeft", 0x7b: "BraceLeft", 0x7c: "Bar", 0x7d: "BraceRight", 0x7e: "AsciiTilde", 0x0a0: "nobreakspace", 0x0a1: "exclamdown", 0x0a2: "cent", 0x0a3: "sterling", 0x0a4: "currency", 0x0a5: "yen", 0x0a6: "brokenbar", 0x0a7: "section", 0x0a8: "diaeresis", 0x0a9: "copyright", 0x0aa: "ordfeminine", 0x0ab: "guillemotleft", 0x0ac: "notsign", 0x0ad: "hyphen", 0x0ae: "registered", 0x0af: "macron", 0x0b0: "degree", 0x0b1: "plusminus", 0x0b2: "twosuperior", 0x0b3: "threesuperior", 0x0b4: "acute", 0x0b5: "mu", 0x0b6: "paragraph", 0x0b7: "periodcentered", 0x0b8: "cedilla", 0x0b9: "onesuperior", 0x0ba: "masculine", 0x0bb: "guillemotright", 0x0bc: "onequarter", 0x0bd: "onehalf", 0x0be: "threequarters", 0x0bf: "questiondown", 0x0c0: "Agrave", 0x0c1: "Aacute", 0x0c2: "Acircumflex", 0x0c3: "Atilde", 0x0c4: "Adiaeresis", 0x0c5: "Aring", 0x0c6: "AE", 0x0c7: "Ccedilla", 0x0c8: "Egrave", 0x0c9: "Eacute", 0x0ca: "Ecircumflex", 0x0cb: "Ediaeresis", 0x0cc: "Igrave", 0x0cd: "Iacute", 0x0ce: "Icircumflex", 0x0cf: "Idiaeresis", 0x0d0: "ETH", 0x0d1: "Ntilde", 0x0d2: "Ograve", 0x0d3: "Oacute", 0x0d4: "Ocircumflex", 0x0d5: "Otilde", 0x0d6: "Odiaeresis", 0x0d7: "multiply", 0x0d8: "Ooblique", 0x0d9: "Ugrave", 0x0da: "Uacute", 0x0db: "Ucircumflex", 0x0dc: "Udiaeresis", 0x0dd: "Yacute", 0x0de: "THORN", 0x0df: "ssharp", 0x0f7: "division", 0x0ff: "ydiaeresis", 0x01001120: "Multi_key", 0x01001137: "Codeinput", 0x0100113c: "SingleCandidate", 0x0100113d: "MultipleCandidate", 0x0100113e: "PreviousCandidate", 0x0100117e: "Mode_switch", 0x01001121: "Kanji", 0x01001122: "Muhenkan", 0x01001123: "Henkan", 0x01001124: "Romaji", 0x01001125: "Hiragana", 0x01001126: "Katakana", 0x01001127: "Hiragana_Katakana", 0x01001128: "Zenkaku", 0x01001129: "Hankaku", 0x0100112a: "Zenkaku_Hankaku", 0x0100112b: "Touroku", 0x0100112c: "Massyo", 0x0100112d: "Kana_Lock", 0x0100112e: "Kana_Shift", 0x0100112f: "Eisu_Shift", 0x01001130: "Eisu_toggle", 0x01001131: "Hangul", 0x01001132: "Hangul_Start", 0x01001133: "Hangul_End", 0x01001134: "Hangul_Hanja", 0x01001135: "Hangul_Jamo", 0x01001136: "Hangul_Romaja", 0x01001138: "Hangul_Jeonja", 0x01001139: "Hangul_Banja", 0x0100113a: "Hangul_PreHanja", 0x0100113b: "Hangul_PostHanja", 0x0100113f: "Hangul_Special", 0x01001250: "Dead_Grave", 0x01001251: "Dead_Acute", 0x01001252: "Dead_Circumflex", 0x01001253: "Dead_Tilde", 0x01001254: "Dead_Macron", 0x01001255: "Dead_Breve", 0x01001256: "Dead_Abovedot", 0x01001257: "Dead_Diaeresis", 0x01001258: "Dead_Abovering", 0x01001259: "Dead_Doubleacute", 0x0100125a: "Dead_Caron", 0x0100125b: "Dead_Cedilla", 0x0100125c: "Dead_Ogonek", 0x0100125d: "Dead_Iota", 0x0100125e: "Dead_Voiced_Sound", 0x0100125f: "Dead_Semivoiced_Sound", 0x01001260: "Dead_Belowdot", 0x01001261: "Dead_Hook", 0x01001262: "Dead_Horn", 0x01001263: "Dead_Stroke", 0x01001264: "Dead_Abovecomma", 0x01001265: "Dead_Abovereversedcomma", 0x01001266: "Dead_Doublegrave", 0x01001267: "Dead_Belowring", 0x01001268: "Dead_Belowmacron", 0x01001269: "Dead_Belowcircumflex", 0x0100126a: "Dead_Belowtilde", 0x0100126b: "Dead_Belowbreve", 0x0100126c: "Dead_Belowdiaeresis", 0x0100126d: "Dead_Invertedbreve", 0x0100126e: "Dead_Belowcomma", 0x0100126f: "Dead_Currency", 0x01001280: "Dead_a", 0x01001281: "Dead_A", 0x01001282: "Dead_e", 0x01001283: "Dead_E", 0x01001284: "Dead_i", 0x01001285: "Dead_I", 0x01001286: "Dead_o", 0x01001287: "Dead_O", 0x01001288: "Dead_u", 0x01001289: "Dead_U", 0x0100128a: "Dead_Small_Schwa", 0x0100128b: "Dead_Capital_Schwa", 0x0100128c: "Dead_Greek", 0x01001290: "Dead_Lowline", 0x01001291: "Dead_Aboveverticalline", 0x01001292: "Dead_Belowverticalline", 0x01001293: "Dead_Longsolidusoverlay", 0x01000061: "Back", 0x01000062: "Forward", 0x01000063: "Stop", 0x01000064: "Refresh", 0x01000070: "VolumeDown", 0x01000071: "VolumeMute", 0x01000072: "VolumeUp", 0x01000073: "BassBoost", 0x01000074: "BassUp", 0x01000075: "BassDown", 0x01000076: "TrebleUp", 0x01000077: "TrebleDown", 0x01000080: "MediaPlay", 0x01000081: "MediaStop", 0x01000082: "MediaPrevious", 0x01000083: "MediaNext", 0x01000084: "MediaRecord", 0x1000085: "MediaPause", 0x1000086: "MediaTogglePlayPause", 0x01000090: "HomePage", 0x01000091: "Favorites", 0x01000092: "Search", 0x01000093: "Standby", 0x01000094: "OpenUrl", 0x010000a0: "LaunchMail", 0x010000a1: "LaunchMedia", 0x010000a2: "Launch0", 0x010000a3: "Launch1", 0x010000a4: "Launch2", 0x010000a5: "Launch3", 0x010000a6: "Launch4", 0x010000a7: "Launch5", 0x010000a8: "Launch6", 0x010000a9: "Launch7", 0x010000aa: "Launch8", 0x010000ab: "Launch9", 0x010000ac: "LaunchA", 0x010000ad: "LaunchB", 0x010000ae: "LaunchC", 0x010000af: "LaunchD", 0x010000b0: "LaunchE", 0x010000b1: "LaunchF", 0x0100010e: "LaunchG", 0x0100010f: "LaunchH", 0x010000b2: "MonBrightnessUp", 0x010000b3: "MonBrightnessDown", 0x010000b4: "KeyboardLightOnOff", 0x010000b5: "KeyboardBrightnessUp", 0x010000b6: "KeyboardBrightnessDown", 0x010000b7: "PowerOff", 0x010000b8: "WakeUp", 0x010000b9: "Eject", 0x010000ba: "ScreenSaver", 0x010000bb: "WWW", 0x010000bc: "Memo", 0x010000bd: "LightBulb", 0x010000be: "Shop", 0x010000bf: "History", 0x010000c0: "AddFavorite", 0x010000c1: "HotLinks", 0x010000c2: "BrightnessAdjust", 0x010000c3: "Finance", 0x010000c4: "Community", 0x010000c5: "AudioRewind", 0x010000c6: "BackForward", 0x010000c7: "ApplicationLeft", 0x010000c8: "ApplicationRight", 0x010000c9: "Book", 0x010000ca: "CD", 0x010000cb: "Calculator", 0x010000cc: "ToDoList", 0x010000cd: "ClearGrab", 0x010000ce: "Close", 0x010000cf: "Copy", 0x010000d0: "Cut", 0x010000d1: "Display", 0x010000d2: "DOS", 0x010000d3: "Documents", 0x010000d4: "Excel", 0x010000d5: "Explorer", 0x010000d6: "Game", 0x010000d7: "Go", 0x010000d8: "iTouch", 0x010000d9: "LogOff", 0x010000da: "Market", 0x010000db: "Meeting", 0x010000dc: "MenuKB", 0x010000dd: "MenuPB", 0x010000de: "MySites", 0x010000df: "News", 0x010000e0: "OfficeHome", 0x010000e1: "Option", 0x010000e2: "Paste", 0x010000e3: "Phone", 0x010000e4: "Calendar", 0x010000e5: "Reply", 0x010000e6: "Reload", 0x010000e7: "RotateWindows", 0x010000e8: "RotationPB", 0x010000e9: "RotationKB", 0x010000ea: "Save", 0x010000eb: "Send", 0x010000ec: "Spell", 0x010000ed: "SplitScreen", 0x010000ee: "Support", 0x010000ef: "TaskPane", 0x010000f0: "Terminal", 0x010000f1: "Tools", 0x010000f2: "Travel", 0x010000f3: "Video", 0x010000f4: "Word", 0x010000f5: "Xfer", 0x010000f6: "ZoomIn", 0x010000f7: "ZoomOut", 0x010000f8: "Away", 0x010000f9: "Messenger", 0x010000fa: "WebCam", 0x010000fb: "MailForward", 0x010000fc: "Pictures", 0x010000fd: "Music", 0x010000fe: "Battery", 0x010000ff: "Bluetooth", 0x01000100: "WLAN", 0x01000101: "UWB", 0x01000102: "AudioForward", 0x01000103: "AudioRepeat", 0x01000104: "AudioRandomPlay", 0x01000105: "Subtitle", 0x01000106: "AudioCycleTrack", 0x01000107: "Time", 0x01000108: "Hibernate", 0x01000109: "View", 0x0100010a: "TopMenu", 0x0100010b: "PowerDown", 0x0100010c: "Suspend", 0x0100010d: "ContrastAdjust", 0x01000110: "TouchpadToggle", 0x01000111: "TouchpadOn", 0x01000112: "TouchpadOff", 0x01000113: "MicMute", 0x01000114: "Red", 0x01000115: "Green", 0x01000116: "Yellow", 0x01000117: "Blue", 0x01000118: "ChannelUp", 0x01000119: "ChannelDown", 0x0100011a: "Guide", 0x0100011b: "Info", 0x0100011c: "Settings", 0x0100011d: "MicVolumeUp", 0x0100011e: "MicVolumeDown", 0x01000120: "New", 0x01000121: "Open", 0x01000122: "Find", 0x01000123: "Undo", 0x01000124: "Redo", 0x0100ffff: "MediaLast", 0x01ffffff: "unknown", 0x01100004: "Call", 0x01100020: "Camera", 0x01100021: "CameraFocus", 0x01100000: "Context1", 0x01100001: "Context2", 0x01100002: "Context3", 0x01100003: "Context4", 0x01100006: "Flip", 0x01100005: "Hangup", 0x01010002: "No", 0x01010000: "Select", 0x01010001: "Yes", 0x01100007: "ToggleCallHangup", 0x01100008: "VoiceDial", 0x01100009: "LastNumberRedial", 0x01020003: "Execute", 0x01020002: "Printer", 0x01020005: "Play", 0x01020004: "Sleep", 0x01020006: "Zoom", 0x0102000a: "Exit", 0x01020001: "Cancel"
                        })
                        property var modifierKeys: [Qt.Key_Alt, Qt.Key_Meta, Qt.Key_Control, Qt.Key_Shift, Qt.Key_NumLock, Qt.Key_Mode_switch]

                        property bool lastWasNotModifier: false
                        function parseKeyEvent(event, released) {
                            if (!autoShortcut.checked)
                                return

                            if (!released && (event.key == Qt.Key_Backspace || event.key == Qt.Key_Delete) && event.modifiers == Qt.NoModifier) {
                                text = ''
                                event.accepted = true
                                return
                            }

                            var isModifier = false
                            modifierKeys.forEach(function(modifKey) {
                                if (modifKey == event.key)
                                    isModifier = true
                            })
                            if (released && lastWasNotModifier) {
                                event.accepted = true
                                return
                            }

                            lastWasNotModifier = !isModifier

                            if (event.key == Qt.Key_unknown) {
                                console.log("Unknown key from a macro probably")
                                //text = ""
                                event.accepted = true
                                return
                            }

                            var result = ''
                            // var result = lastWasNotModifier ? text + "," : ''
                            if (!(event.modifiers & Qt.NoModifier)) {
                                for(var modifier in modifiers) {
                                    if (modifier & event.modifiers)
                                        result += modifiers[modifier] + "+"
                                }
                            }

                            if (!released && !isModifier) {
                                result += keys[event.key]
                            }
                            if (text.endsWith('+')) {
                                var t = text.split(',')
                                text = t.slice(0, t.length - 1).join(',')
                            }
                            if (text) {
                                if (text.endsWith(','))
                                    text = text + result
                                else
                                    text = text + ',' + result
                            }
                            else {
                                text = result
                            }
                            event.accepted = true
                        }
                        Keys.onPressed: parseKeyEvent(event, false)
                        Keys.onReleased: parseKeyEvent(event, true)

                        ToolButton {
                            id: autoShortcut
                            anchors {
                                top: parent.top
                                bottom: parent.bottom
                                right: parent.right
                                bottomMargin: 2
                                topMargin: 2
                                rightMargin: 2
                            }
                            text: qsTr("auto")
                            checkable: true
                            checked: true
                            tooltip: qsTr("Wheter this line tries to create shortcut with you keypresses.\nIf disabled, you will be able to enter any key sequence as plain text")
                        }
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
                Component.onCompleted : {
                    var commands = settings.commands
                    if (commands) {
                        myModel.fromString(commands)
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

                onVisibleChanged : {
                    if (!activeFocus) {
                        text = JSON.stringify(myModel.data())
                    }
                }

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
            }
        }
    }
}
