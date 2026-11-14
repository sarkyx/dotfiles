import Quickshell
import QtQuick
import ".."

Scope {
	id: root
	required property var parentBar

	Timer {
		interval: 1000
		running: true
		repeat: true
		onTriggered: {
			console.log(appDisplay.xEnd)
		}
	}
	
	PanelWindow {
		id: appDisplay
		screen: root.parentBar.screen
		
		anchors {
			left: true
			bottom: true
			top: true
			right: true
		}
		
		property real visualWidth: root.parentBar.mb.visualWidth
		
		property real xStart: root.parentBar.mb.xStart
		property real xEnd: root.parentBar.mb.xEnd
		
		Canvas {
			id: adVisual
			
			anchors.fill: parent
			
			onPaint: {
				var ctx = getContext("2d");
				ctx.reset()
				
				ctx.moveTo(appDisplay.xStart,0)
				ctx.lineTo(appDisplay.xStart,500)
				ctx.lineTo(appDisplay.xEnd,500)
				ctx.lineTo(appDisplay.xEnd,0)
				ctx.closePath()
				
				ctx.fillStyle = Qt.rgba(1,0,0,0.75)
				ctx.fill()
			}
		}
		
		mask: Region {}
		
		color: "transparent"
		exclusionMode: ExclusionMode.Ignore
	}
	
	PanelWindow {
		id: iconDisplay
		
		anchors {
			left: true
			bottom: true
			top: true
			right: true
		}
		
		Canvas {
			id: idVisual
		}
		
		mask: Region {}
		
		color: "transparent"
		exclusionMode: ExclusionMode.Ignore
	}
}
