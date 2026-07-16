import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root
    Layout.minimumWidth: row.implicitWidth + 8
    Layout.preferredWidth: row.implicitWidth + 8
    Layout.fillHeight: true

    readonly property string scriptBase: "bash /home/celo/projects/personal/claude_usage/claude_usage.sh"
    property string statusIndicator: "unknown"

    function statusColor(indicator) {
        if (indicator === "none")     return "#4ade80"
        if (indicator === "minor")    return "#facc15"
        if (indicator === "major")    return "#f97316"
        if (indicator === "critical") return "#ef4444"
        return "#6b7280"
    }

    function reloadAll() {
        label.text = "…"
        cmdMain.disconnectSource(root.scriptBase)
        cmdMain.connectSource(root.scriptBase)
    }

    function reloadUsage() {
        label.text = "…"
        var src = root.scriptBase + " usage"
        cmdUsage.disconnectSource(src)
        cmdUsage.connectSource(src)
    }

    function reloadStatus() {
        var src = root.scriptBase + " status"
        cmdStatus.disconnectSource(src)
        cmdStatus.connectSource(src)
    }

    Plasmoid.contextualActions: [
        PlasmaCore.Action {
            text: "Recarregar cota"
            icon.name: "view-refresh"
            onTriggered: root.reloadUsage()
        },
        PlasmaCore.Action {
            text: "Recarregar status"
            icon.name: "network-connect"
            onTriggered: root.reloadStatus()
        }
    ]

    // Periodic refresh: fetches quota + status
    Plasma5Support.DataSource {
        id: cmdMain
        engine: "executable"
        connectedSources: [root.scriptBase]
        interval: 300000
        onNewData: function(source, data) {
            if (parseInt(data["exit code"]) !== 0) return
            var out = data["stdout"].trim()
            if (!out) return
            var parts = out.split("::")
            label.text = parts[0]
            root.statusIndicator = parts.length > 1 ? parts[1] : "unknown"
        }
    }

    // Manual refresh: quota only
    Plasma5Support.DataSource {
        id: cmdUsage
        engine: "executable"
        interval: 0
        onNewData: function(source, data) {
            cmdUsage.disconnectSource(source)
            if (parseInt(data["exit code"]) !== 0) return
            var out = data["stdout"].trim()
            if (out) label.text = out
        }
    }

    // Manual refresh: status only
    Plasma5Support.DataSource {
        id: cmdStatus
        engine: "executable"
        interval: 0
        onNewData: function(source, data) {
            cmdStatus.disconnectSource(source)
            if (parseInt(data["exit code"]) !== 0) return
            var out = data["stdout"].trim()
            if (out) root.statusIndicator = out
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.reloadAll()
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 5

        Image {
            source: Qt.resolvedUrl("../icons/claude.png")
            width: 14
            height: 14
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: label
            text: "Claude..."
            color: "white"
            font.pixelSize: 12
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: "|"
            color: "white"
            font.pixelSize: 12
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            width: 8
            height: 8
            radius: 4
            color: root.statusColor(root.statusIndicator)
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
