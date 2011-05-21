////////// AllGui	- an overview for global vars and some classvars //////////

sclang has several options for permanent state:
	global variables in the interpreter (a-z)
	a currentEnvironment
	some classvars that keep all instances:
		Pdef.all, Tdef.all, Pdefn.all,
		ProxySpace.all, Ndef.all,
	and potentially others.

AllGui shows an overview of these: 
	the number global vars in use (a-z);
	the number of items in the currentEnvironment,
	the number of items in Tdef.all, Pdef.all, Pdefn.all, 
	and the number items in Ndef.all, and proxies in proxyspaces.

	// numItems arg is used here to set default numItems for thesizes for the 
AllGui.new;

	// the "open" button opens the proper JITGui for each collection;
	// the number next to it sets the number of items each gui will 
	// display without scrolling.

	// the numItems argument here sets the default numItems in the AllGui.
AllGui(16); 

	// test adding things that should show up: 
a = 12;
z = 42;
~bar = 345;
~foo = 345;
Tdef(\a);	
Tdef(\b);	
Pdef(\a);
Pdef(\b);
Pdefn(\trala);
Pdefn(\hopsa);
Ndef(\a);
Ndef(\b);

p = ProxySpace(s, \p);
p[\a] = 12;
p[\kkk] = 12;


// todo: 
*	a non-overlapping layout for all of them, based on numItems
* 	maybe a version that puts them all on one window? 
* 	maybe a CocoaMenu entry on OSX
* 	maybe an uncloseable flag
* 	a simple way to add other classes to it

*	what other candidates that should be there?

/* 
(
Class.allClasses.do { |cl|
	cl.classVarNames.do { |cvn|
		if (cvn.asString.containsi("all")) { 
			[cl.asSymbol, cvn].postcs
		}
	}
}
)
*/