Halo - associate a halo of meanings to any object. 
should be used with DefLib to find things by categories and tags

* problem - this may break garbage collection, 
as it keeps objects reachable that are gone otherwise.
so, only use this on semi-permanent objects 
	(which is the intended use anyway)

	// object 'a'
a = 12;
a.addHalo(\otto, 234);
a.addHalo(\ada, \bebe, 123);

a.getHalo;
a.getHalo( \otto)
a.getHalo(\ada)
a.getHalo(\ada, \bebe)

	// internal
Halo.lib;
Halo.at(a);
Halo.postTree;

	// one can add specs, useful e.g. for Ndefs, Tdefs, Pdefs
a.addSpec(\myfreak, [66.6, 666, \exp]);
a.addSpec(\amp, [0, 4, \amp]);
a.getSpec(\amp);
a.getSpec(\pan);	// get defaults from Spec.specs if missing
a.getSpec

Halo.at(a, \spec);


Ndef(\a).addSpec(\myfreak, [66.6, 666, \exp]);
Ndef(\a).addSpec(\amp, [0, 4, \amp]);

Ndef(\a).getSpec
NdefGui ... should use Halo! 


	// add tags for semantic clouds;
	// can be weighted (default weight is 1)
a.addTag(\kewl);
a.addTag(\arm);
a.addTag(\sexy, 3); 

a.getTag;
a.getTag(\arm);

	// add categories for searching, with weights also
a.addCat(\num);
a.addCat(\even);
a.addCat(\small);

a.getCat;

DefLib.openHelpFile;

