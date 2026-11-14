import Quickshell
import QtQuick
import "mod"
import "mod/bars"
import "mod/lock"
import "mod/drun"
import "mod/proc"

ShellRoot {
	id: root
	
	Variants {
		id: screenVariants
		model: Quickshell.screens
		
		delegate: TopBar {
			id: topBar
			property var modelData
			screen: modelData
			
			Launcher {
				parentBar: topBar
			}
		}
	}
}
