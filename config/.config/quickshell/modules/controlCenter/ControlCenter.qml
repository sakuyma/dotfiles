import qs.settings
import qs.widgets
import qs.services
import qs.functions
import qs.modules.controlCenter.widgets
import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Io
import QtQuick.Controls
import Quickshell.Services.Pipewire
import Qt5Compat.GraphicalEffects

PanelWindow {
    id: controlCenter
    WlrLayershell.layer: WlrLayer.Top
    visible: Shell.ready && GlobalStates.controlCenterOpen

    color: "transparent"
    exclusiveZone: 0

    // --- Directly use Hyprland's focused monitor ---
    property var monitor: Hyprland.focusedMonitor


    property real controlCenterWidth: Shell.flags.bar.modules.bluetoothWifi.position === "center" ? 560 : 520
    property real controlCenterHeight: 640

    implicitWidth: controlCenterWidth
    implicitHeight: controlCenterHeight

    anchors {
        top: Shell.flags.bar.atTop 
        left: Shell.flags.bar.modules.bluetoothWifi.position === "left"
        right: Shell.flags.bar.modules.bluetoothWifi.position === "right" 
        bottom: !Shell.flags.bar.atTop
    }

    margins {
        top: Shell.flags.bar.atTop ? Appearance.margin.small : 0
        bottom: !Shell.flags.bar.atTop ? Appearance.margin.small : 0
        left: Appearance.margin.large
        right: Appearance.margin.large
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    property var sink: Pipewire.defaultAudioSink?.audio


    StyledRect {
        id: container
        color: Appearance.m3colors.m3background
        radius: Appearance.rounding.verylarge
        implicitWidth: controlCenter.controlCenterWidth
        implicitHeight: controlCenter.controlCenterHeight

        anchors.fill: parent

        Item {
            anchors.fill: parent
            anchors.leftMargin: Appearance.margin.large
            anchors.rightMargin: Appearance.margin.small
            anchors.topMargin: Appearance.margin.large + 5 
            anchors.bottomMargin: Appearance.margin.large

            ColumnLayout {
                id: mainLayout
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: Appearance.margin.tiny
                anchors.rightMargin: Appearance.margin.small
                anchors.topMargin: Shell.flags.bar.atTop ? Appearance.margin.large : 0
                anchors.bottomMargin: !Shell.flags.bar.atTop ? Appearance.margin.large : 0
                anchors.margins: Appearance.margin.large
                spacing: Appearance.margin.large

                // --- Top Section ---
                RowLayout {
                    Layout.fillWidth: true

                    ProfilePicture {}

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.leftMargin: 10
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 2

                        StyledText { 
                            text: SystemDetails.username 
                            font.pixelSize: Appearance.font.size.wildass - 6
                        }

                        RowLayout {
                            spacing: 8

                            StyledText {
                                text: SystemDetails.osIcon
                                font.pixelSize: Appearance.font.size.huge
                            }

                            StyledText {
                                text: Stringify.shortText(SystemDetails.uptime, 18)
                                font.pixelSize: Appearance.font.size.normal
                            }
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Column {
                        spacing: 6
                        Layout.leftMargin: 25
                        Layout.alignment: Qt.AlignVCenter 
                        StyledRect {
                            id: powerbtncontainer
                            color: Appearance.m3colors.m3paddingContainer
                            radius: Appearance.rounding.normal
                            implicitHeight: settingsButton.height + Appearance.margin.tiny
                            implicitWidth: settingsButton.width + Appearance.margin.small
                            Layout.alignment: Qt.AlignRight | Qt.AlignTop
                            Layout.topMargin: 10
                            Layout.leftMargin: 15

                            MaterialSymbolButton {
                                id: powerButton
                                icon: "⏻"
                                anchors.centerIn: parent
                                iconSize: Appearance.font.size.wildass - 10

                                onButtonClicked: {
                                    GlobalStates.controlCenterOpen = false
                                    GlobalStates.powerMenuOpen = true
                                }
                            }
                        }
                        StyledRect {
                            id: settingsbtncontainer
                            color: Appearance.m3colors.m3paddingContainer
                            radius: Appearance.rounding.normal
                            implicitHeight: settingsButton.height + Appearance.margin.tiny
                            implicitWidth: settingsButton.width + Appearance.margin.small
                            Layout.alignment: Qt.AlignRight | Qt.AlignTop
                            Layout.topMargin: 10
                            Layout.leftMargin: 15

                            MaterialSymbolButton {
                                id: settingsButton
                                icon: ""
                                anchors.centerIn: parent
                                iconSize: Appearance.font.size.wildass - 10

                                onButtonClicked: {
                                    GlobalStates.controlCenterOpen = false
                                    GlobalStates.visible_settingsMenu = true
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Appearance.m3colors.m3outlineVariant
                    radius: 1
                }

                // --- Bottom Grid Section (right under the separator) ---
                GridLayout {
                    id: middleGrid
                    Layout.fillWidth: true
                    columns: 2
                    columnSpacing: Appearance.margin.large
                    rowSpacing: Appearance.margin.large

                    // Make all items stretch equally
                    Layout.preferredWidth: parent.width

                    Network {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                    }
                    Bluetooth {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                    }
                    Notifications {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80                    
                    }
                    Interface {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80                         
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Appearance.m3colors.m3outlineVariant
                    radius: 1
                }

                ColumnLayout {
                    spacing: Appearance.margin.small
                    
                    Layout.fillWidth: true

                    RowLayout {
                        StyledText {
                            Layout.alignment: Qt.AlignLeft
                            text: "Volume"
                        }

                        Item { Layout.fillWidth: true }

                        StyledText {
                            animate: false
                            text: Math.round(sink ? sink.volume * 100 : 0) + "%"
                            Layout.alignment: Qt.AlignRight
                        }
                    }

                    ColumnLayout {
                        id: bottomColumn
                        Layout.fillWidth: true

                        Volume {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                        }

                        RowLayout {

                            StyledText {
                                Layout.alignment: Qt.AlignLeft
                                text: "Brightness"
                            }

                            Item { Layout.fillWidth: true }

                            StyledText {
                                animate: false
                                property var monitor: Brightness.monitors.length > 0 ? Brightness.monitors[0] : null
                                text: Math.round(monitor.brightness * 100) + "%"
                                Layout.alignment: Qt.AlignRight
                            }
                        }

                        Brightness {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                        }
                    }
                }
            }
        }
    }

    // --- Toggle logic ---
    function togglecontrolCenter() {
        const newState = !GlobalStates.controlCenterOpen
        GlobalStates.controlCenterOpen = newState
        if (newState)
            controlCenter.forceActiveFocus()
        else
            controlCenter.focus = false
    }

    IpcHandler {
        target: "controlCenter"
        function toggle() {
            togglecontrolCenter()
        }
    }

    Connections {
        target: Hyprland
        function onFocusedMonitorChanged() {
            controlCenter.monitor = Hyprland.focusedMonitor
        }
    }
}
