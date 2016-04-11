
(
deviceName: "manta",
protocol: \osc,
elementTypes: [\pad, \slider],
deviceType: \manta,
status: (
	linux: "unknown",
	osx: "tested and working. 2016-04-10, adc",
	win: "unknown"),

idInfo: "manta",
// srcPort is the port external source is listening to, and SC should send to;
// recvPort is the port SC should listen to for messages from the external source.
netAddrInfo: ( srcPort: 31417, ipAddress: "127.0.0.1", recvPort: 31416 ),

specialMessages: (
	enableLEDControl: [
		[ "/manta/ledcontrol", "padandbutton", 1 ],
		[ "/manta/ledcontrol", "slider", 1 ],
		[ "/manta/ledcontrol", "button", 1 ]
]),
testCode: {
	// start MantaOSC terminal program. this sends on port
	"/Users/adc/scgit/libmanta/MantaOSC/build/MantaOSC".runInTerminal;

	// make a manta mktl
	m = MKtl(\mt, "*manta");
	m.trace;

	// not working? have a look at where data is coming from...
	OSCFunc.trace(true);

	// update accordingly
	m.device.updateSrcAddr("127.0.0.1", 31417);
	m.device.updateRecvPort(57120);

	OSCFunc.trace(false);

	m.elAt.action = { |el| [el.name, el.value.round(0.0001)].postln };
},

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
	longName: "Snyderphonics Manta"
),
elementsDesc: (
	elements: [
		(
			key: \pad,
			shared: (
				spec: 'mantaTouch',
				ioType: \in
			),
			elements: (0..47).collect { |id|
				(
					key: id.asSymbol,
					elements: [
						(
							key: \con,
							oscPath: '/manta/continuous/pad',
							argTemplate: [ id ],
							elementType: 'slider',
							style: (
								row: 2.0 + (id div: 8) + 0.5,
								column: id % 8,
								width: 0.6, height: 1)
						),
						(
							key: \vel,
							oscPath: '/manta/velocity/pad',
							argTemplate: [ id ],
							elementType: 'pad',
							style: (row: 2.3 +  (id div: 8) + 0.5,
								column: id % 8 + 0.45,
								width: 0.6, height: 0.7)
						),
						(
							key: \led,
							oscPath: '/manta/led/pad',
							argTemplate: [ nil, id ],
							elementType: 'led',
							spec: 'mantaLed',
							ioType: \out,
							style: (row: 2.0 + (id div: 8) + 0.5,
								column: id % 8 + 0.45,
								width: 0.6, height: 0.5
							)
						)
					]
				)
			};
		),
		(
			key: \bt,
			elements: (0..3).collect { |id|
				(
					key: id.asSymbol,
					elements: [
						(
							key: \con,
							oscPath: '/manta/continuous/button',
							argTemplate: [ id ],
							elementType: 'slider', // 'pad'
							spec: 'mantaTouch',
							ioType: \in,
							style: (row: 0.0 + (id div: 2),
								column: 5.5 + (id % 2) + (id div: 2 * 0.5),
								width: 0.6, height: 1
							)
						),
						(
							key: \vel,
							oscPath: '/manta/velocity/button',
							argTemplate: [ id ],
							elementType: 'pad',
							spec: 'mantaTouch',
							ioType: \in,
							style: (
								row: 0.3 + (id div: 2),
								column: 5.5 + (id % 2) + (id div: 2 * 0.5) + 0.45,
								width: 0.6, height: 0.7
							)
						),
						(
							key: \led,
							oscPath: '/manta/led/button',
							argTemplate: [ nil, id ],
							elementType: 'led',
							spec: 'mantaLed',
							ioType: \out,
							style: (row: 0 + (id div: 2),
							column: 5.5 + (id % 2) + (id div: 2 * 0.5) + 0.45,
								width: 0.6, height: 0.5
							)
						)
					]
				)
			}
		),
		(
			key: \sl,
			elements: (0..1).collect { |id|
				(key: id.asSymbol,
					elements: [
						(key: \con,
							oscPath: '/manta/continuous/slider',
							argTemplate: [ id ],
							elementType: 'slider',
							spec: 'mantaSlider',
							ioType: \in,
							style: (row: id + 0.5, column: 1 - id,
								width: 4, height: 0.6),
						),
						(
							key: \led,
							elements: (0..7).collect { |jd|
								// this need a fix still!
								(
									oscPath: '/manta/led/slider',
									argTemplate: [ nil, id, jd ],
									elementType: 'button', // 'led',
									spec: 'mantaLed',
									ioType: \out,
									style: (
										row: id,
										column: (1 - id) + (jd * 0.5),
										width: 0.6, height: 0.6),
								);
							}
						)
					]
				)
			}
		)
	];
)
);
