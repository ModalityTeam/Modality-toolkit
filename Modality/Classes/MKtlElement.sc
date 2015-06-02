/*
superclass for MKtlElement and MKtlElementGroup
leave type, ioType etc as instvars for speed reasons
MAbstractElement.allSubclasses
*/


MAbstractElement {

	classvar <>addGroupsAsParent = false;

	var <name; // its name in MKtl.elements
	var <source; // the MKtl it belongs to - not used anywhere
	var <type; // its type.
	var <tags; // array of user-assignable tags

	var <ioType; // can be \in, \out, \inout

	var <>action;

	// keep current and previous value here
	var <deviceValue;
	var <prevValue;

	// server support, currently only one server per element supported.
	var <bus;

	// nested MKtlElement / MKtlElementGroup support
	var <>parent;
	var <groups;
	var <collectives;

	// the dict from the MKtlDesc
	// that has this element's properties
	var <elementDescription;


	*new { |source, name|
		^super.newCopyArgs( source, name).init;
	}

	init {
		tags = Set[];
	}

	getSpec { |specName|
		^if (source.notNil) {
			source.getSpec(specName)
		} {
			MKtl.globalSpecs[specName] ?? { [0,1].asSpec };
		};
	}

	hasOut { ^[\out, \inout].includes( this.elementDescription[\ioType] ) }

	trySend {
		if (this.hasOut
			and: { source.notNil
				and: { source.hasDevice }}) {
			source.send(name, deviceValue);
			^true
		};
		^false
	}

		// MAbstractElement does no mapping, so it has no spec.
		// the get/set value methods are all flattened out
		// for speed and reading clarity
	value_ { | newval |
		if (newval.isNil) { ^this };
		prevValue = deviceValue;
		deviceValue = newval;
		this.trySend;
		this.updateBus;
		this.changed( \value, deviceValue );
	}
	valueNoSend_ { | newval |
		if (newval.isNil) { ^this };
		prevValue = deviceValue;
		deviceValue = newval;
		this.updateBus;
		this.changed( \value, deviceValue );
	}
	valueAction_ { | newval |
		if (newval.isNil) { ^this };
		prevValue = deviceValue;
		deviceValue = newval;
		this.trySend;
		this.updateBus;
		this.doAction;
		this.changed( \value, deviceValue );
	}
	// just aliases because we have no spec
	deviceValue_ { | newval | ^this.value_(newval) }
	deviceValueAction_ { | newval | ^this.valueAction_(newval) }
	deviceValueNoSend_ { | newval | ^this.valueNoSend_(newval) }

	value { ^deviceValue }

	doAction {
		action.value( this );
		parent !? _.doAction( this );
		groups.do( _.doAction( this ) );
	}

	// UGen support
	updateBus {
		bus !? {bus.setn(this.value.asArray)};
	}

	initBus {|server|
		server = server ?? { Server.default };
		server.serverRunning.not.if{^this};
		bus.isNil.if({
			bus = Bus.control(server, (deviceValue ? 1).asArray.size);
		});
	}

	freeBus {
		bus.notNil.if({
			Bus.free;
		});
	}

	kr {|server|
		// server is an optional argument that you only have to set once
		// and only if the server for your bus is not the defualt one.
		this.initBus(server);
		^In.kr(bus.index, bus.numChannels)
	}

	// support for navigation inside ordered element hierarchy
	index {
		^this.parent !? _.indexOf( this );
	}

	key { ^this.index }

	indices {
		^this.parent !? { |x| x.indices ++ [ this.index ] };
	}

	// for printOn only, this will not remake it properly from code.
	storeArgs { ^[name, type, this.index] }

	printOn { | stream | this.storeOn(stream) }

	// handling groups
	prAddGroup { |group|
		if( parent === group ) { ^this };
		if (groups.notNil and: { groups.includes( group ) }) {
			^this
		};
		// really do it
		groups = groups.add( group );
	}

	prRemoveGroup { |group|
		groups.remove( group );
	}

	// MKtlElementCollective support
	prAddCollective { |collective|
		if( collectives.isNil or: { collectives.includes( collective ).not }) {
			collectives = collectives.add( collective );
		};
	}

	prRemoveCollective { |collective|
		if( collectives.notNil ) {
			collectives.remove( collective );
		};
	}

	asBaseClass {
		^this;
	}


	//tagging support
	addTag {|... newTags|
		tags = tags.union(newTags.flat);
	}
	removeTag {|... newTags|
		tags = tags - newTags.flat;
	}
	includesTag {|... tag|
		^tag.isSubsetOf(tags)
	}
	clearTags {
		tags = Set[];
	}
}

MKtlElement : MAbstractElement {
	classvar <types;

	// for mapping between numbers from device
	// and internal value between [0, 1]
	var <deviceSpec;

	*initClass {
		types = (
			\slider: \x,
			\button: \x,
			\thumbStick: [\joyAxis, \joyAxis, \button],
			\joyStick: [\joyAxis, \joyAxis, \button]
		)
	}

	// source is used for sending back to the device.
	*new { |name, desc, source|
		^super.newCopyArgs(name, source)
		.elementDescription_(desc);
	}

	elementDescription_ { |dict|
		var mySpecOrName;
		if (dict.isNil) {
			inform("MKtlElement(%): no element description given.".format(name));
			^this
		};
		// fill instvars
		elementDescription = dict;
		type = elementDescription[\type];
		ioType = elementDescription[\ioType] ? \in;

		this.setSpecFromDesc(dict);

		// keep old values if there.
		if (deviceValue.isNil) {
			deviceValue = prevValue = this.defaultValue;
		};

	}

	setSpecFromDesc { |desc|
		var mySpecOrName = desc[\deviceSpec] ? desc[\spec];

		if (mySpecOrName.isKindOf(Symbol)) {
			deviceSpec = (source ? MKtl).getSpec(mySpecOrName);
		};

		if (mySpecOrName.isNil) {
			warn("deviceSpec for '%' is missing!".format(this));
			"using [0, 1].asSpec instead".postln;
		} {
		mySpecOrName = mySpecOrName.asSpec;
		};
			// and now we will have a spec.
		this.deviceSpec_(mySpecOrName);
	}


	deviceSpec_ {|newspec|
		if (newspec.isNil) {
			^this.getSpec;
		};
		newspec = newspec.asSpec;
		elementDescription[\deviceSpec] = newspec;
		deviceSpec = newspec;
	}

	// just update params on the fly, keep description in sync
	updateDescription { |dict|
		dict.keysValuesDo { |key, val|
			elementDescription.put(key, val);
		};
		// sync back if these changed
		this.deviceSpec_(dict[\spec]);
		type = elementDescription[\type];
		ioType = elementDescription[\ioType] ? \in;
	}

	defaultValue {
		^if (deviceSpec.notNil) { deviceSpec.default} { 0 };
	}

	// In MKtl, the instvar value is in deviceSpec range,
	// so e.g. .value converts value to unipolar and .value_ converts back

	// numbers as they come from device
	value { ^deviceSpec.unmap(deviceValue) }

	// the methods are flattened out for speed and reading clarity
	// set value in unipolar, so:
	value_ { | newval |
		if (newval.isNil) { ^this };
		prevValue = deviceValue;
		deviceValue = deviceSpec.map(newval);
		// [newval, deviceSpec, deviceValue].postln;

		this.trySend;
		this.updateBus;
		this.changed( \value, newval );
	}
	valueNoSend_ { | newval |
		if (newval.isNil) { ^this };
		prevValue = deviceValue;
		deviceValue = deviceSpec.map(newval);
		this.updateBus;
		this.changed( \value, newval );
	}
	valueAction_ { | newval |
		if (newval.isNil) { ^this };
		prevValue = deviceValue;
		deviceValue = deviceSpec.map(newval);
		this.trySend;
		this.updateBus;
		this.doAction;
		this.changed( \value, newval );
	}
	// no spec here, so we can redirect to superclass
	deviceValue_ { | newval | ^super.value_(newval) }
	deviceValueAction_ { | newval | ^super.valueAction_(newval) }
	deviceValueNoSend_ { | newval | ^super.valueNoSend_(newval) }



	// where the action is:
	addAction { |argAction|
		action = action.addFunc(argAction);
	}

	removeAction { |argAction|
		action = action.removeFunc(argAction);
	}

	resetAction {
		action = nil
	}

	// assuming that something setting the element's value will
	// first set the value and then call doAction (like in Dispatch)
	doAction {
		super.doAction;
		this.changed( \doAction, this );
	}


	// pattern support
	embedInStream { |inval|
		this.value.embedInStream(inval);
		^inval
	}

	asStream {
		^Pfunc({ |inval| this.value }).asStream
	}
}
