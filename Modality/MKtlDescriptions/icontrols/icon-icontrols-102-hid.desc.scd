/*
This is for the HID part of the older version of the
iCon iControls, which registers as "iCON iControl V1.02".

It registers on two midi in ports and 1 out,
and the joystick registers as an HID device (a mouse);
this file only only for the joystick.
while its HID descriptor says it has all 6 generic
mouse elements, it actually only has 3:
mouse x and y, and bt1 = click on the joy hat.

// tests:
MKtlDesc.loadDescs;
m.free; m = MKtl(\ic, "*icontrols-102-hid");
m.trace; m.gui;

m.elAt.action = { |el| [el.name, el.deviceValue].postln };
m.elementsDict.size;
m.postElements;

[0.47244095802307, 0.52755904197693].asFraction(300)

*/

(
deviceName: "iCON iControl V1.02_iCON",
protocol: 'hid',
deviceType: \joystick,
status: (
	linux: "unknown",
	osx: "tested and working. 2016_04_08, adc",
	win: "unknown"),
elementTypes: [\joyAxis],

idInfo: "iCON iControl V1.02_iCON",

deviceInfo: (
	vendorURI: "http://icon-global.com/product/icontrols/",
	manualURI: "http://support.icon-global.com/hc/en-us/articles/216201337-iControls",
	// description: "",
	// features: [],
	notes: "This desc only implements the joystick of the device.",
	longName: "iCON iControls (HID)"
),
//nescivi: (icontrols V2.00) spec is a bit tricky to get right, but this comes close
// adc: (V1.02) on osx this seems to be very close to [60/127, 67/127].
specs: ( \mouseAxisIcon: [ 0.47244095802307, 0.52755904197693, \lin, 0, 0.5].asSpec ),
elementsDesc: (
	shared: ( hidUsagePage: 1, elementType: 'mouseAxis', ioType: 'in', spec: 'mouseAxisIcon', mode: \center ),
	elements: [
		(key: 'x', hidUsage: 48),
		(key: 'y', hidUsage: 49),
		(key: \hatBt, elementType: \button, spec: \hidBut, hidUsagePage: 9, hidUsage: 1),
	]
)
)
