import qs.settings
import qs.widgets
import qs.services
import Quickshell.Widgets
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts


ContentMenu {
    title: "Appearance"
    description: "Adjust how the desktop looks like to your preference."

    ContentCard {

        /* ---------- Dark Mode Row ---------- */
        RowLayout {
            spacing: 10
            Layout.fillWidth: true

            ColumnLayout {
                StyledText { 
                    text: "Dark mode"
                    font.pixelSize: 16
                }
                StyledText { 
                    text: "Whether to use dark color schemes."
                    font.pixelSize: 12
                }
            }

            Item { Layout.fillWidth: true }

            StyledSwitch {
                checked: Shell.flags.appearance.theme === "dark"
                onToggled: {
                    Quickshell.execDetached({
                        command: ['qs', 'ipc', 'call', 'global', "toggleTheme"]
                    })
                }
            }
        }

        StyledSwitchOption {
            title: "Show Clock"
            description: "Whether to show or disable the clock on the background."
            prefField: "background.showClock"
        }

        ColumnLayout {
            StyledText {
                text: "Color Generation Schemes:"
                font.pixelSize: 16
            }
            GridLayout {
                rows: 2
                columns: 4 
                Repeater {
                    model: [
                        "scheme-content",
                        "scheme-expressive",
                        "scheme-fidelity",
                        "scheme-fruit-salad",
                        "scheme-monochrome",
                        "scheme-neutral",
                        "scheme-rainbow",
                        "scheme-tonal-spot"
                    ]

                    delegate: StyledButton {
                        text: modelData
                        clip: true
                        Layout.fillWidth: true
                        implicitWidth: 0

                        // Selected state
                        checked: Shell.flags.appearance.colorScheme === modelData

                        // Rounded corners depending on whether this is first/last item
                        topLeftRadius: index === 0
                            ? Appearance.rounding.normal
                            : Appearance.rounding.small
                        bottomLeftRadius: index === 0
                            ? Appearance.rounding.normal
                            : Appearance.rounding.small

                        topRightRadius: index === (model.count - 1)
                            ? Appearance.rounding.normal
                            : Appearance.rounding.small
                        bottomRightRadius: index === (model.count - 1)
                            ? Appearance.rounding.normal
                            : Appearance.rounding.small

                        onClicked: {
                            Shell.setNestedValue("appearance.colorScheme", modelData)
                            Quickshell.execDetached(["qs", "ipc", "call", "global", "regenColors"])
                        }
                    }
                }
            }
        }
    }
}
