// gyrosc iphone/ipad app, skeching how OSC devices should work.
// should create an
/*
OSCMktl.find; // can't detect any active ones ...
OSCMktl('gyrosc', "gyrosc");
newFromDesc
OSCExplorer
OSCMktl.new;

MKtl.loadAllDescs;
MKtl.allDevDescs[\gyrosc];

*/

(
idInfo: "gyrosc",
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
description: (
	'gyrosc/*/gyro': (\oscMsgType: \, \type: \gyro, \spec: \midiCC)
)
)
