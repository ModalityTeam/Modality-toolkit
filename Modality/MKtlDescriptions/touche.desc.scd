/*

This controller comes in two variants: SE (which does not have mahogani) and another version with mahogani, both should work the same with this desc.

It has 4 "shiftings" of sensitivity (left, right, top, bottom) which are available here, but also an encoder which is used to adjust the sensitivity of the device (not available here).

----- Test code -----
m = MKtl('touchy', "touche");

// A Sine wave for each corner of the controller
(
var minfreq=80, maxfreq=2500;

// A feedback sine wave for each corner of the controller
Ndef(\fourSines, {|f1, f2, f3, f4, fb1=0.5, fb2=0.5, fb3=0.5, fb4=0.5 amp=0.25|
	amp*Splay.ar(SinOscFB.ar([f1,f2,f3,f4], [fb1, fb2, fb3, fb4]))
}).play;

Ndef(\fourSines)[1] = \filter -> {|in, verb=0.5|
	FreeVerb2.ar(in[0], in[1], 1, verb.linlin(0.0,1.0,5.0,0.0001), 0.1)
};

Ndef(\fourSines)[2] = \filter -> {|in, pitch=0.5|
	PitchShift.ar(in, 0.25, pitch.linlin(0.0,1.0,0.1,4.0), pitch/4, pitch/3)
};

m.elAt('sl', 'top').action = {|el|
	Ndef(\fourSines).set(
		\f1, el.value.linexp(0.0,1.0,minfreq,maxfreq),
		\fb4, el.value,
		\verb, el.value
	)
};

m.elAt('sl', 'bottom').action = {|el|
	Ndef(\fourSines).set(
		\f2, el.value.linexp(0.0,1.0,minfreq,maxfreq),
		\fb3, el.value,
		\pitch, el.value,
	)};

m.elAt('sl', 'left').action = {|el|
	Ndef(\fourSines).set(
		\f3, el.value.linexp(0.0,1.0,minfreq,maxfreq),
		\fb1, el.value,
		\wet1, el.value
	)};

m.elAt('sl', 'right').action = {|el|
	Ndef(\fourSines).set(
		\f4, el.value.linexp(0.0,1.0,minfreq,maxfreq),
		\fb2, el.value,
		\wet2, el.value
	)
};

)
*/

(
deviceName: "touche",
protocol: 'midi',
deviceType: 'controller',
// elementTypes: [],
status: (
	linux: "tested 22-01-2020 by Mads Kjeldgaard",
	osx: "unknown",
	win: "unknown"
),
idInfo: "TOUCHE_SE",
deviceInfo: (
	vendorURI: 'https://www.expressivee.com/touche-se',
	manualURI: 'https://www.expressivee.com/media/downloadable/files/ee/TOU002-Touche_SE/touche_se_manual.pdf',
	description: "A touch controller with 4 axis and an encoder to adjust sensibility",
	//features: [],
	//hasScribble: false
),
elementsDesc: (
	elements: [
		(
			key: \sl,
			shared: ('midiChan': 0, 'midiMsgType': 'cc', 'elementType': 'slider', 'spec': 'midiCC'),
			elements:
			[
				( key: \bottom, midiNum: 16 , style: (row: 0, column: i, width: 1, height: 8) ),
				( key: \top, midiNum: 17 , style: (row: 0, column: i, width: 1, height: 8) ),
				( key: \left, midiNum: 18 , style: (row: 0, column: i, width: 1, height: 8) ),
				( key: \right, midiNum: 19 , style: (row: 0, column: i, width: 1, height: 8) ),
			]
		)
	]
)
);