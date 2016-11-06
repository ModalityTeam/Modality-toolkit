// test expansion in MKtlGUI
MKtl.find;

// create a keyboard with 61 keys and polytouch
// - 61 keys barely fit on screen
// - black keys could be black
// noteOn, off, touch work!
(
a = (
	key: \k,
	// groupType: \noteOnOffTouch,
	shared: (groupType: \noteOnOffTouch, 'elementType':
		'pad', spec: \midiVel, midiChan: 0),
	elements: (36..96).collect { |num, i|
		var pos = Piano.pos(num, 36);
		(
			key: num.asSymbol,
			shared: (
				midiNum: num,
				style: (row: pos.y, column: pos.x + (1-pos.y * 0.2),
					width: pos.w * 1.2, height: 1.2, color: pos.color)
			)
		)
	}
);
d = (protocol: \midi, idInfo: "test", elementsDesc: (elements: [a]));
m.free; m = MKtl(\x, d);
g = m.trace.gui.showLabels;
)

// not working yet
MKtlElementGroupGUI(nil, nil, m.elAt(0));


// test all types of noteOnOffTouch combinations
// controlled by a single MPadView
// and connected back from element via SimpleController
(
w = Window("test", Rect(10, 100, 150, 600)).front;
m = List[];
g = List[];

MPadView.modeKeys.keep(5).do { |mode, i|
	var elemDesc, desc, mktl, mkgui, grp, pad;
	elemDesc = (
		groupType: mode.postcs,
		key: \xy,
		shared: (elementType: \pad, type: 'button', midiNum: 42,
			midiChan: 0, ioType: \in)
	);
	desc = (idInfo: "blabla", protocol: \midi, elementsDesc: elemDesc);
	MKtl(mode).free;
	mktl = MKtl(mode, desc);
	mkgui = mktl.gui;
	mkgui.showLabels; g.add(mkgui);
	mkgui.parent.bounds = Rect(200, 600 - (i * 120), 200, 90);

	grp = MKtl(mode).elementGroup;
	grp.action = { |el| [\test1_2, el.name, el.value.round(0.001)].postln };

	pad = MPadView(w, Rect(0, 120 * i, 145, 120)).front;
	m.add(pad);

	pad.mode = grp.groupType;
	pad.label = grp.groupType;

	grp.at(0) !? {
		SimpleController( grp.at(0) )
		.put(\value, { |onEl| pad.value = onEl.value; pad.refresh });
		pad.action = { |m| grp.at(0).valueAction_(pad.value) };
	};
	grp.at(1) !? {
		SimpleController( grp.at(1) )
		.put(\value, { |offEl| pad.upValue = offEl.value; pad.refresh });
		pad.upAction = { |m| grp.at(1).valueAction_(pad.upValue) };
	};
	grp.at(2) !? {
		SimpleController( grp.at(2) )
		.put(\value, { |tchEl| pad.moveValue = tchEl.value; pad.refresh });
		pad.moveAction = { |m| grp.at(2).valueAction_(pad.moveValue) };
	};

};
)
w.close; g.do { |gui| gui.parent.close };


// sketch for connecting one group of up to three elements
// in a group of noteOn/Off/Touch to a single MPadView:
(
p = MKtlDesc.deepExpand(
	(
		//		groupType: \noteOnOffBut,
		groupType: MPadView.modeKeys.choose.postcs,
		key: \xy,
		shared: (elementType: \pad, midiNum: 42, type: 'button', midiChan: 0, spec: \midiBut, ioType: \in))
);

k.free; k = MKtl(\x, (idInfo: "blabla", protocol: \midi, elementsDesc: p));
l = k.trace.gui.showLabels;

g = MKtl(\x).elementGroup;
g.groupType.postln;
g.action = { |el| [\poster, el.name, el.value.round(0.001)].postln };

w = Window("test", Rect(200, 200, 100, 100)).front;
m = MPadView(w, Rect(0, 0, 100, 100)).front;
m.action = { |m| g.at(0) !? { g.at(0).valueAction_(m.value) } };
m.upAction = { |m| g.at(1) !? { g.at(1).valueAction_(m.upValue) } };
m.moveAction = { |m| g.at(2) !? { g.at(2).valueAction_(m.moveValue) } };
m.mode = g.groupType;
m.label = g.groupType;
)

// test whether expansion works
(
a = (
	key: \xyz,
	shared: (groupType: \noteOnOffTouch, 'elementType': 'pad',
		spec: \midiVel, midiChan: 0),
	elements: (36..39).collect((midiNum: _))
);
d = (protocol: \midi, idInfo: "test", elementsDesc: (elements: [a]));
m.free; m = MKtl(\x, d);
m.postElements;
m.gui;
)

// test with mixed elements
(
a = (
	key: \xyz,
	shared: (groupType: \noteOnOffTouch, elementType: \pianoKey,
		spec: \midiVel, midiChan: 0),
	elements: (36..39).collect((midiNum: _))
);
b = (
	key: \sl,
	shared: (elementType: \slider, midiChan: 0, ioType: \in,
		\spec: \midiCC, midiMsgType: \control),
	elements: (0..9).collect ((midiNum: _))
);
d = (protocol: \midi, idInfo: "test", elementsDesc: (elements: [a, b]));
m.free; m = MKtl(\x, d);
m.postElements;
m.gui;
)

// test expanding methods:
MKtlDesc.expandElemToGroup((yo: \mon));
MKtlDesc.expandElemToGroup((yo: \mon), \noSuchGroup);
MKtlDesc.expandElemToGroup((yo: \mon), \noteOnOff);
MKtlDesc.expandElemToGroup((yo: \mon), \noteOnOffBut);
MKtlDesc.deepExpand((yo: \mon));
MKtlDesc.deepExpand((), \noteOnOffBut);
MKtlDesc.deepExpand((yo: \mon, groupType: \noSuch));
MKtlDesc.deepExpand((yo: \mon, groupType: \noteOnOffTouch));
MKtlDesc.deepExpand((key: \xyz, elements: [(midiNum: 47), (midiNum: 11)]), \noteOnOffTouch).cs;

