// for Manta controller made by Jeff Snyder,
// control names as they come from libmanta
// based USB2OSC bridge unixCmd program.
/*
OSCMKtl.find; // can't detect any active ones ...
OSCMktl('gyrosc', "gyrosc");
OSCExplorer
OSCMktlDevice.new;
*/

MKtl.addSpec(\mantaPad, [0, 200]);
MKtl.addSpec(\mantaPad, [10, 4086]);

(
device: "manta",
protocol: \osc,
description: (
	'pad': (
		vel: (0..47).collect { |i|
			(
				msgName: '/manta/velocity/pad',
				num: i, 'type': 'pad', spec: \mantaPad
		) },
		'con': (0..47).collect { |i|
			(
				msgName: '/manta/continuous/pad',
				num: i, 'type': 'pad', spec: \mantaPad
		) }
	),
	'bt': (
		vel: (0..3).collect { |i|
			(
				msgName: '/manta/velocity/button',
				num: i, 'type': 'pad', spec: \mantaPad
		) },
		'con': (0..3).collect { |i|
			(
				msgName: '/manta/continuous/button',
				num: i, 'type': 'pad', spec: \mantaPad
		) },

		'sl': (1..2).collect { |i|
			(
				msgName: '/manta/continuous/slider',
				num: i, 'type': 'slider', spec: \mantaPad
		) }
	)
)
)
