/************** defaultTestCode for desc files **************/

// test this desc file:
// get name from file when code is within a desc file
// ~thisdescname = thisProcess.nowExecutingPath.basename.split($.).first.postcs;
// or set desc full or partial file name by hand:
~thisdescname = "descNameHere";

~descs = MKtlDesc.loadDescs(~thisdescname); ~descs.size.postln; ~thisdesc = ~descs.first;
// check web info for it
~thisdesc.web;

// close old ~mktl, open new one, make gui:
~mktl.free; ~mktl = MKtl(\test, ~thisdescname);
try { ~mgui.close }; ~mgui = ~mktl.gui.parent.alwaysOnTop_(true);

~mktl.trace;
// -> wiggle all elements now on gui and/or device

// give all elements an action:
~mktl.trace(false);
~mktl.elAt.action = { |el|
	"TEST: % has val %.\n".postf(el.name.cs, el.value.round(0.0001));
};
// -> AGAIN, now wiggle all elements now on gui and/or device


// is the number of elements and hierarchy plausible?
~mktl.elementsDict.size;
~mktl.postElements;

// can all elements can be set to random values?
// (should post and appear on gui):
~mktl.elementsDict.do(_.valueAction_(1.0.rand)); "";

// do all outputElelements change on device and gui?
~mktl.outputElements.size; // how many are there?
~mktl.outputElements.do(_.valueAction_(1)); ""; // all on
~mktl.outputElements.do(_.valueAction_(0)); ""; // all off

// when done, update test status!
~mktl.desc.openFile;

