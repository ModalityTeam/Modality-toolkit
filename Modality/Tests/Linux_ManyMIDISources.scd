// test whether lots of midi ins and outs are sorted correctly.
// example is from linux, where apps auto-register midi IO.

// give MIDIClient fake sources and destinations:
MIDIClient.prSetSources([
    MIDIEndPoint("System", "Timer", 0),
    MIDIEndPoint("System", "Announce", 1),
    MIDIEndPoint("Midi Through", "Midi Through Port-0", 917504),
    MIDIEndPoint("nanoKONTROL", "nanoKONTROL MIDI 1", 1310720),
    MIDIEndPoint("nanoKONTROL2", "nanoKONTROL2 MIDI 1", 1310721),
    MIDIEndPoint("nanoKONTROL2", "nanoKONTROL2 MIDI 1", 1310722),
    MIDIEndPoint("BCR2000", "BCR2000 MIDI 1", 1572864),
    MIDIEndPoint("BCR2000", "BCR2000 MIDI 2", 1572865),
    MIDIEndPoint("SuperCollider", "out0", 8388614),
    MIDIEndPoint("SuperCollider", "out1", 8388615),
    MIDIEndPoint("SuperCollider", "out2", 8388616),
    MIDIEndPoint("SuperCollider", "out3", 8388617),
    MIDIEndPoint("SuperCollider", "out4", 8388618)
]).prSetDestinations([
    MIDIEndPoint("Midi Through", "Midi Through Port-0", 917504),
    MIDIEndPoint("nanoKONTROL", "nanoKONTROL MIDI 1", 2310720),
    MIDIEndPoint("nanoKONTROL2", "nanoKONTROL2 MIDI 1", 2310721),
    MIDIEndPoint("nanoKONTROL2", "nanoKONTROL2 MIDI 1", 2310722),
    MIDIEndPoint("BCR2000", "BCR2000 MIDI 1", 1572864),
    MIDIEndPoint("BCR2000", "BCR2000 MIDI 2", 1572865),
    MIDIEndPoint("BCR2000", "BCR2000 MIDI 3", 1572866),
    MIDIEndPoint("SuperCollider", "in0", 8388608),
    MIDIEndPoint("SuperCollider", "in1", 8388609),
    MIDIEndPoint("SuperCollider", "in2", 8388610),
    MIDIEndPoint("SuperCollider", "in3", 8388611),
    MIDIEndPoint("SuperCollider", "in4", 8388612),
    MIDIEndPoint("SuperCollider", "in5", 8388613)
]);

// have MKtlLookup organize them
MKtlLookup.addAllMIDI;
MKtlLookup.midiAll.size;

// this is what we have now:
MKtlLookup.midiAll.sortedKeysValuesDo { |key, val|
	key.postcs;
	val.postcs;
	"---\n".postln;
};"";

// do we find the in and out of the single nanokontrol?
MKtl(\x, "korg-nanokontrol");
MKtl(\x).desc.openTestCode;

// do we find two nk2s, and get asked to provide a multiIndex?
MKtl(\nk2, "korg-nanokontrol2");

// if so, take the first one
MKtl(\nk2, "korg-nanokontrol2", multiIndex: 0);
MKtl(\x).desc.openTestCode;

// do we find the matching ports 1 of the bcr2000 ?
MKtl(\br1, "behringer-bcr2000");
MKtl(\br1).device.midiOut.dump; // looks ok, have to test with device

// open SC IO at 0 as MKtl with no elements:
MKtl(\sc0, 'midi_4_supercollider', multiIndex: 0);

