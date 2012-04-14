///////// A sketch for how auto-guis for MKtls could work //////////

// the descriptions could contain a location and size (a Rect)
// of the gui element that is reasonably similar to the physical device.
// based on its type, gui elements will be drawn in that location.

MKtl.find;
MKtl( 'thrs0');

	// make a virtual MKtl, based on Ferrari GamePad
MKtl.make(\ferr1, 'Run_N_Drive');

	// post a template for typing in lots of rects:
(
"(\n var zoneDict = (".postln;
MKtl(\ferr1).elements.keys.asArray.sort.do { |k|
	"	'%': Rect(0, 0, 40, 40),\n".postf(k);
};
");\n)".postln;""
)

	// all descriptions
MKtl(\ferr1).postDeviceDescription;
	
	// one specific description
MKtl(\ferr1).elements[\joyHat_L].elementDescription;

(	// collect all the types that occur in a Set
z = Set[];
MKtl(\ferr1).elements.do { |el| 
	z.add(el.type);
};
z.postcs
)

		// A GUI sketch for a GamePad: 

(
var zoneDict, skin, buildFuncs, elemGuis; 

	// the window
try { w.close };
w = Window("Ferrari").background_(Color(1, 0.1, 0.1)).front;

	// the zones for each element 
	// - suggestions for width and height could be based on  types
zoneDict = (
	'bt_R_1': Rect(250 + 40, 200 - 12, 40, 24),
	'bt_R_2': Rect(275 + 40, 225 - 12, 40, 24),
	'bt_R_3': Rect(300 + 40, 200 - 12, 40, 24),
	'bt_R_4': Rect(275 + 40, 175 - 12,  40, 24),
	
	'compass': Rect.aboutPoint(100@200, 45, 45),
	'compass_X': Rect.aboutPoint( 100@200, 45, 20),
	'compass_Y': Rect.aboutPoint( 100@200,  20, 45),
	
	'joyHat_L': 	Rect(140, 320 + 20, 50, 40),
	'joy_L_X': 	Rect(60, 280 + 20, 120, 40),
	'joy_L_Y': 	Rect(100, 240 + 20, 40, 120),
	
	'joyHat_R': Rect(300, 320 + 20, 50, 40),
	'joy_R_X': Rect(220, 280 + 20, 120, 40),
	'joy_R_Y': Rect(260, 240 + 20, 40, 120),
	
	'lfBot_7': Rect(110, 25,  40, 20),
	'lfTop_5': Rect(40, 100,  80, 20),
	
	'mid_L_9': Rect(150, 190, 48, 20),
	'mid_R_10': Rect(202, 190, 48, 20),
	
	'rfBot_8': Rect(250, 25,  40, 20),
	'rfTop_6': Rect(280, 100,  80, 20),
	
	'throt_L': Rect(30, 55, 120, 40),
	'throt_R': Rect(250, 55, 120, 40),
	
	'wheel': Rect(5, 125, 40, 150 )
);	
	// a color scheme
skin = (onColor: Color(0.5, 1, 0.5, 1.0), offColor: Color.grey(0.7), fontColor: Color.black);


	// the funcs to make each kind of element.
	// these could be class methods of MKtlGui. 
	
	// Joysticks should be 2DSliders, 
	// hat with alt-click action maybe; state represented with knobColor.
	// a student of mine has done nice 2DSliders with Pen ... 
	// Compass should be a new class.
	
buildFuncs = (
	joyAxis: { |w, el| EZSlider(w, zoneDict[el.name], el.name, 
		[0,1].asSpec
		// el.spec, // double 
		{ |sl|
			el.valueAction_(sl.value);
			[el.name, sl.value, el.prevValue, el.value].postln;
		}, el.value, layout: \line2, numberWidth: 40); 
	},
	springFader: { |w, el| buildFuncs[\joyAxis].value(w, el) }, 
	
	button: { |w, el| Button(w, zoneDict[el.name.postcs].postln)
			.states_([[el.name, skin.fontColor, skin.offColor], 
				[el.name, skin.fontColor, skin.onColor]])
			.action_({ |but| 
				el.valueAction_(but.value);
				[el.name, but.value, el.prevValue, el.value].postln 
			}); 
		},
	hidHat: { |w, el| buildFuncs[\button].value(w, el) }, 
	
		// Compass needs to be a class, ... because value_ on a 
		// pseuod-object dict does not work.
	compass: { |w, el| 
		var center = zoneDict[el.name].center;
		var zone = StaticText(w, zoneDict[el.name]).string_(el.name)
			.background_(Color.grey(0.8, 0.5))
			.align_(\center); 
		var buttons = 8.collect { |i| 
			var angle = (i + 4 / 8 * -2pi );
			var butcent = center + Polar(35, angle).asPoint;
			Button(w, Rect.aboutPoint(butcent, 10, 10))
				.states_([[(i + 1).asString, skin.fontColor, skin.offColor ], 
					[(i + 1).asString, skin.fontColor, skin.onColor ]])
				.action_({ |but| 
					buttons.do { |but2, j| if (i != j) { but2.value = 0 } };
					el.valueAction_(if (but.value > 0, i + 1, 0));
					[el.name, but.value, el.prevValue, el.value].postln;
				}); 
		};
	}
);

elemGuis = ();

//MKtl(\ferr1);
MKtl(\thrs0).elements.do { |el| 
	var gui = buildFuncs[el.type].value(w, el); 
	elemGuis.put(el.name, gui);
	el.eventSource.doDef( \gui, { |newval| try { [el.name, newval].postln; { gui.value_(newval) }.defer } });
	//	el.addFuncElem(\gui, { |name, newval| try { [name, newval].postln; gui.value_(newval) } });
};
)


(
MKtl(\ferr1).elements[\joy_L_Y].valueAction_(1.0.rand);
MKtl(\ferr1).elements[\joy_R_Y].valueAction_(1.0.rand);

MKtl(\ferr1).elements[\lfBot_7].valueAction_(1);
)
