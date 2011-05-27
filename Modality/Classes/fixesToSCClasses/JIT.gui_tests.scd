GUI.cocoa;
Ndef(\a, { |a, b, c, d, e, f, g, h| DC.ar(0.5) }).gui

Ndef.gui

p = ProxySpace(s); 
p[\a] = { |a, b, c, d, e, f, g, h| DC.ar(0.5) };
p.gui
Pdef(\a).set(\a, 1, \b, 2, \c, [3,4], \d, [5,6,7]).gui
Tdef(\a).set(\a, 1, \b, 2, \c, [3,4], \d, [5,6,7]).gui(5)
	
	// broken on QT
Tdef.gui
Pdef.gui

TdefAllGui.new



