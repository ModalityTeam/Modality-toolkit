PKtl 		access MKtl values in patterns

MKtl.find;
	// make an MKtl
MKtl.make(\nk1, 'nanoKONTROL');

z = PKtl(MKtl(\nk1), Pseq( [\sl1_1, \sl1_2], inf ) );
z = PKtl(MKtl(\nk1), [\sl1_1, \sl1_1] );
z = PKtl(MKtl(\nk1), \sl1_1, 5 );

Pdef(\mk, Pbind(\amp, z/4, \degree, Pseq([0,3], inf), \dur, 0.25, \pos, [-1,1] ).trace).play;
Pdef(\mk, Pbind(\amp, z/4, \degree, [0,3], \dur, 0.25, \pos, [-1,1] ).trace).play;


n.at(\sl1_1).value_(64);
n.at(\sl1_1).value_(127.rand);


n = MKtl('thrs0');
z = PKtl(MKtl(\thrs0), Pseq( [\bt1r, \bt2r], inf ) );
z = PKtl(MKtl(\thrs0), [\bt1r, \bt2r] );
z = PKtl(MKtl(\thrs0), \bt1r, 5 );


	// get a value from its elements
n.elements.at(\bt1r).value;
	// shortcut for access
z.elName = [\bt1r, \bt2r];
n.at(\bt1r).value;

	// make a PKtl
z = PKtl(MKtl(\thrs0), Pseq( [\bt1r, \bt2r], inf ) );
z = PKtl(MKtl(\thrs0), [\bt1r, \bt2r] );
z = PKtl(MKtl(\thrs0), \bt1r, 5 );

	// use it in a playing pattern
Pdef(\mk, Pbind(\amp, z/4, \degree, Pseq([0,3], inf), \dur, 0.25, \pos, [-1,1] ).trace).play;
Pdef(\mk, Pbind(\amp, z/4, \degree, [0,3], \dur, 0.25, \pos, [-1,1] ).trace).play;

	// change mktl's relevant value
n.at(\sl1_1).value_(64);
n.at(\sl1_1).value_(127.rand);

	// test polyphony support: 
z.elName = [\sl1_1, \sl1_2];

n.at(\sl1_1).value_(127.rand.postln);
n.at(\sl1_2).value_(127.rand.postln);

n.setValueAt([\sl1_1, \sl1_2], [10.rand, rrand(60, 70)].postln);
