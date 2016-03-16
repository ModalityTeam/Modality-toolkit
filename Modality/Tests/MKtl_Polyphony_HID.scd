In Modality, one can have several MKtls for the same device,
and switch between them, as controller pages.
One can also activate them polyphically if desired,
e.g. to control multiple analogous processes from the same gestures.


MKtl.find;
// make two Mktls for a saitek gamepad
g = MKtl('g', "*impact*gamepad");
i = MKtl('i', "*impact*gamepad");

// they point to the same HID device!
g.device.source === i.device.source;
g.device.source.id;

// set an action for all elements of g
g.elAt.action = { |el ... groups| [el.source, el.name, el.value.round(0.001)].postln };
i.elAt.action = { |el ... groups| [el.source, el.name, el.value.round(0.001)].postln };


// press some buttons - actions of both MKtls will run and post:
[ MKtl('g'), joy_r_y, 0.506 ]
[ MKtl('i'), joy_r_y, 0.506 ]

// add an action for button 1
g.elAt(\bt, \1).action = { "ONE!".postln };
i.elAt(\bt, \1).action = { "ENO?".postln };

// switch between the two
g.enable; i.disable;
i.enable; g.disable;

// make a third one, then turn the three into a PagedMKtl
MKtl('h', "*impact*gamepad");
MKtl('h').elAt.action = g.elAt.action;
MKtl('h').elAt(\bt, \1).action = { "T W O".postln };
p = PagedMKtl(\impact, ['g', 'h', 'i']);

// activate one at a time
p.page(\g);
p.page(\h);
p.page(\i);

// all 3 at the same time:
p.mktlDict.do(_.enable);
// all off
p.mktlDict.do(_.disable);
