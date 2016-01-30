//
/* example for the Steinberg CMD-FD hi-res faderbox.

* use 4 faders of FD to set values of four sliders in a grid of 16x4:

*/

// make a dict for this example
~fdex = ~fdex ? ();

// make a window with 4 x 16 faders to control
~fdex.w = Window(); ~fdex.w.addFlowLayout(2@2, 1@1);
~fdex.faders = {{ |i| EZSlider(~fdex.w, Rect(0,0,23,95), i, layout: \vert) }!16 } ! 4;
~fdex.w.front;
~fdex.faders.shape;

// create vars and methods to select a group of 4 highlighted faders
// init values
~fdex.selected = ~fdex.faders[0].keep(4);
~fdex.slrow = 0; ~fdex.slcol = 0;


~fdex.selectFaders = { |dict, row, col|
	defer {
		// unhighlight prev selected
		~fdex.selected.do(_.setColors(background: Color.clear));

		// set new indices
		~fdex.slrow = row ? ~fdex.slrow;
		~fdex.slcol = col ? ~fdex.slcol;

		//// select new ones
		~fdex.selected = ~fdex.faders
		.wrapAt(~fdex.slrow )
		.wrapAt(~fdex.slcol + (0..3));

		"selected: row % col %.\n".postf(~fdex.slrow, ~fdex.slcol);

	// highlight selected faders
	~fdex.selected.do(_.setColors(background: Color.green(0.85)));
	}
};
/* test method:
~fdex.selectFaders(0, 4);
~fdex.selectFaders(3, -3);
*/

// now the cmc faderbox:
~fdex.mk = MKtl('fd', "*-fd");
// ~fdex.mk.gui;
// this is how to get the index of the fader to use as offset
~fdex.mk.elAt('fader').action = { |el| el.indexInGroup.postln };

// set the group action of the fader to change a slider value
~fdex.mk.elAt('fader').action = { |el|
	var sliderToMove = ~fdex.selected[el.indexInGroup];
	defer { sliderToMove.value = el.value };
};

// set buttons to step up and down columns = channels
~fdex.mk.elAt('bt', 'chanL', 'on').action = {
	~fdex.selectFaders(~fdex.slrow, ~fdex.slcol - 1 % 16);
};
~fdex.mk.elAt('bt', 'chanR', 'on').action = {
	~fdex.selectFaders(~fdex.slrow, ~fdex.slcol + 1 % 16);
};
// ... and rows = banks:
~fdex.mk.elAt('bt', 'bankL', 'on').action = {
	~fdex.selectFaders(~fdex.slrow - 1 % 4, ~fdex.slcol);
};
~fdex.mk.elAt('bt', 'bankR', 'on').action = {
	~fdex.selectFaders(~fdex.slrow + 1 % 4, ~fdex.slcol);
};
