/**** Faderfox UC4 desc file for custom setup with CCah (14bit, absolute) for the encoders

// General Info:

This desc file addresses a custom Setup that can be loaded into an arbitrary Setup on the UC4 via the accompanying SySex file

UC4_CCAh_individualChannels_2025-11-06.syx

located in the UC4 desc folder.

To load the setting onto your controller you need a sysex dump software like
 Bome ‘Send SX’ for Windows (http://www.bome.com/products/sendsx) or
 Snoize ‘SysEx Librarian‘ for Mac (http://www.snoize.com/SysExLibrarian/).


on the UC4

1. go into setup mode (shift + 2x grey button)
2. select the Setup into which you want to save the Setup configuration (for me: SE10)
3. press encoder 7 until running bar lines turn into `rc00` to start listening to sysex dump

on your computer

1. start SysEx Librarian (on mac)
2. select Faderfox UC4 as the Destination
3. open the syx file
4. press `play`

on the UC4

1. you should see `rc00` followed by SE.. (for me SE10) after successful upload
2. exit Setup mode by pressing grey button
3. wiggle knobs and be happy :)


This desc file has the pages in the top layer:

slpg1 [\sl, \bt][column] or [\xfade]
...
slpg8 [\sl, \bt][column] or [\xfade]

knpg1 [\kn, \pbt][index]
...
knpg8 [\kn, \pbt][index]

// see example and explanation here:
"Tutorials/Hardware_paging".openHelpFile;


// basic example to get you started:

MKtlDesc.loadDescs; k.free; k = MKtl('uc4', "faderfox-uc4_pg_CCAh"); k.gui;

k.trace; // trace incoming messages
k.trace(false); // trace incoming messages

k.elementsDict.size; // how many elements are there in total
k.postElements; // see all elements

k.elAt.action = { |el| [el.name, el.value.round(0.001), el.deviceValue].postcs }; // display all elements
k.elAt.action = nil; // stop posting

// access individual elements
k.elAt(\pgKn1, \kn, 0).action = { |el| "individual knob: ".post; [el.name, el.deviceValue].postln };
k.elAt(\pgKn1, \kn, 0).value; // get value
k.elAt(\pgKn1, \kn, 0).value = 0.5; // set value


k.elAt(\pgKn1, \pbt, 0).action = { |el| "individual knob press: ".post; [el.name, el.deviceValue].postln };
k.elAt(\pgKn1, \pbt, 0).isOn; // get state
k.elAt(\pgSl1, \xfader).action = { |el| "xfade ".post; [el.name, el.deviceValue].postln };
k.elAt(\pgSl1, \bt, 0, 0).isOn;

****/

(
parentDesc: "faderfox-uc4",

status: (
	linux: "unknown",
	osx: "tested and working. 2025-11-06, LFSaw",
	win: "unknown"
),

elementsDesc: (
	shared: (ioType: \inout),

	// the 8 pages for the knobs and the knob hat switches,
	// then the 8 pages for sliders and buttons,
	// then the xfader

	elements: 8.collect {|gr_i|
		var midiChan = gr_i; // midi channel equals group index
		// 8 groups of knobs(8 + (0..7));
		(
			key: ("pgKn" ++ (gr_i + 1)).asSymbol,

			elements:
			[
				(
					key: \kn,
					shared: (
						'midiChan': midiChan,
						'midiMsgType': \cc14,
						'spec': 'midiCC14',
						'elementType': 'knob'
					),
					elements: 8.collect { |i|
						(
							midiNum: 8 + i,
							\style: ( \row: i div: 4 * 1.5,
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
					shared: ('midiChan': midiChan, 'elementType': 'pad',
						groupType: \noteOnOffBut,
						\page: gr_i, 'spec': 'midiBut'),
					// 0-7
					elements: (0..7).collect { |num, i|
						(
							// key: nil,
							midiNum: num,

							style: (\row: i div: 4 * 1.5 + 0.8,
								\column: i % 4 * 2 + 0.5,
								height: 0.8,
								// label: "pbt_" ++ (i + 1),
								showLabel: true
							)
						)
					}
				)
			]
		)

	}

	++ 8.collect { |gr_i|
		var midiChan = gr_i; // midi channel equals group index

		var slNum1 = 32;
		var btNum1 = 64;
		var slElems = (
			key: \sl,
			shared: ('midiChan': midiChan, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
			elements: 8.collect { |i|
				(
					midiNum: slNum1 + i,
					\style: ( \row: 3, \column: i, height: 2),
					\page: gr_i
				)
			}
		);

		var btElems = (
			key: \bt,
			shared: ('midiChan': midiChan, 'elementType': 'pad', \page: gr_i, groupType: \noteOnOffBut, 'spec': 'midiBut'),
			// 0-7
			elements: 8.collect { |i|
				(
					key: nil, midiNum: (btNum1 + i),
					// label: ("bt_" ++ (i + 1)),
					style: ( \row: 6, \column: i, height: 1)
				)
			};
		);

		var xfader = (
			'key': 'xfader',
			'midiNum':  112,
			'midiMsgType': 'cc',
			'elementType': 'slider',
			'spec': 'midiCC',
			'midiChan': midiChan,
			\style: ( \row: 5, \column: 2.5, height: 1, width: 3),
			\page: gr_i
		);


		(
			key: ("pgSl" ++ (gr_i + 1)).asSymbol,
			elements: [ slElems, btElems, xfader];
		)
	}
)
);
