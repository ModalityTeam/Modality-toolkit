// simple preset states of MKtl element values

// make an MKtl
g = MKtl(\gp, "*run*drive");
g.gui;
// get current settings of all controllers:
~pre0 = g.getKeysValues;

// get some values only by name:
g.getKeysValues([\joy_l_x, \joy_l_y]);

// create sets of names to use in preset
~joyKeys = g.elementAt(\joy).flat.collect(_.name);
~butKeys = g.elementAt(\bt).collect(_.name);


// create random settings:
g.elementsDict.do(_.value_(1.0.rand));
~rnd1 = g.getKeysValues;
g.elementsDict.do(_.value_(1.0.rand));
~rnd2 = g.getKeysValues;

// make random sttings for some keys only
~joyKeys.do { |key| g.dictAt(key).value_(1.0.rand) };
~rndJoy1 = g.getKeysValues(~joyKeys);

~butKeys.do { |key| g.dictAt(key).value_(1.0.rand) };
~rndBut1 = g.getKeysValues(~butKeys);

// restore to initial setting
g.setKeysValues(~pre0);

// give all elements an action,
// then set states with doAction
g.elementGroup.action_ { |el| "YO: % %\n".postf(el.name, el.value) };

// one of them
g.setKVAction([~pre0, ~rnd1, ~rnd2, ~rndBut1, ~rndJoy1].choose);



