
(
deviceName: "manta",
protocol: \osc,
elementTypes: [\pad, \slider],
deviceType: \manta,
status: (
	linux: "unknown",
	osx: "tested and working. 2017-02-11, lfsaw",
	win: "unknown"),

idInfo: "manta",
// srcPort is the port external source is listening to, and SC should send to;
// recvPort is the port SC should listen to for messages from the external source.
netAddrInfo: ( srcPort: 31417, ipAddress: "127.0.0.1", recvPort: 31416 ),

specialMessages: (
	enableLEDControl: [
		[ "/manta/ledcontrol", "padandbutton", 1 ],
		[ "/manta/ledcontrol", "slider", 1 ]
	],
	disableLEDControl: [
		[ "/manta/ledcontrol", "padandbutton", 0 ],
		[ "/manta/ledcontrol", "slider", 0 ]
	],
	enablePadButtonLEDControl: [
		[ "/manta/ledcontrol", "padandbutton", 1 ]
	],

	disablePadButtonLEDControl: [
		[ "/manta/ledcontrol", "padandbutton", 0 ]
	]
),
testCode: {
	// start MantaOSC terminal program.
	"/<PATH/TO/MANTAOSC>/MantaOSC 0 31417 57120".runInTerminal;

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

	// sliders have an encoded release value
	m.elAt(\sl, 0, \con).action = {|el|
		var on = el.deviceValue != 65535;

		on.if({
			el.value.postln
		}, {
			"finger released".postln
		})
	};


	// enable LED control and set one light
	m.sendSpecialMessage(\enableLEDControl);

	// Manta v.2 has two different LED colors; amber and red
	// Manta v.1 has only amber.
	m.elAt(\pad, 0, \led).deviceValue = "amber";

	// some light patterns
	q = q ? ();

	q.ledPatterns = IdentityDictionary[
		('spiral'          -> #[1,0,1,1,1,1,0,1,0,1,0,0,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,1,1,0,1,0,1,0,0,0,0,1,0]),
		('leftRight'       -> #[1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1]),
		('flower'          -> #[0,1,1,0,1,0,1,1,1,0,1,0,0,1,0,1,0,1,1,0,1,0,1,1,1,1,0,1,0,1,1,0,1,0,1,0,0,1,0,1,1,1,0,1,0,1,1,0]),
		('hStripes'        -> #[1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0]),
		('smallChecker'    -> #[1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1]),
		('checker'         -> #[1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1]),
		('vStripes'        -> #[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0]),
		('frame'           -> #[0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,1,0,0,0,0,1,0,0,1,0,0,0,0,1,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0]),
		('rStripes'        -> #[1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0]),
		('lStripes'        -> #[1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1]),
		('reflection'      -> #[1,0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,0,1,1,1,1,1,1,0,1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,0,1]),
		('realTriads'      -> #[1,1,0,1,1,0,1,1,1,0,0,1,0,0,1,0,1,1,0,1,1,0,1,1,1,0,0,1,0,0,1,0,1,1,0,1,1,0,1,1,1,0,0,1,0,0,1,0]),
		('twoStripes'      -> #[1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0]),
		('squareFrame'     -> #[0,1,1,1,1,1,1,0,0,1,0,0,0,0,1,0,0,1,0,1,1,0,1,0,0,1,0,1,1,0,1,0,0,1,0,0,0,0,1,0,0,1,1,1,1,1,1,0]),
		('upperLower'      -> #[1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1]),
		('ring'            -> #[1,0,1,1,1,1,0,1,0,1,0,0,0,1,0,1,0,1,0,1,1,0,1,0,1,0,1,0,1,0,1,0,0,1,0,1,1,0,1,0,0,1,0,0,0,1,0,1]),
		('checkeredTriads' -> #[1,1,0,1,1,0,1,1,1,0,0,1,0,0,1,0,0,0,1,0,0,1,0,0,0,1,1,0,1,1,0,1,1,1,0,1,1,0,1,1,1,0,0,1,0,0,1,0]),
		('lrBurst'         -> #[1,1,0,1,0,1,0,0,0,1,0,1,1,0,1,1,1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,1,1,0,1,1,0,1,0,0,0,1,0,1,0,1,1])
	];

	q.ledPatterns.choose.do{|val, i|
		// amber is 1, red is 0.5
		m.elAt(\pad, i, \led).value = val;
	};

},

specs: (
	mantaTouch: [ 0, 227 ].asSpec, // this seems to be the spec, looking at the github source code
	mantaSlider: [ 0, 4095 ].asSpec, // slider sends values between 0 and 4095, releasing the slider sends 65535
	mantaLed: ItemsSpec.new( ["off","red", "amber"] ), // led can be off, red, or amber
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
				var row = 8 - (id div: 8) + 0.5 * 1.5;
				var column = (id % 8 + 0.5 - (id div: 8 % 2 * 0.5 ) * 2);

				(
					key: id.asSymbol,
					elements: [
						(
							key: \con,
							oscPath: '/manta/continuous/pad',
							argTemplate: [ id ],
							elementType: 'pad',
							style: (
								row: row,
								column: column,
								width: 1.1, height: 1.5)
						),
						(
							key: \vel,
							oscPath: '/manta/velocity/pad',
							argTemplate: [ id ],
							elementType: 'pad',
							style: (row: row + 0.6,
								column: column + 0.9,
							width: 1.1, height: 0.9)
						),
						(
							key: \led,
							oscPath: '/manta/led/pad',
							argTemplate: [ nil, id ],
							elementType: 'led',
							spec: 'mantaLed',
							ioType: \out,
							style: (row: row,
								column: column + 0.9,
								width: 1.1, height: 0.9
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
