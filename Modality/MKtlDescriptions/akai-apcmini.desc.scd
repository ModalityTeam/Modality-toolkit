/*

	/* todo:
	* proper indexing of 8x8 pads,
	* labels for buttons:
	- up, down left right buttons,
	- fader ctrl: volume, pan, send, device
	- sceneLaunch: ...
	- gui layout of all of them
	*/

a = MKtl('apc1', "akai-apcmini");
a.gui;
a.elementAt(\sl).action_({ |elem| [elem.name, elem.value].postln; });
a.elementAt(\keyOn).action_({ |elem| [\ON, elem.name, elem.value].postln; });
a.elementAt(\keyOff).action_({ |elem| [\OFF, elem.name, elem.value].postln; });
*/
(
deviceName: "APC MINI",
protocol: 'midi',
deviceType: \launchpad,
elementTypes: [\fader, \pad, \button],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: "APC MINI",

deviceInfo: (
	vendorURI: "http://www.akaipro.com/product/apc-mini",
	manualURI: "http://6be54c364949b623a3c0-4409a68c214f3a9eeca8d0265e9266c0.r0.cf2.rackcdn.com/990/documents/APC%20mini%20-%20User%20Guide%20-%20v1.0.pdf",
	// description: "",
	features: [
		"64 buttons with tri-lighting",
		"9 faders",
		"17 buttons",
	],

	// notes: "",
	// hasScribble: false
),
elementsDesc: (

	elements: [
		(
			key: \pad,
			shared: (midiMsgType: 'noteOnOff', elementType: 'pad',
				midiChan: 0, spec: 'midiNote', ioType: \inout),
			elements: (0..63).collect { |midiNote| (midiNum: midiNote)  }
		),
		(
			key: \navBut,
			shared: (midiMsgType: 'noteOnOff', elementType: 'button',
				midiChan: 0, spec: 'midiBut', ioType: \inout),
			elements: (64..67).collect { |midiNote| (midiNum: midiNote)  }
		),
		(
			key: \ctrlBut,
			shared: (midiMsgType: 'noteOnOff', elementType: 'button',
				midiChan: 0, spec: 'midiBut', ioType: \inout),
			elements: (68..71).collect { |midiNote| (midiNum: midiNote)  }
		),
		(
			key: \launchBut,
			shared: (midiMsgType: 'noteOnOff', elementType: 'button',
				midiChan: 0, spec: 'midiBut', ioType: \inout),
			elements: (82..89).collect { |midiNote| (midiNum: midiNote)  }
		),
		(
			key: \shift,
			midiMsgType: 'noteOnOff', elementType: 'button',
			midiChan: 0, midiNum:  98, spec: 'midiBut', ioType: \inout
		),
		(
			key: \sl,
			shared: (midiMsgType: 'cc', elementType: 'slider',
				midiChan: 0, spec: 'midiBut', ioType: \in),
			elements: (48..56).collect { |midinote|
				(midiNum: midinote, spec: 'midiCC', ioType: \in)
			}
		)
	]
)
)
