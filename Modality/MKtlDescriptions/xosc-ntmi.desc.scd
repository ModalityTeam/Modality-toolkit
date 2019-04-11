/*
NOT DONE YET:

+ output communication
+ serial input messages are raw data, how to handle?
+ how to handle string only values?
+ ping returns strings,
+ sending back to set stuff uses strings
-> use PassSpec for not touching raw values


OSCFunc.trace;
OSCFunc.trace(false);

g = MKtl(\xoscN, "*xosc-ntmi");
// update with the address seen in OSCMon or OSCFunc.trace:
g.device.updateSrcAddr("169.254.1.1", 9000);

g.trace
g.trace(false)

g.gui
*/

(
deviceName: "x-osc",
protocol: \osc,
deviceType: \multiController,
elementTypes: [\accelerometer, \sensor, \serial],
status: (
	linux: "unknown after refactor",
	osx: "imu and analog, switches tested and working.",
	win: "unknown after refactor"
),

idInfo: "x-osc",
netAddrInfo: ( ipAddress: "169.254.1.1", recvPort: 57120 ), // ip for adhoc mode

deviceInfo: (
	vendorURI: "http://www.x-io.co.uk/products/x-osc/",
	manualURI: "http://www.x-io.co.uk/downloads/x-OSC-User-Manual-v0.4.pdf",
	description: "WLan OSC I/O board",
	features: [
		"16× analogue/digital inputs",
		"16× digital/PWM outputs (up to 50 mA per channel)",
		"13-bit ADC with 400 Hz update rate per channel",
		"Up to 16-bit PWM resolution for 5 Hz to 250 kHz",
		"Control up to 400 RGB LEDs (NeoPixel)",
		"4× serial communication channels"
	],
	longName: "XIO x-OSC",
	notes: "",
),

specs: (
	\switch: [0, 1, \lin, 1],
	\pass: PassSpec,
	// measured degrees of rotation at 100 Hz sendrate:
	gyroAxis: [-1000, 1000],
	// measured max accel with fast shaking:
	accelAxis: [-8, 8],
	// guessing, usually more between +-0.5:
	magnetAxis: [-0.8, 0.8],
	// gyro temperature
	temp: [0, 100],
	// min and max working battery voltage
	batVolt: [3.4, 3.9]
),

collectives: (
	imu: (
		oscPath: '/imu',
		elements: [
			[\gyro, \pitch], [\gyro, \roll], [\gyro, \yaw],
			[\accel, \x], [\accel, \y], [\accel, \z],
			[\magnet, \pitch], [\magnet, \roll], [\magnet, \yaw],
			[\temp]
		],
		ioType: \in
	),
	dIn: (
		oscPath: '/inputs/digital',
		elements: 16.collect {|i|
			[\sw, (i + 1).asSymbol]
		},
		ioType: \in
	),
	aIn: (
		oscPath: '/inputs/analogue',
		elements: 16.collect {|i|
			[\inA, (i + 1).asSymbol]
		},
		ioType: \in
	),
	aCIn: (
		oscPath: '/inputs/analogue/comparator',
		elements: 16.collect {|i|
			[\inC, (i + 1).asSymbol]
		},
		ioType: \in
	)
),

elementsDesc: (
	// input elements:

	// 10 floating-point arguments indicating the current readings of the on board sensors. Arguments 1 – 3 gyroscope (°/s) x, y, z; arguments 4 – 6 accelerometer (g), x, y ,z; arguments 7 – 9 magnetometer (Ga) x, y ,z; argument 10 gyroscope temperature (°C)
	elements: [
		(
			key: \accel,
			shared: (elementType: 'accelAxis', ioType: \collectiveIn,
				\spec: 'accelAxis' ),
			elements: [\x, \y, \z].collect { |name, i|
				(key: name, style: (row: 0, column: i * 0.9 + 0, height: 2))
			}
		),
		(
			key: \gyro,
			shared: (elementType: 'gyroAxis', ioType: \collectiveIn,
				\spec: 'gyroAxis' ),
			elements: [\pitch, \roll, \yaw].collect{ |name, i|
				(key: name, style: (row: 0, column: i * 0.9 + 3, height: 2))
			}
		),
		(
			key: \magnet,
			shared: (elementType: 'gyroAxis', ioType: \collectiveIn,
				\spec: 'magnetAxis' ),
			elements: [\pitch, \roll, \yaw].collect { |name, i|
				(key: name, style: (row: 0, column: i* 0.9  + 6, height: 2))
			}
		),
		(
			key: \temp, elementType: 'cvIn', ioType: \collectiveIn,
			\spec: 'temp' ),

		// 1 float indicating the current battery voltage
		(
			key: \battery, oscPath: '/battery', ioType: \in,
			elementType: \voltage, spec: \batVolt),

		// 16 integer arguments represent the state of the 16 digital inputs (0 or 1). Sent only when the state of any digital input pin changes
		(
			// key: \inD,
			key: \sw,
			shared: (elementType: \switch, spec: \switch, ioType: \collectiveIn),
			elements:  (1..16).collect { |num|  (key: num.asSymbol) }
		),
		(
			key: \led,
			shared: (elementType: \pad, spec: \unipolar, ioType: \out),
			elements:  (1..16).collect { |num|  (key: num.asSymbol) }
		),

		// 16 floating-point arguments indicate the analogue readings for all 16 inputs. Sent at the analogue input message rate
		(
			key: \inA,
			shared: (elementType: \slider, spec: \lin1, ioType: \collectiveIn),
			elements:  (1..16).collect { |num|  (key: num.asSymbol, style: (height: 2)) }
		),

		// 16 integer arguments represent the current compare state of the 16 analogue inputs (0 if below or 1 if above the threshold). Sent only when a threshold on any channel is crossed
		(
			key: \inC,
			shared: (elementType: \switch, spec: \switch, ioType: \collectiveIn),
			elements: (1..16).collect { |num|  (key: num.asSymbol,  height: 0.5) }
		),

		// // 1 blob argument containing the raw serial data received on input <channel> (1 – 4)
		// inS1: (oscPath: '/inputs/serial/1', inType: \blob, ioType: \in),
		// inS2: (oscPath: '/inputs/serial/2', inType: \blob, ioType: \in),
		// inS3: (oscPath: '/inputs/serial/3', inType: \blob, ioType: \in),
		// inS4: (oscPath: '/inputs/serial/4', inType: \blob, ioType: \in),

	]
)
);
