MKtlElementView {

	classvar <>makeViewFuncDict;

	var <element;
	var <>parent, <>view, <>value, <>getValueFunc;

	var <>snapbackValue = 0, <snapback = false;

	*new { |parent, bounds, element, redirectView|
		// "% : redirectView is % \n".postf(thisMethod, redirectView);
		^this.newCopyArgs( element ).makeView( parent, bounds, redirectView );
	}

	*initClass {
		makeViewFuncDict = (
			'button': { |parent, bounds, label = ""|
				label = MKtlGUI.splitLabel(label);
				Button( parent, bounds.insetBy( MKtlGUI.margin ) )
				.states_([[ label ],[ label , Color.black, Color.gray(0.33) ]]);
			},
			'slider': { |parent, bounds, label|
				Slider( parent, bounds.insetBy( MKtlGUI.margin ) );
			},
			'knob': { |parent, bounds, label|
				Knob( parent, bounds.insetBy( MKtlGUI.margin ) );
			},

			'pad': { |parent, bounds, label|
				MPadView( parent, bounds.insetBy( MKtlGUI.margin ) )
				.useUpValue_( true )
				.label_(label ? "")
				.autoUpTime_( 0.2 );
			},
			'hexpad': { |parent, bounds, label|
				MHexPad( parent, bounds.insetBy( MKtlGUI.margin ) )
				.useUpValue_( true )
				.label_(label ? "")
				.autoUpTime_( 0.2 );
			},
			'roundpad': { |parent, bounds, label|
				MRoundPad( parent, bounds.insetBy( MKtlGUI.margin ) )
				.useUpValue_( true )
				.label_(label ? "")
				.autoUpTime_( 0.2 );
			},

			'padUp': { |parent, bounds, label, redirectView|
				MPadUpViewRedirect( redirectView )
			},
			'padMove': { |parent, bounds, label, redirectView|
				MPadMoveViewRedirect( redirectView )
			},
			'unknown': { |parent, bounds, label|
				var vw;
				vw = NumberBox( parent, bounds.insetBy( MKtlGUI.margin ) )
				.clipLo_(0).clipHi_(1)
				.step_(0.01).scroll_step_(0.01);
				if( vw.respondsTo( \maxDecimals_ ) ) {
					vw.maxDecimals = 4;
				};
				vw;
			},

			'fader': \slider,
			'xfader': \slider,
			'springFader': \slider,

			'bender': \slider,
			'modWheel': \slider,
			'lever': \slider,

			'rumble':\slider,
			'ribbon': \slider,

			'joyAxis': \slider,
			'mouseAxis':  \slider,
			'thumbAxis': \slider,
			'accelAxis': \slider,
			'gyroAxis': \slider,

			'padX': \slider,
			'padY': \slider,
			'padTouch': \slider, // overlay on pad view
			'keyTouch': \slider, // overlay on pianoKey view
			'chanTouch': \slider,

			'mouseWheel': \slider,
			'scrollWheel': \slider,

			'hatSwitch': \knob,
			'encoder': \knob,

			'trigger': \button,
			'switch': \button,

			'pianoKey': \pad,

			// 'compass'		-> CompassView as on gamepads
			// 'stick' 			-> StickView - thumbstick with x, y, hat
			// 'cvIn' 'cvOut'	-> VU-meter,  qunexus,
			// 'led' : 			-> LEDView w color, from 0-1 intensity
			// 'option'	?
			// 'voltage' - a VU-meter?

		);
	}

	makeView { |inParent, bounds, redirectView |
		var label;
		parent = inParent ? parent;
		// "makeView: redirectView is %\n".postf(redirectView);
		if( ((element.elemDesc[ \style ] !? _.showLabel) ? MKtlGUI.showLabels) ) {
			label = (element.elemDesc[ \label ] ? element.name).asString;
			if (element.elemDesc.groupType.notNil) {
				label = MKtlGUI.dropLastElem(label);
			};
		};

		view = this.getMakeViewFunc( element.type ).value( parent, bounds, label, redirectView );
		getValueFunc = this.makeGetValueFunc( element, view );

		view.keyDownAction = { |vw, key|
			(	$t: { this.snapback_(false) },
				$m: { this.snapback_(true) }
			)[key].value;
		};

		if ((element.type == \button) and: {
			element.elemDesc[ \mode ] == \push;
		}) {
			this.snapback_(true, false);
		};
	}

	getMakeViewFunc { |type|
		var func;
		func = makeViewFuncDict[ type ? element.type ] ?? { makeViewFuncDict[ \unknown ] };
		if( func.isKindOf( Symbol ) ) {
			func = makeViewFuncDict[ func ];
		};
		^func;
	}

	makeGetValueFunc { |element, view|
		var getValueFunc, value, ctrl, changed = true;

		ctrl = SimpleController( element )
		.put( \value, { |obj| changed = true });

		getValueFunc = { if( changed == true ) { changed = false; element.value; }; };
		value = getValueFunc.value;

		view.value_( value );
		view.onClose = view.onClose.addFunc( { ctrl.remove } );
		view.action_({ |vw|
			element.valueAction = vw.value;
			if( element.source.traceRunning == true ) {
				"% - % > % | via GUI\n".postf(
					element.source.name, element.name, element.value.round(0.0001);
				);
			};
		});

		^getValueFunc;
	}

	updateGUI {
		var newValue;
		newValue = getValueFunc.value;
		if( newValue.notNil ) {
			view.value = newValue
		};
	}

	snapback_ { |flag = true, post = true|
		snapback = flag;
		if (snapback) {
			if (post) {
				"% gui: switching to momentary action/snapback.\n".postf(element);
			};
			if (view.isKindOf(Button)) {
				view.mouseDownAction = { |bt| bt.valueAction = 1 };
			};
			// elasticity
			view.mouseUpAction = {
				defer ({
					element.valueAction = snapbackValue;
					view.value = snapbackValue;
				}, 0.05);
			};
		} {
			if (post) {
				"% gui: switching to toggle action.\n".postf(element);
			};
			if (view.isKindOf(Button)) { view.mouseDownAction = nil; };
			view.mouseUpAction = nil;
		};
	}
}

MKtlGUI {

	classvar <>maxSize = 900;
	classvar <>minViewSize = 38;
	classvar <>maxViewSize = 60;
	classvar <>margin = 5;

	classvar <>showLabels = true;

	var <mktl;
	var <parent, <views, <skipJack;
	var <gridSize;
	var <traceButton, <labelButton;
	var <labelView;
	var <pageComposites, <pagesSwitch;
	var <currentPage = 0;

	*dropLastElem { |str, sep = $_|
		var indices = str.findAll(sep);
		if (indices.isNil) { ^str };
		^str.keep(indices.last);
	}

	*splitLabel { |label, maxLength = 5|
		var name = label = (label ? "").asString;
		var nameSize = name.size;
		var splitPoints, bestIndex;
		if( nameSize > maxLength ) {
			splitPoints = name.findAll($_);
			if (splitPoints.isNil) {
				bestIndex = (nameSize / 2).roundUp.asInteger;
			} {
				bestIndex = splitPoints.minItem { |i| absdif(i, nameSize / 2) };
			};
			name = name.keep(bestIndex)  ++ "\n" ++ name.drop(bestIndex);
		};
		^name
	}

	*new { |parent, bounds, mktl|
		^super.newCopyArgs( mktl, parent ).init( bounds );
	}

	init { |bounds|
		var createdWindow = false;
		var numRowsColumns, cellSize;
		var pages;
		var elemsToShow, viewToPass;

		pages = this.getNumPages;
		this.layoutElements( pages );

		numRowsColumns = this.getNumRowsColumns;
		cellSize = (maxSize / numRowsColumns.maxItem).round(1).clip(minViewSize,maxViewSize); // grid size
		bounds = bounds ?? { Rect( 128,64, *(numRowsColumns.reverse * cellSize) + [10,30]) };
		parent = parent ?? {
			createdWindow = true;
			Window( mktl.name, bounds, false ).front;
		};

		if( pages.notNil ) {
			pageComposites = pages.collect({ |i|
				CompositeView( parent, parent.view.bounds ).background_( Color.hsv( i / pages, 0.75, 0.75, 0.1) );
			});
		};

		// // was:
		// elemsToShow = mktl.elementGroup.flat;
		// keep groups with a groupType together
		elemsToShow = mktl.elementGroup.elements.flatIf { |el| el.groupType.isNil };
		"%: will show %'s % elements in % views.\n".postf(thisMethod, mktl,
			mktl.elementsDict.size, elemsToShow.size);

		views = elemsToShow.collect({ |item|
			var style, bounds, parView = parent, redirView, newViews;
			var itemIsGroup = item.isKindOf(MKtlElementGroup);

			style = try { item.elemDesc[ \style ] } ?? { ( row: 0, column: 0, width: 0, height: 0 ) };
			if( pages.notNil && { item.elemDesc[ \page ].notNil }) {
				parView = pageComposites[ item.elemDesc[ \page ] ];
			};

			if (itemIsGroup.not) {
				MKtlElementView(
					parView,
					Rect( style.column * cellSize, (style.row * cellSize) + 25,
						style.width * cellSize, style.height * cellSize ),
					item
				);
			} {
				// "item is a group: %\n".postf(item);
				newViews = item.elements.collect { |it, i|
					var nuview;
					// "index: % sending to nuview: %\n".postf(i, redirView);
					nuview = MKtlElementView(
						parView,
						Rect( style.column * cellSize, (style.row * cellSize) + 25,
							style.width * cellSize, style.height * cellSize ),
						it,
						redirView
					);

					if ( i == 0) {
						redirView = nuview.view;
						redirView.mode = item.groupType;
						if (style.color.notNil) { redirView.baseColor = Color.perform(style.color) };
						// "setting redirView: %\n".postf(redirView);
					} {
						// "used nuview.view - it is %. \n".postf(nuview.view);
					};
					nuview
				};
				redirView = nil;
				newViews;
			};
		}).flat;

		labelView = UserView( parent, bounds.moveTo(0,0) )
		.background_( Color.black.alpha_(0.33) )
		.drawFunc_({ |vw|

			views.do({ |item, i|
				var name;
				var doDraw = item.view.isKindOf(MPadUpViewRedirect).not
				and: { item.element.elemDesc[ \page ].isNil
					or: { item.element.elemDesc[ \page ] == currentPage } };

				if(doDraw) {
					name = item.element.name.asString;
					if (item.element.elemDesc.groupType.notNil) {
						name = name.split($_).drop(-1).join($_);
					};
					name = MKtlGUI.splitLabel(name);
					Pen.stringCenteredIn( name,
						Rect.aboutPoint( item.view.bounds.center, 60, 15 ), nil, Color.white )
				};
			});
		})
		.acceptsMouse_(false) // allow using underlying views.
		.visible_( false );

		traceButton = Button( parent, Rect(2,2,50,16) )
		.states_([["trace"],["trace", Color.black, Color.green]])
		.action_({ |bt| mktl.trace( bt.value.booleanValue ) })
		.value_( mktl.traceRunning.binaryValue );

		labelButton = Button( parent, Rect(54,2,50,16) )
		.states_([["labels"],["labels", Color.black, Color.green]])
		.action_({ |bt| this.showLabels( bt.value.booleanValue ) });

		if( pages.notNil ) {
			Button( parent, Rect( 168, 2, 16, 16 ) )
			.states_([ ["<"] ])
			.action_({ pagesSwitch.valueAction = (pagesSwitch.value - 1).wrap(0, pagesSwitch.items.size-1); });
			pagesSwitch = PopUpMenu( parent, Rect( 188, 2, 80, 16 ) )
			.items_( pages.collect({ |item| "page: %".format( item ) }) )
			.action_({ |pu|
				currentPage = pu.value;
				pageComposites.do({ |item, i| if( currentPage == i ) { item.visible = true } { item.visible = false } });
				labelView.refresh;
			});
			Button( parent, Rect( 272, 2, 16, 16 ) )
			.states_([ [">"] ])
			.action_({ pagesSwitch.valueAction = (pagesSwitch.value + 1).wrap(0, pagesSwitch.items.size-1); });
			pagesSwitch.valueAction_( currentPage );
		};

		skipJack = SkipJack( { this.updateGUI }, 0.2, { parent.isClosed } );
	}

	currentPage_ { |number = 0|
		if( pagesSwitch.notNil ) {
			pagesSwitch.valueAction = number;
		};
	}

	getNumRowsColumns {
		if (mktl.elementGroup.elements.isEmpty) {
			^[1, 2]
		};
		^mktl.elementGroup.flat.collect({ |item|
			var desc = item.elemDesc;
			desc !? {
				((desc[ \style ] ?? { ( row: 0, column: 0, width: 0, height: 0 ) })
					.atAll([ \row, \height, \column, \width ])
					- [0, 1, 0, 1]).clump(2).collect(_.sum);
			}
		}).flop.collect(_.maxItem) + 1;
	}

	// this assumes that pages are indices starting with 0,
	// hardware pages often are named, e.g. A, B, C, D on qunexus,
	// or 1,2,3,4 on nanoKontrol 1.

	getNumPages {
		^mktl.elementGroup.flat.collect({ |item| item.elemDesc[ \page ] }).select(_.notNil).maxItem !? (_+1);
	}

	layoutElements { |pages|
		this.layoutElementsOnPage();
		pages.do({ |page|
			this.layoutElementsOnPage( page );
		});
	}

	layoutElementsOnPage { |page|
		var columnSpacingTrend, layout, placeFunc, scanFunc;

		layout = FlowLayout( Rect(0,0,32,32), 0@0, 0@0 );

		placeFunc = { |element|
			var bounds, style;
			if( element.elemDesc[ \page ] == page ) {
				bounds = ().bounds_(
					switch( element.type,
						\slider, { Rect(0,0,1,3) },
						{ Rect( 0,0,1,1 ) }
					)
				);
				style = element.elemDesc[ \style ] ? ();

				style.parent = nil;

				if( style.width.notNil ) { bounds.bounds.width = style.width };
				if( style.height.notNil ) { bounds.bounds.height = style.height };
				if( style.column.notNil ) {
					if( layout.left > 0 && { style.column > 0 } && { style.column != layout.left } && { (style.row ? layout.top) == layout.top }) {
						columnSpacingTrend = style.column - layout.left;
					};
					layout.left = style.column;
				} {
					if( columnSpacingTrend.notNil ) {
						layout.shift( columnSpacingTrend, 0 );
					};
				};
				if( style.row.notNil ) { layout.top = style.row };
				layout.place( bounds );
				bounds = bounds.bounds;
				element.elemDesc[ \style ] = style
				.parent_( ( row: bounds.top, column: bounds.left, width: bounds.width, height: bounds.height ) );
			};
		};

		scanFunc = { |element|
			var lastElement;
			if( element.isKindOf( MKtlElementGroup ) ) {
				if( element.elements.any({ |x| x.isKindOf( MKtlElementGroup ) }) ) {
					element.elements.do(scanFunc.(_));
				} {
					layout.nextLine;
					columnSpacingTrend = nil;
					element.elements.do({ |item| placeFunc.( item ); });
				};
			} {
				placeFunc.( element );
			};
		};

		scanFunc.(mktl.elementGroup);
	}

	updateGUI {
		views.do(_.updateGUI);
	}

	showLabels { |bool = true|
		labelView.visible = bool;
	}

	moveTo { |h, v|
		var bounds;
		if (parent.isKindOf(Window)) {
			bounds = parent.bounds;
			parent.bounds = bounds.moveTo(
				h ? bounds.left,
				v ? bounds.top
			);
		}
	}

}