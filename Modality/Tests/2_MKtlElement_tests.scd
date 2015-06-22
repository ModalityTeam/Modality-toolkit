//// Make MKtls by hand:

x = MKtlElement(\x, (deviceSpec: [-100, 100], type: \joyX, ioType: \in));
x.deviceSpec;

x = MKtlElement(\x, (deviceSpec: \freq, type: \joyX, ioType: \in));
x.deviceSpec;
x.deviceSpec_([200, 2000, \exp]);
x.deviceSpec;

x.deviceSpec;
// check
x.value;
x.value = 0.8; x.value;
x.deviceValue;

x.value = 0.25; x.value;
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
x.deviceSpec;
x.type
x.ioType;
x.deviceSpec
x.deviceSpec_([5, 105] * 2);

x.value_(0.75).value;
x.deviceValue
// cannot be nil, so it cannot get stuck in bad state
x.deviceValue_(nil);
x.deviceValue

x.value;



// AN EXAMPLE for making a derived MKtlElement, as in issue #72:
// (math is not correct yet, bt works in principle)
// // issue #72 - Adding custom filter elements to an existing (and instantiated) controller
// m = MKtl.make(\meXYController, \meXYControl);
// m.addVirtualElement(\xyPolar, {| me |
// 	atan2(me.elements[\x], me.elements[\y])
// });
//

~post = { |el| [el.name, el.value].postln };

x.addAction(~post);
x.value_(1.0.rand);
x.valueAction_(0.6);

y = MKtlElement(\y, (spec: [-100, 100], type: \joyY, ioType: \in));
y.addAction(~post);

Slider2D(nil, Rect(0,0,200,200)).action_({ |sl2d|
	x.valueAction_(sl2d.x); y.valueAction_(sl2d.y);
}).front;

z = MKtlElement(\polar, (spec: [-pi, pi], type: \xyPolar, ioType: '?'));

~doZAction = { z.doAction };
[x, y].do {|el| el.addAction(~doZAction) };
[x, y].do { |el| el.removeAction(~post) };


// first add a function to calc value
~getXY = { |polar|
	polar.deviceValue_(atan2(x.deviceValue, y.deviceValue));
};
z.addAction(~getXY);
z.addAction(~post);

// polar values/math not ok yet, FIXME later.
~postPolar = { |polar| "polar atan2 value: % \n".postf(polar.deviceValue); };
// then one to do something with it
z.removeAction(~post);
z.addAction(~postPolar);


// MKtlElements work in patterns
x.value = 0.6;
Pbind(\x, x).trace.play;
x.value = 1.0.rand;

Pbind(\x, Pfunc({ x.deviceValue })).trace.play;
x.deviceValueAction = exprand(20, 200);

