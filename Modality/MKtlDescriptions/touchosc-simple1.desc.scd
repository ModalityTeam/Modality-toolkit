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
NetAddr.langPort;

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
t.gui;
// trace to look what address the touchOSC app sends from:
OSCFunc.trace(true);
// and turn off tracing.
OSCFunc.trace(false);

// set the address to the one you see in the trace:
t.device.updateSrcAddr("192.168.178.68", 63763);

NetAddr.langPort;

// now trace the MKtl itself
t.trace;
t.device;
// and give it an action for all its elements
t.elAt.action = { |el|
	"tOsc %: %\n".postf(el.name, el.value.round(0.001))
};

t.gui;

// or if you test by simulation from SC:
n = NetAddr("192.168.178.51", 57120);
MKtl(\tosca).device.updateSrcAddr("192.168.178.51", 57120);


Tdef(\toscTest, {
	inf.do {
		n.sendMsg('/accxyz', 1.0.rand2, 1.0.rand2, 1.0.rand2);
		if (0.1.coin) { n.sendMsg('/xfader'.postln, 1.0.rand); };
		if (0.1.coin) { n.sendMsg("/1/fader4".postln, 1.0.rand); };
		0.1.wait;
	};
}).play;

*******************************/
(
(
deviceName: "touchOSC",
protocol: \osc,
deviceType: \phoneApp,
elementTypes: [\accelerometer, \fader, \button],
status: (
	linux: "unknown after refactor",
	osx: "tested and working. 2016-04-10, adc.",
	win: "unknown after refactor"
),

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
			oscPath: '/1/fader5', elementType: 'slider', spec: \unipolar, ioType: \in,
			style: (width: 4, height: 1)
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