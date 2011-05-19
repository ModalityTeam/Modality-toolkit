/*
MKtl.make(\nk1, 'nanoKONTROL');
n = MKtl(\nk1);
n.elements.at(\sl1_1);
n.at(\sl1_1);
n.at([\sl1_1, \sl1_2]); 

z = PKtl(n, \sl1_1);
Pdef(\mk, Pbind(\amp, z.squared, \dur, 0.25).trace).play;

z.elName = [\sl1_1, \sl1_2];

n.at(\sl1_1).value_(127.rand);
n.at(\sl1_2).value_(127.rand);

n.setValueAt([\sl1_1, \sl1_2], [64, 96]);


	// todo 
	// Test polyphony: 

(a: 1, b: 2, c: 3).at(\a)
(a: 1, b: 2, c: 3).at([\a, \b])
(a: 1, b: 2, c: 3).atKeys([\a, \b])
(a: 1, b: 2, c: 3).atKeys(\a)

n.elements.atKeys([\sl1_1, \sl1_2])

z = PKtl(n, [\sl1_1, \sl1_2]);
z.asStream.value;

n.at(\sl1_1); 
n.at([\sl1_1, \sl1_2]); 
n.elements[\sl1_1]

*/

PKtl : Pattern { 
	var <>mktl, <>elName; 
	*new { |mktl, elName| 
		^super.newCopyArgs(mktl, elName);
	}

	embedInStream { arg inval; 
		inf.do { 
			var item = mktl.valueAt(elName);
			inval = item.embedInStream(inval);
		};
		^inval;
	}

	storeArgs { ^[ mktl, elName ] }
	
	value { ^mktl.at(elName).value }
}
	