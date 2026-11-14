pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: config
	
	readonly property string homeDir: Quickshell.env("HOME")
	readonly property string configDir: Quickshell.env("QIWI_CONFIG") || (Quickshell.env("XDG_CONFIG_HOME") || (homeDir + "/.config")) + "/qiwi"
	
	property var dat: ({})
	property var inc: []
	
	FileView {
		path: config.configDir + "/include"
		preload: true
		watchChanges: true
		onLoaded: config._include(text() || "")
		onFileChanged: reload()
		printErrors: false
	}
	
	Instantiator {
		id: confInst
		model: !config.inc || config.inc.length === 0 ? ["config.json"] : config.inc
		
		delegate: FileView {
			path: config.configDir + "/" + modelData
			preload: true
			watchChanges: true
			onLoaded: config._parse(text() || "")
			onFileChanged: reload()
			printErrors: false
		}
	}
	
	function _include(raw) {
		if (!raw) return
		try { config.inc = raw.split(/\r?\n/).filter(Boolean) } catch (e) {}
	}
	
	function _parse(raw) {
		if (!raw) return
		try { config.dat = Object.assign({}, config.dat, JSON.parse(raw)) } catch (e) {}
	}
	
	function _clamp(val, min, max) {
		return Math.max(min, Math.min(max, val))
	}
	
	readonly property var colors: {
		"Base16": {
			"black": config.dat.Colors?.Base16?.black ?? "black",
			"red": config.dat.Colors?.Base16?.red ?? "red",
			"green": config.dat.Colors?.Base16?.green ?? "green",
			"yellow": config.dat.Colors?.Base16?.yellow ?? "yellow",
			"blue": config.dat.Colors?.Base16?.blue ?? "blue",
			"magenta": config.dat.Colors?.Base16?.magenta ?? "magenta",
			"cyan": config.dat.Colors?.Base16?.cyan ?? "cyan",
			"white": config.dat.Colors?.Base16?.white ?? "white",
			
			"gray": config.dat.Colors?.Base16?.gray ?? "gray",
			"brightRed": config.dat.Colors?.Base16?.brightRed ?? "red",
			"brightGreen": config.dat.Colors?.Base16?.brightGreen ?? "green",
			"brightYellow": config.dat.Colors?.Base16?.brightYellow ?? "yellow",
			"brightBlue": config.dat.Colors?.Base16?.brightBlue ?? "blue",
			"brightMagenta": config.dat.Colors?.Base16?.brightMagenta ?? "magenta",
			"brightCyan": config.dat.Colors?.Base16?.brightCyan ?? "cyan",
			"brightWhite": config.dat.Colors?.Base16?.brightWhite ?? "white"
		},
		
		"Special": {
			"background": config.dat.Colors?.Special?.background ?? "#000000",
			"foreground": config.dat.Colors?.Special?.foreground ?? "white",
			"cursor": config.dat.Colors?.Special?.cursor ?? "white",
			"border": config.dat.Colors?.Special?.border ?? "white"
		}
	}
	
	readonly property var style: {
		"Global": {
			"fontFamily": config.dat.Style?.Global?.fontFamily ?? "terminus",
			"backgroundOpacity": config._clamp(config.dat.Style?.Global?.backgroundOpacity, 0, 1) ?? 1
		},
		
		"TopBar": {
			"borderWidth": config.dat.Style?.Global?.borderWidth ?? 2,
			"animationSlowdown": Math.max(0, config.dat.Style?.TopBar?.animationSlowdown) ?? 1,
			"periphSizePrc": Math.max(0, config.dat.Style?.TopBar?.periphSizePrc) ?? 0.5,
			"midSizePrc": config._clamp(config.dat.Style?.TopBar?.midSizePrc, 0, 1) ?? 0.25,
			"sideMarginPrc": config._clamp(config.dat.Style?.TopBar?.sideMarginPrc, 0, 1) ?? 0,
			"panelHeightPx": config.dat.Style?.TopBar?.panelHeightPx ?? 42,
			"panelSlantPx": config.dat.Style?.TopBar?.panelSlantPx ?? 36,
			"exclusiveZoneBool": Boolean(config.dat.Style?.TopBar?.exclusiveZoneBool) ?? false
		}
	}
}
