
/*
ha's ver 2, according to custom Layout "RelativelyGlobal"

Use relative control scheme on the knobs:
* this avoids parameter jumps completely
* no need to update the device element values
* no need for softSet or other special synching solution.


Instructions:

1. get Arturia MIDI control center app
2. connect beatstep
3. load RelativelyGlobal.beatstep file into device
4. switch to that setup on the beatstep

// now test with the device
MKtl.find(\midi);

k.free;
k = MKtl('abs', "*step-rel-16");
k.gui;
k.trace(true);
k.trace(false);

// top group has 16 pages:
k.elAt
// one can switch with 16 midichans: hold 'chan', press pad number 12 to set to chan 12


k.elAt(0) // first page
// add first page under name 'curr'
k.addNamed(\curr, k.elAt(0));
k.elAt(\curr);

// or all elements of say page 0 group to namedDict:
k.elAt(0).do { |grp| k.addNamed(grp.name, grp) };
k.addNamed(\bigKnob, k.elAt(0, \bigKnob));
k.namedDict.keys

// now group '1' is in front, and one can access its pads directly:
k.elAt(\pad);



// now the same examples as in arturia-beatstep-rel-0 work:

s.boot;

Ndef(\test, { |amp = 0.2, cutoff = 1000, reso = 5|
	RLPF.ar(Saw.ar(50, amp ! 2), cutoff, 1/reso);
}).play;

Ndef(\test).addSpec(\cutoff, [800, 10000, \exp]);
Ndef(\test).addSpec(\reso, [0.5, 100, \exp]);
Ndef(\test).edit;

// do relative set on parameters with RelSet class
k.elAt(\kn, 0).action = { |el| RelSet(Ndef(\test), \amp, el.value - 0.5 ) };
k.elAt(\kn, 1).action = { |el| RelSet(Ndef(\test), \cutoff, el.value - 0.5) };
k.elAt(\kn, 2).action = { |el| RelSet(Ndef(\test), \reso, el.value - 0.5) };


// do relative volume of ndef step by step
k.elAt(\bigKnob).action = { |el|
	var ampspec = \amp.asSpec;
	var currvol = Ndef(\test).vol;
	var delta = el.value - 0.5;
	var newvol = ampspec.unmap(currvol) + delta;
	newvol = ampspec.map(newvol);
	Ndef(\test).vol_(newvol)
};

// or more compact:
k.elAt(\bigKnob).action = { |el|
	var spec = \amp.asSpec;
	var newUnmappedVol = spec.unmap(Ndef(\test).vol) + (el.value - 0.5);
	Ndef(\test).vol_(spec.map(newUnmappedVol))
};

// both should eventually be done with SmartSetter.


// some example actions for the pads and buttons:
k.elAt(\pad).action = { |el| [el.name, el.value.round(0.001)].postln };
k.elAt(\pad).action = nil;

k.elAt(\pad, 0, \on).do(_.action = { |el| "1 ON vel: %\n".postf(el.value.round(0.001)) });
k.elAt(\pad, 0, \off).do(_.action = { |el| "1 Off vel: %\n".postf(el.value.round(0.001)) });
k.elAt(\pad, 0, \touch).do(_.action = { |el| "1 touch: %\n".postf(el.value.round(0.001)) });

// stop and play on press only,
k.elAt(\stop, \on).action = { |el| "STOP!".postln };
k.elAt(\play, \on).action = { |el| "PLAY!".postln };

k.elAt(\stop, \off).action = { |el| "stop button released.".postln };

*/

(
deviceName: "Arturia BeatStep",
protocol: \midi,
deviceType: \multiController,
elementTypes: [\encoder, \button],
status: (
	linux: "unknown",
	osx: "tested and working. 2015-03-15, adc",
	win: "unknown"),

idInfo: "Arturia BeatStep",

deviceInfo: (
	vendorURI: "https://www.arturia.com/products/hybrid-synths/beatstep",
	manualURI: "http://downloads.arturia.com/products/beatstep/manual/BeatStep_Manual_1_0_1_EN.pdf",
	// description: "",
	features: [
		"16 drum pads with velocity and polyphonic aftertouch",
		"16 rotary encoders; supporting absolute and dec/inc mode",
		"1  BIG rotary encoder; supporting absolute and dec/inc mode",
		"2  Buttons: play, pause, that send MMC by default",
	],
	notes:
	"- Desc file for use with HH's custom HW Template \"Relatively#1Global\":
- all knobs send Relative mode #1 with fast Acceleration
- all controllers send on global channel
- only for Relative mode: sends CCvalues 63/65 for dec/inc, a maximum of 42, 86 with Fast Acceleration
- 16 glob. MIDI channels can be easily switched on HW (CHAN Button plus 1 of 16 Pads), so use that as 16 pages w' identical cc/midi nr's.
- alternatively/additionally, 16 layout 'templates' with different CC assignments could be created and easily switched on HW (RECALL Button plus 1 of 16 Pads), but that's a lot of work to edit, and 256 pages are a bit too much anyways?
- can MMC be read? For now, the 2 transport buttons are remapped to NoteOn/Offs.
ToDo:
-add paging via 16 MIDI Chans
",
	longName: "Arturia Beatstep (Rel16 custom)."

),

specs: (midiCCrel_64_22: [42, 86, \lin, 1].asSpec), // absolute maxima with fast accel.

elementsDesc: (
	elements: (0..15).collect { |chan, i|
		(
			shared: (midiChan: chan, page: i),


			elements: [
				(
					key: \stop,
					groupType: \noteOnOffBut,
					shared: (elementType: 'pad', midiNum: 1, spec: \midiBut,
						groupType: \noteOnOffBut,
						style: (row: 2, column: 0, height: 0.75)
					)
				),
				(
					key: \play,
					groupType: \noteOnOffBut,
					shared: (elementType: 'pad', midiNum: 1, spec: \midiBut,
						groupType: \noteOnOffBut,
						style: (row: 2, column: 1, height: 0.75)
					)
				),

				(
					key: \pad,
					shared: (elementType: 'pad', spec: 'midiVel'),
					elements: (36 + ((8..15)++(0..7))).collect { |num,i|
						(
							groupType: \noteOnOffTouch,
							shared: (midiNum: num,
								groupType: \noteOnOffTouch,
								style: (row: (i div: 8 + 2), column: i % 8 + 2,
									height: 1)
							)
						)
					}
				),
				(
					// relative - inc/dec !
					key: \kn,
					shared: (midiMsgType: 'cc', elementType: 'encoder',
						spec: 'midiCCrel_64_22'),
					elements: [
						[ 10, 74, 71, 76, 77, 93, 73, 75],
						[114, 18, 19, 16, 17, 91, 79, 72]
					].flat.collect { |num, i|
						( midiNum:  num,

							style: (row: (i div: 8), column: i % 8 + 2)
						)
					}

				),
				(
					// relative - inc/dec !
					key: \bigKnob, midiMsgType: 'cc', elementType: 'encoder',
					spec: 'midiCCrel_64_22', // [56, 72, \lin, 1].asSpec,
					midiNum: 7,  // big knob
					style: (row: 0, column: 0, height: 2, width: 2)
				)
			]
		)
	}
)
)
