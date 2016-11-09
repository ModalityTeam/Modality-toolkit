/**** Faderfox UC4 desc file

// General Info:

This desc file only addresses Setup 01,
and does not have faders and knobs in every group!

This is because the default cc numbers of encoder group 4 and fader group 1 overlap,
-> so encoder group 4 was moved to 0-7;
and fader groups 5-8 all use the same ccnum range (104-111).
This can be fixed by reprogramming these groups in the device.

this desc file has the pages in the top layer:
\xfader
slpg1 [\sl, \bt][column]
...
slpg8 [\sl, \bt][column]

knpg1 [\kn, \pbt][index]
...
knpg8 [\kn, \pbt][index]

// see example and explanation here:
"Tutorials/Hardware_paging".openHelpFile;

MKtlDesc.loadDescs("*uc4_pg");
m.free; m = MKtl(\uc4, "*uc4_pg"); m.trace.gui;

****/

(
parentDesc: "faderfox-uc4",

status: (
	linux: "unknown",
	osx: "tested and working. 2016-04-10, adc",
	win: "unknown"),

elementsDesc: (
	shared: ('midiChan': 0, ioType: \inout),

	// the 8 pages for the knobs and the knob hat switches,
	// then the 8 pages for sliders and buttons,
	// then the xfader

	elements: [8, 16, 24, 0, 72, 80, 88, 96].collect { |knum1, gr_i|

		// 8 groups of knobs[8, 16, 24, 32, 72, 80, 88, 96].collect(_ + (0..7));
		// as group 4 - 32-39 overlaps with a fader group,
		// it is overwritten as 0..7, which needs reprogramming on the device
		(
			key: ("pgKn" ++ (gr_i + 1)).asSymbol,

			elements:
			[
				(
					key: \kn,
					shared: ('midiMsgType': 'cc', 'elementType': 'knob', 'spec': 'midiCC'),
					elements: 8.collect { |i|
						(
							midiNum: knum1 + i,
							\style: ( \row: i div: 4 * 2,
								\column: i % 4 * 2 + 0.5,
								showLabel: true
							),
							\page: gr_i
						)
					}
				),
				// note-buttons
				(
					key: \pbt,
					shared: ('elementType': 'pad', groupType: \noteOnOffBut,
						\page: gr_i, 'spec': 'midiBut'),
					// 0-7, 8-15 ... 56-63
					elements: ((0..7) + (gr_i * 8)).collect { |num, i|
						(
							key: nil, midiNum: num,
							shared:	(
								style: (\row: i div: 4 * 2 + 0.8,
									\column: i % 4 * 2 + 0.5,
									height: 0.8,
									showLabel: true))
						)
					}
				)
			]
		)
	}

	++ 8.collect { |gr_i|

		// 	// WE ONLY MAKE 5 SLIDER GROUPS, because only the first 5 are really different
		// 	// of these 8 groups: [32, 40, 48, 56,  104, 104, 104, 104].collect(_ + (0..7));
		// 	// 6-8 are same as 5 -> fix in custom groups if needed, or in hardware setup

		var slNum1 = [32, 40, 48, 56, 104, 104, 104, 104][gr_i];
		var btNum1 = (64, 72..120);
		var slElems = (
			key: \sl,
			shared: ('midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
			elements: 8.collect { |i|
				(
					midiNum: slNum1 + i,
					\style: ( \row: 4, \column: i, height: 2),
					\page: gr_i
				)
			}
		);

		var btElems = (
			key: \bt,
			shared: ('elementType': 'pad', \page: gr_i, groupType: \noteOnOffBut, 'spec': 'midiBut'),
			// 0-7, 8-15 ... 56-63
			elements: 8.collect { |i|
				(
					key: nil, midiNum: (btNum1[gr_i] + i),
					shared:	(
						style: ( \row: 7, \column: i, height: 0.8)
					)
				)
			};
		);

			// only put sliders in first 5 pages
		(
			key: ("pgSl" ++ (gr_i + 1)).asSymbol,
			elements: if (gr_i < 5) { [ slElems, btElems] } { [ btElems ] };
		)
	}
	++
	[
		( key: 'xfader', 'midiNum':  112, 'midiMsgType': 'cc',
			'elementType': 'slider', 'spec': 'midiCC',
			\style: ( \row: 6, \column: 2.5, height: 1, width: 3)
	)]

)
);
