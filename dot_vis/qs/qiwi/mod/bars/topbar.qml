import Quickshell
import QtQuick
import ".."
import "../proc"

PanelWindow {
	id: root
	
	anchors.top: true
	
	color: "transparent"
	implicitHeight: 0
	implicitWidth: 0
	exclusionMode: ExclusionMode.Normal
	exclusiveZone: Config.style.TopBar.exclusiveZoneBool ? Math.max(midBar.height + midBar.y, leftBar.height + leftBar.y, rightBar.height + rightBar.y) : 0
	
	function _hextorgba(hex, alpha) {
		const cleanHex = hex.replace("#","");
		
		const r = parseInt(cleanHex.substring(0,2), 16);
		const g = parseInt(cleanHex.substring(2,4), 16);
		const b = parseInt(cleanHex.substring(4,6), 16);
		
		return Qt.rgba(r / 255, g / 255, b / 255, alpha)
	}
	
	
	component EaseAnim: Behavior {
		NumberAnimation {
			duration: 250 * Config.style.TopBar.animationSlowdown
			easing.type: Easing.OutCubic
		}
	}
	
	component ColorAnim: Behavior {
		ColorAnimation {
			duration: 250 * Config.style.TopBar.animationSlowdown
		}
	}
	
	PanelWindow {
		id: midBar
		screen: root.screen
		
		anchors.top: true
		margins.top: -1
		
		property int y: active ? -borderWidth / 2 : -height - (borderWidth / 2)
		EaseAnim on y {}
		onYChanged: mbVisual.requestPaint()
		property int x: 0
		
		property int xStart: (screen.width / 2) - (width / 2)
		property int xEnd: (screen.width / 2) + (width / 2)
		
		implicitWidth: (screen.width * Config.style.TopBar.midSizePrc) + borderWidth
		implicitHeight: Config.style.TopBar.panelHeightPx
		property real slant: Math.min(visualWidth / 3, Config.style.TopBar.panelSlantPx)
		onSlantChanged: mbVisual.requestPaint()
		
		property real visualWidth: width - borderWidth
		onVisualWidthChanged: mbVisual.requestPaint()
		property real visualHeight: height
		onVisualHeightChanged: mbVisual.requestPaint()
		
		exclusionMode: ExclusionMode.Ignore
		property real borderWidth: Math.max(0, Math.min(visualHeight / 3, Config.style.TopBar.borderWidth))
		onBorderWidthChanged: mbVisual.requestPaint()
		
		color: "transparent"
		
		Item {
			id: mbColors
			
			property color background: root._hextorgba(Config.colors.Special.background, Config.style.Global.backgroundOpacity)
			ColorAnim on background {}
			onBackgroundChanged: mbVisual.requestPaint()
			
			property color border: Config.colors.Special.border
			ColorAnim on border {}
			onBorderChanged: mbVisual.requestPaint()
			
			property color baseForeground: Config.colors.Special.foreground
			ColorAnim on baseForeground {}
			onBaseForegroundChanged: mbVisual.requestPaint()
		}
		
		property bool active: false
		property bool visible: true
		
		Canvas {
			id: mbVisual
			
			anchors.fill: parent
			
			onPaint: {
				var ctx = getContext("2d");
				ctx.reset();
				
				if (midBar.visible) {
					ctx.moveTo(midBar.x + midBar.borderWidth, midBar.y);
					ctx.lineTo(midBar.x + midBar.borderWidth + midBar.slant, midBar.y + midBar.visualHeight);
					ctx.lineTo(midBar.x + midBar.visualWidth - midBar.slant, midBar.y + midBar.visualHeight);
					ctx.lineTo(midBar.x + midBar.visualWidth, midBar.y);
					ctx.closePath();
					
					ctx.fillStyle = mbColors.background;
					ctx.fill();
					
					if (midBar.borderWidth > 0) {
						ctx.strokeStyle = mbColors.border
						ctx.lineWidth = midBar.borderWidth
						ctx.stroke();
					}
				}
			}
		}
		
		Timer {
			interval: 500
			running: true 
			repeat: true
			onTriggered: {
				midBar.active = true
			}
		}
		
		Rectangle {
			id: mbTextSpace
			
			x: midBar.x + ( midBar.borderWidth * 1.5 ) + ( midBar.slant )
			y: midBar.y
			
			width: midBar.visualWidth - ( midBar.slant * 2 ) - ( midBar.borderWidth * 2 )
			height: midBar.visualHeight
			property int fontSize: height / 2
			
			color: "transparent"
			
			Text {
				id: mbTextField
				width: parent.width
				
				anchors.fill: parent
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter
				
				color: mbColors.baseForeground
				font.family: Config.style.Global.fontFamily
				font.pixelSize: mbTextSpace.fontSize
				
				elide: Text.ElideLeft
				
				text: TimeProcess.time
			}
		}
	}
	
	PanelWindow {
		id: leftBar
		screen: root.screen
		
		anchors {
			top: true
			left: true
		}
		
		margins.top: -1
		
		property int y: active ? -borderWidth / 2 : -height - (borderWidth / 2)
		EaseAnim on y {}
		onYChanged: lbVisual.requestPaint()
		property int x: Math.min(Math.max(screen.width * Config.style.TopBar.sideMarginPrc, midBar.xStart - (midBar.visualWidth * Config.style.TopBar.periphSizePrc)), midBar.xStart)
		onXChanged: lbVisual.requestPaint()
		
		implicitWidth: midBar.xStart + borderWidth
		implicitHeight: Config.style.TopBar.panelHeightPx
		property real slant: Math.min(visualWidth / 3, Config.style.TopBar.panelSlantPx)
		onSlantChanged: lbVisual.requestPaint()
		
		property real visualWidth: midBar.xStart - leftBar.x
		onVisualWidthChanged: lbVisual.requestPaint()
		property real visualHeight: height
		onVisualHeightChanged: lbVisual.requestPaint()
		
		exclusionMode: ExclusionMode.Ignore
		property real borderWidth: Math.max(0, Math.min(visualHeight / 3, Config.style.TopBar.borderWidth))
		onBorderWidthChanged: lbVisual.requestPaint()
		
		color: "transparent"
		Item {
			id: lbColors
			
			property color background: root._hextorgba(Config.colors.Special.background, Config.style.Global.backgroundOpacity)
			ColorAnim on background {}
			onBackgroundChanged: lbVisual.requestPaint()
			
			property color border: Config.colors.Special.border
			ColorAnim on border {}
			onBorderChanged: lbVisual.requestPaint()
			
			property color baseForeground: Config.colors.Special.foreground
			ColorAnim on baseForeground {}
			onBaseForegroundChanged: lbVisual.requestPaint()
		}
		
		property bool active: false
		property bool visible: true
		
		Timer {
			interval: 1000
			running: true 
			repeat: true
			onTriggered: {
				leftBar.active = true
			}
		}
		
		Canvas {
			id: lbVisual
			
			anchors.fill: parent
			
			onPaint: {
				var ctx = getContext("2d");
				ctx.reset();
				
				if (leftBar.visible) {
					ctx.moveTo(leftBar.x, leftBar.y);
					ctx.lineTo(leftBar.x + leftBar.slant, leftBar.y + leftBar.visualHeight);
					ctx.lineTo(leftBar.x + leftBar.visualWidth, leftBar.y + leftBar.visualHeight);
					ctx.lineTo(leftBar.x + leftBar.visualWidth - leftBar.slant, leftBar.y);
					ctx.closePath();
					
					ctx.fillStyle = lbColors.background;
					ctx.fill();
					
					if (leftBar.borderWidth > 0) {
						ctx.strokeStyle = lbColors.border
						ctx.lineWidth = leftBar.borderWidth
						ctx.stroke();
					}
				}
			}
		}
	}

	PanelWindow {
		id: rightBar
		screen: root.screen
		
		anchors {
			top: true
			right: true
		}
		
		margins.top: -1
		
		property int y: active ? -borderWidth / 2 : -height - (borderWidth / 2)
		EaseAnim on y {}
		onYChanged: rbVisual.requestPaint()
		property int x: 0
		
		implicitWidth: screen.width - midBar.xEnd + borderWidth
		implicitHeight: Config.style.TopBar.panelHeightPx
		property real slant: Math.min(visualWidth / 3, Config.style.TopBar.panelSlantPx)
		onSlantChanged: rbVisual.requestPaint()
		
		property real visualWidth: Math.max(0, Math.min(midBar.visualWidth * Config.style.TopBar.periphSizePrc, Math.max(width - (screen.width * Config.style.TopBar.sideMarginPrc))))
		onVisualWidthChanged: rbVisual.requestPaint()
		property real visualHeight: height
		onVisualHeightChanged: rbVisual.requestPaint()
		
		exclusionMode: ExclusionMode.Ignore
		property real borderWidth: Math.max(0, Math.min(visualHeight / 3, Config.style.TopBar.borderWidth))
		onBorderWidthChanged: rbVisual.requestPaint()
		
		color: "transparent"
		
		Item {
			id: rbColors
			
			property color background: root._hextorgba(Config.colors.Special.background, Config.style.Global.backgroundOpacity)
			ColorAnim on background {}
			onBackgroundChanged: rbVisual.requestPaint()
			
			property color border: Config.colors.Special.border
			ColorAnim on border {}
			onBorderChanged: rbVisual.requestPaint()
			
			property color baseForeground: Config.colors.Special.foreground
			ColorAnim on baseForeground {}
			onBaseForegroundChanged: rbVisual.requestPaint()
		}
		
		property bool active: false
		property bool visible: true
		
		Timer {
			interval: 1000
			running: true 
			repeat: true
			onTriggered: {
				rightBar.active = true
			}
		}
		
		Canvas {
			id: rbVisual
			
			anchors.fill: parent
			
			onPaint: {
				var ctx = getContext("2d");
				ctx.reset();
				
				if (rightBar.visible) {
					ctx.moveTo(rightBar.borderWidth + rightBar.x + rightBar.slant, rightBar.y);
					ctx.lineTo(rightBar.borderWidth + rightBar.x, rightBar.y + rightBar.visualHeight);
					ctx.lineTo(rightBar.x + rightBar.visualWidth - rightBar.slant, rightBar.y + rightBar.visualHeight);
					ctx.lineTo(rightBar.x + rightBar.visualWidth, rightBar.y);
					ctx.closePath();
					
					ctx.fillStyle = rbColors.background;
					ctx.fill();
					
					if (rightBar.borderWidth > 0) {
						ctx.strokeStyle = rbColors.border;
						ctx.lineWidth = rightBar.borderWidth
						ctx.stroke();
					}
				}
			}
		}
	}
}
