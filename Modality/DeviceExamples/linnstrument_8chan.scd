MKtl.find(\midi);

k.free; MKtlDesc.allDescs.clear;
k = MKtl('linn', "linnstrument_8chan");
k.gui;
k.trace;
k.trace(false);
// access elements
k.elAt;
k.elAt(\row);
k.elAt(\row, 0);

// sound!
s.boot; s.scope; s.latency = nil;

// example1: sound for a single note
(
Ndef(\linn0).clear;
n = Ndef(\linn0, { |freq=250, ffreq=500, amp=0, pan, res=2, bend|
	var snd = Saw.ar((freq * bend.midiratio).lag(0.1));
	var filt = RLPF.ar(snd, ffreq.lag(0.1), 1/res.lag(0.1));
	Pan2.ar(filt, pan, amp.lag(0.1))
}).play;
n.gui;

// bottom row, elem 13 - center line, above "TRIPLETS"
k.elAt(\row, 0, \pad, 12, \on).action = { |el|
	var note = el.elemDesc.at(\midiNum);
	[el.name, note, el.value].postcs;
	n.set(
		\freq, (note).midicps,
		\amp, \amp.asSpec.map(el.value)
	);
};
// polytouch sets amp
k.elAt(\row, 0, \pad, 12, \touch).action = { |el|
	n.set(\amp, \amp.asSpec.map(el.value).postln);
};

// bend controls pitch
k.elAt(\row, 0, \bend).action = { |el|
	var bendval = el.value.linlin(0, 1, -2, 2);
	// [el.name, bendval.round(0.001)].postln;
	n.set(\bend, bendval);
};

// y-axis changes filterfreq
k.elAt(\row, 0, \padY).action = { |el|
	n.set(\ffreq, el.value.linexp(0, 1, 300, 3000));
};
)







// Example 2: A stick-like instrument with one monophonic string on each row:

s.boot; s.scope; s.latency = nil;

// on linnstrument, per-split settings, switch to LOUDNESS to CHAN PRES
// use channel touch / pressure sets amp to TEST:

k.elAt(\row, \all, \touch).do(_.action = { |el|
	"chan press: ".post; [el.name, el.value.round(0.001)].postcs;
});

// turn debug posting on and off
~trace = false;
~trace = true;

// run all at once
(
// or individually in 3 steps:
(
Ndef(\str8).clear;
Ndef(\str8).play;
Ndef(\str8).gui;
// make a post function
~trace = true;
~postel = { |el ... vals|
	if (~trace) { ([el.name, el.value] ++ vals).round(0.001).postcs; }
};

// put the same soundfunc in slots 1-8
~sndfunc = { |freq=250, ffreq=500, amp=0, pan, res=2, bend|
	var snd = Saw.ar((freq * bend.midiratio).lag(0.1));
	var filt = RLPF.ar(snd, ffreq.lag(0.1), 1/res.lag(0.1));
	Pan2.ar(filt, pan, amp.lag(0.1))
};

(1..8).do { |i| Ndef(\str8).put(i, ~sndfunc) };
);

// add controls for pitch, velocity and channel pressure to amp
(
k.elAt(\row).do { |rowgroup, rowi|
		// note number sets pitch, velocity sets amp
	rowgroup.elAt(\pad, \all, \on).do { |el, coli|
		el.name.postcs;
		el.action = { |el|
			var note = el.elemDesc.at(\midiNum);
			~postel.(el, note, rowi + 1);
			Ndef(\str8).setAt(rowi + 1,
				\freq, (note).midicps,
				\amp, \amp.asSpec.map(el.value)
			);
		};
	};
	// use channel touch / pressure sets amp
	rowgroup.elAt(\touch).action = { |el|
		~postel.(el);
		Ndef(\str8).setAt(rowi + 1, \amp, \amp.asSpec.map(el.value));
	};
};
);


// bend controls pitch, per row
(
k.elAt(\row, \all, \bend).do { |el, rowi|
	el.action = { |el|
		var bendval = el.value.linlin(0, 1, -2, 2);
		~postel.(el);
		Ndef(\str8).setAt(rowi + 1, \bend, bendval);
	};
};

// y-axis changes filterfreq, per
k.elAt(\row, \all, \padY).do { |el, rowi|
	el.action = { |el|
		var filtval = el.value.linexp(0, 1, 300, 3000);
		~postel.(el, filtval);
	//	Ndef(\str8).setAt(rowi + 1, \ffreq, filtval);
	};
};
);
)
