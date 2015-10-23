// user: channel 0
// factory: channel 8

/**** to do:
check  overlap of midiNum with device/down, mute/left,
****/

(
deviceName: "Launch Control XL",
protocol: \midi,
deviceType: \mixer,
elementTypes: [\fader, \button, \knob],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

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
elementsDesc: (

	elements: [
		(
			key: 'knSndA',
			shared: ('midiMsgType': 'cc', 'type': 'knob',
				'spec': 'midiCC', \ioType: \inout),
			elements: 16.collect { |chan|
				(
					elements: (13..20).collect { |num|
						('midiChan': chan, 'midiNum':  num, \page: chan)
				})
		}),
		(
			key: 'knSndB',
			shared: ('midiMsgType': 'cc', 'type': 'knob',
				'spec': 'midiCC', \ioType: \inout),
			elements: 16.collect { |chan|
				(
					elements: (29..36).collect { |num|
						('midiChan': chan, 'midiNum':  num, \page: chan)
				})
		}),
		(
			key: 'knPan',
			shared: ('midiMsgType': 'cc', 'type': 'knob',
				'spec': 'midiCC', \ioType: \inout),
			elements: 16.collect { |chan|
				(
					elements: (49..56).collect { |num|
						('midiChan': chan, 'midiNum':  num, \page: chan)
				})
		}),
		(
			key: 'sl',
			shared: ('midiMsgType': 'cc', 'type': 'slider',
				'spec': 'midiCC', \ioType: \inout),
			elements: 16.collect { |chan|
				(
					elements: (49..56).collect { |num|
						('midiChan': chan, 'midiNum':  num,
							\page: chan, \style: ( height: 4 ))
				})
		}),
		(
			key: 'btFcs',
			shared: ('midiMsgType': 'cc', 'type': 'button',
				'spec': 'midiBut', \ioType: \inout),
			elements: 16.collect { |chan|
				(
					elements: ((41..44) ++ (57..60)).collect { |num|
						('midiChan': chan, 'midiNum':  num,
							\page: chan)
				})
		}),
		(
			key: 'btCtl',
			shared: ('midiMsgType': 'cc', 'type': 'button',
				'spec': 'midiBut', \ioType: \inout),
			elements: 16.collect { |chan|
				(
					elements: ((73..76) ++ (89..92)).collect { |num|
						('midiChan': chan, 'midiNum':  num,
							\page: chan)
				})
		}),

		// single buttons 16 pages
		(
			key: 'device',
			shared: ('midiMsgType': 'noteOnOff', 'type': 'button',
				'midiNum':  105,'spec': 'midiNote', \ioType: \inout,
				\style: (row: 3, column: 8.5, showLabel: true)),
			elements: 16.collect { |chan| ('midiChan': chan, \page: chan) }
		),
		(
			key: 'mute',
			shared: ('midiMsgType': 'noteOnOff', 'type': 'button',
				'midiNum':  106,'spec': 'midiNote', \ioType: \inout,
				\style: (row: 4, column: 8.5, showLabel: true)),
			elements: 16.collect { |chan| ('midiChan': chan, \page: chan) }
		),
		(
			key: 'solo',
			shared: ('midiMsgType': 'noteOnOff', 'type': 'button',
				'midiNum':  107,'spec': 'midiNote', \ioType: \inout,
				\style: (row: 5, column: 8.5, showLabel: true)),
			elements: 16.collect { |chan| ('midiChan': chan, \page: chan) }
		),
		(
			key: 'arm',
			shared: ('midiMsgType': 'noteOnOff', 'type': 'button',
				'midiNum':  108,'spec': 'midiNote', \ioType: \inout,
				\style: (row: 6, column: 8.5, showLabel: true)),
			elements: 16.collect { |chan| ('midiChan': chan, \page: chan) }
		),


		(
			key: 'up',
			shared: ('midiMsgType': 'noteOnOff', 'type': 'button',
				'midiNum':  104,'spec': 'midiNote', \ioType: \inout,
				\style: (row: 1, column: 8, showLabel: true)),
			elements: 16.collect { |chan| ('midiChan': chan, \page: chan) }
		),
		(
			key: 'down',
			shared: ('midiMsgType': 'noteOnOff', 'type': 'button',
				'midiNum':  105,'spec': 'midiNote', \ioType: \inout,
				\style: (row: 1, column: 9, showLabel: true)),
			elements: 16.collect { |chan| ('midiChan': chan, \page: chan) }
		),

		(
			key: 'left',
			shared: ('midiMsgType': 'noteOnOff', 'type': 'button',
				'midiNum':  106,'spec': 'midiNote', \ioType: \inout,
				\style: (row: 2, column: 8, showLabel: true)),
			elements: 16.collect { |chan| ('midiChan': chan, \page: chan) }
		),
		(
			key: 'right',
			shared: ('midiMsgType': 'noteOnOff', 'type': 'button',
				'midiNum':  107,'spec': 'midiNote', \ioType: \inout,
				\style: (row: 2, column: 9, showLabel: true)),
			elements: 16.collect { |chan| ('midiChan': chan, \page: chan) }
		),
	]
)
);

