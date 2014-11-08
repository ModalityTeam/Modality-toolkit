// for Manta controller made by Jeff Snyder,
// control names as they come from libmanta
// based USB2OSC bridge unixCmd program.
/*
q = q ? ();
q.manta = ();
q.manta.path = "/Users/adc/scgit/libmanta/MantaOSC/build/";
q.manta.binaryName = "MantaOSC";
q.manta.run = { |d| (d.path +/+ d.binaryName).runInTerminal; };

q.manta.run;

q.manta.mktl = MKtl(\manta, "manta");

q.manta.mktl;
q.manta.mktl.mktlDevice;

q.manta.oscFuncs = (
	\padVel: OSCFunc({ |msg| msg.postln; }, '/manta/velocity/pad'),
	\padCon: OSCFunc({ |msg| msg.postln; }, '/manta/continuous/pad'),
	\btVel: OSCFunc({ |msg| msg.postln; }, '/manta/velocity/button'),
	\btCon: OSCFunc({ |msg| msg.postln; }, '/manta/continuous/button'),
	\slCon: OSCFunc({ |msg| msg.postln; }, '/manta/continuous/slider')
);

q.manta.oscFuncs.padVel.prFunc = { |msg|
	q.manta.mktl.elementAt(\pad, \vel, msg[1]).valueAction_(msg[2] / 200);
};
q.manta.oscFuncs.padCon.prFunc = { |msg|
	q.manta.mktl.elementAt(\pad, \con, msg[1]).valueAction_(msg[2] / 200);
};

Ndef(\test, { |freq = 300| SinOsc.ar(freq) }).play;

q.manta.mktl.elementAt(\pad, \con, 0).action = { |el|
[el.name, el.value].postln;
Ndef(\test).setUni(\freq, el.value);
};

*/



MKtl.addSpec(\mantaPad, [0, 200]);
MKtl.addSpec(\mantaPad, [10, 4086]);

(
device: "manta",
protocol: \osc,
description: (
	'pad': (
		vel: (0..47).collect { |i|
			i -> (
				msgName: '/manta/velocity/pad',
				num: i, 'type': 'pad', spec: \mantaPad
		) },
		'con': (0..47).collect { |i|
			i -> (
				msgName: '/manta/continuous/pad',
				num: i, 'type': 'pad', spec: \mantaPad
		) }
	),
	'bt': (
		vel: (0..3).collect { |i|
			i -> (
				msgName: '/manta/velocity/button',
				num: i, 'type': 'pad', spec: \mantaPad
		) },
		'con': (0..3).collect { |i|
			i -> (
				msgName: '/manta/continuous/button',
				num: i, 'type': 'pad', spec: \mantaPad
		) },

		'sl': (0..1).collect { |i|
			i -> (
				msgName: '/manta/continuous/slider',
				num: i, 'type': 'slider', spec: \mantaPad
		) }
	)
)
)
