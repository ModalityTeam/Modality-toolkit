PKtl 		access MKtl values in patterns

	// make an MKtl

MKtl.find
MKtl(\nnkn0);
n = MKtl(\nnkn0);

	// get a value from its elements
n.elements.at(\sl1_1).value;
n.elements.at(\sl2_1).value;
	// shortcut for access
n.at(\sl1_1).value;
n.at(\sl2_1).value;

	// make a PKtl
z = PKtl(MKtl(\nnkn0), \sl1_1);

	// use it in a playing pattern
Pdef(\mk, Pbind(\amp, z.squared, \dur, 0.25, \freq, [250, 500, 1000])).play;

	// change mktl's relevant value
n.at(\sl1_1).rawValue_(64);
n.at(\sl1_1).rawValue_(127.rand);

	// test polyphony support: 
z.elName = [\sl1_1, \sl2_1, \sl3_1];

n.at(\sl1_1).value_(127.rand.postln);
n.at(\sl1_2).value_(127.rand.postln);

n.setValueAt([\sl1_1, \sl1_2], [10.rand, rrand(60, 70)].postln);
