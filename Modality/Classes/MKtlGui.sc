/* 
* convert sketch to class: 

MKtl(\ferr1, 'Run_N__Drive');
MKtl(\nk1, 'nanoKONTROL');


	// the zones for each element 
	// - suggestions for width and height could be based on  types
zoneDict = (
	'bt1r': Rect(250 + 40, 200 - 12, 40, 24),
	'bt2r': Rect(275 + 40, 225 - 12, 40, 24),
	'bt3r': Rect(300 + 40, 200 - 12, 40, 24),
	'bt4r': Rect(275 + 40, 175 - 12,  40, 24),
	
	'compass': Rect.aboutPoint(100@200, 45, 45),
	
	'joyLHat': 	Rect(140, 320 + 20, 50, 40),
	'joyLX': 		Rect(60, 280 + 20, 120, 40),
	'joyLY': 		Rect(100, 240 + 20, 40, 120),
	
	'joyRHat': Rect(300, 320 + 20, 50, 40),
	'joyRX': Rect(220, 280 + 20, 120, 40),
	'joyRY': Rect(260, 240 + 20, 40, 120),
	
	'lfBot7': Rect(110, 25,  40, 20),
	'lfTop5': Rect(40, 100,  80, 20),
	
	'midL9': Rect(150, 190, 48, 20),
	'midR10': Rect(202, 190, 48, 20),
	
	'rfBot8': Rect(250, 25,  40, 20),
	'rfTop6': Rect(280, 100,  80, 20),
	
	'throtL': Rect(30, 55, 120, 40),
	'throtR': Rect(250, 55, 120, 40),
	
	'wheel': Rect(5, 125, 40, 150 )
);	

	
	

*/

MKtlGui : JITGui { 
	classvar buildFuncs;
	classvar defaultSizes;
	classvar skin;
	
	*zoneTemplate { |mktl| 
		"(\n // where should each gui element be? \n"
		"var zoneDict = (".postln; 
		mktl.elements.keys.asArray.sort.do { |k|
			"	'%': Rect(0, 0, 40, 40),\n".postf(k);
		};
		");\n)".postln;""
	}
	
	skin { ^skin ?? { this.init; skin } }
	buildFuncs { ^skin ?? { this.init; buildFuncs } }
	
	*init {	
		
		skin = (onColor: Color(0.5, 1, 0.5, 1.0), offColor: Color.grey(0.7), fontColor: Color.black);
		defaultSizes = (
			button: 40@20, 
			compass: 90@90, 
			joyStick: 120@120,
			joyLHat: 50@40, 	// temp
			joyAxisX: 120@40,	// temp
			joyAxisY: 40@120,	// temp
			wheel: 40@150
		);
		
		buildFuncs = (
			joyAxis: { |w, zone, el| EZSlider(w, zone, el.name, 
				el.spec, { |sl|
					el.valueAction_(sl.value);
					[el.name, sl.value, el.prevValue, el.value].postln;
				}, el.value, layout: \line2, numberWidth: 40); 
			},
			springFader: { |w, zone, el| buildFuncs[\joyAxis].value(w, el) }, 
			
			button: { |w, zone, el| Button(w, zone)
					.states_([[el.name, skin.fontColor, skin.offColor], 
						[el.name, skin.fontColor, skin.onColor]])
					.action_({ |but| 
						el.valueAction_(but.value);
						[el.name, but.value, el.prevValue, el.value].postln 
					}); 
				},
			hidHat: { |w, zone, el| buildFuncs[\button].value(w, el) }, 
			
				// Compass needs to be a class, ... because value_ on a 
				// pseuod-object dict does not work.
			compass: { |w, zone, el| 
				var center = zone.center;
				var myZone = StaticText(w, zone)
					.string_(el.name)
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
	}

	*new { |mtkl, parent, zoneDict| 
		
	}
}