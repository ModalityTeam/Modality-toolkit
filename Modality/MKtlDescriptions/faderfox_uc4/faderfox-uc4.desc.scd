/**** Faderfox UC4 desc file.

// General Info:

The UC4 is a compact, ultraflexible general purpose MIDI controller.
It has 9 sliders, 8 knobs with 8 pushbuttons and 8 normal buttons;
by switching between 8 groups one has 264 controls in one setup,
and 16 presets of 8 groups each allow very flexible uses.

The knobs are relative with a resolution of about 35 updates per revolution.

This desc file only addresses Setup 01 setup,
and does not have faders and knobs in every group!

It has this element order - faderfox_uc4:
\sl [slpage][column]
\bt [slpage][column]
// and on a different page
\kn [knpage][index],
\pbt [knpage][index]
\xfader


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
parentDesc: "faderfox-uc4",

status: (
	linux: "unknown",
	osx: "tested and working. 2016-03-16, adc",
	win: "unknown"),

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
						\style: ( \row: i div: 4 * 2,
							\column: i % 4 * 2 + 0.5,
							showLabel: true
						),
						\page: gr_i
					)
				} )
			}
		),
		// note-buttons
		(
			key: \pbt,
			shared: ('midiChan': 0, 'elementType': 'pad', 'spec': 'midiCC'),
			elements: (0..63).clump(8).collect { |list, gr_i|
				(
					elements: list.collect { |num, i|
						(
							groupType: \noteOnOffBut,
							shared:  (midiNum: num, page: gr_i, groupType: \noteOnOffBut,
								style: ( \row: i div: 4 * 2 + 1, \column: i % 4 * 2 + 0.5,
									height: 0.75)
							)
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
			shared: ('midiChan': 0, 'elementType': 'pad', 'spec': 'midiCC'),
			elements: (64..127).clump(8).collect { |list, gr_i|
				(
					elements: list.collect { |num, i|
						(
							groupType: \noteOnOffBut,
							shared:  (midiNum: num, page: gr_i, groupType: \noteOnOffBut,
								\style: ( \row: 7, \column: i, height: 0.75)
							)
						)
					}
				)
			}
		)
	]
)
);

