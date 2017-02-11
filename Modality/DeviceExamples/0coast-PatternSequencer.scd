MKtl(\nocoast, "makenoise-0coast");
MKtl(\nocoast).openDeviceVia("USB MIDI Device", true, 1);


// test
MKtl(\nocoast).elAt(\key, 50, \on).deviceValue_(127);

MKtl(\nocoast).elAt(\key, 50, \off).deviceValue_(0);

MKtl(\nocoast).elAt(\key, 55, \on).deviceValue_(127);
MKtl(\nocoast).elAt(\key, 55, \off).deviceValue_(0);



// turn off arpeggiator
MKtl(\nocoast).elAt(\ctl, \arpeggiator).deviceValue_(0)


MKtl(\nocoast).elAt(\key, 55, \on).deviceValue_(127);
MKtl(\nocoast).elAt(\key, 55, \off).deviceValue_(0);


// portamento?
MKtl(\nocoast).elAt(\ctl, \portamento).deviceValue_(1)




(
MKtl(\nocoast).elAt(\ctl, \chanA).deviceValue_(0);
MKtl(\nocoast).elAt(\ctl, \cvA).deviceValue_(0);
MKtl(\nocoast).elAt(\ctl, \gateA).deviceValue_(0);

// make midiB independant gate/cv:
MKtl(\nocoast).elAt(\ctl, \chanB).deviceValue_(1);
MKtl(\nocoast).elAt(\ctl, \cvB).deviceValue_(0);
MKtl(\nocoast).elAt(\ctl, \gateB).deviceValue_(0);



)

MKtl(\nocoast).elAt(\ctl, \gateB).deviceValue_(4);


// midiA
(\type: \midi, 	\midiout: MKtl(\nocoast).device.midiOut, \chan: 0, \midinote: rrand(50, 100), \dur: 0.1).play


// midiB
(\type: \midi, 	\midiout: MKtl(\nocoast).device.midiOut, \chan: 1, \midinote: rrand(10, 40), \dur: 0.1).play



////// just a pattern...
Pdef(\player).set(\mydur, 0.125);
(
Pdef(\player).quant = 4;
Pdef(\player, Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, MKtl(\nocoast).device.midiOut,
	\chan, MKtl(\nocoast).elAt(\key).elemDesc.midiChan,
	\ctranspose, 2,
	\note, Pslide([0, 2, 3, 5]-3, inf, 3, 1, 0),
	\octave, Pseq([3], inf),
	\dur, Pkey(\mydur),
	\sustain, {~dur/4}
))
)
Pdef(\player).play
Pdef(\player).stop

Pdef(\player).gui


/// just another pattern on midiB
(
Pdef(\playerB).quant = [4, 1];
Pdef(\playerB, Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, MKtl(\nocoast).device.midiOut,
	\chan, 1,
	// \degree, Pseq([0, 4, 4, 12], inf),
	\degree, Pseq((0!16) ++ (1!16), inf),
	// \octave, Pseq([2, 4] * [1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2], inf),
	\octave, Pseq([2, 44], inf) * Pseq([1, 1, 0, 1], inf),
	\dur, Pfunc({2 * Pdef(\player).get(\mydur)}),
	\sustain, Pkey(\dur) * Pseq([Pseries(0.01, 0.01, 32)], inf),
)).play
)

Pdef(\playerB).gui

