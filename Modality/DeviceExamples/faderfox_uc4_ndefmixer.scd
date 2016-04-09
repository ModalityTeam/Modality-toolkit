s.boot;
s.latency = 0.03;

// make 11 proxies named a..k with 11 params named a..k
(
~names = "abcdefghijk".collectAs(_.asSymbol, Array);
~names.do { |n|
	Spec.add(n, [100, 1000, \exp]);
	Ndef(n, {
		var freqs = ~names.collect(_.kr);
		Splay.ar(Ringz.ar(Dust.ar(5 ! freqs.size), freqs, 0.2));
	});
	~names.do { |par| Ndef(n).set(par, exprand(100, 1000)) };
};
Ndef(\a).play(vol: 0.1)
)
// make a dict for all faderfox stuff
(
~ff = ();

// make a mixer w 16 chans
~ff.mx = NdefMixer(s, 16);
// make a faderfox mktl;
~ff.mk.free; ~ff.mk = MKtl(\uc4, "*uc4_pg"); ~ff.mk.trace.gui;
~ff.mk.trace(false);

// sliders from first 2 pages softSet ndef volume
~ff.vols = ~ff.mk.elAt([\pgSl1, \pgSl2], \sl).flat;
~ff.vols.do { |el, i|
	el.action = { |el|
		var ndef = ~ff.mx.arGuis[i].object;
		if (ndef.notNil) {
			ndef.softVol_(
				el.value.squared,
				lastVal: el.prevValue.squared
			);
		};
	};
};

// xfader is master vol, always sets
~ff.masta = ~ff.mk.elAt(\xfader);
~ff.masta.action = { |el|
	s.volume.volume = el.value.linlin(0.0, 1.0, -90, 6);
};

// buttons from first 2 pages play/stop
~ff.playBts = ~ff.mk.elAt([\pgSl1, \pgSl2], \bt, \all, \on).flat;
~ff.playBts.do { |bt, i|
	bt.action = {
		var obj = ~ff.mx.arGuis[i].object.postln;
		obj !? { if (obj.monitor.isPlaying) { obj.stop } { obj.play } };
	};
};

// encoder hats from first two pages send ndef to editor
~ff.editHats = ~ff.mk.elAt([\pgKn1, \pgKn2], \pbt, \all, \on).flat;
~ff.editHats.do { |bt, i|
	bt.action = {
		var mongui = ~ff.mx.arGuis[i].postln;
		var obj = mongui.object;
		obj !? { defer { mongui.edBut.doAction } };
	};
};

// knobhats from first 2 pages edit params on editGui
// encoder hats from first two pages send ndef to editor
~ff.editKns = ~ff.mk.elAt([\pgKn1, \pgKn2], \kn).flat;
~ff.editKns.do { |kn, i|
	kn.action = {
		var param, obj = ~ff.mx.editGui.object;
		obj !? {
			param = ~ff.mx.editGui.paramGui.prevState.editKeys[i];
			param !? { RelSet(obj, param, kn.value - 0.5 * 0.25) };
		};
	};
};

)



