pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: time

	property string time

	Timer {
		interval: 100
		running: true
		repeat: true
		onTriggered: time.time = new Date().toLocaleTimeString(Qt.locale(), "HH:mm:ss")
	}
}
