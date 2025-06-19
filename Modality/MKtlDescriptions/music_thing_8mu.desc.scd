/***

Example:
k = MKtl('8mu', "*music_thing*");
k.elementAt(\sl, 0).action = { \yo.postln; };
k.elementAt(\sl, 1).action = { 1.postcs; };


****/

(
deviceName: "Music Thing 8mu",
protocol: 'midi',
deviceType: \faderbox,
elementTypes: [\fader, \knob, \button],
status: (
	linux: "tested by bgola 15.02.2024",
	osx: "unknown",
	win: "unknown"),

idInfo: "Music Thing m0 Plus",

deviceInfo: (
	vendorURI: 'https://www.musicthing.co.uk/8mu_page/',
	manualURI: 'https://www.musicthing.co.uk/8mu.html',
	description: "8mu is a pocket-sized MIDI controller, slightly smaller than a credit card.",
),
elementsDesc: (
	elements: [
		// Buttons
		(
			key: \bt,
			shared: (midiChan: 0, groupType: \noteOnOffBut, elementType: 'button', midiNum: 1, spec: \midiBut),
			elements: 4.collect { |buttonIdx|
				(
					midiNum:  36 + (buttonIdx*12),
					style: (\row: 0, \column: buttonIdx, \height: 1)
				)
			}
		),
		// sliders
		(
			key: \sl,
			shared: (midiChan: 0, elementType: \slider, midiMsgType: \cc, spec: \midiCC),
			elements: 8.collect { |sliderIdx|
				(
					midiNum:  34 + sliderIdx,
					style: (row: 1, column: sliderIdx, showLabel: true)
				)
			}
		),

		// Acc
		(
			key: \acc,
			shared: ('midiChan': 0, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
			elements: [
				( key: \front_up, 'midiNum':  42, style: (column: 0, showLabel: true)),
				( key: \back_up, 'midiNum':  43, style: (column: 1, showLabel: true)),
				( key: \right_up, 'midiNum':  44, style: (column: 2, showLabel: true)),
				( key: \left_up, 'midiNum':  45, style: (column: 3, showLabel: true)),
				( key: \cw, 'midiNum':  46, style: (column: 4, showLabel: true)),
				( key: \ccw, 'midiNum':  47, style: (column: 5, showLabel: true)),
				( key: \upside_down, 'midiNum':  48, style: (column: 6, showLabel: true)),
				( key: \upside_up, 'midiNum':  49, style: (column: 7, showLabel: true)),
			]
		),
	]
)
);
