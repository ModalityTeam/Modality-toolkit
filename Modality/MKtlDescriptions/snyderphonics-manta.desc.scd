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
q.manta.desc = MKtlDesc("*manta*");

MKtl(\manta, q.manta.desc);
MKtl(\manta).trace(true);

// changing
MKtl(\manta).mktlDevice.source;
MKtl(\manta).mktlDevice.updateSrcAddr("1.2.3.4", 56789);
MKtl(\manta).mktlDevice.source;
// -> disconnected now!

// reconnect:
MKtl(\manta).mktlDevice.updateSrcAddr("127.0.0.1", 31417);
MKtl(\manta).mktlDevice.source;

// same with dest
MKtl(\manta).mktlDevice.updateDestAddr(port: 1234, hostname: "5.6.7.8");
MKtl(\manta).mktlDevice.destination;

/// test with dumb sound
s.boot;
Ndef(\test, { |freq = 300| Saw.ar(freq) }).play(vol: 0.1);

// single pad action - bottom left
MKtl(\manta).trace(false);
MKtl(\manta).elementAt(\pad, 0, \con).action = { |el|
	[el.name, el.value, el.deviceValue].postln;
	Ndef(\test).set(\freq, el.value.linexp(0, 1, 20, 2000));
};

// all pads, all pad controls
MKtl(\manta).elementAt(\pad).action = { |el| [el.name, el.value.round(0.001)].postln };

///////// old, not yet working again :
// make a custom group ... how to add it as a collective?
q.manta.padBot8 = MKtlElementGroup( 'padBot8',
	MKtl(\manta).elementAt( \pad, (0..7)).collect(_.at(\vel))
);
q.manta.padBot8.elements[0].dump

s.quit;
*/

(
deviceName: \manta,
idInfo: ( srcPort: 31417, ipAddress: "127.0.0.1", recvPort: 57120 ),
protocol: \osc,
deviceType: \manta,

specialMessages: (
	enableLEDControl: [
		[ "/manta/ledcontrol", "padandbutton", 1 ],
		[ "/manta/ledcontrol", "slider", 1 ],
		[ "/manta/ledcontrol", "button", 1 ]
]),

specs: (
	mantaTouch: [ 0, 227 ].asSpec, // this seems to be the spec, looking at the github source code
	mantaSlider: [ 0, 4095 ].asSpec, // slider sends values between 0 and 4095, releasing the slider sends 65536
	mantaLed: ItemsSpec.new( ["off","amber","red"] ), // led can be off, amber or red
),
deviceInfo: (
	vendorURI: "http://www.snyderphonics.com/products.htm",
	manualURI: "http://www.snyderphonics.com/documentation.htm",
	// description: "",
	features: [
		"48 touch sensors in a 6 X 8 hexagonal array - each sensor can independently send both continuous control data and note-on/off events with velocity sensitivity simultaneously",
		"2 assignable touch sliders",
		"4 assignable touch-sensing function buttons with LED feedback",
		"68 user-controllable LEDs",
	],
	notes: "This device relies on mantaOSC which is part of [libmantassfr’s libmanta implementation](https://github.com/ssfrr/libmanta).",
	type: [\pad, \slider],
	hasScribble: true
),
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