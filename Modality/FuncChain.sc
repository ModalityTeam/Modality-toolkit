
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
	
	add { |name, func, addAction = \addToTail, target|
		this.perform( addAction, name, func, target );
	}
		// adc: aliases, I like my names better, sorry. 
	addToHead {  |name, func| ^this.addFirst(name, func) }
	addToTail {  |name, func| ^this.addLast(name, func) }
	addReplace {  |name, func| ^this.replaceAt(name, func) }
	
	addLast { |name, func| // no where
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
		^if (index.notNil) { this.removeAtIndex(index) } { nil };
	}
	
	removeAtIndex { |index| 
		names.removeAt(index);
		^array.removeAt(index);
	}
	
	addAfter { |name, func, where| 
		var newIndex = names.indexOf(where); 
		this.removeAt(name);
		
		if (newIndex.notNil) { 
			newIndex = newIndex + 1;
			if (newIndex < (array.size - 1)) { 
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
