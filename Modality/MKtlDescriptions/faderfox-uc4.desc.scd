/**** Faderfox UC4 desc file. adc 2015_12_24 (merry xmas)

// General Info:

The UC4 is a compact, ultraflexible general purpose MIDI controller.
It has 9 sliders, 8 knobs with 8 pushbuttons and 8 normal buttons;
by switching between 8 groups one has 264 controls in one setup,
and 16 presets of 8 groups each allow very flexible uses.

This desc file only addresses Setup 01 setup,
and does not have faders and knobs in every group!

This is because the default cc numbers of encoder group 4 and fader group 1 overlap,
and fader groups 5-8 all use the same ccnum range (104-111).
This can be fixed by reprogramming these groups in the device.


// Basic examples:

MKtlDesc.loadDescs; k.free; k = MKtl('uc4', "faderfox-uc4"); k.gui;
k.elementsDict.size;
k.postElements

k.elAt.action = { |el| [el.name, el.value.round(0.001), el.deviceValue].postcs };

k.elAt(\kn).action = { |el| "knob: ".post; [el.name, el.deviceValue].postln };
k.elAt(\xfader).action = { |el| "xfade ".post; [el.name, el.deviceValue].postln };
k.elAt(\bt, 0, 0).isOn;

****/

(
deviceName: "Faderfox UC4",
protocol: 'midi',
deviceType: 'faderbox',
elementTypes: [ \slider, \knob, \button, \pushbutton ],
status: (
	linux: "unknown",
	osx: "tested and working. 2016-03-16, adc",
	win: "unknown"),

idInfo: "Faderfox UC4",

hardwarePages: (1..8),

deviceInfo: (
	vendorURI: "http://faderfox.de/uc4.html",
	manualURI: "http://www.faderfox.de/PDF/UC4%20Manual%20V01.PDF",
	description: "",
	features: [
		"Universal controller for all kinds of midi controllable hard- and software",
		"Very compact design in a black casing with metal faceplate"

		"8 push encoders without detents (resolution about 36 pulses)",
		"9 faders with 30mm length and programmable snap function",
		"8 Buttons with LED for switchable parameters",
		"4-digit-display to show control values and programming data",
		"All controls (incl. push buttons) fully programmable in the device by channel, type, number",

		"8 independent groups for encoders and faders/buttons",
		"About 264 commands per setup (33 controls x  8 groups)",
		"18 setups with backup/restore function contain all controller settings",

		"absolute and relative controller modes are available",
		"14 bit high resolution encoder mode for sensitive parameters",
		"Programmable value ranges with min/max values",
		"Data feedback for encoders and faders avoid value jumps",
		"MIDI in and out ports with routing and merge functionality"
	],
	notes: "",
	hasScribble: false
),


elementsDesc: (
	shared: (ioType: \inout),

	elements: [
		// ------ cc -------------
		(
			key: \kn,
			shared: ('midiChan': 0, 'midiMsgType': 'cc', 'elementType': 'knob', 'spec': 'midiCC'),
			// these 8 groups are available: [8, 16, 24, 32, 72, 80, 88, 96].collect(_ + (0..7));
			// as group 4 - 32-39 overlaps with a fader group,
			// it is overwritten as 0..7, which needs reprogramming on the device
			elements: [8, 16, 24, 0, 72, 80, 88, 96].collect { |num1, gr_i|
				( elements: 8.collect { |i|
					(
						midiNum: num1 + i,
						\style: ( \row: i div: 4 * 2, \column: i % 4 * 2 + 0.5),
						\page: gr_i
					)
				} )
			}
		),
		// note-buttons
		(
			key: \pbt,
			shared: ('midiChan': 0, 'elementType': 'button', 'spec': 'midiCC'),
			elements: (0..63).clump(8).collect { |list, gr_i|
				(
					elements: list.collect { |num, i|
						(
							shared:  (midiNum: num, page: gr_i),
							elements: [
								(
									key: \on, 'midiMsgType':  'noteOn',
									\style: ( \row: i div: 4 * 2 + 1, \column: i % 4 * 2 + 0.5, height: 0.5)
								),
								(
									key: \off, 'midiMsgType': 'noteOff',
									\style: ( \row: i div: 4 * 2 + 1.4, \column: i % 4 * 2 + 0.5, height: 0.5)
								)
							]
						)
					}
				)
			}
		),
		(
			key: \sl,
			shared: ('midiChan': 0, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
			// these 8 groups are available: [32, 40, 48, 56,  104, 104, 104, 104].collect(_ + (0..7));
			// only make the first 5 groups are really different,
			// 6-8 are same as 5 -> fix in custom groups if needed
			elements: [32, 40, 48, 56, 104].collect { |num1, gr_i|
				( elements: 8.collect { |i|
					(
						midiNum: num1 + i,
						\style: ( \row: 4, \column: i, height: 2),
						\page: gr_i

				) } )
			}
		),
		( key: 'xfader', 'midiNum':  112, 'midiChan': 0, 'midiMsgType': 'cc',
			'elementType': 'slider', 'spec': 'midiCC',
			\style: ( \row: 6, \column: 2.5, height: 1, width: 3)
		),
		(
			key: \bt,
			shared: ('midiChan': 0, 'elementType': 'button', 'spec': 'midiCC'),
			elements: (64..127).clump(8).collect { |list, gr_i|
				(
					elements: list.collect { |num, i|
						(
							shared:  (midiNum: num, page: gr_i),
							elements: [
								(key: \on, 'midiMsgType':  'noteOn',
									\style: ( \row: 7, \column: i, height: 0.5)
								),
								(key: \off, 'midiMsgType': 'noteOff',
									\style: ( \row: 7.4, \column: i, height: 0.5)
								)
							]
						)
					}
				)
			}
		)
	]
)
);

