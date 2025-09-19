/********
Receive LeapMotion 1 via Geco in SC, 2025, adc.
1. Open the GECO app 2.1.0
2. load leap_OSCSend2SC.geco
- this switches all outs to OSC, with geco default names,
- and sends to localhost, SC default port 57120.
- can check these in File -> Document settings.

3. in SC, check that NetAddr.langPort really is 57120
NetAddr.langPort;
OSCdef.trace(false, true);
OSCdef.trace(true, true);

// catch all messages with OSCMon:
o = OSCMon.new;			// make an OSCMon
o.enable;               // turn it on
o.show;                 // show them on gui

MKtlDesc("leap_geco");
MKtl(\leap, "leap_geco");
MKtl(\leap).gui
MKtl(\leap).postElements

// geco always starts with a new sending port,
// so you can use this OSCdef to detecta leap,
// and update sender and destination address to connect:

OSCdef(\detectLeap, { |msg, t, sender|
	"*** LEAP detected!".postln;
    sender.postln;
	MKtl(\leap).device.updateSrcDstAddr(sender.hostname, sender.port);
	OSCdef(\detectLeap).disable;
	"*** LEAP connected, detection disabled.".postln;
}, '/left/closed/present').enable;

// this is the list of single oscpaths:
[
	'/left/closed/present',
	'/left/closed/posx',
	'/left/closed/posy',
	'/left/closed/posz',

	'/left/closed/movx',
	'/left/closed/movy',
	'/left/closed/movz',
	'/left/closed/pitch',
	'/left/closed/roll',
	'/left/closed/yaw',

// same for
	'/left/open/...',
	'/right/closed/...',
	'/right/open/...',
];

*****/

(
deviceName: "leapGeco",
protocol: \osc,
deviceType: \handTracker,
elementTypes: [\fader, \button],
status: (
	linux: "unknown",
	osx: "tested and working. 2025-09-16, adc.",
	win: "unknown"
),

idInfo: "leapGeco",
// recvPort will default to NetAddr.langPort
netAddrInfo: (srcPort: 58222, recvPort: 57120, ipAddress: "127.0.0.1"),

deviceInfo: (
	longName: "leap motion 1 via Geco"
),

// seem to be the max accel values on iphone
specs: (
	'present': [0, 1, \lin, 1],
	'posx': \pan,
	'posy': \unipolar,
	'posz': \pan,
	'movx': \pan,
	'movy': \pan,
	'movz': \pan,
	'pitch': \pan,
	'roll': \pan,
	'yaw': \pan
),

elementsDesc: (
	elements: [ \left, \right ].collect { |side, i|
		(
			key: side,
			elements: [ \open, \closed ].collect { |handstate, j|
				(
					key: handstate,
					elements: [
						'present',
						'posx',
						'posy',
						'posz',
						'movx',
						'movy',
						'movz',
						'pitch',
						'roll',
						'yaw',
					].collect { |key, k|

						(key: key, spec: key, elementType: \slider,
							oscPath: "/%/%/%".format(side, handstate, key));

					}
				)
			}
		)
	}
);
)

