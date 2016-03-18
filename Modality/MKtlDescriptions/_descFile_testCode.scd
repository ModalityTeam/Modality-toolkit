// test a desc file:
// get name from file when code is within a desc file
// ~thisdescname = thisProcess.nowExecutingPath.basename.split($.).first.postcs;

// or set desc full or partial file name by hand,
// like ~thisdescname = "*nanokontrol2";
~thisdescname = "descNameHere";
~descs = MKtlDesc.loadDescs(~thisdescname); ~descs.size.postln; ~thisdesc = ~descs.first;
// check web info for it
~thisdesc.web;

// close old m, open new one, make gui:
~mktl.free; ~mktl = MKtl(\test, ~thisdescname);
try { ~mgui.close }; ~mgui = ~mktl.gui.parent.alwaysOnTop_(true);

~mktl.trace;
// now wiggle elements on gui or device

// is numer of elements and hierarchy plausible?
~mktl.elementsDict.size;
~mktl.postElements;

// test that all elements can be set to random values
// (should post and appear on gui):
~mktl.elAt.action = { |el|
	"TEST: % has val %.\n".postf(el.name.cs, el.value.round(0.0001));
};

~mktl.elementsDict.do(_.valueAction_(1.0.rand)); "";

// test that all outputElelements change on device and gui
~mktl.outputElements.size; // how many are there?
~mktl.outputElements.do(_.valueAction_(1)); ""; // all on
~mktl.outputElements.do(_.valueAction_(0)); ""; // all off

