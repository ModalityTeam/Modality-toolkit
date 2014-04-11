/*
	This example demonstrates basic MIDI resolution,
	modeling MIDI encoder knobs, and using them with RelSet,
	and shows a finetuning by a gui model of a scientific
	potentiometer.

*/

// Make an example process with parameters

Ndef(\a, { RLPF.ar(Pulse.ar(\freq.kr(200 ), \pwidth.kr(0.38)), 1500) }).play;

// set its freq
Ndef(\a).set(\freq, 500);

// set freq specs, here to default
Ndef(\a).addSpec(\freq, [20, 20000, \exp]);
Ndef(\a).addSpec(\pwidth, [0.01, 0.5, \exp]);

// make a gui for it to see changes
Ndef(\a).gui.skipjack.dt = 0.05;


// examples
// - 127 steps for pitch resolution is very coarse.
// encoding with RelSet is much finer
(
q = q ? ();
w = Window("MIDI issues - 127 steps, encoder").front;
w.addFlowLayout;

StaticText(w, 380@32).string_(
"MIDI cc only has 127 steps or resolution,
which is clearly audible on wide pitch ranges." );
EZSlider(w, 380@40, 'freq: 127 steps', [0, 127, \lin, 1], { |sl| Ndef(\a).setUni(\freq, sl.value/127) },labelWidth: 100);

StaticText(w, 380@32).string_(
"Less clearly, but still audible on width modulation." );
EZSlider(w, 380@40, 'pwidth: 127 steps', [0, 127, \lin, 1], { |sl| Ndef(\a).setUni(\pwidth, sl.value/127) },labelWidth: 100);

w.view.decorator.nextLine.shift(0, 20);

StaticText(w, 180@120).string_(
"A MIDIish encoder knob for freq:
mouse-click to start,
twirl clockwise for up,
counterclockwise for down.
10 rotations is full range.
64 angle steps per rotation." );

u = UserView(w, 200@200); u.background_(Color.grey(0.7));
u.drawFunc = { |u|
	Pen.stringAtPoint("freq", 10@10);
	Pen.translate(100, 100);
	[10, 20, 30, 40, 50].do { |rad, i|
		Pen.addArc(0@0, rad, 0, 2pi);
		Pen.stroke;
	}


};
u.mouseDownAction = { |uv, x, y|
	q.lastXYPos = Point(x.linlin(0, 200, -1, 1), y.linlin(0, 200, -1, 1)).asPolar;
};
u.mouseMoveAction = { |uv, x, y|
	var angleDiff, normRotDiff;
	var xyPos = Point(x.linlin(0, 200, -1, 1), y.linlin(0, 200, -1, 1)).asPolar;
	q.lastXYPos = q.lastXYPos ? xyPos;

	// get angle difference, wrap to avoid jumps from -pi to pi
	angleDiff = (xyPos.angle - q.lastXYPos.angle).wrap(pi, -pi);

	// [0, 1] is one full rotation of angle
	normRotDiff = angleDiff / 2pi;
	normRotDiff.round(0.0001).postln;

	// simulate MIDI Encoder
	// - e.g. 64 click-steps of knob per full rotation
	if (normRotDiff.abs > (1/64)) {
		// increase resolution by 10:
		RelSet(Ndef(\a), \freq, normRotDiff * 0.1);
		q.lastXYPos = xyPos;
	};

	// like ten-times ganged potentiometers,
	// ten turns for full range.
	//

};
u.refresh;
)

(
// alternative for finetuning from GUI - don't use hardware like angle steps;
// If you circle far from center, you can get very fine resolution!

// This is modeled on scientific potentiometers which typically
// have 10 rotations to the full range for more precise fine-tuning.

u.mouseMoveAction = { |uv, x, y|
	var angleDiff, normRotDiff;
	var xyPos = Point(x.linlin(0, 200, -1, 1), y.linlin(0, 200, -1, 1)).asPolar;
	q.lastXYPos = q.lastXYPos ? xyPos;

	// get angle difference, wrap to avoid jumps from -pi to pi
	angleDiff = (xyPos.angle - q.lastXYPos.angle).wrap(pi, -pi);

	// [0, 1] is one full rotation of angle
	normRotDiff = angleDiff / 2pi;
	normRotDiff.round(0.0001).postln;

	// like ten-times ganged potentiometers,
	// ten turns for full range.
	// increase resolution by 10:
	RelSet(Ndef(\a), \freq, normRotDiff * 0.1);
	q.lastXYPos = xyPos;
};
)
