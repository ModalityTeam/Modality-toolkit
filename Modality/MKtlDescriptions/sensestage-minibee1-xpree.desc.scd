// access minibees with an XPee expansion board.
// see sensestage-minibee1 for more information.
/*

  <configuration id="3" name="expree" message_interval="50" samples_per_message="1">
    <pin config="TWIData" id="A4" />
    <pin config="TWIClock" id="A5" />
    <pin config="AnalogIn10bit" id="A0"  name="analog0" />
    <pin config="AnalogIn10bit" id="A1"  name="analog1" />
    <pin config="AnalogIn10bit" id="A2"  name="analog2" />
    <pin config="AnalogIn10bit" id="A3"  name="analog3" />
    <pin config="AnalogIn10bit" id="A6"  name="analog4" />
    <pin config="AnalogIn10bit" id="A7"  name="analog5" />
    <pin config="DigitalIn" id="D3" name="digitaal0" />
    <pin config="DigitalIn" id="D5" name="digitaal1" />
    <pin config="DigitalIn" id="D6" name="digitaal2" />
    <pin config="DigitalIn" id="D7" name="digitaal3" />
    <pin config="DigitalIn" id="D8" name="digitaal4" />
    <pin config="DigitalIn" id="D9" name="digitaal5" />
    <pin config="DigitalIn" id="D10" name="digitaal6" />
    <pin config="DigitalIn" id="D11" name="digitaal7" />
    <twi id="1" device="ADXL345" name="accelero" />
  </configuration>

*/

/*

testcode:

~bee3 = MKtl(\bee3, "*minibee1-xpree");
~bee3.rebuild( "*minibee1-xpree" );

~bee3.gui;
~bee3.trace(true);

// faking data from SC:
n = NetAddr.new( "127.0.0.1", NetAddr.langPort );
n.sendMsg( '/minibee/data', 1, 1,0,0,1, 1,0,0, 1,  0.1, 0.2, 0.3,0.4, 0.5, 0.6  , 1.0.rand, 1.0.rand, 1.0.rand );

n.sendMsg( '/minibee/data', 1, 0,1,1,0, 0, 1,1, 0,  0.1, 0.2, 0.3,0.4, 0.5, 0.6  , 1.0.rand, 1.0.rand, 1.0.rand );

~bee3.trace(false);


*/

(
deviceName: "minibee1-xpree",
protocol: \osc,
deviceType: \minibee,
elementTypes: [\accelerometer, \analogSensor, \button],
status: (
	linux: "tested (fake device only); 2016_03_20 by nescivi",
	osx: "unknown",
	win: "unknown"),

idInfo: "minibee1-xpree",
netAddrInfo: ( srcPort: nil, ipAddress: "127.0.0.1", recvPort: 57120 ),

specs: (
	minibeeButton: [0, 1, \linear, 1, 0 ].asSpec,
	minibeeAnalog: [0, 1, \linear, 0, 0 ].asSpec,
	minibeeAccelAxis: [0, 1, \linear, 0, 0.5].asSpec
),

deviceInfo: (
	vendorURI: "https://shop.sensestage.eu/product.php?id_product=11",
	// manualURI: "",
	// description: "",
	// features: [],
	notes: "This is the Sense/Stage MiniBee with the XPree expansion board default configuration (3)",
	// hasScribble: false
),

collectives: (
	data: (
		oscPath: '/minibee/data',
		argTemplate: [ 1 ],
		elements: [
			[\b,0], [\b,1], [\b,2], [\b,3], [\b,4], [\b,5], [\b,6], [\b,7],
			[\ana, 0], [\ana, 1], [\ana, 2], [\ana, 3],[\ana, 4], [\ana, 5],
			[\accel, \x], [\accel, \y], [\accel, \z]
		],
		ioType: \in
	)
),
elementsDesc: (
	elements: [
		(
			key: \accel,
			shared: (elementType: 'accelAxis', ioType: \collectiveIn, \spec: 'minibeeAccelAxis' ),
			elements: [
				(key: \x),
				(key: \y),
				(key: \z),
			]
		),
		(
			key: \ana,
			shared: (elementType: 'bender', ioType: \collectiveIn, \spec: 'minibeeAnalog'),
			elements: (1..6).collect {|num, i|
				(key: num.asSymbol)
			}
		),
		(
			key: \b,
			shared: (elementType: 'bender', ioType: \collectiveIn, \spec: 'minibeeButton'),
			elements: (1..8).collect {|num, i|
				(key: num.asSymbol)
			}
		)

	]
)
)

