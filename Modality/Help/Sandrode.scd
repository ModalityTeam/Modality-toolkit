/*	Sandrode - simulates Touch Sandrodes as used in CircuitBending
	requires the MultiTouchPad quark by Batuhan Bozkurt.
	Inspired by Peter Blasser's magical Fyrall, Fourses, et al.

*/

(
Server.default = s = Server.internal;
s.boot;

GUI.cocoa;
q = q ? ();
q.sandNames = [\a, \b, \c, \d, \e];

	// make 5 sandrodes
Sandrode(\a, 0.25@0.50, 0.15);
Sandrode(\b, 0.40@0.25, 0.15);
Sandrode(\c, 0.60@0.25, 0.15);
Sandrode(\d, 0.75@0.50, 0.15);
Sandrode(\e, 0.50@0.75, 0.15);

	// make a MultiTouchPad - uses MultiTouchPad quark.
MultiTouchPad.gui;
w = MultiTouchPad.guiWin; 
u = w.view.children.first; 

// add shortcut keys to MultiTouchPad.guiWin:
	// m to maximise
	// x to normal size
	// space to start, 
	// . to stop, 
	// d to redraw
w.view.keyDownAction = Sandrode.mtpKeydownFunc;

	// adapt drawing function of MultiTouchPad
u.drawFunc = Sandrode.mtpDrawFunc;

	// draw the sandrode areas
Sandrode.drawAll(w.view);

Sandrode.verbose = true;
Sandrode.verbose = false;

	// set the three MultiTouchPad actions:
MultiTouchPad.touchAction = {|curID, xys| 
	Sandrode.addMtpTouch(curID, xys);
//	[\touch, curID].postln;
};

MultiTouchPad.untouchAction = {|curID| 
	Sandrode.removeTouch(curID);
//	[\untouch, curID].postln;
};
	// this one does the most:
	// ccalculate how strong the auras influence each other;
	// based on that, set the modulation weights in the Ndef below:
	
MultiTouchPad.setAction = {|curID, xys| 
	Sandrode.addMtpTouch(curID, xys);
	Sandrode.auras.keysValuesDo { |key, aura|
		var vals = q.sandNames.collect { |k2| (aura[k2] ? 0); };
		Ndef(\nodes).setn(key, vals.round(0.0001));	
	};
};
)
	// and the sound: 
	// a network of modulating VarSaws.
	// controlled by aura weights ...
(
Spec.add(\octaves, [0, 9]);
Spec.add(\angle, [0, 1]);
Spec.add(\delaytime, [0, 0.1, \amp]);
Spec.add(\spiky, [0.1, 10, \exp]);
Spec.add(\xtalk, [0.0, 1, \amp]);

Ndef(\nodes, { |widefreq=10, hairy = 0.618, angle = 0.4, octaves = 4, delaytime = 0.01, spiky = 1, xtalk = 0.03|
	var n = Sandrode.all.size; 
	var modIn = LocalIn.ar(5);

	var influxes = [
		\a.kr(0!n),
		\b.kr(0!n),
		\c.kr(0!n),
		\d.kr(0!n),
		\e.kr(0!n)
	]; // + xtalk.lag(0.5);
	
	var freqs = ([ 	
			(modIn * \a.kr).sum, 
			(modIn * \b.kr).sum, 
			(modIn * \c.kr).sum, 
			(modIn * \d.kr).sum, 
			(modIn * \e.kr).sum
		] * (octaves.lag(0.5) * 12)).midiratio * widefreq.lag(0.5)
		* (2 ** [-2, -1, 0, 1, 2].scramble * hairy.lag(0.5));
	
	var freqs2 = DelayN.ar(freqs, 0.1, delaytime);
		// roll off angles and spikyness for high freqs:
	var angles = freqs2.collect { |freq| (freq.explin(100, 5000, 1, 0) * ((angle * 2 - 1) ** 0.33 * 0.5)) + 0.5 };
	var spikyness = spiky ** freqs.explin(100, 5000, 1, 0.25);
		
		// the oscillators
	var oscs = VarSaw.ar(freqs2.clip(0, 20000), 0, angles) ** spikyness;
		
		// out to feedback
	LocalOut.ar(oscs);
		// mix to two chans
	Splay.ar(oscs);
}).play;
NdefGui(Ndef(\nodes), 12);
)

	// test setting node weights
Ndef(\nodes).set([\a, \b, \c, \d, \e].choose, ({1.0.rand.squared}!5).round(0.001));



	// general Sandrode tests

c = Sandrode(\a, 0.5 @ 0.5, 0.2);
c.dump;

w = Window.new.front;
c.drawOn(w.view);
c.sectArea(Rect(0.5, 0.5, 0.1, 0.1)); // 0.25
