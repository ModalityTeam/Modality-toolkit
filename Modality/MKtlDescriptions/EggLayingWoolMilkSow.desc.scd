// EggLayingWoolMilkSow

// for testing, create an MKtlDesc of a MIDI device
// that listens to every possible MIDI message.
// when this works and passes all tests, MIDI is in great shape.

/*
MIDIMKtlDevice.allMsgTypes.postcs;

... put test patch here with MIDISim sending to all elements

*/

// Proposal for  serialisable notation:
// use KeyValueArray format to keep order,
// and use event-like expansion notation:
// [midiChan: 1] // single value for all elements
// [midiChan: [0, 3] // list of values
// [ midiNum: [\range, 36, 96] ]; // continuous range of values
// [ midiNum: [12, 24, [\range, 36, 96], 108 ] // nestable, will be flattened
// can be converted as needed when reading file.

(
	idInfo: "\EggLayingWoolMilkSow",
	name: \EggLayingWoolMilkSow,
	protocol: \midi,
	description: [

		// with midinum - 127 per channel
		non: [midiMsgType: \noteOn, midiChan: [\range, 0, 9], midiNum: [\range, 36, 96]],
		noff: [midiMsgType: \noteOff, midiChan: [\range, 0, 9], midiNum: [\range, 36, 96]],

		// composed onoff, and polyTouch goes with it
		nonoff: [midiMsgType: \noteOnOff, midiChan: 15, midiNum: [\range, 24, 60]],
		polyTouch: [midiMsgType: \control, midiChan: 15, midiNum: [\range, 24, 60]],

		cc: [midiMsgType: \control, midiChan: 0, midiNum: [5, 8, [\range, 13, 21], 42] ],

		// 1 per channel
			// touch
		touch: [midiMsgType: \touch, midiChan: [\range, 0, 9]],
		bend: [midiMsgType: \bend, midiChan: [\range, 8, 15]],
		program: [midiMsgType: \bend, midiChan: 0]
		// add more here when integrated: \\
		// ...
	]
);