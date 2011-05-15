/*

FuncChain: 	a named FunctionList 

	// make one: 	 
(
a = FuncChain([
	\ada, { "ada" }, 
	\bob, { "bob" }
]);
)
	
	// add a name and func to the end
a.add(\carl, { "carl" });

	// replace if name is there
a.add(\ada, { "ada222" });

	// insert relative to a name
a.addAfter(\carl, \otto, { "otto" });
	
	// adds to end if not there
a.addAfter(\bongo, \otto, { "otto222" });

	// adds to head if not there
a.addBefore(\bongo, \otto, { "otto222" });

	// 
a.removeAt(\carl);
a.removeAtIndex(2);

a.putAtIndex(1, \dodo, { "dodo" });

a.add(\eve, { "eveve" });

*/

FuncChain : FunctionList { // a named FunctionList
	var <>names; 
	
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
	
	add { |name, func, addAction, target|
		this.perform( addAction, name, func, target );
	}
	
	addLast{ |name, func| // no where
		var index = names.indexOf(name); 
			// replace at name if there
		if (index.notNil) { 
			array[index] = func; 
		} {	// or add to end
			names = names.add(name); 
			array = array.add(func);
		}; 	
	}
	
	putAtIndex { |index, name, func| 
		array.put(index, func);
		names.put(index, name);
	}
	
	removeAt { |name| 
		var index = names.indexOf(name); 
		if (index.notNil) { this.removeAtIndex(index) };
	}
	
	removeAtIndex { |index| 
		array.removeAt(index);
		names.removeAt(index);
	}
	
	addAfter { |name, func, where| 
		var newIndex = names.indexOf(where); 
		this.removeAt(name);
		
		if (newIndex.notNil) { 
			newIndex = newIndex + 1;
			if (newIndex < (array.size - 2)) { 
				this.putAtIndex(newIndex); 
			} { 
				this.addLast(name, func);
			}
		} { 
			"addAfter: name % not found, adding to end.".format(where).inform;
			this.addLast(name, func);
		};
	}

	addBefore { |name, func, where| 
		var newIndex = names.indexOf(where); 
		this.removeAt(name);
		
		if (newIndex.notNil) { 
			newIndex = newIndex - 1;
			if (newIndex >= 0) { 
				this.putAtIndex(newIndex); 
			} { 
				this.addFirst(name, func);
			}
		} { 
			"addBefore: name % not found, adding to head.".format(where).inform;
			this.addFirst(name, func);
		};
	}
	
	addFirst { |name, func| // no where 
		this.removeAt(name);
		array = array.addFirst(func);
		names = names.addFirst(name); 
	}
	
	replaceAt { |name, func, where| 
		var index = names.indexOf(where); 
		if (index.notNil) { 
			this.putAtIndex(index)
		} { 							// add if absent
			names = names.add(name); 
			array = array.add(func);
		};
	}
	
	at { |name| 
		var index = names.indexOf(name); 
		^if (index.notNil, { array[index] }, nil);
	}
	atIndex { |index| ^array[index] }
}
