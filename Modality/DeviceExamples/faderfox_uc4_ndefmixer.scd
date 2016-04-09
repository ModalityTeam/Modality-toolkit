s.boot; s.latency = 0.03;

// test setup:
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
// make a faderfox mktl;
~ff.free; ~ff = MKtl(\uc4, "*uc4_pg");
~ff.addHalo(\gui, ~ff.gui);
~ff.addHalo(\mx, NdefMixer(s, 16));

// sliders from first 2 pages softSet ndef volume
~ff.addNamed(\vols, ~ff.elAt([\pgSl1, \pgSl2], \sl).flat);
~ff.elAt(\vols).do { |el, i|
	el.action = { |el|
		var ndef = ~ff.getHalo(\mx).arGuis[i].object;
		if (ndef.notNil) {
			ndef.softVol_(
				el.value.squared,
				lastVal: el.prevValue.squared
			);
		};
	};
};

// xfader is master vol, always sets
~ff.addNamed(\masta, ~ff.elAt(\xfader));
~ff.elAt(\masta).action = { |el|
	s.volume.volume = el.value.linlin(0.0, 1.0, -90, 6);
};

// buttons from first 2 pages play/stop
~ff.addNamed(\playBts, ~ff.elAt([\pgSl1, \pgSl2], \bt, \all, \on).flat);
~ff.elAt(\playBts).do { |bt, i|
	bt.action = {
		var pbut = ~ff.getHalo(\mx).arGuis[i].monitorGui.playBut;
		defer { pbut.valueAction_(1 - pbut.value) };
	};
};

// encoder hats from first two pages send ndef to editor
~ff.addNamed(\editHats, ~ff.elAt([\pgKn1, \pgKn2], \pbt, \all, \on).flat);
~ff.elAt(\editHats).do { |bt, i|
	bt.action = {
		var mongui = ~ff.getHalo(\mx).arGuis[i].postln;
		var obj = mongui.object;
		obj !? { defer { mongui.edBut.doAction } };
	};
};

// encoders from first two pages do relative sets on editgui params
~ff.addNamed(\editKns, ~ff.elAt([\pgKn1, \pgKn2], \kn).flat);
~ff.elAt(\editKns).do { |kn, i|
	kn.action = {
		var mx = ~ff.getHalo(\mx);
		var param, obj = mx.editGui.object;
		obj !? {
			param = mx.editGui.paramGui.prevState.editKeys[i];
			param !? { RelSet(obj, param, kn.value - 0.5 * 0.25) };
		};
	};
};
)
