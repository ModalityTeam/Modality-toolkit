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

// try adding a custom group:
var grp = MKtlElementGroup( 'padBot8', q.manta.mktl.elementAt( \pad, \vel, (0..7)) );


q.manta.mktl.addCustomGroup('padBot8', grp);

q.manta.mktl

*/




(
initialisationMessages: [
	[ "/manta/ledcontrol", "padandbutton", 1 ],
	[ "/manta/ledcontrol", "slider", 1 ],
	[ "/manta/ledcontrol", "button", 1 ]
],
specs: (
	mantaTouch: [ 0, 227 ].asSpec, // this seems to be the spec, looking at the github source code
	mantaSlider: [ 0, 4095 ].asSpec, // slider sends values between 0 and 4095, releasing the slider sends 65536
	mantaLed: ItemsSpec.new( ["off","amber","red"] ), // led can be off, amber or red
),
infoURL: "https://github.com/ssfrr/libmanta",
infoMessage: "Please start the MantaOSC program, if it is not already started",
idInfo: ( srcPort: 31417, ipAddress: "127.0.0.1", recvPort: 31416 ), // sends/receives on the same port, so we do not need to define destPort separately
protocol: \osc,
description: (
	pad: (0..47).collect{ |id|
		(
			con: (
				oscPath: '/manta/continuous/pad',
				argTemplate: [ id ],
				type: 'pad',
				spec: 'mantaTouch',
				ioType: \in
			),
			vel: (
				oscPath: '/manta/velocity/pad',
				argTemplate: [ id ],
				type: 'pad',
				spec: 'mantaTouch',
				ioType: \in
			),
			led: (
				oscPath: '/manta/led/pad',
				argTemplate: [ nil, id ],
				type: 'led',
				spec: 'mantaLed',
				ioType: \out
			);
		);
	},
	bt: (0..3).collect{ |id|
		(
			con: (
				oscPath: '/manta/continuous/button',
				argTemplate: [ id ],
				type: 'pad',
				spec: 'mantaTouch',
				ioType: \in
			),
			vel: (
				oscPath: '/manta/velocity/button',
				argTemplate: [ id ],
				type: 'pad',
				spec: 'mantaTouch',
				ioType: \in
			),
			led: (
				oscPath: '/manta/led/button',
				argTemplate: [ nil, id ],
				type: 'led',
				spec: 'mantaLed',
				ioType: \out
			);

		)
	},
	sl: (0..1).collect{ |id|
		(
			con: (
				oscPath: '/manta/continuous/slider',
				argTemplate: [ id ],
				type: 'slider',
				spec: 'mantaSlider',
				ioType: \in
			),
			led: (0..7).collect{ |jd| // this need a fix still!
				(
					oscPath: '/manta/led/slider',
					argTemplate: [ nil, id, jd ],
					type: 'led',
					spec: 'mantaLed',
					ioType: \out
				);
			}
		)
	};
)
);

/*
old version:

MKtl.addSpec(\mantaPad, [0, 200]);
MKtl.addSpec(\mantaPad, [10, 4086]);

(
idInfo: "manta",
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
		) }
	),

	'sl': (0..1).collect { |i|
		i -> (
			msgName: '/manta/continuous/slider',
			num: i, 'type': 'slider', spec: \mantaPad
	) }
)
)
*/