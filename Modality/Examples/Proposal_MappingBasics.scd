Proposal for Mapping Basics - Recommendations for simple uniform mapping strategies.

requirements:

* control sources have unipolar number range, no specs
* destinations know their current param values and specs
* destinations respond to get, set, getUni, setUni
  [Maybe write SetUni, GetUni classes like SoftSet?]

recommendations:
* controllers only send unipolar or relative values
* object knows its param specs, and conversions are handled
  by setUni, or SoftSet, or RelSet

* when controller is newly assigned to destination, use SoftSet
* when controller is relative, use RelSet


/******** Discussion and examples **********/

//////////// SET, GET //////

Very many objects and processes in SC respond to
obj.set(<paramName1>, <value1>)
by setting the value of the named parameter to the given value.
x = Synth(\default);
x.set(\freq, 500, \amp, 0.4);

Many objects keep the last value they were set to in an internal collection of parameter values, e.g.
Tdef(\a).set(\x, 123);
Tdef(\a).set(\y, 456);
Ndef(\a).set(\freq, 123);

// These can then be accessed again by
Tdef(\a).get(\x);
Tdef(\a).get(\y);
x.get(\freq, { |val| "async value from server: %".postf(val) });
// ... Synth object does not remember on the language side


// These set commands can also be extended to multiple params:
Tdef(\a).set(\x, 456, \y, 789);

// currently .get only returns first param value
// Question - should get commands  be polyphonic as well???

Tdef(\a).get(\x, \y);
x.get(\freq, { |...args| args.postln })
// does not work:
x.get([\freq, \amp], { |...args| args.postln })


Ndef(\a).set(\freq, 123, \amp, 0.5);
	// also with ndefs, currently only return first val, why not multiple?
Ndef(\a).get(\freq, \amp);


// give the Ndef a sound, and a gui to read its values
Ndef(\a, { RLPF.ar(Pulse.ar(\freq.kr(200 ), \pwidth.kr(0.38)), 4000) }).play
Ndef(\a).gui.skipjack.dt_(0.05);


/////////// SPECS AND RANGES /////////

// Almost always, numerical parameters have meaningful ranges,
// which are usually expressed in "specs", ControlSpec(min, max, ..);

// existing global preset specs can be accessed, e.g.
// for \freq, with audible range of 20 - 20000 Hz,
// and exponential mapping, which feels linear in perception:
\freq.asSpec

// add a new global default
Spec.add(\spinalAmp, [0, 11, \amp]);
// and access it
\spinalAmp.asSpec


// It makes sense that objects should keep specs that describe their
// parameters' characteristics, for example as tuned ranges within
// which a process behaves as intended, or as safety limits within
// which the process will not crash, filter math will not blow up, etc.
// With Halo, a class provided in JITLibExtensions, this works as follows:

// add a spec that is local the object - can be any object
Ndef(\a).addSpec(\spinalAmp, [0, 11, \amp]);
Ndef(\a).addSpec(\pwidth, [0.01, 0.2, \exp]);

// get the local spec back
Ndef(\a).getSpec(\spinalAmp);
// get all its local specs
z = Ndef(\a).getSpec;

// this spec dict has the global specs as parent:
z.parent.parent == Spec.specs
// so it can find specs of all the global spec presets
z[\amp]
z[\freq]

// When an object knows its specs, it can provide them for
// for semantically straightforward parameter value setting:

// compare: here, the slider owns the spec,
// which is nice when one wants to display its number value.
EZSlider(nil, 300@20, \freq, \freq, { |sl| Ndef(\a).set(\freq, sl.value) });

// On a hardware slider, you don't see the number, just the physical
//  range of movement; here the Ndef can own the spec for the param,
// and the slider can remain ingorant of it.
EZSlider(nil, 300@20, \freq, nil, { |sl| Ndef(\a).setUni(\freq, sl.value) }, numberWidth: 0);

// Here, it is much easier to change mappings with multiple controllers:
// you only change the spec the object has, and all controllers use it.
(
w = Window("Local specs rule").front; w.addFlowLayout;
EZSlider(w, 300@20, nil, nil, { |sl| Ndef(\a).setUni(\freq, sl.value) });
EZSlider(w, 300@20, nil, nil, { |sl| Ndef(\a).setUni(\pwidth, sl.value) });

Slider2D(w, 300@200).action_({ |sl2d| Ndef(\a).setUni(\freq, sl2d.x, \pwidth, sl2d.y) });
)


// Changing the spec ranges now is very simple;
// one only informs the object instead of all the
// controllers that may be in use right now.

Ndef(\a).addSpec(\freq, [12, 1200, \exp]);
Ndef(\a).addSpec(\pwidth, [0.01, 0.2, \exp]);

// if you want to zoom in to a smaller range,
// you can rescale the unipolar range of the controllers,
// or temporarily change the spec in the object...


// MULTIPLE CONTROLLERS and SOFT TAKEOVER //

// When a physical controller is newly assigned to an object's parameter, its physical position is likely to be far away from the parameter's current value. This is easy to fix on a GUI slider - (just set its value) or on motorized faders (send a command to move it there), but on most others, the next movement will introduce a potentially large value jump.

// SoftSet is designed to alleviate this :
// SoftSet will ask the object for its current value,
// and only do the set command if the newValue is either
// * close enough to the current value,
// * or if the controller has set the current value of the object,
//   and can prove it by sending a lastVal that is close.
//   (when one moves a controller quickly, one can lose it if
//   the "within" range is small.)

// Here is an example from the SoftSet help file demonstrates this; the recommended variant is to use lastVal wherever possible, and choose between having specs in the controllers (and updating them when needed), or using the object's specs and changeing those for tuning the mapping.

(
    var w = Window("SoftSet - compare  Variants").front;
    var lastVal, lastValUni;
    w.addFlowLayout;

    StaticText(w, 380@32).string_("SoftSet classvar defaultWithin sets range within a destination's parameter will be taken over.");
   EZSlider(w, 380@20, 'SoftSet-defaultWithin', [0.025, 0.2, \exp], { |sl|
        SoftSet.defaultWithin = sl.value;
    }, labelWidth: 150);


StaticText(w, 380@32).string_("SoftSet(name, val) only depends on 'within' closeness - can be lost when moving too fast." );
    EZSlider(w, 380@32, 'SoftSet(...)', \freq, { |sl|
        SoftSet(Ndef(\a), \freq, sl.value);
    }, labelWidth: 150);

StaticText(w, 380@32).string_("SoftSet.uni(name, normVal) without a lastVal can also be lost when moving too fast." );
    EZSlider(w, 380@32, 'SoftSet.uni()', nil, { |sl|
        SoftSet.uni(Ndef(\a), \freq, sl.value);
    }, labelWidth: 150);

StaticText(w, 380@32).string_("SoftSet(name, val, ... lastVal) cannot be lost, unless something else sets the param to a value outside 'within range'." );
   EZSlider(w, 380@32, 'SoftSet with lastVal', \freq, { |sl|
    [\last, lastVal, \new, sl.value].postln;
        SoftSet(Ndef(\a), \freq, sl.value, lastVal: lastVal);
        lastVal = sl.value;
    }, labelWidth: 150);

StaticText(w, 380@32).string_("SoftSet.uni(name, val, ... lastVal) is e very tight once it is taken over." );
   EZSlider(w, 380@32, 'Soft.uni with lastVal', nil, { |sl|
        SoftSet.uni(Ndef(\a), \freq, sl.value, lastVal: lastValUni);
        lastValUni = sl.value;
    }, labelWidth: 150);
)

Proposal for Mapping Basics - Recommendations for simple uniform mapping strategies.

requirements:

* control sources have unipolar number range, no specs
* destinations know their current param values and specs
* destinations respond to get, set, getUni, setUni
  [Maybe write SetUni, GetUni classes like SoftSet?]

recommendations:
* controllers only send unipolar or relative values
* object knows its param specs, and conversions are handled
  by setUni, or SoftSet, or RelSet

* when controller is newly assigned to destination, use SoftSet
* when controller is relative, use RelSet


/******** Discussion and examples **********/

//////////// SET, GET //////

Very many objects and processes in SC respond to
obj.set(<paramName1>, <value1>)
by setting the value of the named parameter to the given value.
x = Synth(\default);
x.set(\freq, 500, \amp, 0.4);

Many objects keep the last value they were set to in an internal collection of parameter values, e.g.
Tdef(\a).set(\x, 123);
Tdef(\a).set(\y, 456);
Ndef(\a).set(\freq, 123);

// These can then be accessed again by
Tdef(\a).get(\x);
Tdef(\a).get(\y);
x.get(\freq, { |val| "async value from server: %".postf(val) });
// ... Synth object does not remember on the language side


// These set commands can also be extended to multiple params:
Tdef(\a).set(\x, 456, \y, 789);

// currently .get only returns first param value
// Question - should get commands  be polyphonic as well???

Tdef(\a).get(\x, \y);
x.get(\freq, { |...args| args.postln })
// does not work:
x.get([\freq, \amp], { |...args| args.postln })


Ndef(\a).set(\freq, 123, \amp, 0.5);
	// also with ndefs, currently only return first val, why not multiple?
Ndef(\a).get(\freq, \amp);


// give the Ndef a sound, and a gui to read its values
Ndef(\a, { RLPF.ar(Pulse.ar(\freq.kr(200 ), \pwidth.kr(0.38)), 4000) }).play
Ndef(\a).gui.skipjack.dt_(0.05);


/////////// SPECS AND RANGES /////////

// Almost always, numerical parameters have meaningful ranges,
// which are usually expressed in "specs", ControlSpec(min, max, ..);

// existing global preset specs can be accessed, e.g.
// for \freq, with audible range of 20 - 20000 Hz,
// and exponential mapping, which feels linear in perception:
\freq.asSpec

// add a new global default
Spec.add(\spinalAmp, [0, 11, \amp]);
// and access it
\spinalAmp.asSpec


// It makes sense that objects should keep specs that describe their
// parameters' characteristics, for example as tuned ranges within
// which a process behaves as intended, or as safety limits within
// which the process will not crash, filter math will not blow up, etc.
// With Halo, a class provided in JITLibExtensions, this works as follows:

// add a spec that is local the object - can be any object
Ndef(\a).addSpec(\spinalAmp, [0, 11, \amp]);
Ndef(\a).addSpec(\pwidth, [0.01, 0.2, \exp]);

// get the local spec back
Ndef(\a).getSpec(\spinalAmp);
// get all its local specs
z = Ndef(\a).getSpec;

// this spec dict has the global specs as parent:
z.parent.parent == Spec.specs
// so it can find specs of all the global spec presets
z[\amp]
z[\freq]

// When an object knows its specs, it can provide them for
// for semantically straightforward parameter value setting:

// compare: here, the slider owns the spec,
// which is nice when one wants to display its number value.
EZSlider(nil, 300@20, \freq, \freq, { |sl| Ndef(\a).set(\freq, sl.value) });

// On a hardware slider, you don't see the number, just the physical
//  range of movement; here the Ndef can own the spec for the param,
// and the slider can remain ingorant of it.
EZSlider(nil, 300@20, \freq, nil, { |sl| Ndef(\a).setUni(\freq, sl.value) }, numberWidth: 0);

// Here, it is much easier to change mappings with multiple controllers:
// you only change the spec the object has, and all controllers use it.
(
w = Window("Local specs rule").front; w.addFlowLayout;
EZSlider(w, 300@20, nil, nil, { |sl| Ndef(\a).setUni(\freq, sl.value) });
EZSlider(w, 300@20, nil, nil, { |sl| Ndef(\a).setUni(\pwidth, sl.value) });

Slider2D(w, 300@200).action_({ |sl2d| Ndef(\a).setUni(\freq, sl2d.x, \pwidth, sl2d.y) });
)


// Changing the spec ranges now is very simple;
// one only informs the object instead of all the
// controllers that may be in use right now.

Ndef(\a).addSpec(\freq, [12, 1200, \exp]);
Ndef(\a).addSpec(\pwidth, [0.01, 0.2, \exp]);

// if you want to zoom in to a smaller range,
// you can rescale the unipolar range of the controllers,
// or temporarily change the spec in the object...


// MULTIPLE CONTROLLERS and SOFT TAKEOVER //

// When a physical controller is newly assigned to an object's parameter, its physical position is likely to be far away from the parameter's current value. This is easy to fix on a GUI slider - (just set its value) or on motorized faders (send a command to move it there), but on most others, the next movement will introduce a potentially large value jump.

// SoftSet is designed to alleviate this :
// SoftSet will ask the object for its current value,
// and only do the set command if the newValue is either
// * close enough to the current value,
// * or if the controller has set the current value of the object,
//   and can prove it by sending a lastVal that is close.
//   (when one moves a controller quickly, one can lose it if
//   the "within" range is small.)

// Here is an example from the SoftSet help file demonstrates this; the recommended variant is to use lastVal wherever possible, and choose between having specs in the controllers (and updating them when needed), or using the object's specs and changeing those for tuning the mapping.

(
    var w = Window("SoftSet - compare  Variants").front;
    var lastVal, lastValUni;
    w.addFlowLayout;

    StaticText(w, 380@32).string_("SoftSet classvar defaultWithin sets range within a destination's parameter will be taken over.");
   EZSlider(w, 380@20, 'SoftSet-defaultWithin', [0.025, 0.2, \exp], { |sl|
        SoftSet.defaultWithin = sl.value;
    }, labelWidth: 150);


StaticText(w, 380@32).string_("SoftSet(name, val) only depends on 'within' closeness - can be lost when moving too fast." );
    EZSlider(w, 380@32, 'SoftSet(...)', \freq, { |sl|
        SoftSet(Ndef(\a), \freq, sl.value);
    }, labelWidth: 150);

StaticText(w, 380@32).string_("SoftSet.uni(name, normVal) without a lastVal can also be lost when moving too fast." );
    EZSlider(w, 380@32, 'SoftSet.uni()', nil, { |sl|
        SoftSet.uni(Ndef(\a), \freq, sl.value);
    }, labelWidth: 150);

StaticText(w, 380@32).string_("SoftSet(name, val, ... lastVal) cannot be lost, unless something else sets the param to a value outside 'within range'." );
   EZSlider(w, 380@32, 'SoftSet with lastVal', \freq, { |sl|
    [\last, lastVal, \new, sl.value].postln;
        SoftSet(Ndef(\a), \freq, sl.value, lastVal: lastVal);
        lastVal = sl.value;
    }, labelWidth: 150);

StaticText(w, 380@32).string_("SoftSet.uni(name, val, ... lastVal) is e very tight once it is taken over." );
   EZSlider(w, 380@32, 'Soft.uni with lastVal', nil, { |sl|
        SoftSet.uni(Ndef(\a), \freq, sl.value, lastVal: lastValUni);
        lastValUni = sl.value;
    }, labelWidth: 150);
)

// For settting by relative values, see Examples/RelSet_MIDI_Finetune.scd.

