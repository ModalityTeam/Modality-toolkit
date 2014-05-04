// FuncChain is a FunctionList with ordered, named functions
// FuncChain2 is a FuncChain with on/off flags for each function
// FCdef - a named FuncChain2

FuncChain : FunctionList {
	var <names;

	storeArgs { ^[names, array].flop.flat.bubble }

	printOn { |stream| this.storeOn(stream) }

	*new { arg pairs;
		var argnames, argfuncs;
		if ( pairs.isNil ){ pairs = []; };
		#argnames, argfuncs = pairs.clump(2).flop;
		if ( argfuncs.isNil ){ argfuncs = []; };
		^super.newCopyArgs(argfuncs).init(argnames);
	}

	init { |argnames| names = argnames }

	put { |name, func|
		var index = names.indexOf(name);
			// replace at name if there
		if (index.notNil) {
			array[index] = func;
		} {	// or add to end
			names = names.add(name);
			array = array.add(func);
		};
	}

	at { |name|
		var index = names.indexOf(name);
		^if (index.notNil, { array[index] }, nil);
	}

	// add supports anonymous adding, as in FunctionList
	add { |name, func, addAction, otherName|
		if (name.isKindOf(Symbol)) {
			if ( addAction.notNil ){
				this.perform( addAction, name, func, otherName );
			} {
				this.put(name, func);
			};
		} {
			// anonymously add
			this.put(nil, func);
		};
	}

	// remove supports anonymous removing, as in FunctionList
	remove { |func|
		var where = array.indexOf(func);
		if (where.notNil) {	this.removeAtIndex(where); }
	}

	removeAt { |name|
		var index;
		if (name.isNil) { ^this }; // not allowed to removeAt(nil)
		index = names.indexOf(name);
		^if (index.notNil) { this.removeAtIndex(index) } { nil };
	}

	// support anonymous addFunc and removeFunc
	addFunc { arg ... functions;
		if(flopped) {
			Error("cannot add a function to a flopped FunctionList").throw
		};
		super.addFunc(functions);
		names = names.addAll(nil ! functions.size);
	}

	// don't reduce to single func or nil, keep the empty FuncChain
	removeFunc { arg function;
		this.remove(function)
	}

	addLast { |name, func|
		this.removeAt(name);
		names = names.add(name);
		array = array.add(func);
	}

	addFirst { |name, func| // no where
		this.removeAt(name);
		array = array.addFirst(func);
		names = names.addFirst(name);
	}

	addBefore { |name, func, otherName|
		var newIndex;
		this.removeAt(name);

		newIndex = names.indexOf(otherName);
		if (newIndex.isNil) {
			warn("FuncChain:addBefore - otherName % not present!\n adding at head.".format(name));
			this.addFirst(name, func)
		} {
			this.insertAtIndex(newIndex, name, func);
		}
	}

	addAfter { |name, func, otherName|
		var newIndex;
		this.removeAt(name);

		newIndex = names.indexOf(otherName);
		if (newIndex.isNil) {
			warn("FuncChain:addAfter - otherName % not present!\n adding % to tail.".format(otherName, name));
			^this.addLast(name, func);
		};

		newIndex = newIndex + 1;
		if (newIndex <= names.lastIndex) {
			this.insertAtIndex(newIndex, name, func);
		} {
			this.addLast(name, func);
		}
	}

	replaceAt { |name, func, otherName|
		var index = names.indexOf(otherName);
 		if (index.notNil) {
			this.putAtIndex(index, name, func)
		} { 							// add if absent
			warn("FuncChain:replaceAt - otherName % not present!\n adding to tail.".format(otherName, name));
			this.put(name, func)
		};
	}
			// move within funcchain
	moveFirst { |name|
		var func = this.removeAt(name);
		if (func.isNil) {
			warn("FuncChain:moveFirst - name % not present.\n".format(name));
			^this;
		};
 		this.addFirst(name, func);
	}

	moveLast { |name|
		var func = this.removeAt(name);
		if (func.isNil) {
			warn("FuncChain:moveLast - name % not present.\n".format(name));
			^this;
		};
 		this.addLast(name, func);
	}

	moveAfter { |name, otherName|
		var func = this.removeAt(name);
		if (func.isNil) {
			warn("FuncChain:moveAfter - name % not present.\n".format(name));
			^this;
		};
		this.addAfter(name, func, otherName);
	}

	moveBefore { |name, otherName|
		var func = this.removeAt(name);
		if (func.isNil) {
			warn("FuncChain:moveBefore - name % not present.\n".format(name));
			^this;
		};
 		this.addBefore(name, func, otherName)
 	}

		// internal methods
	putAtIndex { |index, name, func|
		array.put(index, func);
		names.put(index, name);
	}

	insertAtIndex { |index, name, func|
		names.insert(index, name);
		array.insert(index, func);
	}

	removeAtIndex { |index|
		names.removeAt(index);
		^array.removeAt(index);
	}

	atIndex { |index| ^array[index] }
}
