Influx can remap many to many parameters, by allowing every
input param to influence any output param by a given weight.
An initial matrix of weights can be generated randomly and
modified.

One typical use would be with sound processes or patterns
with too many input parameters: Rather than mapping one control
to each param, one can entangle rather fewish control parameters
with the big bundle of process control inputs.

Another use would be using the same param names for in and output,
starting with neutral weights like [0,0,1,0] where each param
only influences its same-named output. Then one can introduce
"entaglement" between params by ading random deviations to the weights.

ToDo:
* use full specs for params?
* use multisiders for display and editing weights
* write up entaglement example
* shift param centers, scale deviation ranges
   to zoom in on interesting areas
* add warp tables or envelopes as alternatives to linear scaling
* add LFO-style automation


// make an influx
a = Influx([\x, \y], [\a, \b, \c,\d, \e, \f, \g, \h], (x: 0.5, y: 0.1));

// internal state
/*
a.inNames
a.outNames
a.inValDict
a.weights   // randomly initialized
a.specs;    // specs will be done fully later
*/

a.rand(0.5);// randomize by an amount between 0 and 1
a.weights.round(0.01); // read the weights now
a.outValDict;          // still empty

a.set(\x, 1.0.rand2, \y, 1.0.rand2); // set to something
a.outValDict;       // outvalues created automatically



///// guis for understanding and testing
(
p = a.weights.flop.plot("a.weights", Rect(320, 800, 200, 200));

w = Window("Influx control", Rect(0, 800, 300, 200)).front;
w.layout = VLayout(
	HLayout(
		VLayout(
			StaticText(w, 190@20).string_("Change Influx weights:"),
			Button(w, 190@20).states_([["drift"]])
			   .action_({ a.rand(0.23); p.value_(a.weights.flop); }),
			Button(w, 190@20).states_([["surprise"]])
			   .action_({ a.rand(0.38); p.value_(a.weights.flop); }),
			Button(w, 190@20).states_([["mystery"]])
			   .action_({  a.rand(062); p.value_(a.weights.flop); }),
			Button(w, 190@20).states_([["RANDOM"]])
			   .action_({  a.rand(1.0); p.value_(a.weights.flop); })
		),
		VLayout(
			StaticText(w, 190@20).string_("Change Influx inputs:"),
			Slider2D(w, 190@190)
			    .action_({|sl| a.set(\x, sl.x * 2 - 1, \y, sl.y * 2 - 1); })
		)
	)
);

w = Window("Influx2 state", Rect(0, 300, 400, 300)).front;
w.addFlowLayout;
StaticText(w, 390@20).string_("Influx values:");

[a.inValDict, a.outValDict].collect { |dict, i|
		var eg = EnvirGui(nil, [4, 8][i], w, 380@100, options: [\name]);
		eg.name_(["ins", "outs"][i]);
		eg.specs.putAll(a.specs);
		eg.object_(dict);
	    eg.skipjack.dt = 0.1;
	}
)

//// more tests by code
a.set(\x, 1.0, \y,0);
a.set(\x, 1.0.rand2, \y, 1.0.rand2);

// add an action to perform when outvals change
a.action.add(\test, { |influx| influx.outValDict.collect(_.round(0.01)).postln });


       // try playing a boring sound with too many parameters
(
Spec.add(\intv, [-24, 24]);
Spec.add(\timescale, [0.01, 10, \exp]);
Spec.add(\curve, [-10, 10]);
Spec.add(\ffreq, \freq);
Spec.add(\loopnode, [0, 12]);

Spec.add(\dens, [10, 1000]);
Spec.add(\resfreq, \freq);
Spec.add(\ringtime, [0.01, 1, \exp]);


Ndef(\a, { |freq=250, intv=19, timescale=1, curve=0, loopnode=0, dens = 10, resfreq = 500, ringtime = 0.01|
	var n = 15;
    var env = EnvGen.kr(
		        Env({ 1.0.rand2 }!(n+1), {1.0.rand}!n, curve, releaseNode: n-1, loopNode: loopnode.min(n-3)),
        timeScale: timescale);
    var pitch = (env * [1, 0.33, -1] * intv).midiratio * freq;
	var form = Formant.ar(pitch, pitch.rotate(1) * 1.6, pitch.rotate(2) * 2.6);
	var dusty = Ringz.ar(Dust.ar(dens!3), resfreq * LFNoise0.kr([3, 5, 7], 0.5, 1), ringtime) * ((dens ** -0.5) * (ringtime ** -0.3)) ;
    Splay.ar(form * dusty);
});
Ndef(\a).gui.moveTo(0, 50);
);

s.boot;
      // connect the influx action to the Ndef!
(
z = (); y = Ndef(\a).getKeysValues.flop.first;
a.outNames.do { |outName, i| z.put(outName, y[i]); };

a.action.add(\test, { |influx|
	var nameValPairs = influx.outNames.collect { |outName|
		var paramName = z[outName];
		[paramName, paramName.asSpec.map(influx.outValDict[outName] + 1 * 0.5)];
	}.flat;

	Ndef(\a).set(*nameValPairs);
});
)

        // and try using it to create presets,
        // try try morphing between those.
        // requires the sJITLibExtensions Quark.
(
n = NdefPreset(Ndef(\a));

w = Window("NdefPreset test", Rect(200, 200, 420, 250)).front;
w.addFlowLayout;
	// a gui for the NdefPreset
g = ProxyPresetGui(n, parent: w);
	// and one for the Ndef
b = NdefGui(Ndef(\a), 8, parent: w);
)


// sketch for multislider interface to make:
(
n=8;


w = Window("MultiSlider Options", Rect(200, Window.screenBounds.height-550, 300, 400));
    w.view.decorator = FlowLayout( w.view.bounds, 10@10, 10@2 );
w.front;

2.collect { |i|
	StaticText(w, 100@30).string_("in_" ++ i);
};
2.collect { |i|
    m = MultiSliderView(w, Rect(0,0,100,180)).indexThumbSize_(20);
	m.indexIsHorizontal_(false);
    m.value=Array.fill(n, {|v| 0.5+((0.3*v).sin*0.25)});
    m.action = { arg q;q.value.postln; };
	m.isFilled = true;
	m.reference = 0.5!n;
};

c = CompositeView(w, 40@180); c.addFlowLayout;
n.do { |i| StaticText(c, 40@20).string_("out_" ++ i); };
)