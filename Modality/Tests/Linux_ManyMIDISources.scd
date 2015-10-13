MIDIClient.init;

MIDIClient.prSetSources([
    MIDIEndPoint("System", "Timer", 0),
    MIDIEndPoint("System", "Announce", 1),
    MIDIEndPoint("Midi Through", "Midi Through Port-0", 917504),
    MIDIEndPoint("nanoKONTROL", "nanoKONTROL MIDI 1", 1310720),
    MIDIEndPoint("BCR2000", "BCR2000 MIDI 1", 1572864),
    MIDIEndPoint("BCR2000", "BCR2000 MIDI 2", 1572865),
    MIDIEndPoint("SuperCollider", "out0", 8388614),
    MIDIEndPoint("SuperCollider", "out1", 8388615),
    MIDIEndPoint("SuperCollider", "out2", 8388616),
    MIDIEndPoint("SuperCollider", "out3", 8388617),
    MIDIEndPoint("SuperCollider", "out4", 8388618)
]).prSetDestinations([
    MIDIEndPoint("Midi Through", "Midi Through Port-0", 917504),
    MIDIEndPoint("nanoKONTROL", "nanoKONTROL MIDI 1", 1310720),
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

MKtl.find(\midi);

MKtlLookup.midiAll.sortedKeysValuesDo { |key, val|
	key.postln;
	val.postcs;
	"---\n".postln;
};"";

MKtlLookup.all.sortedKeysValuesDo { |key, val|
	key.postln;
	val.postcs;
	"---\n".postln;
};"";


MKtl(\x, "korg-nanokontrol");
MKtl(\br1, "behringer-bcr2000");

