// access minibees with an XPee expansion board.
// see sensestage-minibee1 for more information.
/*

  <configuration id="2" name="expee" message_interval="50" samples_per_message="1">
    <pin config="TWIData" id="A4" />
    <pin config="TWIClock" id="A5" />
    <pin config="AnalogIn10bit" id="A0"  name="analog0" />
    <pin config="AnalogIn10bit" id="A1"  name="analog1" />
    <pin config="AnalogIn10bit" id="A2"  name="analog2" />
    <pin config="AnalogIn10bit" id="A3"  name="analog3" />
    <pin config="AnalogOut" id="D9" name="led0" />
    <pin config="AnalogOut" id="D10" name="led1" />
    <pin config="AnalogOut" id="D11" name="led2" />
    <pin config="AnalogOut" id="D3" name="led3" />
    <pin config="AnalogOut" id="D5" name="led4" />
    <pin config="AnalogOut" id="D6" name="led5" />
    <twi id="1" device="ADXL345" name="accelero" />
  </configuration>

*/
/* test code:

n = NetAddr.new( "127.0.0.1", NetAddr.langPort );
n.sendMsg( '/minibee/data', 1, 1.0.rand, 1.0.rand, 1.0.rand );

~bee2 = MKtl(\bee2, "*minibee1-xpee");

~bee2.gui;
~bee2.trace( true );

// fake sending data:
n = NetAddr.new( "127.0.0.1", NetAddr.langPort );
n.sendMsg( '/minibee/data', 1, 0.1, 0.2, 0.3,0.4  , 1.0.rand, 1.0.rand, 1.0.rand );

OSCFunc.trace( true );

~bee2.elementAt( \led, '1' ).value_( 0.5 );
~bee2.elementAt( \led, '2' ).value_( 0.8 );
~bee2.elementAt( \led, '3' ).value_( 0.2 );
~bee2.elementAt( \led, '4' ).value_( 0.6 );
~bee2.elementAt( \led, '5' ).value_( 0.8 );
~bee2.elementAt( \led, '6' ).value_( 0.9 );

~bee2.trace( false );
OSCFunc.trace( false );

*/

(
deviceName: "minibee1-xpee",
protocol: \osc,
deviceType: \minibee,
elementTypes: [\accelerometer, \analogSensor],
status: (
	linux: "tested (fake device only); 2016_03_20 by nescivi", // need to check whether outputs are integers!
	osx: "unknown",
	win: "unknown"),

idInfo: "minibee1-xpee",
netAddrInfo: ( srcPort: nil, ipAddress: "127.0.0.1", recvPort: 57120 ),

specs: (
	minibeeButton: [0, 1, \linear, 1, 0 ].asSpec,
	minibeePWM: [0, 255, \linear, 1, 0 ].asSpec,
	minibeeAnalog: [0, 1, \linear, 0, 0 ].asSpec,
	minibeeAccelAxis: [0, 1, \linear, 0, 0.5].asSpec
),

deviceInfo: (
	vendorURI: "https://shop.sensestage.eu/product.php?id_product=11",
	// manualURI: "",
	// description: "",
	// features: [],
	notes: "This is the Sense/Stage MiniBee with the XPee expansion board default configuration (2)",
	// hasScribble: false
),

collectives: (
	data: (
		oscPath: '/minibee/data',
		argTemplate: [ 1 ],
		elements: [
			[\ana, 0], [\ana, 1], [\ana, 2], [\ana, 3],
			[\accel, \x], [\accel, \y], [\accel, \z]
		],
		ioType: \in
	),
	output: (
		oscPath: '/minibee/output',
		argTemplate: [ 1 ],
		elements: [
			[\led, 0], [\led, 1], [\led, 2], [\led, 3], [\led, 4], [\led, 5]
		],
		ioType: \out
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
			shared: (elementType: \multiPurpose, ioType:
				\collectiveIn, \spec: 'minibeeAnalog'), // nescivi: why bender?
			elements: (1..4).collect {|num, i|
				(key: num.asSymbol)
			}
		),
		(
			key: \led,
			shared: (elementType: 'led', ioType: \collectiveIn, \spec: 'minibeePWM'),
			elements: (1..6).collect {|num, i|
				(key: num.asSymbol)
			}
		)
	]
)
)

