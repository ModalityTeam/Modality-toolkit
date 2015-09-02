// gyrosc iphone/ipad app
/*
ip addr should be passed in later.
*/

(
name: "gyrosc",
idInfo: ( srcPort: 31417, ipAddress: "1.2.3.4", recvPort: 57120 ),
protocol: \osc,
deviceInfo: (
	vendorURI: "http://www.bitshapesoftware.com/instruments/gyrosc/",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",
	// type: [],
	// hasScribble: false
),
	// actually about 7 more messages possible.
	// replace wildcard later with nameTag as set in iphone used.
description: (
	'gyrosc/*/gyro': (\oscMsgType: \, \type: \gyro, \spec: \midiCC)
)
)
