MKtlElementView {

	classvar <>makeViewFuncDict;

	var <element;
	var <>parent, <>view, <>value, <>getValueFunc;

	*new { |parent, bounds, element|
		^this.newCopyArgs( element ).makeView( parent, bounds );
	}

	*initClass {
		makeViewFuncDict = (
			'button': { |parent, bounds, label, element|
				var mouseDownAction;
				if( element.elementDescription[ \mode ] == \push ) {
					mouseDownAction = { |bt| bt.valueAction = 1 };
				};
				Button( parent, bounds.insetBy( MKtlGUI.margin ) )
				.mouseDownAction_( mouseDownAction )
				.states_([[ label ? "" ],[ label ? "", Color.black, Color.gray(0.33) ]]);
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
					.autoUpTime_( 0.2 );
			},
			'unknown': { |parent, bounds, label|
				var vw;
				vw = NumberBox( parent, bounds.insetBy( MKtlGUI.margin ) ).clipLo_(0).clipHi_(1);
				if( vw.respondsTo( \maxDecimals_ ) ) {
					vw.maxDecimals = 4;
				};
				vw;
			},
			'midiBut': \button,
			'joyAxis': \slider,
			'springFader': \slider,
			'rumble':\slider,
			'ribbon': \slider,
			'hatSwitch': \knob,
			'encoder': \knob
		);
	}

	makeView { |inParent, bounds|
		var label;
		parent = inParent ? parent;
		if( element.elementDescription[ \style ] !? _.showLabel ? false ) {
			label = element.elementDescription[ \label ] ?? { element.name };
		};
		view = this.getMakeViewFunc( element.type ).value( parent, bounds, label, element );
		getValueFunc = this.makeGetValueFunc( element, view );

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
					element.source.name, element.name, element.value;
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

}

MKtlGUI {

	classvar <>maxSize = 900;
	classvar <>minViewSize = 38;
	classvar <>maxViewSize = 60;
	classvar <>margin = 5;

	var <>mktl;
	var <>parent, <>views, <>skipJack;
	var <>gridSize;
	var <>traceButton, <>labelButton;
	var <>labelView;
	var <currentPage = 0;

	*new { |parent, bounds, mktl|
		^super.newCopyArgs( mktl, parent ).init( bounds );
	}

	init { |bounds|
		var createdWindow = false;
		var numRowsColumns, cellSize;
		var pages, pageComposites, pagesSwitch;

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

		views = mktl.elements.flat.collect({ |item|
			var style, bounds, view = parent;
			style = item.elementDescription[ \style ] ?? { ( row: 0, column: 0, width: 0, height: 0 ) };
			if( pages.notNil && { item.elementDescription[ \page ].notNil }) {
				view = pageComposites[ item.elementDescription[ \page ] ];
			};
			MKtlElementView( view, Rect( style.column * cellSize, (style.row * cellSize) + 25, style.width * cellSize, style.height * cellSize ), item );
		});

		labelView = UserView( parent, bounds.moveTo(0,0) )
		.background_( Color.black.alpha_(0.33) )
		.drawFunc_({ |vw|
			views.do({ |item, i|
				var name;
				if( item.element.elementDescription[ \page ].isNil or: { item.element.elementDescription[ \page ] == currentPage } ) {
					name = item.element.name.asString;
					if( name.asString.size > 5 ) {
						name = name.split( $_ );
						name[((name.size-1) / 2).floor] = name[((name.size-1) / 2).floor] ++ "\n";
						name = name.join( $_ );
					};
					Pen.stringCenteredIn( name, Rect.aboutPoint( item.view.bounds.center, 60, 15 ), nil, Color.white )
				};
			});
		})
		.visible_( false );

		traceButton = Button( parent, Rect(2,2,80,16) )
			.states_([["trace"],["trace", Color.black, Color.green]])
			.action_({ |bt| mktl.trace( bt.value.booleanValue ) })
			.value_( mktl.traceRunning.binaryValue );

		labelButton = Button( parent, Rect(84,2,80,16) )
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

	getNumRowsColumns {
		^mktl.elements.flat.collect({ |item|
			item.elementDescription !? { |x|
				((x[ \style ] ?? { ( row: 0, column: 0, width: 0, height: 0 ) })
					.atAll([ \row, \height, \column, \width ]) - [0, 1, 0, 1]).clump(2).collect(_.sum);
			}
		}).flop.collect(_.maxItem) + 1;
	}

	getNumPages {
		^mktl.elements.flat.collect({ |item| item.elementDescription[ \page ] }).select(_.notNil).maxItem !? (_+1);
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
			if( element.elementDescription[ \page ] == page ) {
				bounds = ().bounds_(
					switch( element.type,
						\slider, { Rect(0,0,1,3) },
						{ Rect( 0,0,1,1 ) }
					)
				);
				style = element.elementDescription[ \style ] ? ();

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
				element.elementDescription[ \style ] = style
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

		scanFunc.(mktl.elements);
	}

	updateGUI {
		views.do(_.updateGUI);
	}

	showLabels { |bool = true|
		labelView.visible = bool;
	}
}