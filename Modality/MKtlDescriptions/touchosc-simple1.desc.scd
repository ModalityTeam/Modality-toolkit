/****************************
// first pass on MKtl support for touchOSC
// this only supports touchOSC page 1 of Layout Simple
//    ( other scenes to be added later! )

// INSTRUCTIONS to test:
// * have touchosc and laptop with SC be in the same network

/////// in the touchOSC app,
// * set OSC host ip to sclang's, as seen in network settings,
//    e.g. 192.168.2.77 // or find them in unixCmd("ifconfig")
// * switch Layout to 'Simple',
// * in options,
// * turn accelerometer on, touch and ping off

/////// in SC
// * check if anything is coming, and note the sending address
OSCFunc.trace(true);
OSCFunc.trace(false);
// * if not, check that touchosc sends to proper port:
NetAddr.langPort

////// the protocol for scene 1 is
// // a horiz. crossfader
// '/1/fader5'
// // four vertical faders
// '/1/fader1' .. 4
// // 4 toggle buttons
// '/1/toggle1' .. 4

// maybe turn off debug info,
OSCMKtlDevice.verbose = false;
// maybe clear MKtls
MKtl.all.do(_.free).clear;

// make our tosc
MKtl(\tOsc, "touchosc-simple1");

// update the touchOSC send address to the one you see in OSCFunc.trace:
MKtl(\tOsc).mktlDevice.updateSrcAddr("192.168.2.79", 55228);
// and give it an action for all its elements
MKtl(\tOsc).elements.action = { |el|
"tOsc %: %\n".postf(el.name, el.value.round(0.001))
};

*******************************/
(
(
deviceName: "touchOSC",
protocol: \osc,
deviceType: \phoneApp,
elementTypes: [\accelerometer, \fader, \button],
status: (
	linux: "unknown",
	osx: "unknown",
	win: "unknown"),

idInfo: (srcPort: 12345, recvPort: 57120, ipAddress: "192.168.2.79"),

deviceInfo: (),

description: [
	\xfader -> (oscPath: '/1/fader5', type: 'slider',
		spec: \unipolar, ioType: \in),
	\sl -> (1..4).collect { |num|
		(
			oscPath: "/1/fader%".format(num).asSymbol,
			type: \slider, spec: \unipolar, ioType: \in
		)
	},
	\bt -> (1..4).collect { |num|
		(
			oscPath: "/1/toggle%".format(num).asSymbol,
			type: \button, spec: \but, ioType: \in
		)
	}
]
);
)
