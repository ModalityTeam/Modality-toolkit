MKtlAbstractElementGroup : MAbstractElement {

	var <elements;

	*new { |source, name, elements|
		^super.newCopyArgs( source, name ).elements_(elements);
	}

	init { }

	elements_ { |newElements|
		elements = newElements;
		this.init;
	}

	// array / dict manipulation support

	at { |index| ^elements[index] }

	put { |index, element|
		this.elements = this.elements.put( index, element );
	}

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

	makePlain {
	}

	removeAll {
		elements.do(_.prRemoveGroup( this ));
		this.elements = nil;
	}

	remove { |element|
		element.prRemoveGroup( this );
		 ^this.elements.remove( element );
	}

	indexOf { |element| ^this.elements.indexOf( element ); }

	do { |function| elements.do( function ); }

	flat {
		^this.elements.flat;
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

	value { ^elements.collect(_.value) }

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
		if( ( parent != group ) && { groups.isNil or: { groups.includes( group ).not } }) {
			groups = groups.add( group );
			elements.do(_.prAddGroup(this));
		};
	}

	prRemoveGroup { |group|
		if( groups.notNil ) {
			groups.remove( group );
		};
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

	reset {
		this.action = nil
	}

	doAction { |...children|
		children = children.add( this );
		action.value( *children );
		parent !? _.doAction( *children );
		groups.do( _.doAction( *children ) );
		this.changed( \doAction, *children );
	}

	// tagging support
	addTag {|... newTags|
		this.collect{|elem|
			elem.addTag(*newTags);
		}
	}

	removeTag {|... newTags|
		this.collect{|elem|
			elem.removeTag(*newTags);
		}
	}

	tags {
		^this.inject(Set[], {|all, item|
			all.union(item.tags)
		})
	}

	elementsForTag {|... tag|
		^this.flat.select{|el|
			el.tags.includes(*tag)
		};
	}


}

MKtlElementArray : MKtlAbstractElementGroup {

	init {
		elements = elements ?? { Array.new };
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

	elements_ { |newElements|
		elements = newElements.asArray;
		this.init;
	}

	asArray {
		^elements.collect({ |item|
			if( item.isKindOf( MKtlElementArray ) ) {
				item.asArray;
			} {
				item;
			};
		});
	}

}

MKtlElementDict : MKtlAbstractElementGroup {


	var >guiKeys;
	init {
		elements = elements ?? {Event.new};
		if( elements.size > 0 ) {
			type = elements.values.first.type;
			elements.do({ |item|
				if( addGroupsAsParent ) { item.parent = this };
				if( item.type != type ) {
					type = 'mixed';
				};
			});
		};
	}

	keys { ^elements.keys }

	elements_ { |newElements|
		elements = newElements; // this should be made into a dictionary somehow
		this.init;
	}

	flat { ^this.elements.values.flat }

	flatSize { ^this.values.flatSize }

	at { |index|
		^elements[index]
	}

	put { |key, element|
		this.elements = this.elements.put( key, element );
	}

	add { |association|
		this.put( association.key, association.value );
	}

	indexOf { |element|
		^elements.findKeyForValue( element );
	}


	// gui support
	guiKeys {
		var order;
		order = [ MKtlElement, MKtlElementDict, MKtlElementArray ];
		^guiKeys ?? {
			guiKeys = elements.keys.asArray.sort({ |a,b|
				(order.indexOf( elements[a].class ) ? -1) <= (order.indexOf( elements[b].class ) ? -1);
			}).separate({ |a,b|
				elements[a].class != elements[b].class
			}).collect(_.sort).flatten(1);
		};
	}

	getElementsForGUI { |function = true|
		var array = Array.new(this.elements.size * 2);
		this.guiKeys.do({ |key|
			var val;
			val = elements[ key ];
			if( function.( val, key ) ) {
				array.add( key ); array.add( val );
			};
		});
		^array
	}
}