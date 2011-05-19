/*
MKtl.make(\nk1, 'nanoKONTROL');
n = MKtl(\nk1);
n.elements.at(\sl1_1).value;
n.at(\sl1_1).value;

z = PKtl(n, \sl1_1);

Pdef(\mk, Pbind(\amp, z.squared, \dur, 0.25).trace).play;

n.at(\sl1_1).value_(64);
n.at(\sl1_1).value_(127.rand);

*/

PKtl : Pattern { 
	var <mktl, <elName; 
	*new { |mktl, elName| 
		^super.newCopyArgs(mktl, elName);
	}

	embedInStream { arg inval; 
		inf.do { 
			var item = mktl.at(elName).value;
			inval = item.embedInStream(inval);
		};
		^inval;
	}

	storeArgs { ^[ mktl, elName ] }
	
	value { ^mktl.at(elName).value }
}
	