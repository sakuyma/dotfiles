import QtQuick 
import QtQuick.Controls 
import Quickshell 
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets
import Quickshell.Io
import QtCore

import "src"

FreezeScreen {
    id: root
    visible: false

    property var activeScreen: null

    Settings {
        id: settings
        category: "Hyprquickshot"
        property bool saveToDisk: true 
    }

    Connections {
        target: Hyprland
        enabled: activeScreen === null

        function onFocusedMonitorChanged() {
            const monitor = Hyprland.focusedMonitor
            if(!monitor) return

            for (const screen of Quickshell.screens) {
                if (screen.name === monitor.name) {
                    activeScreen = screen

                    const timestamp = Date.now()
                    const path = Quickshell.cachePath(`screenshot-${timestamp}.png`)
                    tempPath = path
                    Quickshell.execDetached(["grim", "-g", `${screen.x},${screen.y} ${screen.width}x${screen.height}`, path])
                    showTimer.start()
                }
            }
        }
    }

    targetScreen: activeScreen

    property var hyprlandMonitor: Hyprland.focusedMonitor
    property string tempPath

    property string mode: "region"

    Shortcut {
        sequence: "Escape"
        onActivated: () => {
            Quickshell.execDetached(["rm", tempPath])
            Qt.quit()
        }
    }
 
    Timer {
        id: showTimer
        interval: 50
        running: false
        repeat: false
        onTriggered: root.visible = true
    }
 
    Process {
        id: screenshotProcess
        running: false

        onExited: () => {
            Qt.quit()
        }

        stdout: StdioCollector {
            onStreamFinished: console.log(this.text)
        }
        stderr: StdioCollector {
            onStreamFinished: console.log(this.text)
        }

    }

    function processScreenshot(x, y, width, height) {
        const scale = hyprlandMonitor.scale
        const scaledX = Math.round(x * scale)
        const scaledY = Math.round(y * scale)
        const scaledWidth = Math.round(width * scale)
        const scaledHeight = Math.round(height * scale)

        const picturesDir = Quickshell.env("HQS_DIR") || Quickshell.env("XDG_SCREENSHOTS_DIR") || Quickshell.env("XDG_PICTURES_DIR") || (Quickshell.env("HOME") + "/Pictures")

        const now = new Date()
        const timestamp = Qt.formatDateTime(now, "yyyy-MM-dd_hh-mm-ss")

        const outputPath = settings.saveToDisk ? `${picturesDir}/screenshot-${timestamp}.png` : root.tempPath

        screenshotProcess.command = ["sh", "-c",
            `magick "${tempPath}" -crop ${scaledWidth}x${scaledHeight}+${scaledX}+${scaledY} "${outputPath}" && ` +
            `wl-copy < "${outputPath}" && ` +
            `rm "${tempPath}"`
        ]

        screenshotProcess.running = true
        root.visible = false
    }

    RegionSelector {
        visible: mode === "region"
        id: regionSelector
        anchors.fill: parent
 
        dimOpacity: 0.6
        borderRadius: 10.0
        outlineThickness: 2.0
 
        onRegionSelected: (x, y, width, height) => {
            processScreenshot(x, y, width, height)
        }
    }
 
    WindowSelector {
        visible: mode === "window"
        id: windowSelector
        anchors.fill: parent
 
        monitor: root.hyprlandMonitor
        dimOpacity: 0.6
        borderRadius: 10.0
        outlineThickness: 2.0
 
        onRegionSelected: (x, y, width, height) => {
            processScreenshot(x, y, width, height)
        }
    }
 
    WrapperRectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40

        color: Qt.rgba(0.1, 0.1, 0.1, 0.8)
        radius: 12
        margin: 8

		Row {
			id: settingRow
			spacing: 25
		
			Row {
				id: buttonRow
				spacing: 8
	 
				Repeater {
					model: [
						{ mode: "region", icon: "region" },
						{ mode: "window", icon: "window" },
						{ mode: "screen", icon: "screen" }
					]
	 
					Button {
						id: modeButton
						implicitWidth: 48
						implicitHeight: 48

						background: Rectangle {
							radius: 8
							color: {
								if(mode === modelData.mode) return Qt.rgba(0.3, 0.4, 0.7, 0.5)
								if (modeButton.hovered) return Qt.rgba(0.4, 0.4, 0.4, 0.5)

								return Qt.rgba(0.3, 0.3, 0.35, 0.5)
							}

							Behavior on color { ColorAnimation { duration: 100 } }
						}

						contentItem: Item {
							anchors.fill: parent

							Image {
								anchors.centerIn: parent
								width: 24
								height: 24
								source: Quickshell.shellPath(`icons/${modelData.icon}.svg`)
								fillMode: Image.PreserveAspectFit
							}
						}

						onClicked: {
							root.mode = modelData.mode
							if (modelData.mode === "screen") {
								processScreenshot(0, 0, root.targetScreen.width, root.targetScreen.height)
							}
						}
					}
				}
			}
			
			Row {
				id: switchRow
				spacing: 8
				anchors.verticalCenter: buttonRow.verticalCenter

				Text {
					text: "Save to disk"
					color: "#ffffff"
					font.pixelSize: 14
					verticalAlignment: Text.AlignVCenter
					anchors.verticalCenter: parent.verticalCenter
				}

				Switch {
					id: saveSwitch
					checked: settings.saveToDisk
					onCheckedChanged: settings.saveToDisk = checked
				}
			}
		}
    }
}
