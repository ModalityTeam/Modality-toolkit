PKtl 		access MKtl values in patterns

	// make an MKtl
MKtl.make(\nk1, 'nanoKONTROL');
n = MKtl(\nk1);

	// get a value from its elements
n.elements.at(\sl1_1).value;
	// shortcut for access
n.at(\sl1_1).value;

	// make a PKtl
z = PKtl(MKtl(\nk1), \sl1_1);

	// use it in a playing pattern
Pdef(\mk, Pbind(\amp, z.squared, \dur, 0.25).trace).play;

	// change mktl's relevant value
n.at(\sl1_1).value_(64);
n.at(\sl1_1).value_(127.rand);

	// test polyphony support: 
z.elName = [\sl1_1, \sl1_2];

n.at(\sl1_1).value_(127.rand.postln);
n.at(\sl1_2).value_(127.rand.postln);

n.setValueAt([\sl1_1, \sl1_2], [10.rand, rrand(60, 70)].postln);
