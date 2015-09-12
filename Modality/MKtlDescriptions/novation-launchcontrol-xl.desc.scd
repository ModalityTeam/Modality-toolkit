// user: channel 0
// factory: channel 8

(
deviceName: "Launch Control XL",
protocol: \midi,
deviceType: \mixer,
elementTypes: [\fader, \button, \knob],
status: "unknown",

idInfo: "Launch Control XL",

hardwarePages: (
	factory: [1,2,3,4,5,6,7,8],
	user: [1,2,3,4,5,6,7,8]
),

deviceInfo: (
	// vendorURI: "http://global.novationmusic.com/launch/launch-control-xl",
	// manualURI: "http://global.novationmusic.com/support/product-downloads?product=Launch+Control+XL",
	description: "A faderbox emulating the interface of a mixing desk",
	features: [
		"24 rotary pots, each with 300 degree motion and 2-colour LED",
		"8 Faders (60mm)",
		"16 multi-colour backlit buttons",
		"8 backlit buttons",
		"8 “user”-pages + 8 “factory”-pages",
	],
	// notes: "",
	// hasScribble: false
),
description:
[

'knSndA' -> 16.collect {|chan| (13..20).collect{|num|
          ('midiMsgType': 'cc',        'type': 'knob',   'midiChan': chan, 'midiNum':  num, 'spec': 'midiCC', \ioType: \inout, \page: chan)
}},

'knSndB' -> 16.collect {|chan| (29..36).collect{|num|
          ('midiMsgType': 'cc',        'type': 'knob',   'midiChan': chan, 'midiNum':  num, 'spec': 'midiCC', \ioType: \inout, \page: chan)
}},

'knPan' ->  16.collect {|chan| (49..56).collect{|num|
          ('midiMsgType': 'cc',        'type': 'knob',   'midiChan': chan, 'midiNum':  num, 'spec': 'midiCC', \ioType: \inout, \page: chan)
}},

\sl ->  16.collect {|chan| (77..84).collect{|num|
		('midiMsgType': 'cc',        'type': 'slider', 'midiChan': chan, 'midiNum':  num, 'spec': 'midiCC', \ioType: \inout, \page: chan, \style: ( height: 4 ))
}},

'btFcs' -> 16.collect {|chan| ((41..44) ++ (57..60)).collect{|num|
          ('midiMsgType': 'noteOnOff', 'type': 'button', 'midiChan': chan, 'midiNum':  num,'spec': 'midiNote', \ioType: \inout, \page: chan)
}},

'btCtl' -> 16.collect {|chan| ((73..76) ++ (89..92)).collect{|num|
          ('midiMsgType': 'noteOnOff', 'type': 'button', 'midiChan': chan, 'midiNum':  num,'spec': 'midiNote', \ioType: \inout, \page: chan)
}},

'device' -> 16.collect {|chan|
		('midiMsgType': 'noteOnOff', 'type': 'button', 'midiChan': chan, 'midiNum':  105,'spec': 'midiNote', \ioType: \inout, \page: chan, \style: (row: 3, column: 8.5, showLabel: true))
},
'mute' ->  16.collect {|chan|
	      ('midiMsgType': 'noteOnOff', 'type': 'button', 'midiChan': chan, 'midiNum':  106,'spec': 'midiNote', \ioType: \inout, \page: chan, \style: (row: 4, column: 8.5, showLabel: true))
},
'solo' ->  16.collect {|chan|
	      ('midiMsgType': 'noteOnOff', 'type': 'button', 'midiChan': chan, 'midiNum':  107,'spec': 'midiNote', \ioType: \inout, \page: chan, \style: (row: 5, column: 8.5, showLabel: true))
},
'arm' ->   16.collect {|chan|
	      ('midiMsgType': 'noteOnOff', 'type': 'button', 'midiChan': chan, 'midiNum':  108,'spec': 'midiNote', \ioType: \inout, \page: chan, \style: (row: 6, column: 8.5, showLabel: true))
},

\up ->     16.collect {|chan|
	      ('midiMsgType': 'cc',        'type': 'button', 'midiChan': chan, 'midiNum':  104, 'spec': 'midiCC', \ioType: \inout, \page: chan, \style: (row: 1, column: 8, showLabel: true))
},
\down ->   16.collect {|chan|
	      ('midiMsgType': 'cc',        'type': 'button', 'midiChan': chan, 'midiNum':  105, 'spec': 'midiCC', \ioType: \inout, \page: chan, \style: (row: 1, column: 9, showLabel: true))
},
\left ->   16.collect {|chan|
	      ('midiMsgType': 'cc',        'type': 'button', 'midiChan': chan, 'midiNum':  106, 'spec': 'midiCC', \ioType: \inout, \page: chan, \style: (row: 2, column: 8, showLabel: true))
},
\right ->   16.collect {|chan|
	      ('midiMsgType': 'cc',        'type': 'button', 'midiChan': chan, 'midiNum':  107, 'spec': 'midiCC', \ioType: \inout, \page: chan, \style: (row: 2, column: 9, showLabel: true))
},
]);

