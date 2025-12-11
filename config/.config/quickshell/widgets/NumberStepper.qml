import qs.settings
import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.widgets

RowLayout {
    id: root
    property string label: ""
    property string prefField: ""
    property int step: 1
    property int minimum: -2147483648
    property int maximum: 2147483647

    spacing: 8
    Layout.alignment: Qt.AlignVCenter

    // Read current numeric value from Shell.flags safely
    function readValue() {
        if (!prefField) return 0
        var parts = prefField.split('.')
        var cur = Shell.flags
        for (var i = 0; i < parts.length; ++i) {
            if (cur === undefined || cur === null) return 0
            cur = cur[parts[i]]
        }
        if (typeof cur === "number") return cur
        var n = Number(cur)
        return isNaN(n) ? 0 : n
    }

    // Write value (uses Shell.setNestedValue which will create missing keys)
    function writeValue(v) {
        if (!prefField) return
        var nv = Math.max(minimum, Math.min(maximum, Math.round(v)))
        Shell.setNestedValue(prefField, nv)
    }

    // Exposed current value property (updates via binding)
    property int value: readValue()

    ColumnLayout {
        spacing: 2
        StyledText { text: root.label; font.pixelSize: 14 }
        RowLayout {
            spacing: 6

            StyledButton {
                text: "-"
                implicitWidth: 36
                onClicked: {
                    writeValue(readValue() - step)
                }
            }

            StyledText {
                text: "" + readValue()
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                width: 72
                elide: Text.ElideRight
            }

            StyledButton {
                text: "+"
                implicitWidth: 36
                onClicked: {
                    writeValue(readValue() + step)
                }
            }
        }
    }
}