import Quickshell
import QtQuick
import ".."

Scope {
	id: root
	required property var parentBar
	
	Timer {
		interval: 1000
		running: false
		repeat: true
		onTriggered: {
			console.log(topDisplay.xStart + ' ' + topDisplay.xEnd)
		}
	}
	
	property alias td: topDisplay
	PanelWindow {
		id: topDisplay
		screen: root.parentBar.screen
		
		anchors {
			left: true
			bottom: true
			top: true
			right: true
		}
		
		property real visualWidth: root.parentBar.mb.visualWidth
		
		property real xStart: root.parentBar.mb.xStart
		onXStartChanged: adVisual.requestPaint()
		property real xEnd: root.parentBar.mb.xEnd
		onXEndChanged: adVisual.requestPaint()
		
		Canvas {
			id: adVisual
			
			anchors.fill: parent
			
			onPaint: {
				var ctx = getContext("2d");
				ctx.reset()
				
				ctx.moveTo(topDisplay.xStart,0)
				ctx.lineTo(topDisplay.xStart,10)
				ctx.lineTo(topDisplay.xEnd,10)
				ctx.lineTo(topDisplay.xEnd,0)
				ctx.closePath()
				
				ctx.fillStyle = Qt.rgba(1,0,0,0.75)
				ctx.fill()
			}
		}
		
		mask: Region {}
		
		color: "transparent"
		exclusionMode: ExclusionMode.Ignore
	}
	
	property alias bd: bottomDisplay
	PanelWindow {
		id: bottomDisplay
		
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
