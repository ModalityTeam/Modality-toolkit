/*
a = MKtl('pcmn0');

a.elementAt(\sl).action_({ |elem| [elem.name, elem.value].postln; });
a.elementAt(\keyOn).action_({ |elem| [\ON, elem.name, elem.value].postln; });
a.elementAt(\keyOff).action_({ |elem| [\OFF, elem.name, elem.value].postln; });
*/
(
idInfo: "APC MINI",
protocol: 'midi',
deviceType: [\launchpad],

deviceInfo: (
	vendorURI: "http://www.akaipro.com/product/apc-mini",
	manualURI: "http://6be54c364949b623a3c0-4409a68c214f3a9eeca8d0265e9266c0.r0.cf2.rackcdn.com/990/documents/APC%20mini%20-%20User%20Guide%20-%20v1.0.pdf",
	// description: "",
	features: [
		"64 buttons with tri-lighting",
		"9 faders",
		"17 buttons",
	],
	elementTypes: [\fader, \pad, \button],
	// notes: "",
	// hasScribble: false
),
description: (

	'keyOn': [(0..63),(64..71),(82..89),[98]].collect { |xs| xs.collect({ |midinote|  ('midiMsgType': 'noteOn', 'type': 'key', 'midiChan': 0, 'midiNum':  midinote, 'spec': 'midiNote', 'ioType': \inout) }) },

	'keyOff': [(0..63),(64..71),(82..89),[98]].collect { |xs| xs.collect({ |midinote|  ('midiMsgType': 'noteOff', 'type': 'key', 'midiChan': 0, 'midiNum':  midinote, 'spec': 'midiNote', 'ioType': \inout) }) },

\sl: (48..56).collect { |midinote|  ('midiMsgType': 'cc', 'type': 'slider', 'midiChan': 0, 'midiNum':  midinote, 'spec': 'midiCC') }

)
)

