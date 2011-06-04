	// test .gui messages for JIT classes

GUI.cocoa;
Ndef(\a, { |a, b, c, d, e, f, g, h| DC.ar(0.5) }).gui
Ndef.gui

p = ProxySpace(s); 
p[\a] = { |a, b, c, d, e, f, g, h| DC.ar(0.5) };
p.gui
Pdef(\a).set(\a, 1, \b, 2, \c, [3,4], \d, [5,6,7]).gui
Tdef(\a).set(\a, 1, \b, 2, \c, [3,4], \d, [5,6,7]).gui(5)
	
PdefnGui.gui
Pdefn(\a, Pseq([1, 2, 3]));
Pdefn(\a).gui

	// broken on QT
Tdef.gui
Pdef.gui
Pdefn.gui

// an optional \small ProxyMixer for 800x600 screens. 

openEdit button rotates between: only ar, ar + kr, ar + editgui.
	
m = NdefMixer(s, 8, options: [\small]);
Ndef(\a, { |freq = 10, amp| Pulse.ar(freq) * amp }).play
Ndef(\k, { |lofreq = 0.3| LFSaw.kr(lofreq) });

m = NdefMixer.small(s, 12);
m.moveTo(0,0)
m = NdefMixer(s);
