// QuNexus has four modes:
// Preset A uses just noteOn/Off and channel bend
// Preset B adds channel pressure
// Preset C allocates notes to 10 rotating midi chans,
// and sends poly bend and pressure mod (cc1) on those chans
// Preset D is for drums (uses chan 10) and clips


// mini code example for global note resp + voicer:
MKtl.find(\midi);
z =  MKtl('qnxs0', "keith-mcmillen-qunexus", );

// fix the srcID - take the first one
x = MIDIClient.sources.collect(_.uid);
z.mktlDevice.prSetSrcID(x[0]); //

// then free the responders and remake them
z.mktlDevice.responders.do(_.free);
z.mktlDevice.makeRespFuncs;

// a debug post for all elements:
z.elements.action = { |el| [el.name, el.value].postln };

// make an NPVoicer, use with \default synthdef:
s.boot; s.latency = nil;
v = NPVoicer(Ndef(\piano)).play;
v.prime(\default);

// add a noteOn function
z.elementAt(\keyOn).action = MFunc(
	[ \debug, { |el, grp| [el.name, grp.name].postln } ]
);

z.elementAt(\keyOn).action.add(\note1, { |el, grp|
	var note = el.elementDescription[\midiNum];
	var vel = el.value;
	v.put(note, [\freq, note.midicps, \amp, vel.squared ].postln);
});

z.elementAt(\keyOff).action = MFunc([
	\debug, { |el, grp| [el.name, grp.name].postln },
	\note1, { |el, grp| v.release(el.elementDescription[\midiNum]) }
]);

z.elementAt(\bend).action = { |el|
	// bend only covers part of the 14bit range,
	// so scale observed min/max to +- semitones:
	var bendVal = el.deviceValue.linlin(6784 + 128, 9472, -2, 2);
//	[\bend, el.deviceValue, bendVal].postcs;
	v.proxy.objects.do { |obj, noteKey|
	//	[obj, noteKey].post;
		obj.set(*[\freq, (noteKey + bendVal)].postln.midicps);
	}
};



/*********  not working yet:
/////// Preset B, use channel \touch
z.elementAt(\touch).action = { |el|
	var touchVal = el.deviceValue.postln;
	[\touch, el.deviceValue, touchVal].postcs;
	v.proxy.objects.do { |obj, noteKey|
	//	[obj, noteKey].post;
	//	obj.set(*[\amp, ].postln.midicps);
	}
};

// Preset C, poly bend and pressure:
// Rather than using multiple bend and cc elements for each channel,
// use global responders, and use channel as info for an NPVoicer.

// same as above, switch to Preset C
// works in principle,
// but better write a synthdef that has nice responses.

q = q ? (); q.chanNotes =  q.chanNotes ? ();

z.global[\noteOn].add(\note1, { |chan, note, vel|
	q.chanNotes.put(chan, note);
	v.put(chan, [\freq, note.midicps, \amp, (vel/127) ].postln);
});
z.global[\noteOff].add(\note1, { |chan, note|
	v.release(chan);
	q.chanNotes.removeAt(chan);
});

z.global[\cc] = MFunc();
z.global[\cc].add(\mod, { |chan, ccnum, val|
	if (ccnum == 1) { v.setAt(chan, \amp, val/127) };
});
z.global[\bend] = MFunc();
z.global[\bend].add(\pitch, { |chan, val|
	var bend = (val - 8192).linlin(-1500, 1500, -2, 2).postln;
	v.setAt(chan, \freq, (q.chanNotes[chan] + bend).postln.midicps.postln);
});

*/

