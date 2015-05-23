//// Make MKtls by hand:

x = MKtlElement(\x, (spec: [-100, 100], type: \joyX, ioType: \in));

// check
x.value;
x.value = 0.5; x.value;
x.deviceValue;

x.value
x.deviceValue
x.dump

x.name
x.type
x.ioType
x.elementDescription;
x.elementDescription_((spec: [100, -100], type: \joyY, ioType: \inout));
x.elementDescription;
x.updateDescription((spec: [5, 105].asSpec, type: \joyXYZ));
x.type
x.ioType;
x.deviceSpec
// this spec is communicating with device,
// so maybe should be deviceSpec?
x.deviceSpec_([5, 105] * 2);

x.value_(0.55).value;
x.deviceValue
// this does not catch nil - should it?
x.deviceValue_(nil) // fails;
x.deviceValue // fails;

x.value;

x.action_(MFunc());
x.action.add(\post, { |el| [el.name, el.value].postln });

x.value_(0.5);
x.valueAction_(0.6);

y = MKtlElement(\y, (spec: [-100, 100], type: \joyY, ioType: \in));
y.action_(MFunc());
y.action.add(\post, { |el| [el.name, el.value].postln });

Slider2D(nil, Rect(0,0,200,200)).action_({ |sl2d|
	x.valueAction_(sl2d.x); y.valueAction_(sl2d.y);
}).front;

z = MKtlElement(\polar, (spec: [-pi, pi], type: \xyPolar, ioType: '?'));

[x, y].do {|el| el.action.add(\toPolar, { z.doAction }) };
[x, y].do { |el| el.action.disable(\post) };

z.action = MFunc();
// first add a function to calc value
z.action.add(\getval, { |polar|
	polar.deviceValue_(atan2(x.deviceValue, y.deviceValue));
});

// then one to do something with it
z.action.add(\postAtan2, { |polar|
	"polar atan2 value: % \n".postf(polar.deviceValue);
});


// // issue #72 - Adding custom filter elements to an existing (and instantiated) controller
// m = MKtl.make(\meXYController, \meXYControl);
// m.addVirtualElement(\xyPolar, {| me |
// 	atan2(me.elements[\x], me.elements[\y])
// });
//
x.value = 0.6;
Pbind(\x, x).trace.play;

Pbind(\x, Pfunc({ x.rawValue })).trace.play;
x.rawValue = 220;


MKtlDesc