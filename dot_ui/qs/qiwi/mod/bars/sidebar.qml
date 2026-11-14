import QuickShell
import QtQuick
import ".."
import "../proc"

Scope {
	id: root

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
		id: leftBar

		anchors.left: true

		property int y: 0
		property int x: active ? -borderWidth / 2 : -width - (borderWidth / 2)
		EaseAnim on x {}
		onXChanged: leftBarVisual.requestPaint()

		implicitWidth: Config.style.SideBar.panelWidthPx
		implicitHeight: 
		property real slant: Math.min(visualHeight / 3, Config.style.SideBar.panelSlantPx)
		onSlantChanged: leftBarVisual.requestPaint()

		property real visualWidth: width
		onVisualWidthChanged: leftBarVisual.requestPaint()
		property real visualHeight: height - borderWidth
		onVisualHeightChanged: leftBarVisual.requestPaint()

		exclusiveZone: ExclusionMode.Ignore
		property real borderWidth: Math.max(0, Math.min(visualWidth / 3, Config.style.SideBar.borderWidth))
		onBorderWidthChanged: midBarVisual.requestPaint()

		color: "transparent"


		Item {
			id: leftBarColors

			property color background: root._hextorgba(Config.colors.Special.background, Config.style.Global.backgroundOpacity)
			ColorAnim on background {}
			onBackgroundChanged: leftBarVisual.requestPaint()

			property color border: Config.colors.Special.border
			ColorAnim on border {}
			onBorderChanged: leftBarVisual.requestPaint()

			property color baseForeground: Config.colors.Special.foreground
			ColorAnim on baseForeground {}
			onBaseForegroundChanged: leftBarVisual.requestPaint()
		}

		property bool active: false
		property bool visible: true

		Canvas: {
			id: leftBarVisual

			anchors.fill: parent

			onPaint: {
				var ctx = getContext("2d");
				ctx.reset();

				if (leftBar.visible) {

				}
			}
		}
	}
}
