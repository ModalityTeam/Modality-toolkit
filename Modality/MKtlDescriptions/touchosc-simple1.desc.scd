/****************************
first pass on MKtl support for touchOSC
in the touchOSC app, this only supports Layout Simple, page 1
( other pages in this Layout, or other touchOSC layouts
may be added later, in separate desc files )

****** INSTRUCTIONS to test: ******
* log the smartphone with touchosc
  and the computer with SC into the same network

On the computer:
1. find its IP address
// on macOS in System Prefs/Network/WiFi,
// or in Terminal with ifconfig, or in SC with
unixCmdGetStdOut("ifconfig");
// -> look for lines with "inet " and the IP4 pattern xxx.xxx.xxx.xxx

2. in SuperCollider, check its langPort number:
NetAddr.langPort;
// default is 57120, but after crashes it can be 57121 or higher


On the smartphone, in touchOSC app, CONNECTIONS:
* set OSC host IP address to the laptop's IP from above
--  e.g. 192.168.178.51
* set OSC port number to SuperCollider's port number
* switch Layout to 'Simple',
* in Options,
-- turn accelerometer on, and touch and ping off

On computer, in SC:
* check if anything is coming, and note the sending address
OSCFunc.trace(true, true);
OSCFunc.trace(false);
// * if nothing, check again that touchosc sends to SC's langPort:
NetAddr.langPort;

// test for the top horiz. fader on page 1:
OSCdef('/1/fader5', { |msg| msg.postln });

////// the protocol for scene 1 is
// // a horiz. crossfader
// '/1/fader5'
// // four vertical faders
// '/1/fader1' .. 4
// // 4 toggle buttons
// '/1/toggle1' .. 4

// maybe turn off debug info if needed
OSCMKtlDevice.verbose = true;
OSCMKtlDevice.verbose = false;

// maybe clear MKtls first if needed
MKtl.all.do(_.free).clear;

// now make our touchosc MKtl from this desc file:
t = MKtl(\tosca, "touchosc-simple1");
t.gui;

// in the touchOSC app, Connections, OSC find Local IP address:
// this is the IP of the smartphone, which touchOSC sends from.
// trace in SC to see the same address that touchOSC sends from:
OSCFunc.trace(true, true);
// and turn off tracing.
OSCFunc.trace(false);

// set the address to the one you see in the trace:
t.device.updateSrcDstAddr("192.168.178.55", 9000);

// now trace the MKtl itself
t.trace;
t.trace(false);
t.gui;

// and give it an action for all its elements
t.elAt.action = { |el|
	"tOsc %: %\n".postf(el.name, el.value.round(0.001))
};

// or test by simulation from SC:
n = NetAddr.localAddr;
MKtl(\tosca).device.updateSrcDstAddr(n.hostname, n.port);


Tdef(\toscTest, {
	inf.do {
		n.sendMsg('/accxyz', 1.0.rand2, 1.0.rand2, 1.0.rand2);
		if (0.1.coin) { n.sendMsg('/xfader'.postln, 1.0.rand); };
		if (0.1.coin) { n.sendMsg("/1/fader4".postln, 1.0.rand); };
		0.1.wait;
	};
}).play;

// set back to touchOSC IP address as above ...
t.device.updateSrcDstAddr("192.168.178.55", 9000);

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
// recvPort will default to NetAddr.langPort
netAddrInfo: (srcPort: 9000, recvPort: nil, ipAddress: "192.168.178.51"),

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
			oscPath: '/1/fader5', elementType: 'slider', spec: \unipolar, ioType: \inout,
			style: (width: 4, height: 1)
		),
		(
			key: \sl,
			shared: (elementType: \slider, spec: \unipolar, ioType: \inout),
			elements: (1..4).collect { |num|
				(oscPath: "/1/fader%".format(num).asSymbol)
			}
		),
		(
			key: \bt,
			shared: (elementType: \button, spec: \but, ioType: \inout),
			elements: (1..4).collect { |num|
				(oscPath: "/1/toggle%".format(num).asSymbol)
			}
		),
		(
			key: \accel,
			shared: (elementType: 'accelAxis', ioType: \collectiveIn, \spec: 'accx'),
			elements: [
				(key: \x, style: (height: 2)),
				(key: \y, style: (height: 2)),
				(key: \z, style: (height: 2))
			]
		)
	]
)
);
)
