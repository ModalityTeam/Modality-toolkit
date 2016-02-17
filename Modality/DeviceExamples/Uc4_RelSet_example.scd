// Test relative setting on UC4:

// on the device, select grp1,
// then go into edit mode: hold \shift, press \edit_setup
// select enc1 on knob 1, change ctlmode to Ccr2,
// hold until running bars go away -> all encoders are now relative

// then test here:
m = MKtl(\uc4, "*uc4");
m.trace;
m.gui;

// add a spec to uc4, for relative use:
// ccr2 is up 58 ... 63 down / 65 .. 70 up,
// so use this for good resolution on gui elements
m.addSpec(\knRel, [56, 72, \lin, 1, 64]);
m.elAt(\kn, \1).do(_.deviceSpec_(m.getSpec(\knRel)));

~ckeys = [\a, \b,\c, \d, \e, \f];
~ckeys.do (Spec.add(_, \amp));
m.specs;
// a silly sound
Ndef(\a, {
	(VarSaw.ar((1..6) * 48.midicps, 0, 0.1)
		* ~ckeys.collect(_.kr(0)).lag(0.1)).mean;
}).play;


Ndef(\a).gui(6);

// make the action fot the encoders:
// - moving knob above 0 will raise level in rel steps,
// - below middle will lower it

~ckeys = Ndef(\a).controlKeys;
m.elAt(\kn, \1).action = { |el|
	RelSet(
		Ndef(\a),
		~ckeys[el.indexInGroup].postln,
		((el.value - 0.5) * 0.06).postln,
		\amp
	)
};

// now try that it works by moving knobs
// ...
// then set Ndef to random values
Ndef(\a).set(* ~ckeys.collect ([_, 1.0.linrand]).flat);

// and move knobs again, should continue smoothly
// from where they are now.
