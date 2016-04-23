// use launchcontrol XL for JITLib:
// control e.g. first 8 ndefs in a proxymixer/NdefMixer.
//
// * 3 knobs control top 3 params of each proxy
// * 8 sliders do softVol on the proxies
// * upper buttons do play/stop
// * lower buttons send to editGui

(
q = q ? (); // store things by name
// make the Mktl and gui
m = MKtl(\lxl, "*launchcontrol-xl");
m.gui;

// 8 names for the proxies or Ndefs
q.names = "abcdefgh".as(Array).collect(_.asSymbol);

Spec.add(\vsWidth, [0.5, 0.99, -3]);
q[\sndFunc] = { |freq = 100, detune = 2, vsWidth = 0.5|
	VarSaw.ar(freq + [detune.neg, detune], 0, vsWidth) * 0.2;
};


// Ndef / NdefMixer variant
q.pxmix = NdefMixer(s.boot);
// create 8 ndefs for 8 names
q.names.do { |key| Ndef(key, q[\sndFunc]) };
// get proxies by name
q.pxes = q.names.collect { |key| Ndef(key) };


// ... or ProxySpace variant:
p = ProxySpace.push(s.boot);
q.pxmix = ProxyMixer(p);
q.names.collect { |key| p.put(key, q[\sndFunc]) };
// get proxies by name
q.pxes = q.names.collect(p[_]);


// function to get proxies from mixer - works for both:
q.getpxes = { q.pxmix.arGuis.collect(_.object) };

// get a single proxy by index
q.getpxAt = { |q, i| q.getpxes[i] }
// test
q.getpxAt(7);



// Now the LCXL mapping: On page 0 of LC XL:
// 8 sliders softVol first 8 ndef volumes
// 8 upper buttons play/stop
// 8 lower buttons pause/resume
// 8x 3 buttons control first 3 ndef params

// 8 sliders to first 8 ndefs
m.elAt(0, \sl).do { |sl, i|
	sl.action = { |sl|
		var ndef = q.getpxAt(i);
		if (ndef.notNil) {
			ndef.softVol_(sl.value.squared, pause: true, lastVal: sl.prevValue.squared)
		};
	};
};

// 8 upper buttons toggle playing on/off on noteOn:
m.elAt(0, \bt, \fcs, \all, \on).do { |bt, i|
	bt.action = { |sl|
		var ndef = q.getpxAt(i);
		if (ndef.notNil) {
			if (ndef.monitor.isPlaying) { ndef.stop } { ndef.play }
		};
	};
};

// 8 lower buttons send proxy to editGui
m.elAt(0, \bt, \ctl, \all, \on).do { |bt, i|
	bt.action = { |sl|
		var ndef = q.getpxAt(i);
		if (ndef.notNil) {
			q.pxmix.arGuis[0].edBut.valueAction_(1);
		};
	};
};

// 8x 3 buttons softSet first 3 ndef params
m.elAt(0, \kn).do { |kngrp3, parIndex|
	kngrp3.do { |kn, chanIndex|
		kn.action = { |kn|
			var ndef, param, spec;
			ndef = q.getpxAt(chanIndex);
			if (ndef.notNil) {
				param = ndef.controlKeys[parIndex];
				ndef.softSet(param, kn.value, mapped: false, lastVal: kn.prevValue);
			};
		};
	}
};
)
