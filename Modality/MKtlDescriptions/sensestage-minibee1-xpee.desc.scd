// access minibees with an XPee expansion board.
// see sensestage-minibee1 for more information.

(
deviceName: "minibee1-xpee",
protocol: \osc,
deviceType: \minibee,
elementTypes: [\accelerometer],
status: (
	linux: "unknown",
	osx: "tested and working, subset of sensors only.",
	win: "unknown"),

idInfo: "minibee1-xpee",
netAddrInfo: ( srcPort: nil, ipAddress: "127.0.0.1", recvPort: 57120 ),

specs: (
	ins: [0, 1],
	accelAxis: [-3, 3]),

deviceInfo: (
	// vendorURI: "",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",
	// hasScribble: false
),

collectives: (
	data: (
		oscPath: '/minibee/data',
		argTemplate: [ 1 ],
		elements: [
			[\in, 0], [\in, 1], [\in, 2], [\in, 3],
			[\accel, \x], [\accel, \y], [\accel, \z]
		],
		ioType: \in
	)
),
elementsDesc: (
	elements: [
		(
			key: \accel,
			shared: (elementType: 'accelAxis', elementType: \accelerationAxis, ioType: \collectiveIn, \spec: 'accelAxis' )
			elements: [
				(key: \x),
				(key: \y),
				(key: \z),
			]
		),
		(
			key: \in,
			shared: (elementType: 'bender', elementType: \multiPurpose, ioType:
				\collectiveIn, \spec: 'ins'),
			elements: (1..4).collect {|num, i|
				(key: num.asSymbol)
			}
		)
	]
)
)

