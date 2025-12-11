import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.services
import qs.settings
import qs.widgets

ContentMenu {
    title: "Interface"
    description: "Adjust the desktop's interface."

    ContentCard {
        StyledText {
            text: "Bar"
            font.pixelSize: 20
            font.bold: true
        }

        ColumnLayout {
            StyledText {
                text: "Position"
                font.pixelSize: 16
            }

            RowLayout {
                spacing: 8

                Repeater {
                    model: ['Top', 'Bottom']

                    delegate: StyledButton {
                        property bool isTop: modelData.toLowerCase() === "top"

                        text: modelData
                        implicitWidth: 0
                        Layout.fillWidth: true // make both buttons full width
                        checked: Shell.flags.bar.atTop === isTop
                        // Rounded corners for visual consistency
                        topLeftRadius: isTop ? Appearance.rounding.normal : Appearance.rounding.normal
                        bottomLeftRadius: isTop ? Appearance.rounding.normal : Appearance.rounding.normal
                        topRightRadius: isTop ? Appearance.rounding.normal : Appearance.rounding.normal
                        bottomRightRadius: isTop ? Appearance.rounding.normal : Appearance.rounding.normal
                        onClicked: Shell.setNestedValue("bar.atTop", isTop)
                    }

                }

            }

        }

        StyledSwitchOption {
            title: "Visible"
            description: "Change the bar's visiblity."
            prefField: "bar.enabled"
        }

        StyledSwitchOption {
            title: "Floating Bar"
            description: "Whether to keep the bar floating."
            prefField: "bar.floating"
        }

        StyledSwitchOption {
            title: "Floating Modules"
            description: "Whether to keep the modules floating."
            prefField: "bar.floatingModules"
        }

        StyledSwitchOption {
            title: "Large Workspace Icons"
            description: "Whether to keep the workspace icons large or not\nIf disabled, the bar will use small icons."
            prefField: "bar.modules.workspaces.largeIcons"
        }

        StyledSwitchOption {
            title: "Workspace Numbers"
            description: "Whether to keep numbers on workspace icons or not.\nNote - This will only work with large workspace icons."
            prefField: "bar.modules.workspaces.showNumbers"
        }


    }

    ContentCard {
        StyledText {
            text: "Bar Content"
            font.pixelSize: 20
            font.bold: true
        }

        ColumnLayout {
            spacing: 20

            // --- Workspaces ---
            ColumnLayout {
                StyledText {
                    text: "Workspaces"
                    font.pixelSize: 16
                    font.bold: true
                }

                StyledSwitchOption {
                    title: "Enabled"
                    description: "Enable Workspaces"
                    prefField: "bar.modules.workspaces.enabled"

                    RowLayout {
                        Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        Repeater {
                            model: ['Left', 'Center', 'Right']

                            delegate: StyledButton {
                                property string posValue: modelData.toLowerCase()

                                text: modelData
                                implicitWidth: 80
                                checked: Shell.flags.bar.modules.workspaces.position === posValue
                                topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                onClicked: Shell.setNestedValue("bar.modules.workspaces.position", posValue)
                            }

                        }

                    }

                }

            }

            // --- System Tray ---
            ColumnLayout {
                StyledText {
                    text: "System Tray"
                    font.pixelSize: 16
                    font.bold: true
                }

                StyledSwitchOption {
                    title: "Enabled"
                    description: "Enable System Tray"
                    prefField: "bar.modules.systemTray.enabled"

                    RowLayout {
                        Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        Repeater {
                            model: ['Left', 'Center', 'Right']

                            delegate: StyledButton {
                                property string posValue: modelData.toLowerCase()

                                text: modelData
                                implicitWidth: 80
                                checked: Shell.flags.bar.modules.systemTray.position === posValue
                                topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                onClicked: Shell.setNestedValue("bar.modules.systemTray.position", posValue)
                            }

                        }

                    }

                }

            }

            // --- Media ---
            ColumnLayout {
                StyledText {
                    text: "Media"
                    font.pixelSize: 16
                    font.bold: true
                }

                StyledSwitchOption {
                    title: "Enabled"
                    description: "Enable Media Module"
                    prefField: "bar.modules.media.enabled"

                    RowLayout {
                        Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        Repeater {
                            model: ['Left', 'Center', 'Right']

                            delegate: StyledButton {
                                property string posValue: modelData.toLowerCase()

                                text: modelData
                                implicitWidth: 80
                                checked: Shell.flags.bar.modules.media.position === posValue
                                topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                onClicked: Shell.setNestedValue("bar.modules.media.position", posValue)
                            }

                        }

                    }

                }

            }

            // --- Bluetooth & WiFi ---
            ColumnLayout {
                StyledText {
                    text: "Bluetooth & WiFi"
                    font.pixelSize: 16
                    font.bold: true
                }

                StyledSwitchOption {
                    title: "Enabled"
                    description: "Enable Bluetooth/WiFi Module"
                    prefField: "bar.modules.bluetoothWifi.enabled"

                    RowLayout {
                        Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        Repeater {
                            model: ['Left', 'Center', 'Right']

                            delegate: StyledButton {
                                property string posValue: modelData.toLowerCase()

                                text: modelData
                                implicitWidth: 80
                                checked: Shell.flags.bar.modules.bluetoothWifi.position === posValue
                                topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                onClicked: Shell.setNestedValue("bar.modules.bluetoothWifi.position", posValue)
                            }

                        }

                    }

                }

            }

            // --- Launcher Button ---
            ColumnLayout {
                StyledText {
                    text: "Launcher Button"
                    font.pixelSize: 16
                    font.bold: true
                }

                StyledSwitchOption {
                    title: "Enabled"
                    description: "Enable launcher button"
                    prefField: "bar.modules.launcherOpen.enabled"

                    RowLayout {
                        Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        Repeater {
                            model: ['Left', 'Center', 'Right']

                            delegate: StyledButton {
                                property string posValue: modelData.toLowerCase()

                                text: modelData
                                implicitWidth: 80
                                checked: Shell.flags.bar.modules.launcherOpen.position === posValue
                                topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                onClicked: Shell.setNestedValue("bar.modules.launcherOpen.postion", posValue)
                            }

                        }

                    }

                }

            }


            // --- Clock ---
            ColumnLayout {
                StyledText {
                    text: "Clock"
                    font.pixelSize: 16
                    font.bold: true
                }

                StyledSwitchOption {
                    title: "Enabled"
                    description: "Enable Clock Module"
                    prefField: "bar.modules.clock.enabled"

                    RowLayout {
                        Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: Appearance.m3colors.m3outline
                        }

                        Repeater {
                            model: ['Left', 'Center', 'Right']

                            delegate: StyledButton {
                                property string posValue: modelData.toLowerCase()

                                text: modelData
                                implicitWidth: 80
                                checked: Shell.flags.bar.modules.clock.position === posValue
                                topLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomLeftRadius: (modelData === "Left" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                topRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                bottomRightRadius: (modelData === "Right" || checked) ? Appearance.rounding.normal : Appearance.rounding.small
                                onClicked: Shell.setNestedValue("bar.modules.clock.position", posValue)
                            }

                        }

                    }

                }

            }

        }

    }

}
