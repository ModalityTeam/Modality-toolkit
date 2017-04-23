/****

Note: button LEDs are controlled by sending noteOn message with the same midi number, with velocity 127 to turn on and velocity 0 to turn off.

Test code:

MKtl('mm',"akai-midimix");

MKtl('mm').gui

//turn button on
MKtl('mm').elementGroup[\bt][0][0].value_(127)

//turn button off
MKtl('mm').elementGroup[\bt][0][0].value_(0)



Please adapt this file as follows:

1. Put any general info and comments about the device here.

2. Add some minimal code examples for testing, such as:

k = MKtl('nk2', "korg-nanokontrol2");
k.elementAt(sl, 0).action = { yo.postln; };
k.elementAt(sl, 1).action = { 1.postcs; };

3. When there are only a few elements, one can keep them in a flat dictionary, and give them clear element names; see
'Reference/Naming_conventions_in_element_descriptions'.openHelpFile

4. When many elements of the same type are listed in an obvious order,
   such as 8 sliders sending cc numbers,
   or 88 piano keys sending noteOn and noteOff,
   it makes sense to organize them into Arrays.
'Reference/MKtl_description_files'.openHelpFile

Instructions will be continued when canonical format is been finalized.
More information can be found here:
'Tutorials/How_to_create_a_description_file'.openHelpFile;
'Tutorials/How_to_create_a_description_file_for_MIDI'.openHelpFile;


****/
var makeBut = { |key, shared, style|
	(key: key,
		shared: shared,
		elements: [
			(
				key: \on, midiMsgType: \noteOn,
				style: style.copy.put(\height, 0.6)
			),
			(
				key: \off, midiMsgType: \noteOff,
				style: style.copy.put(\height, 0.6)
				.put(\row, style.row + 0.45)
			)
		]
	)
};
(
deviceName: "MIDI Mix",
protocol: 'midi',
deviceType: 'mixer',
elementTypes: [\knob, \slider, \pad],
status: (
	linux: "tested and working, 2017-03-20, Miguel Negrão",
	osx: "unknown",
	win: "unknown"),

idInfo: "MIDI Mix",

// deviceInfo: (
// vendorURI: 'http://company.com/products/this',
// manualURI: 'http://company.com/products/this/manual.pdf',
	// description: ,
	// features: [],
	// notes: ,
	// hasScribble: false
// ),

elementsDesc: (
	 elements: [

		(
			key: \kn,
			shared: (midiChan: 0, 'midiMsgType': 'control', 'type': 'knob', 'spec': 'midiCC', \ioType: \in),
			elements: [
				( elements: [16, 20, 24, 28, 46, 50, 54, 58]
					.collect{ |n,i| (midiNum: n, \style: (row:0, column: i)) }
				),
				( elements: [17, 21, 25, 29, 47, 51, 55, 59]
					.collect{ |n,i| (midiNum: n, \style: (row:1, column: i)) }
				),
				( elements: [18, 22, 26, 30, 48, 52, 56, 60]
					.collect{ |n,i| (midiNum: n, \style: (row:2, column: i)) }
				),
			]
		),

		(
			key: \sl,
			shared: (midiChan: 0, 'midiMsgType': 'cc', 'type': 'slider', 'spec': 'midiCC', \ioType: \in),
			elements: [19, 23, 27, 31, 49, 53, 57, 61, 62]
					.collect{ |n,i| (midiNum: n, \style: (row:5, column: i)) }
		),

		(
			key: \bt,
			shared: ('midiChan': 0, 'elementType': 'pad', 'spec': 'midiBut', \ioType: \inout),
			elements: [
				( elements: [1,4,7,10,13,16,19,22]
					.collect{ |midiNote,i|
						MKtlDesc.notePair(
							(i+1).asSymbol, midiNote,
							style: (
								row: 3,
								column: i,
								showLabel: true
							)
						)
					}
				),
				( elements: [3,6,9,12,15,18,21,24]
					.collect{ |midiNote,i|
						MKtlDesc.notePair(
							(i+1).asSymbol, midiNote,
							style: (
								row: 4,
								column: i,
								showLabel: true
							)
						)
					}
				)
			]
		),

		makeBut.(
			\bankLeft,
			('midiChan': 0, 'elementType': 'pad', 'spec': 'midiBut', \ioType: \inout, 'midiNum': 25),
			(row: 1, column: 8, showLabel: true)
		),

		makeBut.(
			\bankRight,
			('midiChan': 0, 'elementType': 'pad', 'spec': 'midiBut', \ioType: \inout, 'midiNum': 26),
			(row: 2, column: 8, showLabel: true)
		),

		makeBut.(
			\solo,
			('midiChan': 0, 'elementType': 'pad', 'spec': 'midiBut', \ioType: \inout, 'midiNum': 27),
			(row: 3, column: 8, showLabel: true)
		),


	]
)

);

