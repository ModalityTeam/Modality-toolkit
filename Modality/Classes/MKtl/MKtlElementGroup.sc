MKtlElementGroup : MKtlElement {

	var <elements;
	var <dict;
	var <>groupAction;

	var <>useSingleGui = false;
	var <>groupType;

	*new { |name, source, elements|
		^super.newCopyArgs( name, source ).elements_(elements);
	}

	*newFrom {|elements|
		^this.new( elements: elements)
	}

	*fromDesc { |desc, srcMktl|
		var elems, isElem, group, elemKey;
		var mktlElemDict = srcMktl !? { srcMktl.elementsDict };
		var newElem;

		^if (desc.isKindOf(Dictionary)) {
			elems = desc[\elements];
			isElem = elems.isNil;
			if (isElem) {
				elemKey = desc.elemKey;
				newElem = MKtlElement(elemKey, desc, srcMktl);
				mktlElemDict !? { mktlElemDict.put(elemKey, newElem) };
				newElem;
			} {
				// elements is always an array
				elems = elems.collect { |desc2|
					this.fromDesc(desc2, srcMktl);
				};
				group = MKtlElementGroup(desc.key, srcMktl, elems);

				if (desc[\shared].notNil) {
					group.shared = desc[\shared];
				};

				group.useSingleGui = desc.useSingleGui ? false;
				group.groupType = desc.groupType;

				group.do { |elem, i|
					var key = if (elem.isKindOf(MKtlElementGroup)) {
						elem.name;
					} {
						elem.elemDesc[\key];
					};
					key = key ?? { (i+1).asSymbol };
					group.dict.put(key, elem);
					if (MKtlElementGroup.addGroupsAsParent) {
						elem.parent_(group)
					};
				};
				group;
			};
		} {
			"%: should not get here! desc is likely malformed.\n".postf(thisMethod);
			nil;
		};
	}

	shared_ { |dict| elemDesc = dict }
	shared { ^elemDesc }

	// do we still need init?
	// *  elements_ should do fromDesc a level lower!
	init {
		var array;
		tags = Set[];
		dict = ();
		elemDesc = ();
		elements = elements ?? { Array.new };
		case { elements.isKindOf( Dictionary ) } {
			elements.sortedKeysValuesDo({ |key, value|
				dict.put( key, value );
				array = array.add( value );
			});
			elements = array ?? {[]};
			this.sortElementsByType;
		} { elements.isKindOf( Array ) } {
			elements = elements.collect({ |item, i|
				var key;
				case { item.isKindOf( Association ) } {
					dict.put( item.key, item.value );
					item.value;
				}
				{ item.isKindOf(Dictionary) } {
					// a dict with an entry for key:
					key = item[\key];
					key = (item.key ?? { (i+1).asSymbol });
					dict.put( key, item );
					item;
				} { item.isKindOf(MKtlElement) } {
					// "gets here?".postln;
					// dict.put(item.name, item);
					item
				};
			});
		};

		dict.keysValuesDo({ |key, item|
			if( elements.includes( item ).not ) {
				dict.removeAt( key );
			};
		});
		// "elements.size: % - %\n".postf(elements.size, elements);

		if( elements.size > 0 ) {
			type = elements.first.type;
			elements.do({ |item|
				if( addGroupsAsParent ) { item.parent = this };
				if( item.type != type ) {
				 	type = 'mixed';
				};
			});
		};
	}

	source { ^elements.first.source }

	sortElementsByType {
		var order;
		order = [ MKtlElement, MKtlElementGroup ];
		if (elements.isNil) {
			^this
		};

		elements = elements.sort({ |a,b|
				(order.indexOf( a.class ) ? -1) <= (order.indexOf( b.class ) ? -1);
			}).separate({ |a,b|
				a.class != b.class
			})
			.flatten(1);
	}

	elements_ { |newElements|
		elements = newElements;
		this.init;
	}

	// array / dict manipulation support

	at { |keyOrIndex|
		if ( keyOrIndex.size > 0 ) {
			^keyOrIndex.collect { |item| this.at( item ) }
		};
		^dict[keyOrIndex] ?? {
			if (keyOrIndex.isKindOf(Integer)) {
				elements[ keyOrIndex ]
			}
		}
	}

	elAt { |...args| ^this.deepAt2(*args) }

	// should keep dict in sync
	put { |index, element|
		this.elements = this.elements.put( index, element );
	}

	// should keep dict in sync
	add { |element|
		this.elements = this.elements.add( element );
	}

	size { ^elements.size }

	select { |function| ^elements.select( function ) }

	collect { |function| ^elements.collect( function ) }

	inject { |thisValue, function|
		^elements.inject(thisValue, function)
	}

	asBaseClass {|recursive = true|
		^recursive.if({
			this.elements.collect{|el| el.asBaseClass(recursive)};
		},{
			elements;
		})
	}

	removeAll {
		elements.do(_.prRemoveGroup( this ));
		this.elements = nil;
	}

	remove { |element|
		element.prRemoveGroup( this );
		 ^this.elements.remove( element );
	}

	indexOf { |item|
		"// using %\n".postf(thisMethod);
		^this.elemIndexOf(item);
	}

	elemIndexOf { |item| ^this.elements.indexOf( item ) }
	elemKeyOf { |item| ^dict.findKeyForValue( item ) }


	do { |function| elements.do( function ); }

	flat {
		^this.elements.flat;
	}

	flatIf { |func|
		^this.elements.flatIf(func);
	}

	prFlat { |list|
		this.do({ arg item, i;
			if (item.respondsTo('prFlat'), {
				list = item.prFlat(list);
			},{
				list = list.add(item);
			});
		});
		^list
	}

	asArray {
		^elements.collect({ |item|
			if( item.isKindOf( MKtlElementGroup ) ) {
				item.asArray;
			} {
				item;
			};
		});
	}
	// for printOn only, this will not remake it properly from code.
	storeArgs { ^[name, source, type, elements.collect(_.name)] }

	value { ^elements.collect(_.value) }
	value_ { |newvals|
		var pairs = [elements, newvals].flop;
		pairs.do { |assoc| assoc[0].value = assoc[1] }
	}

	deviceValue { ^elements.collect(_.deviceValue) }
	deviceValue_ { |newvals|
		var pairs = [elements, newvals].flop;
		pairs.do { |assoc| assoc[0].deviceValue = assoc[1] }
	}

	prevValue { ^elements.collect(_.prevValue) }
	prevDeviceValue { ^elements.collect(_.prevDeviceValue) }

	// special method for a group of separate elements [\on, \off]
	// if onElement was changed last, assume this group is on
	isOn {
		var onEl, offEl, onTime, offTime;
		onEl = this.dict[\on]; onEl ?? { ^false };
		offEl = this.dict[\off]; onEl ?? { ^false };
		^onEl.lastUpdateTime > offEl.lastUpdateTime
	}

	prettyValues {
		^elements.collect { |el|
			if (el.isKindOf(this)) {
				[el.name, el.value]
			} { el.value }
		}
	}

	postElements {
		var postOne = { |elemOrGroup, index, depth = 0|
			depth.do { $\t.post; };
			index.post; $\t.post;
			if (elemOrGroup.isKindOf(MKtlElementGroup)) {
				"Group: ".post; elemOrGroup.name.postcs;
				elemOrGroup.do({ |item, i| postOne.value(item, i, depth + 1) });
			} {
				elemOrGroup.name.postcs;
			};
		};
		postOne.value(this, "-");
	}

	valueAction_ {|newvals|
		var pairs = [elements, newvals].flop;
		this.value_(newvals);
		this.doGroupAction;
		this.doAction;
	}

	deviceValueAction_ {|newvals|
		this.deviceValue_(newvals);
		this.doGroupAction;
		this.doAction;
	}

	doGroupAction { groupAction.value(this) }

	groupValueAction_ { |newvals|
		this.value_(newvals)
		.doGroupAction;
	}

	groupDeviceValueAction_ { |newvals|
		this.deviceValue_(newvals)
		.doGroupAction;
	}

	keys { ^elements.collect({ |item| dict.findKeyForValue( item ) }) }

	shape { ^elements.shape }

	// this can break nested elementGroups
//	flop { ^elements.flopTogether } /// a bit dirty but it works

	attachChildren {
		elements.do(_.prAddGroup(this));
	}

	detachChildren { |ignoreAction = false|
		if( ignoreAction or: { action.isNil } ) {
			elements.do({ |element|
				element.prRemoveGroup( this );
				if( element.respondsTo( \detachChildren ) ) {
					element.detachChildren( ignoreAction );
				};
			});
		};
	}

	prAddGroup { |group|
		if( ( parent === group )
			or: { groups.notNil and: { groups.includes( group ) } }) {
			^this
		};
		// if group not here yet, add it
		groups = groups.add( group );
		elements.do(_.prAddGroup(this));
	}

	prRemoveGroup { |group|
		groups.remove( group );
	}

	// action support
	action_ { |func|
		action = func;
		if( action.notNil ) {
			this.attachChildren;
		} {
			this.detachChildren;
		};
	}

	addAction { |argAction|
		this.action = action.addFunc(argAction);
	}

	removeAction { |argAction|
		this.action = action.removeFunc(argAction);
	}

	resetAction {
		this.action = nil
	}

	doAction { |...children|
		children = children.copy.add( this );
		if (enabled) { action.value( *children ) };
		parent !? _.doAction( *children );
		groups.do( _.doAction( *children ) );
		this.changed( \doAction, *children );
	}

	// tagging support
	addTag {|... newTags|
		this.do {|elem|
			elem.addTag(*newTags);
		}
	}

	removeTag {|... newTags|
		this.do {|elem|
			elem.removeTag(*newTags);
		}
	}

	tags {
		^this.inject(Set[], {|all, item|
			all.union(item.tags)
		})
	}

	elementsForTag {|... tag|
		^this.flat.select {|el|
			el.tags.includes(*tag)
		};
	}

	doesNotUnderstand { |selector ...args|
		var res;
		if( elements.respondsTo( selector ) ) {
			res = elements.perform( selector, *args );
			"performing %.%(%)\n".format( elements.cs, selector, args.collect(_.cs).join(", ") );
			if( res !== elements ) {
				^res;
			}
		} {
			^super.doesNotUnderstand( selector, *args );
		};
	}

	getElementsForGUI { ^elements.collect({ |item| [ item.key, item ] }).flatten(1); }
}

MKtlElementCollective : MKtlElementGroup {

	*new { |source, name, elemDesc|
		^super.newCopyArgs(name, source).init( elemDesc );
	}

	init { |inElemDesc|
		tags = Set[];
		elemDesc = inElemDesc ?? {
			source.collectiveDescriptionFor(name);
		};
		if( elemDesc.notNil ) {
			ioType = elemDesc[\ioType];
			elements = elemDesc[\elements].valuesKeysCollect({ |item|
				source.elementAt( *item );
			});
			this.addCollectiveToChildren;
		};
	}

	addCollectiveToChildren {
		elements.do(_.prAddCollective(this));
	}

	removeCollectiveFromChildren {
		elements.do(_.prRemoveCollective(this));
	}

}