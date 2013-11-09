DefLib is an attempt to make libs where lots of Xdefs can be present in the background, 
(but not in .all, so they dont clutter Xdef.all, resp. mixer);
they can be found by name, 
or later searched by categories and tags.

Based on suggestion by ricardo guerreiro, barcelona workshop 2011


* Hide puts N/T/Pdefs in the DefLib, 
* Show puts them into .all again (lookup in DefLib by name)
* later: find them by halo tags, categories (not done yet)


Naming Question:

Would it be better to use names NdefLib, PdefLib, TdefLib?
Or Tdef.lib (i.e. stored in Tdef class itself, as classvar lib)?


	// examples:
s.boot;
NdefMixer(s);

a = Ndef(\a, 0.2);
b = Ndef(\b, { Dust.ar(40) * Ndef(\a).kr });
b.play;


DefLib.ndefs.postTree;

Ndef(\a).hide;
Ndef(\b).hide;
Ndef.all;

Ndef.show(\a);
Ndef.show(\b);
Ndef.show(\b, true);
Ndef.all;


Tdef.all;
TdefAllGui();
Tdef(\a, { loop { 0.5.wait; "sososo...".scramble.postln } }).play;
Tdef(\a).hide;
Tdef.show(\a).play;

Pdef.all;
PdefAllGui();
Pdef(\a, Pbind(\midinote, Pbrown(36, 96, 5).round(2.4), \dur, 0.125)).play;
Pdef(\a).hide;
Pdef.show(\a).play;

DefLib.ndefs;
DefLib.tdefs;
DefLib.pdefs;


// searching could be like this - not working yet:
Ndef.best(\noise, \cute, 10); // best 10 matches for category noise and tag cute
Ndef.best([\synth, \noise], [\doom, \evil], 5); 

