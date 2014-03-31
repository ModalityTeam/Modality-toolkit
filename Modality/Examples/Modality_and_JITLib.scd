// TODO
// * fix overwriting of kn_1_3 by but_4_2_1
// * check whether there are any other clashes of cc numbers !
// * make a fake gui replacement for nano1!

// later:
// * implement shifting when more than 8 volume slots
// * and param sliders (same as NanoKtl pxShift, paramShift)


///////////////////////////////////////////////
/**** Using Modality with JITLib objects *****/


// this demo goes thru some examples for how one can
// use modality controllers with JITLib proxies.

// find a midi controller; here it is a NanoKontrol 1

MIDIMKtl.find;

q = q ? ();
q.nk1 = MIDIMKtl('nnkn0');

// check to see values, element names, cc numbers etc:
q.nk1.verbose = true
q.nk1.verbose = false

// TODO - make a fake gui replacement nano1 here!

// give the play button an action
q.nk1.at(\play).action = { "yo, play!".postln };

// better do that only on button value 1,
// i.e. when pressed, not on release :
q.nk1.at(\play).action = { |but| if (but.value > 0) { "yo, play!".postln }; };


// make a proxy space
p = ProxySpace.push(s.boot);

// create a silly proxy, and play it
~x = { |a, b, c, d, e| Splay.ar(Blip.ar(2 + [a, b, c, d, e] * 100, 4)) * 0.2  };
~x.play;
// add a spec to ~x
// - this requires JITLibExtensions ATM
~x.addSpec(\a, [-1, 1]);

// add multiple specs at once to ~x
~x.addSpec(\a, \pan,
	\b, \pan,
	\c, \pan,
	\d, \pan,
	\e, \pan
);
// this is where the specs now live:
~x.getHalo;

// same with proxy ~y
~y = { |a, b, c, d, e| Splay.ar(Blip.ar(3 + [a, b, c, d, e] * 100, 3)) * 0.2  };
~y.stop;

// different way to add specs:
~y.controlKeys;// which ones are there?
// same names, different ranges from ~x
~y.controlKeys.do (~y.addSpec(_, [-2, 2]));
~y.getHalo;

q.nk1.verbose = true
//

// get a single slider from q.nk1 by raw name,
// and let it post its value
q.nk1.at(\sl_1_1).action = { |el| el.value.postln };

// access by hierarchical names, special method
// index starts with 1 because numbering on controller does
q.nk1.elementAt(\sl, 1, 1).action.postcs

// access by hierarchical names and at method
// index starts with 0
q.nk1.elements[\sl][0][0].action.postcs

// make a gui so you see the values change
q.ndg = NdefGui(~x, 8).moveTo(0, 200);
q.ndg.skipjack.dt = 0.05; // make display updates faster


// MAP TO A PROXY DIRECTLY:
// this is independent of any guis,
// and is nice for playing without screen.

//  map knobs 1-8 to the first max 8 control inputs of ~x
q.nk1.elements[\kn][0].drop(-1).do { |el, i|
	var paramKey = ~x.controlKeys[i].postcs;
	if (paramKey.notNil) {
		el.action_ { ~x.setUni(paramKey, el.value) }
	};
};

// make the last knob set proxy volume
q.nk1.elements[\kn][0].last.action_({ |el| ~x.vol_(el.value.squared.postln) });



// <proxy>.setUni tells the proxy to use the specs it has for
// the param in question.


// JITGui EXAMPLE 1: MAP TO AN NDEF GUI
// we made this NdefGui earlier
// q.ndg = NdefGui(~x, 8).moveTo(0, 200);

//  map knobs 1-8 to the 8 slots of NdefGui
q.nk1.elements[\kn][0].drop(-1).do { |el, i|
	var paramKey = q.ndg.editKeys[i].postcs;
	if (paramKey.notNil) {
		el.action_ { q.ndg.object.setUni(paramKey, el.value) }
	};
};

// set q.ndg to show proxy ~y,
// then q.nk1 sets that proxy's params:
q.ndg.object_(~y);


// JITGui EXAMPLE 2: MAP TO A ProxyMixerGUI
// ProxyMixer shows all the proxies in a proxyspace,
// one can balance their levels, play/stop them,
// and edit the params of one selected proxy.

// this example rebuilds most of what the NanoKtl class did:

// * nano rightmost slider controls master volume of server

// * nano sliders control proxy play levels
// * upper nano buttons send proxies to the editGui,
// * lower nano buttons control play/stop

// * knobs control params on the proxy in the editGui
// * rightmost knob controls edited proxy's volume



// rightmost slider goes to server volume in all scenes
s.makeWindow; // so you see it change
// add a global spec for master volume
Spec.add(\mastaVol, [s.volume.min, s.volume.max, \db]);
4.do { |scene|
	q.nk1.elements[\sl][scene].last.action_({ |el|
		s.volume.volume_(\mastaVol.asSpec.map(el.value.postln))
	});
};

// now make a proxymixer
q.pxmx = ProxyMixer(p);

// add a dict for lastVals, so when can use softSet and softVol
// for smooth takeover when midi faders are far away from the
// current setting
q.nk1.addHalo(\lastVal, ());

// map each slider but the last to a proxy in the mixer slot
// and remember the sliders last value for softSet
q.nk1.elementAt(\sl, 1).drop(-1).do { |el, i|
	el.action_ { |el|
		var proxy = q.pxmx.arGuis[i].object;
		var lastVal;
		if (proxy.notNil) {
			lastVal = q.nk1.getHalo(\lastVal, el.name);
			proxy.softVol_(el.value, lastVal: lastVal);
			q.nk1.addHalo(\lastVal, el.name, el.value);
		};
	};
};

// upper buttons send proxy to editGui:
q.nk1.elementAt(\but, 1, 1).drop(-1).do { |el, i|
	el.action_ { |el|
		var proxy;
		if (el.value > 0) { // only on downclick
			proxy = q.pxmx.arGuis[i].object;
			if (proxy.notNil) {
				defer {
					q.pxmx.editGui.object_(proxy);
					q.pxmx.switchSize(2);
			} };
		};
	};
};


// lower buttons toggle proxy play/stop
q.nk1.elementAt(\but, 1, 2).drop(-1).do { |el, i|
	el.action_ { |el|
		var proxy;
		if (el.value > 0) { // only on downclick
			proxy = q.pxmx.arGuis[i].object;
			if (proxy.notNil) {
				if (proxy.monitor.isPlaying) { proxy.stop } { proxy.play };
			};
		};
	};
};

// knobs 1 - 8 set editGui params, last knob softSets
// edited proxy volume

q.nk1.elementAt(\kn, 1).drop(-1).do { |el, i|
	el.action_ { |el|
		var editGui = q.pxmx.editGui;
		var proxy = editGui.object;
		var lastVal, paramName, paramSpec;
		if (proxy.notNil) {
			lastVal = q.nk1.getHalo(\lastVal, el.name);
			paramName = editGui.editKeys[i];
			proxy.softSet(editGui.editKeys[i],
				proxy.getSpec(paramName).map(el.value),
				lastVal: lastVal);
			q.nk1.addHalo(\lastVal, el.name, el.value);
		};
	};
};


// TODO:
// * implement shifting when more than 8 volume slots
// * and param sliders (same as NanoKtl pxShift, paramShift)

