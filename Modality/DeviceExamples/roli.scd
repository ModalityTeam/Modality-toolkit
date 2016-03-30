// first example of support for a roli keyboard:


/*
this raises a good question for mktl!
like the qunexus, the roli keyboard uses
expression polyphony as suggested by Roli:
n midi channels get used dynamically
every new key starts on the next channel,
pitchbend, polytouch and cc (?) on that channel
gets routed to the process of that note.

this requires making responders that are
* channel-agnostic or match to an array of channels
* note-agnostic (MKtlElements for channel only)
* and have several values - note, amp, bend
Q:
how to modalize these without creating hundreds of
useless elements?

// the following example works with current SC3
// and requires just one extension:
Quarks.install("JITLibExtensions");

// boot server, connect midi
s.reboot; s.scope; s.latency = nil;
MIDIIn.connectAll;

*/



// then run all of this at once:
(
// make an NPVoicer object for the polyphony
q = q ? ();
q.roli = NPVoicer(Ndef(\roli));
// tell it to play to audio outputs
q.roli.play;

// make a simple synthdef for each note
SynthDef(\roli01, {
	|out, freq = (60.midicps), amp = 0.25, pan, gate = 1,
	press = 1, bend = 0, ffreq = 1000, reso = 3|

	var freq2 = freq * bend.midiratio;
	var snd = RLPF.ar(
		Saw.ar(freq2.lag(0.1)),
		ffreq, 1/reso);
	var env = EnvGen.ar(Env.adsr(0.001, 0.3, 0.5, 0.3), gate);
	Out.ar(out, Pan2.ar(
		snd * env, pan,
		amp.lag(0.01, 0.2)));
}).add;

// tell the voicer to use the synthdef above
q.roli.prime(\roli01);


// // to use your own synth instead, just do
// SynthDef(\myRoli, {
// 	... your synthesis here ...
// }).add;
// q.roli.prime(\myRoli);

/*
// tests for the synthdef
x = (instrument: \roli01, dur: inf).play;
x.set(\press, 4);
x.set(\ffreq, 5000, \reso, 10);
x.set(\reso, 10);
x.set(\bend, -12);
x.release
*/

// the four functions needed for on, off, bend, touch
q.makeNote = { |q, chan, note = 60, vel = 64|
	q.roli.put(chan, [\freq, note.midicps, \amp, (vel/127) ** 2 ]);
};
q.endNote = { |q, chan|
	var obj = q.roli.proxy.objects[chan];
	if (obj.notNil) { obj.set(\gate, 0) };
};

q.setTouch = { |q, chan=0, touchval = 64|
	var obj = q.roli.proxy.objects[chan];
	if (obj.notNil) { obj.set(\amp, (touchval/127).squared) };
};
q.setBend = { |q, chan=0, bendval = 0|
	var obj = q.roli.proxy.objects[chan];
	if (obj.notNil) { obj.set(\bend,
		bendval.linlin(0, 16383, -12, 12)) };
};


/* /// test the functions by hand
q.makeNote(0, 72, 64);
q.endNote(0);
q.makeNote(0, 72, 64);
q.setTouch(0, 96);
q.setBend(0, 8192 * (1 + (-2/12)));
q.setBend(0, 8192 * (1 + (2/12)));
q.setBend(0, 8192 * (1 + (0/12)));

q.makeNote(1, 60, 96);
q.setBend(1, 8192 * (1 + (3/12)));
*/

// four MIDIdefs to listen to midi in
// for on, off, bend, touch messages

MIDIdef.noteOn(\roliOn, { |vel, noteNum, chan|
	"noteOn: % % %\n".postf(noteNum, vel, chan);
	q.makeNote(chan, noteNum, vel);
}).enable;

MIDIdef.noteOff(\roliOff, { |noteNum, vel, chan|
	"noteOff: % % %\n".postf(noteNum, vel, chan);
	q.endNote(chan, noteNum);
}).enable;

MIDIdef.polytouch(\roliTouch, { |touch, noteNum, chan|
	"touch: % %\n".postf(touch, chan);
	q.setTouch(chan, touch);
});
MIDIdef.bend(\roliBend, { |bend, chan|
	"bend: % %\n".postf(bend, chan);
	q.setBend(chan, bend);
});
);

