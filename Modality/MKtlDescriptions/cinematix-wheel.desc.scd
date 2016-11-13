/*
CinematixWheel has a special midi scheme, which this desc file shows how to use.

It has 16 rotating wheels, with possible 1023 position values.
The encoding is in midi noteOn messages:
the 7 bits of velocity are the crude wheel position value,
the first 3 bits of note number are extra precision of value,
and the last 4 bits of note number are the wheel index.

// test as MKtl
c = MKtl(\cin, "cinematix-wheel");

MKtlDesc.loadDescs.size;
MKtlDesc.writeCache;
g = c.trace.gui;
c.elAt.action = { |el| "action! %, %, %\n".postf(el.source, el.name.cs, el.value.round(0.001)) };

c.elAt(0).deviceValueAction_(1023);
10.do { c.elAt(16.rand).deviceValueAction_(1024.rand); };

// the coding given in modality issues #177 seems to be :
// 7 bits of value are crude wheel position value,
// first 3 bits of note are extra precision,
// last 4 bits of note are wheel index.
(
MIDIdef.noteOn( \cinWheel, { |val, note|
	var wheelIndex, value;
	wheelIndex = note mod: 16;
	value = val << 3 + (note >> 4);
	(wheel: wheelIndex, value: value).postln;
	c.elAt(wheelIndex).deviceValueAction_(value);
});
);

MIDIClient.init;
// test that coding is correct:

// access wheels, last 4 bits of note
MIDIIn.noteOn.value(0, 0, 0, 0); // action: '1', 0
MIDIIn.noteOn.value(0, 0, 1, 0); // action: '2', 0
MIDIIn.noteOn.value(0, 0, 15, 0); // action: '16', 0

// higher 3 bits of note go to low bits of value
MIDIIn.noteOn.value(0, 0, 16, 0); // action: '1', 0.001
// wheel 4, value 2
MIDIIn.noteOn.value(0, 0, 32 + 4, 0); // action: '5', 0.002
MIDIIn.noteOn.value(0, 0, 112 + 15, 16); // action: '16', 0.132

// velocity sets higher bits of value
MIDIIn.noteOn.value(0, 0, 0, 1);
MIDIIn.noteOn.value(0, 0, 32, 64);
MIDIIn.noteOn.value(0, 0, 127, 127);
MIDIIn.noteOn.value(0, 0, 15, 64);

// wheel is 0-15, val = 0 - 1023
~fakeCinIn = { |wheel, val|
	var note = (val % 8 * 16) + wheel;
	var velval = val div: 8;
	MIDIIn.noteOn.value(nil, nil, note, velval);
	(note: note, vel: velval).postln;
};

~fakeCinIn.(0, 1016);
~fakeCinIn.(0, 512);
~fakeCinIn.(4, 512);

~fakeCinIn.(*[16.rand, 1023.rand].postln);
*/

(
	idInfo: "CinematixWheel",
	protocol: \virtual,
	specs: ('lin11bit': [0, 1024, \lin, 1]),
	elementsDesc: (
		shared: (elementType: \slider, spec: 'lin11bit'),
		elements: (1..16).collect { |num| (key: num.asSymbol) }
	),
);
