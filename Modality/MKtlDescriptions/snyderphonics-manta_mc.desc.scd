/*********
* same basic desc as manta, but for MantaCocoa.
* useful as fallback on osx when MantaOSC does not work well.

- mainly the oscPaths are different
- setting leds is likely impossible (not tested)

- In centroid and velocity turned off in MantaCocoa.
- noteOn always has very low initial velocity value,
-> better not use it.

- The Manta quark class Manta has its own noteOn logic,
  which could be ported.


/// TESTS:
// start MantaCocoa app
"/Applications/manta*" +/+ "MantaCocoa.app".openOS;

// in MantaCocoa, turn off centroid and velocity

// make an MKtl for the Manta
m.free; m = MKtl(\mt, "*manta_mc");
// trace incoming data - do someting on Manta, just to read the source addr port
OSCFunc.trace;
// ... and then update it in the MKtl:
m.device.updateSrcAddr(port: 54969);

// trace m, and play on the Manta: should post all elements now
m.trace; OSCFunc.trace(false);

// gui is broken - too small and commented out elements mess it up.
// -> redo sometime, not urgent.
m.gui;
****/
(
deviceName: "manta",
protocol: \osc,
elementTypes: [\pad, \slider],
deviceType: \manta,
status: (
	linux: "unknown",
	osx: "tested and working. gui needs fixes. 2016-04-10, adc",
	win: "unknown"),

idInfo: "manta",
// this has to be set in MantaCocoa
netAddrInfo: ( srcPort: 8001, ipAddress: "127.0.0.1", recvPort: 57120 ),

///// very likely this does not work
// specialMessages: (
// 	enableLEDControl: [
// 		[ "/manta/ledcontrol", "padandbutton", 1 ],
// 		[ "/manta/ledcontrol", "slider", 1 ],
// 		[ "/manta/ledcontrol", "button", 1 ]
// ]),

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
							oscPath: '/manta/value', // '/manta/continuous/pad',
							argTemplate: [ id ],
							elementType: 'slider',
							style: (
								row: 2.0 + (8 - (id div: 8)) + 0.5,
								column: id % 8 + (id div: 8 % 2 * 0.5),
								width: 0.6, height: 1)
						),
						(
							key: \vel,
							oscPath: '/manta/noteOn', // '/manta/velocity/pad',
							argTemplate: [ id ],
							elementType: 'pad',
							style: (
								row: 2.3 +  (8 - (id div: 8)) + 0.5,
								column: id % 8 + 0.45 + (id div: 8 % 2 * 0.5),
								width: 0.6, height: 0.7)
						),
						(
							key: \velOff,
							oscPath: '/manta/noteOff', // '/manta/velocity/pad',
							argTemplate: [ id ],
							elementType: 'pad',
							style: (
								row: 2.3 +  (8 - (id div: 8)) + 0.5,
								column: id % 8 + 0.45 + (id div: 8 % 2 * 0.5),
							width: 0.6, height: 0.7)
						),
						// likely not working:
						// (
						// 	key: \led,
						// 	oscPath: '/manta/led/pad',
						// 	argTemplate: [ nil, id ],
						// 	elementType: 'led',
						// 	spec: 'mantaLed',
						// 	ioType: \out,
						// 	style: (row: 2.0 + (8 - (id div: 8)) + 0.5,
						// 		column: id % 8 + 0.45 + (id div: 8 % 2 * 0.5),
						// 		width: 0.6, height: 0.5
						// 	)
						// )
					]
				)
			};
		),
		(
			key: \bt,
			elements: (48..51).collect { |id|
				(
					key: id.asSymbol,
					elements: [
						(
							key: \con,
							oscPath: '/manta/value',
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
							oscPath: '/manta/noteOn',
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
							key: \velOff,
							oscPath: '/manta/noteOff',
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
						// (
						// 	key: \led,
						// 	oscPath: '/manta/led/button',
						// 	argTemplate: [ nil, id ],
						// 	elementType: 'led',
						// 	spec: 'mantaLed',
						// 	ioType: \out,
						// 	style: (row: 0 + (id div: 2),
						// 		column: 5.5 + (id % 2) + (id div: 2 * 0.5) + 0.45,
						// 		width: 0.6, height: 0.5
						// 	)
						// )
					]
				)
			}
		),
		(
			key: \sl,
			elements: [1, 2].collect { |id|
				(key: id.asSymbol,
				////// slider leds very likely not addressable with MantaCocoa,
				////// keeping depth for compatibility with MantaOSC
					elements: [
						(key: \con,
							oscPath: '/manta/slider', // '/manta/continuous/slider',
							argTemplate: [ id ],
							elementType: 'slider',
							spec: 'mantaSlider',
							ioType: \in,
							style: (row: id + 0.5, column: 1 - id,
								width: 4, height: 0.6),
						),
						// (
						// 	key: \led,
						// 	elements: (0..7).collect { |jd|
						// 		// this need a fix still!
						// 		(
						// 			oscPath: '/manta/led/slider',
						// 			argTemplate: [ nil, id, jd ],
						// 			elementType: 'button', // 'led',
						// 			spec: 'mantaLed',
						// 			ioType: \out,
						// 			style: (
						// 				row: id,
						// 				column: (1 - id) + (jd * 0.5),
						// 			width: 0.6, height: 0.6),
						// 		);
						// 	}
						// )
					]
				)
			}
		)
	];
)
);
