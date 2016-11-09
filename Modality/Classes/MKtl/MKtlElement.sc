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
	var <>enabled = true;

	// keep current and previous value here
	var <deviceValue;
	var <prevDeviceValue;

	var <lastUpdateTime = 0;

	// server support, currently only one server per element supported.
	var <bus;

	// nested MKtlElement / MKtlElementGroup support
	var <>parent;
	var <groups;
	var <collectives;

	// the dict from the MKtlDesc that has this element's properties
	var <elemDesc;


	*new { |name, source|
		^super.newCopyArgs( name, source ).init;
	}

	init {
		tags = Set[];
	}

	getSpec { |specName|
		^if (source.notNil) {
			source.getSpec(specName)
		} {
			MKtl.globalSpecs[specName] ?? { \unipolar.asSpec };
		};
	}

	// overwrite when using osc timetags?
	updateTime { lastUpdateTime = Process.elapsedTime }

	hasOut { ^elemDesc.notNil and: { [\out, \inout].includes( elemDesc[\ioType] ) } }

	trySend {
		if (this.hasOut
			and: { source.notNil
				and: { source.hasDevice }}) {
			source.send(name, this.deviceValue);
			^true
		};
		^false
	}

		// MAbstractElement does no mapping, so it has no spec.
		// the get/set value methods are all flattened out
		// for speed and reading clarity
	value_ { | newval |
		if (newval.isNil) { ^this };
		prevDeviceValue = deviceValue;
		deviceValue = newval;

		this.trySend;
		this.updateBus;
		lastUpdateTime = Process.elapsedTime;
		this.changed( \value, deviceValue );
	}

	valueNoSend_ { | newval |
		if (newval.isNil) { ^this };
		prevDeviceValue = deviceValue;
		deviceValue = newval;
		this.updateBus;
		lastUpdateTime = Process.elapsedTime;
		this.changed( \value, deviceValue );
	}

	valueAction_ { | newval |
		if (newval.isNil) { ^this };
		prevDeviceValue = deviceValue;
		deviceValue = newval;
		this.updateBus;
		lastUpdateTime = Process.elapsedTime;
		this.doAction;
		this.changed( \value, deviceValue );
	}

	// just aliases because we have no spec
	deviceValue_ { | newval | ^this.value_(newval) }
	deviceValueAction_ { | newval | ^this.valueAction_(newval) }
	deviceValueNoSend_ { | newval | ^this.valueNoSend_(newval) }

	value { ^deviceValue }
	prevValue { ^prevDeviceValue }
	// shortcut for switches, like MKtlElementGroup().isOn
	isOn { ^this.value > 0 }

	timeSinceLast { ^Process.elapsedTime - lastUpdateTime }

	enable { enabled = true }
	disable { enabled = false }

	doAction {
		if (enabled) { action.value( this ) };
		parent !? _.doAction( this );
		groups.do( _.doAction( this ) );
		this.changed( \doAction, this );
	}

	// where the action is:
	addAction { |argAction|
		action = action.addFunc(argAction);
	}

	removeAction { |argAction|
		action = action.removeFunc(argAction);
	}

	reset {
		this.deprecated(thisMethod, this.class.findMethod(\resetAction));
		this.resetAction;
	}

	resetAction { action = nil }

	flat { ^[this] }

	// pattern support
	embedInStream { |inval|
		this.value.embedInStream(inval);
		^inval
	}

	asStream {
		^Pfunc({ |inval| this.value }).asStream
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
	// adc - index, key, and MEGroup.indexOf is really confusing.
	// MKtlElements now always have an index and a key,
	// so we can always ask for the one we want:
	// .index and .indices return integers,
	// .key and .keys return dict keys,
	// MKtlElementGroup:
	// elemIndexOf == indexOf,  returns index of an element in group
	// elemKeyOf returns key of an element in group

	// backwards compat
	index {
		^this.indexInGroup
	}

	key {
		^this.keyInGroup
	}

	indices {
		// "// using %\n".postf(thisMethod);
		^this.parent !? { parent.indices ++ [ this.index ] };
	}

	keys {
		// "// using %\n".postf(thisMethod);
		^this.parent !? { parent.keys ++ [ this.key ] };
	}

	// get index or key specifically
	indexInGroup {
		^this.parent !? _.elemIndexOf(this)
	}

	keyInGroup {
		^this.parent !? _.elemKeyOf(this)
	}

	// for printOn only, this will not remake it properly from code.
	storeArgs { ^[name, type] }

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
		// types found with MKtlDesc.elementTypesUsed.size
		types = [ 'accelAxis', 'bender', 'button', 'compass', 'cvIn', 'cvOut', 'encoder', 'fader', 'gyroAxis', 'hatSwitch', 'joyAxis', 'key', 'keyTouch', 'knob', 'led', 'lever', 'midiBut', 'mouseAxis', 'mouseWheel', 'multiPurpose', 'option', 'pad', 'padX', 'padY', 'pianoKey', 'ribbon', 'rumble', 'scroller', 'slider', 'springFader', 'switch', 'thumbAxis', 'touch', 'trigger', 'voltage', 'wheel', 'xfader' ]
	}

	// source is used for sending back to the device.
	*new { |name, desc, source|
		^super.newCopyArgs(name, source)
		.elemDesc_(desc).init;
	}

	elemDesc_ { |dict|
		var mySpecOrName;
		if (dict.isNil) {
			inform("MKtlElement(%): no element description given.".format(name));
			^this
		};
		// fill instvars
		elemDesc = dict;
		type = elemDesc[\elementType] ? elemDesc[\type];
		ioType = elemDesc[\ioType] ? \in;

		this.setSpecFromDesc(dict);

		// keep old values if there.
		if (deviceValue.isNil) {
			deviceValue = prevDeviceValue = this.defaultValue;
		};

	}

	setSpecFromDesc { |desc|
		var mySpecOrName = desc[\deviceSpec] ? desc[\spec];

		if (mySpecOrName.isKindOf(Symbol)) {
			deviceSpec = (source ? MKtl).getSpec(mySpecOrName);
		};

		if (mySpecOrName.isNil) {
			warn("% : deviceSpec for '%' is missing!".format(this, mySpecOrName));
			"using [0, 1].asSpec instead.".postln;
			mySpecOrName = [0,1];
		};
		mySpecOrName = mySpecOrName.asSpec;

			// and now we will have a spec.
		this.deviceSpec_(mySpecOrName);
	}


	deviceSpec_ {|newspec|
		if (newspec.isNil) {
			^this.getSpec;
		};
		newspec = newspec.asSpec;
		elemDesc[\deviceSpec] = newspec;
		deviceSpec = newspec;
	}

	// just update params on the fly, keep description in sync
	updateDescription { |dict|
		dict.keysValuesDo { |key, val|
			elemDesc.put(key, val);
		};
		// sync back if these changed
		this.deviceSpec_(dict[\spec]);
		type = elemDesc[\elementType] ? elemDesc[\type];
		ioType = elemDesc[\ioType] ? \in;
	}

	defaultValue {
		^if (deviceSpec.notNil) { deviceSpec.default} { 0 };
	}

	// In MKtl, the instvar value is in deviceSpec range,
	// so e.g. .value converts value to unipolar and .value_ converts back

	// numbers as they come from device
	value { ^deviceSpec.unmap(deviceValue) }
	prevValue { ^deviceSpec.unmap(prevDeviceValue) }

	// the methods are flattened out for speed and reading clarity
	// set value in unipolar, so:
	value_ { | newval |
		if (newval.isNil) { ^this };
		prevDeviceValue = deviceValue;
		deviceValue = deviceSpec.map(newval);
		// [newval, deviceSpec, deviceValue].postln;

		this.trySend;
		collectives.do(_.trySend);
		this.updateBus;
		lastUpdateTime = Process.elapsedTime;
		this.changed( \value, newval );
	}
	valueNoSend_ { | newval |
		if (newval.isNil) { ^this };
		prevDeviceValue = deviceValue;
		deviceValue = deviceSpec.map(newval);
		this.updateBus;
		lastUpdateTime = Process.elapsedTime;
		this.changed( \value, newval );
	}
	valueAction_ { | newval |
		if (newval.isNil) { ^this };
		prevDeviceValue = deviceValue;
		deviceValue = deviceSpec.map(newval);

		this.trySend;
		collectives.do(_.trySend);
		this.updateBus;
		lastUpdateTime = Process.elapsedTime;
		this.doAction;
		this.changed( \value, newval );
	}

	// no spec here, so we can redirect to superclass
	deviceValue_ { | newval | ^super.value_(newval) }
	deviceValueAction_ { | newval | ^super.valueAction_(newval) }
	deviceValueNoSend_ { | newval | ^super.valueNoSend_(newval) }

}
