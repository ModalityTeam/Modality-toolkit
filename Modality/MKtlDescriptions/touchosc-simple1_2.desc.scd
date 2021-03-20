/****************************
MKtl support for touchOSC, Layout Simple, all 4 pages
( more touchOSC layouts may be added later, in new desc files )

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
s.quit;
OSCFunc.trace(false);
// * if nothing, check again that touchosc sends to SC's langPort:
NetAddr.langPort;

// now make our touchosc MKtl from this desc file:
t.free; MKtlDesc.loadDescs("touchosc-simple*");
t = MKtl(\tosc12, "touchosc-simple1_2");
t.gui;
// set the address to the one you see in the trace:
t.device.updateSrcDstAddr("192.168.178.55", 9000);


// in the touchOSC app, Connections, OSC find Local IP address:
// this is the IP of the smartphone, which touchOSC sends from.
// trace in SC to see the same address that touchOSC sends from:
OSCFunc.trace(true, true);
// and turn off tracing.
OSCFunc.trace(false);


// and give it an example action for all its elements
t.elAt.action = { |el|
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
	linux: "unknown after refactor",
	osx: "tested and working. 2016-04-10, adc.",
	win: "unknown after refactor"
),

idInfo: "touchOSC",
// nil gets replaced with NetAddr.langPort
netAddrInfo: (srcPort: 9000, recvPort: 57120, ipAddress: "192.168.178.55"),

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
        ),
        xy: (
            oscPath: '/3/xy',
            elements: [ [\xy, \x], [\xy, \y]],
            ioType: \in
        )
    ),
elementsDesc: (
	elements: [
		// page 1
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
		),
		///// page 2 on Layout Simple
		(
			key: \pb,
			shared: (elementType: \button, spec: \but, ioType: \inout),
			elements: (1..16).collect { |num, i|
				(oscPath: "/2/push%".format(num).asSymbol,
					style: (column: i % 4 + 4, row: i div: 4)
				)
			}
		),
		(
			key: \bt2,
			shared: (elementType: \button, spec: \but, ioType: \inout),
			elements: (1..4).collect { |num, i|
				(oscPath: "/2/toggle%".format(num).asSymbol,
					style: (column: i % 4 + 4, row: 4)
				)
			}
		),

		////// page 3 -
		/////// xy collective not working yet ...
		/////// and xy should have a Slider2D as GUI ...
		(
			key: \xy,
			shared: (elementType: 'accelAxis', ioType: \collectiveIn, \spec: 'accx'),
			elements: [
				(key: \x, style: (row: 0, column: 8, width: 4, height: 1)),
				(key: \y, style: (row: 1, column: 9.5, width: 1, height: 3)),
			]
		),
		(
			key: \bt3,
			shared: (elementType: \button, spec: \but, ioType: \inout),
			elements: (1..4).collect { |num, i|
				(oscPath: "/3/toggle%".format(num).asSymbol,
					style: (column: i % 4 + 8, row: 4)
				)
			}
		),
		// page 4
		(
			key: \m,
			shared: (elementType: \button, spec: \but, ioType: \inout),
			elements: (1..64).collect { |num, i|
				var col = i % 8, row = i div: 8;
				(
					oscPath: "/4/multitoggle/%/%".format(col + 1, row + 1).asSymbol,
					style: (column: col / 2 + 12, row: row / 2,
						width: 0.6, height: 0.6
					)
				)
			}
		),
		(
			key: \bt4,
			shared: (elementType: \button, spec: \but, ioType: \inout),
			elements: (1..4).collect { |num, i|
				(oscPath: "/4/toggle%".format(num).asSymbol,
					style: (column: i % 4 + 12, row: 4)
				)
			}
		),
	]
)
);
)
