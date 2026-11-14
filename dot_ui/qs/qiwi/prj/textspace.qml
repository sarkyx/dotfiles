		Rectangle {
			id: textSpace

			x: midBar.slant

			property int fontSize: midBar.height / 2
			width: midBar.width - ( midBar.slant * 2 ) - ( fontSize * 0.6 )
			height: midBar.height

			color: "transparent"

			TextField {
				id: textField

				ContextMenu.menu: null

				anchors.fill: parent
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter

				background: Rectangle {
					color: "transparent"
				}

				color: midBar.loConf.col.fg
				font.family: midBar.loConf.stl.fnt
				font.pixelSize: parent.fontSize
				selectionColor: midBar.loConf.col.cr
				selectedTextColor: midBar.loConf.col.bg

				cursorDelegate: Rectangle {
					id: cursor

					visible: parent.activeFocus
					width: parent.font.pixelSize * 0.6
					height: parent.font.pixelSize * 1.3
					color: midBar.loConf.col.cr

					readonly property string charAtCursor: parent.text.charAt(parent.cursorPosition)

					Text {
						text: cursor.charAtCursor
						font.family: textField.font.family
						font.pixelSize: textField.font.pixelSize
						color: midBar.loConf.col.bg
						anchors.fill: parent
					}
				}
			}
		}

		mask: Region {
			item: textSpace
		}
