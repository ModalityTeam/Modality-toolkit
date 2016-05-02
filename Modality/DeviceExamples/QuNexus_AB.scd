// QuNexus has four modes:
// Preset A uses just noteOn/Off and channel bend
// Preset B adds channel pressure
// -> desc "*qunexus*AB" covers both A and B;

// Preset C allocates notes to 10 rotating midi chans,
// and sends poly bend and pressure mod (cc1) on those chans

// Preset D is for drums (uses chan 10) and clips


// code example for global note responder + voicer:
MKtl.find(\midi);
z = MKtl('qnxs0', "*qunexus*AB");

// a debug post for all elements:
z.elAt.action = { |el| [el.name, el.value].postln };
z.elAt.action = nil;

// make an NPVoicer, use with \default synthdef:
s.boot; s.latency = nil;
v = NPVoicer(Ndef(\piano)).play;
v.prime(\default);

// make a global noteOn function,
MFdef(\qn_on).add(\debug, { |el| el.postln });

// and add it to all on elements
z.elAt(\pk, \all, \on).do(_.action_( MFdef(\qn_on)));

// add a noteOn
MFdef(\qn_on).add(\note1, { |el, grp|
	var note = el.elemDesc[\midiNum];
	var vel = el.value;
	v.put(note, [\freq, note.midicps, \amp, vel.squared ].postln);
});

MFdef(\qn_off).add(\debug, { |el| el.postln });
MFdef(\qn_off).add(\note1, { |el| v.release(el.elemDesc[\midiNum].postln) });

z.elAt(\pk, \all, \off).do(_.action_( MFdef(\qn_off)));

z.elAt(\bend).action = nil;

z.elAt(\bend).action = { |el|
	// bend only covers part of the 14bit range,
	// so scale observed min/max to +- semitones:
	var bendVal = el.deviceValue.linlin(6784 + 128, 9472, -2, 2);
//	[\bend, el.deviceValue, bendVal].postcs;
	v.proxy.objects.do { |obj, noteKey|
	//	[obj, noteKey].post;
		obj.set(*[\freq, (noteKey + bendVal)].midicps);
	}
};

z.elAt(\monotouch).action = { |el|
	var touchVal = el.value.postln;
	v.proxy.objects.do { |obj, noteKey|
		[\touch, noteKey].post;
		obj.set(*[\amp, touchVal.squared].postln);
	}
};


MIDIFunc.trace;
MIDIFunc.trace(false);

/*********  not working yet:

* Preset C, poly bend and pressure with channel-based polyphony;
	should be done with:

MChanVoicer.openHelpFile

* Preset D is for drums (uses chan 10) and clips,
  to be done when someone wants to use it.

*/

