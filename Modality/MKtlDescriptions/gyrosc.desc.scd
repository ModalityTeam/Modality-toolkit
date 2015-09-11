// gyrosc iphone/ipad app
/*
replace asterisked name from all control elements:
MKtlDesc.openFolder

MKtl.replaceOSCpaths("*", "adc");
MKtl(\gyradc).elementsDict.choose.elemDesc;

(
MKtl(\gyradc).free;
MKtl(\gyradc, "gyrosc");
MKtl(\gyradc).elementsDict.keys;

)
ip addr should be passed in later.
*/

(
deviceName: "gyrosc",
idInfo: ( srcPort: 31417, ipAddress: "1.2.3.4", recvPort: 57120 ),
protocol: \osc,
deviceType: \phoneApp,

deviceInfo: (
	vendorURI: "http://www.bitshapesoftware.com/instruments/gyrosc/",
	// manualURI: "",
	// description: "",
	// features: [],
	// notes: "",
	elementTypes: [\imu, \accelerometer],
	// hasScribble: false
),
	// actually about 7 more messages possible.
	// replace wildcard later with nameTag as set in iphone used.
description: (
	'gyro': (\oscPath: 'gyrosc/*/gyro', \type: \gyro, \spec: \gyro)
)
)
