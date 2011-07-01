
MKtlAllGui : JITGui {
	var <dragViews; 
	*new { |numItems = 12, parent, bounds| 
		^super.new(MKtl, numItems, parent, bounds);
	}

		// these methods should be overridden in subclasses: 
	setDefaults { |options|
		defPos = if (parent.isNil, 10@260, skin.margin);
		minSize = 170 @ (numItems * skin.buttonHeight + skin.headHeight);
	}
	
	winName { ^"MKtl.all" }
	
	makeViews {
		
		dragViews = numItems.collect { |num|
			var numbox, drag;
			Button(zone, Rect(0,0, 40, 20))
				.states_([["open"]])
				.action_({ MKtlGui.new(drag.object, numbox.value.asInteger) });
			numbox = EZNumber(zone, Rect(0,0, 20, 20), nil, [0, 32, \lin, 1], 
				initVal: numItems, numberWidth: 20);

			drag = DragSource(zone, 100@20)
				.object_(nil).visible_(false)
				.align_(\center);	
		};
	} 
	
	getState { 
		^object.all.keys.asArray.sort;
	}
			// optimize later
	checkUpdate { 
		var newState = this.getState;
		dragViews.do { |drag, i| 
			var key = newState[i];
			drag.object_(object.all[key])
				.visible_(key.notNil)
			}
	}
}

MKtlGui : JITGui { 
	classvar <buildFuncs;
	classvar <defaultSizes;
	classvar <skin;
	
	var <elemParent, <elemViews;
	
	*postZoneTemplate { |mktl| 
		var nameArr = mktl.elementNames;
		"(\n // where should each gui element be? \n"
		"var zoneDict = (".postln; 
		nameArr.do { |k, i|
			var type = mktl.elements[k].type;
			var sizePt = (defaultSizes[type] ?? { 40@40 });
			"	'%': Rect(0, 0, %, %)%\n".postf(k, sizePt.x, sizePt.y, if (i < nameArr.lastIndex, ",", ""));
		};
		");\n)".postln;""
	}

	setDefaults { |options|
		if (parent.isNil) { 
			defPos = 10@260
		} { 
			defPos = skin.margin;
		};
		minSize = 400 @ 400;
	}
	
	skin { ^skin ?? { this.init; skin } }
	buildFuncs { ^skin ?? { this.init; buildFuncs } }
	
	*init { 
		
		skin = (onColor: Color(0.5, 1, 0.5, 1.0), offColor: Color.grey(0.7), fontColor: Color.black);
		defaultSizes = (
			button:    40@20, 
			slider: 	 120@40,
			springFader: 	 120@40,
			compass:   90@90, 
			joyStick: 120@120,
			joyLHat:   50@40, 	// temp
			joyAxisX: 120@40,	// temp
			joyAxisY:  40@120,	// temp
			wheel:     40@150
		);
		
		buildFuncs = (
			knob: { |w, zone, el| 
				EZKnob(w, zone, el.name, 
					el.spec, { |sl|
						el.valueAction_(sl.value);
						[el.name, sl.value, el.prevValue, el.value].postln;
					}, el.value); 
				
			
			}, 
			button: { |w, zone, el| Button(w, zone)
					.states_([[el.name, skin.fontColor, skin.offColor], 
						[el.name, skin.fontColor, skin.onColor]])
					.action_({ |but| 
						el.valueAction_(but.value);
						[el.name, but.value, el.prevValue, el.value].postln 
					}); 
				},
			slider: { |w, zone, el| 
				EZSlider(w, zone, el.name, 
					el.spec, { |sl|
						el.valueAction_(sl.value);
						[el.name, sl.value, el.prevValue, el.value].postln;
					}, el.value, layout: \line2, numberWidth: 40); 
				},

			wheel: { |w, zone, el| buildFuncs[\slider].value(w, zone, el) }, 
			springFader: { |w, zone, el| buildFuncs[\slider].value(w, zone, el) }, 

			joyStick: { |w, zone, el|
				StickView(w, zone);
				// el;
			},

				// individual axes, not needed anymore
//			joyAxis: { |w, zone, el| 
//				EZSlider(w, zone, el.name, 
//					el.spec, { |sl|
//						el.valueAction_(sl.value);
//						[el.name, sl.value, el.prevValue, el.value].postln;
//					}, el.value, layout: \line2, numberWidth: 40); 
//				},
			
//			hidHat: { |w, zone, el| buildFuncs[\button].value(w, zone, el) }, 
			
			compass: { |w, zone, el|			
					CompassView(w, zone)
						.action_({ |comp| 
							// el.valueAction;
							// [el.name, but.value, el.prevValue, el.value].postln;
						});
				}
		);
	}
	
	getName { ^try { object.name } { "anon" } }
	
	*new { |mtkl, parent, bounds, makeSkip = true, options = #[]| 
		^super.new(mtkl, 0, parent, bounds, makeSkip, options);
	}
			// only allow once - replugging makes no sense
	accepts { |obj| ^object.isNil and: { obj.isKindOf(MKtl) } }

	object_ { |obj| 
		if (this.accepts(obj)) {
			object = obj;
		} { 
			"% : object % not accepted!".format(this.class, obj).warn;
		}
	}

	makeViews { 

		var lineheight = skin.headHeight;
		
		nameView = DragBoth(zone, Rect(0,0, 60, lineheight))
			.font_(font)
			.align_(\center)
			.receiveDragHandler_({ arg obj; 
				this.object = View.currentDrag 
			});
			
		csView = EZText(zone, 
			Rect(0,0, bounds.width - 65, lineheight), 
			nil, { |ez| object = ez.value; })
			.font_(font);
		csView.enabled_(false); // disable until testable
		csView.view.resize_(2);
		csView.textField.align_(\center).resize_(2);
		
		elemViews = ();
		
	}
	
		// called if object changed: 
	makeElemViews { |rectDict| 
		
		elemParent = elemParent ?? { 
			CompositeView(zone, zone.bounds.top_(zone.bounds.top - 30))
		};

		// remove old ones:
		elemViews.keysValuesDo { |k, v|
			elemViews.removeAt(k).remove;
		};
		
		if (rectDict.isNil) { 
			// make them left to right in lines and hope for the best

	//		// then make new ones 
	//		object.elements.do { |elem| 
	//			// make view for each element 
	//			var type = elem.type;
	//			var elemBounds = rectDict[elem.name] ? Rect(0,0, 100, 100);
	//			[parent, elemBounds, elem].postln;
	//		//	buildFuncs[elem.type].value();
	//		};
		} {
			rectDict.keysValuesDo { |k, rect| 
				var elem = object.elements[k];
				buildFuncs[elem.type].value(elemParent, rect, elem);
			};
		}	
	}
	
	checkUpdate { 
		var newState = this.getState; 

		if (newState[\object] != prevState[\object]) { 
				// redraw elements if object changed!
			this.name_(this.getName);
			if (csView.textField.hasFocus.not) { csView.value_(object) };
		}; 
		newState[\values].keysValuesDo { |k, v|
			if (v != prevState[k]) { 
				try { elemViews[k].value_(v) };
			}
		};
	}
	getState { 
			// get object, get all values from its elements;
		^(object: object, values: object.elements.collect(_.value));
	}
	
	
}