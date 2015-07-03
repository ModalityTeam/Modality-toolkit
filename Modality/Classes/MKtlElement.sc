/*
MAbstractElement
    |        |
   /          \
  /            \
MKtlElement   MDispatchOut

MDispatchOut : MAbstractElement {}

Why do we need this hierarchy ??
*/
MAbstractElement {

	var <source; // the MKtl it belongs to
	var <name; // its name in MKtl.elements
	var <type; // its type.
	var <tags; // array of user-assignable tags

	var <ioType; // can be \in, \out, \inout

	var <>action;

	// keep value and previous value here
	var <value;
	var <prevValue;

	// server support, currently only one server per element supported.
	var <bus;

	// nested MKtlElement / MKtlElementGroup support
	var <>parent;
	var <groups;
	var <collectives;

	var <elementDescription;	 //its particular device description
	                         // of type: ( 'midiChan': Int, 'midiMsgType': symbol, 'spec': ControlSpec,
	                         //           'ccNum': Int, 'specName': symbol, 'type': Symbol )
	                         // i.e.   ( 'chan':0, 'midiMsgType':'cc', 'spec': ControlSpec,
	                         //          'ccNum': 24, 'specName':'midiCC', 'type':'midiBut' )

	classvar <>addGroupsAsParent = false;

	*new { |source, name|
		^super.newCopyArgs( source, name).init;
	}

	prMaybeSend {
		if( [\out, \inout].includes( this.elementDescription.ioType ) ) {
			source.send(name, this.rawValue)
		}
	}

	//value_ is (possibly) mapped and sends out the value
	//rawValue_ is not mapped and does not send out value
	value_ { | newval |
		this.rawValue_( newval );
		collectives.do(_.prMaybeSend);
		this.prMaybeSend
	}

	valueAction_ { |newval|
		this.value_( newval );
		this.doAction;
	}

	rawValue_{|newval|
		// copies the current state to:
		prevValue = value;
		// updates the state with the latest value
		value = newval;
		this.changed( \value, value );
		this.updateValueOnServer;
	}

	rawValueAction_{|newval|
		this.rawValue_( newval );
		this.doAction;
	}

	doAction {
	//	source.recordRawValue( name, value );
		action.value( this );
		parent !? _.doAction( this );
		groups.do( _.doAction( this ) );
	}

	// UGen support
	updateValueOnServer {
		//this.initBus;
		// set bus values
		bus !? {bus.setn(this.value.asArray)};
	}

	initBus {|server|
		server = server ?? {Server.default};
		server.serverRunning.not.if{^this};
		bus.isNil.if({
			bus = Bus.control(server, (value ? 1).asArray.size);
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

	index {
		^this.parent !? _.indexOf( this );
	}

	key { ^this.index }

	indices {
		var p = this.parent;
		^p !? { p.indices ++ [ this.index ] };
	}

	printOn { | stream |
		stream << "an " << this.class.name << "(" << this.name.cs << ", " << this.type.cs << ", " << this.index << ")" ;
	}

	// MKtlElementGroup support
	prAddGroup { |group|
		if( ( parent != group ) && { groups.isNil or: { groups.includes( group ).not } }) {
			groups = groups.add( group );
		};
	}

	prRemoveGroup { |group|
		if( groups.notNil ) {
			groups.remove( group );
		};
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

MKtlElement : MAbstractElement{
	classvar <types;

	var <spec; // ControlSpec -> its spec

	*initClass {
		types = (
			\slider: \x,
			\button: \x,
			\thumbStick: [\joyAxis, \joyAxis, \button],
			\joyStick: [\joyAxis, \joyAxis, \button]
		)
	}

	*new { |source, name|
		^super.newCopyArgs( source, name).init;
	}

	init {
		tags = Set[];
		elementDescription = source.elementDescriptionFor(name);
		if( elementDescription.notNil ) {
			spec = elementDescription[\spec];
			if (spec.isNil) {
				//NB: warning is done in MKtl
				// warn("spec for '%' is missing! using [0,1].asSpec instead".format(spec));
				spec = [0,1].asSpec;
			};
			value = prevValue = spec.default ? 0;
			type = elementDescription[\type];
			ioType = elementDescription[\ioType];
			if ( ioType.isNil ){
				ioType = \in; // default is in
			};
		};

	}

	defaultValue {
		^(spec.default ? 0);
	}

	value { ^spec.unmap(value) }

	value_ {|newval|
		^super.value_(spec.map(newval))
	}

	addAction { |argAction|
		action = action.addFunc(argAction);
	}

	removeAction { |argAction|
		action = action.removeFunc(argAction);
	}

	reset {
		action = nil
	}

	// assuming that something setting the element's value will first set the value and then call doAction (like in Dispatch)
	doAction { |sendValue = true|
		super.doAction;
		this.changed( \doAction, this );
	}

	rawValue { ^value }

	rawValue_ {|newVal|
		super.rawValue_(newVal)
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



















