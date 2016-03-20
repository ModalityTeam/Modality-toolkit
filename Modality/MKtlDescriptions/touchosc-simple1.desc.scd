/****************************
// first pass on MKtl support for touchOSC
// in the touchOSC app, this only supports Layout Simple, page 1
// ( other scenes may be added later, in separate desc files )

// INSTRUCTIONS to test:
// * have touchosc and laptop with SC be in the same network

/////// in the touchOSC app,
// * set OSC host ip to the laptops IP, as seen in network settings,
//    e.g. 192.168.178.51
// or find them in unixCmd("ifconfig")
// * switch Layout to 'Simple',
// * in options,
// * turn accelerometer on, and touch and ping off

/////// in SC:
// * check if anything is coming, and note the sending address
OSCFunc.trace(true);
OSCFunc.trace(false);
// * if nothing, check that touchosc sends to proper port:
NetAddr.langPort

OSCdef('/1/fader5', { |msg| msg.postln });

////// the protocol for scene 1 is
// // a horiz. crossfader
// '/1/fader5'
// // four vertical faders
// '/1/fader1' .. 4
// // 4 toggle buttons
// '/1/toggle1' .. 4

// maybe turn off debug info,
OSCMKtlDevice.verbose = false;
// maybe clear MKtls first
MKtl.all.do(_.free).clear;

// make our tosc
t = MKtl(\tosca, "touchosc-simple1");

// update the touchOSC send address to the one you see in OSCFunc.trace:
MKtl(\tosca).device.updateSrcAddr("192.168.178.74", 54054);
m = MKtl(\tosca);
m.trace;
// and give it an action for all its elements
MKtl(\tosca).elements.action = { |el|
"tOsc %: %\n".postf(el.name, el.value.round(0.001))
};

t.gui;
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

idInfo: "touchOSC",
netAddrInfo: (srcPort: 9000, recvPort: 57120, ipAddress: "192.168.178.51"),

deviceInfo: (
	longName: "touchOSC"
),

// seem to be the max accel values on iphone
specs: (accx: [-3.0, 3.0, \lin]),

collectives: (
        accel: (
            oscPath: '/accxyz',
            elements: [ [\accel, \x], [\accel, \y], [\accel, \z]],
            ioType: \in
        )
    ),
elementsDesc: (
	elements: [
		(
			key: \xfader,
			oscPath: '/1/fader5', type: 'slider', spec: \unipolar, ioType: \in
		),
		(
			key: \sl,
			shared: (elementType: \slider, spec: \unipolar, ioType: \in),
			elements: (1..4).collect { |num|
				(oscPath: "/1/fader%".format(num).asSymbol)
			}
		),
		(
			key: \bt,
			shared: (elementType: \button, spec: \but, ioType: \in),
			elements: (1..4).collect { |num|
				(oscPath: "/1/toggle%".format(num).asSymbol)
			}
		),
		(
			key: \accel,
			shared: (elementType: 'accelAxis', ioType: \collectiveIn, \spec: 'accx' ),
			elements: [
				(key: \x),
				(key: \y),
				(key: \z)
			]
		)
	]
)
);
)