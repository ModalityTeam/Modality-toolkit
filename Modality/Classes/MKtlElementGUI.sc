MKtlElementGUI {

	classvar <>makeViewFuncDict;
	classvar <>labelWidth = 80;
	classvar <>smallLabelWidth = 20;

	var <element;
	var <>parent, <>views, <>values, <>getValueFuncs, <>skipJack;
	var <>subGUIs;

	*new { |parent, bounds, element|
		^this.newCopyArgs( element ).makeView( parent, bounds );
	}

	*initClass {
		makeViewFuncDict = (
			'button': { |parent, label|
				if( label.notNil ) {
					StaticText( parent, labelWidth@16 ).string_( label.asString ++ " " ).align_( \right );
				};
				Button( parent, if( label.notNil ) { labelWidth@16 } { 20@16 })
				.states_([[ label ? "" ],[ label ? "", Color.black, Color.gray(0.33) ]]);
			},
			'slider': { |parent, label|
				if( label.notNil ) {
					StaticText( parent, labelWidth@16 ).string_( label.asString ++ " " ).align_( \right );
				};
				Slider( parent, if( label.notNil ) { 80@20 } { 20@80 });
			},
			'knob': { |parent, label|
				if( label.notNil ) {
					StaticText( parent, labelWidth@16 ).string_( label.asString ++ " " ).align_( \right );
				};
				Knob( parent, 20@20 );
			},
			'pad': { |parent, label|
				if( label.notNil ) {
					StaticText( parent, labelWidth@16 ).string_( label.asString ++ " " ).align_( \right );
				};
				MPadView( parent, 20@20 )
					.useUpValue_( true )
					.autoUpTime_( 0.2 );
			},
			'unknown': { |parent, label|
				if( label.notNil ) {
					StaticText( parent, labelWidth@16 ).string_( label.asString ++ " " ).align_( \right );
				};
				NumberBox( parent,
					if( label.notNil ) { 80@16 } { 30@16 }
				).clipLo_(0).clipHi_(1);
			},
			'midiBut': \button,
			'joyAxis': \slider,
			'springFader': \slider,
			'rumble':\slider,
			'ribbon': \slider,
			'hatSwitch': \knob,
			'encoder': \knob,
		);
	}

	makeView { |inParent, bounds|
		var createdWindow = false;

		parent = inParent ? parent ?? {
			createdWindow = true;
			Window( element.source.name, bounds, scroll: true ).front;
		 };

		if( parent.asView.decorator.isNil ) { parent.addFlowLayout };

		views = [ ];
		values = [ ];
		getValueFuncs = [ ];

		this.makeSubViews;

		if( createdWindow ) {
			skipJack = SkipJack( { this.updateGUI }, 0.2, { parent.isClosed } );
		};
	}

	getMakeViewFunc { |type|
		var func;
		func = makeViewFuncDict[ element.type ] ?? { makeViewFuncDict[ \unknown ] };
		if( func.isKindOf( Symbol ) ) {
			func = makeViewFuncDict[ func ];
		};
		^func;
	}

	makeSubViews {
		var view, getValueFunc, value;

		view = this.getMakeViewFunc( element.type ).value( parent, element.name );

		getValueFunc = { element.value; };
		value = getValueFunc.value;

		view.value_( value );
		view.action_({ |vw|
			element.valueAction = vw.value;
			if( element.source.verbose == true ) {
				"% - % > % | via GUI\n".postf(
					element.source.name, element.name, element.value;
				);
			};
		});

		getValueFuncs = getValueFuncs.add( getValueFunc );
		values = values.add( value );
		views = views.add( view );
	}

	updateGUI {
		values = values.collect({ |value, i|
			var newValue;
			newValue = getValueFuncs[i].value;
			if( newValue.notNil ) {
				views[ i ].value = newValue
			};
			newValue;
		});
		subGUIs.do(_.updateGUI);
	}

}

MKtlElementDictGUI : MKtlElementGUI {

	makeSubViews {
		var lastElement;
		element.getElementsForGUI.pairsDo({ |key, item|
			if( item.size == 0 ) {
				if( lastElement.notNil && { lastElement.type != item.type }) {
					parent.asView.decorator.nextLine;
				};
				lastElement = item;
			} {
				parent.asView.decorator.nextLine;
			};
			subGUIs = subGUIs.add( item.gui( parent ) );
		});
	}

}

MKtlElementArrayGUI : MKtlElementGUI {

	makeSubViews {
		var division, size;
		if( element.elements.any({ |item| item.size > 0 }) ) {
			subGUIs = element.elements.collect({ |element|
				element.gui( parent );
			});
		} {
			size = element.size;

			division = [8,9,10,6,7].detect({ |item|
					(size / item).frac == 0;
			}) ? 8;

			if( parent.asView.decorator.left != 4 ) {
				parent.asView.decorator.nextLine;
			};

			StaticText( parent, labelWidth@16 ).string_( element.name.asString ++ " " ).align_( \right );

			element.elements.do({ |element, i|
					var view, getValueFunc, value, ctrl, changed = true;

					if( (i != 0) && ((i % division) == 0)) {
						parent.asView.decorator.nextLine;
						parent.asView.decorator.shift( labelWidth + 4, 0 );
					};

					view = this.getMakeViewFunc( element.type ).value( parent );
					
					ctrl = SimpleController( element )
						.put( \value, { |obj| changed = true });

					getValueFunc = { if( changed == true ) { changed = false; element.value; }; };
					value = getValueFunc.value;

					view.value_( value );
					view.onClose_( { ctrl.remove } );
					view.action_({ |vw|
						element.valueAction = vw.value;
						if( element.source.verbose == true ) {
							"% - % > % | via GUI\n".postf(
								element.source.name, element.name, element.value;
							);
						};
					});

					getValueFuncs = getValueFuncs.add( getValueFunc );
					values = values.add( value );
					views = views.add( view );
			});
		};
	}

}


+ MKtlElement {
	gui { |parent, bounds|
		^MKtlElementGUI( parent, bounds, this );
	}
}

+ MKtlElementDict {
	gui { |parent, bounds|
		^MKtlElementDictGUI( parent, bounds, this );
	}
}

+ MKtlElementArray {
	gui { |parent, bounds|
		^MKtlElementArrayGUI( parent, bounds, this );
	}
}

