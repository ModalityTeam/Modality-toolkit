// dis/en-able indiv. funcs,
// keep flags in a separate array - maybe not the best way

// possible speed optimization for value method:
// make an array of all activeFuncs and call .value on that only

// where to keep lists of func names that belong together?
// in Halo for now

FuncChain2 : FuncChain { // a named FunctionList
	var <flags, <tracing = false;

	trace { |bool = true| tracing = bool; }

	*new { arg pairs;
		var argnames, argfuncs;
		if ( pairs.isNil ){ pairs = []; };
		#argnames, argfuncs = pairs.clump(2).flop;
		if ( argfuncs.isNil ){ argfuncs = []; };
		^super.newCopyArgs(argfuncs).init(argnames);
	}

	init { |argnames|
		names = argnames;
		flags =  argnames.collect(true);
	}

	enable { |which, flag = true|
		if (which == \all) { which = names };
		which.do { |name|
			var index = names.indexOf(name);
			if (index.notNil) { flags.put(index, flag) };
		}
	}

	disable { |which| this.enable(which, false) }

	enableFrom { |which, groupList|
		this.disable(groupList).enable(which);
	}

	isEnabled { |name| ^flags[names.indexOf(name)] }

	put { |name, func|
		var index = names.indexOf(name);
			// replace at name if there
		if (index.notNil) {
			array[index] = func;
		} {	// or add to end
			names = names.add(name);
			array = array.add(func);
			flags = flags.add(true);
		};
	}

	// add supports anonymous adding, as in FunctionList
	add { |name, func, addAction, otherName, flag = true|
		if (name.isKindOf(Symbol)) {
			if ( addAction.notNil ){
				this.perform( addAction, name, func, otherName, flag );
			} {
				this.put(name, func);
			};
		} {
			// anonymously add
			this.put(nil, func);
		};
	}

		// only evaluate the ones with true flags,
		// but keep the original order of the funcs
	value { arg ... args;
		var res = array.collect { |func, i|
			if (flags[i]) { func.valueArray(args) }
		};
		if(flopped) { res = res.flop };
		if(tracing) { ("FuncChain2.value trace: " + res).postln };
		^res
	}

	// support anonymous addFunc and removeFunc
	addFunc { arg ... functions;
		if(flopped) {
			Error("cannot add a function to a flopped FunctionList").throw
		};
		super.addFunc(functions);
		names = names.addAll(nil ! functions.size);
		flags = flags.addAll(true ! functions.size);
	}

	addLast { |name, func, flag = true|
		this.removeAt(name);
		names = names.add(name);
		array = array.add(func);
		flags = flags.add(flag);
	}

	addFirst { |name, func, flag = true| // no where
		this.removeAt(name);
		array = array.addFirst(func);
		names = names.addFirst(name);
		flags = flags.addFirst(flag);
	}

	addBefore { |name, func, otherName, flag = true|
		var newIndex;
		this.removeAt(name);

		newIndex = names.indexOf(otherName);
		if (newIndex.isNil) {
			warn("FuncChain:addBefore - otherName % not present!\n adding at head.".format(name));
			this.addFirst(name, func, flag)
		} {
			this.insertAtIndex(newIndex, name, func, flag);
		}
	}

	addAfter { |name, func, otherName, flag = true|
		var newIndex;
		this.removeAt(name);

		newIndex = names.indexOf(otherName);
		if (newIndex.isNil) {
			warn("FuncChain:addAfter - otherName % not present!\n adding % to tail.".format(otherName, name));
			^this.addLast(name, func, flag);
		};

		newIndex = newIndex + 1;
		if (newIndex <= names.lastIndex) {
			this.insertAtIndex(newIndex, name, func);
		} {
			this.addLast(name, func, flag);
		}
	}

	replaceAt { |name, func, otherName, flag = true|
		var index = names.indexOf(otherName);
 		if (index.notNil) {
			this.putAtIndex(index, name, func, flag)
		} { 							// add if absent
			warn("FuncChain:replaceAt - otherName % not present!\n adding to tail.".format(otherName, name));
			this.put(name, func, flag)
		};
	}

		// internal methods
	putAtIndex { |index, name, func, flag = true|
		array.put(index, func);
		names.put(index, name);
		flags.put(index, flag);
	}

	insertAtIndex { |index, name, func, flag = true|
		names.insert(index, name);
		array.insert(index, func);
		flags.insert(index, flag);
	}

	removeAtIndex { |index|
		names.removeAt(index);
		flags.removeAt(index);
		^array.removeAt(index);
	}
}

FCdef : FuncChain {
	classvar <all;
	var <key;

	*initClass { all = (); }

	*at { |key| ^all[key]; }

	// access by name - how to handle extra args if name exists?
	*new { |key, pairs|
		var res = this.at(key);
		if(res.isNil) {
			res = super.new(pairs).prAdd(key);
		} {
			// not sure that this is really smart
			// better block setting like this?
			if(pairs.notNil) {
				pairs.postln.pairsDo(res.add(_, _));
			};
		}
		^res
	}
	prAdd { |argKey|
		key = argKey;
		all.put(key, this);
	}

	storeArgs { ^[key] }
	printOn { |stream| ^this.storeOn(stream) }
}

FC2def : FuncChain2 {
	classvar <all;
	var <key;

	*initClass { all = (); }

	*at { |key| ^all[key]; }

	// access by name - how to handle extra args if name exists?
	*new { |key ... pairs|
		var res = this.at(key);
		if(res.isNil) {
			res = super.new(*pairs).prAdd(key);
		} {
			// not sure that this is really smart
			// better block setting like this?
			if(pairs.notNil) {
				pairs.pairsDo(res.add(_));
			};
		}
		^res
	}
	prAdd { |argKey|
		key = argKey;
		all.put(key, this);
	}

	storeArgs { ^[key] }
	printOn { |stream| ^this.storeOn(stream) }
}