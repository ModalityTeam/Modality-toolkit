
FuncChain : FunctionList { // a named FunctionList
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

	add { |name, func, addAction, otherName|
		if ( addAction.isNil ){ 
			^this.put(name, func);
		};
		this.perform( addAction, name, func, otherName );
	}

	removeAt { |name| 
		var index = names.indexOf(name); 
		^if (index.notNil) { this.removeAtIndex(index) } { nil };
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

	addBefore { |name, func, othername| 
		var newIndex; 
		this.removeAt(name); 
		
		newIndex = names.indexOf(othername); 
		if (newIndex.isNil) { 
			warn("FuncChain:addBefore - othername % not present!\n adding at head.".format(name));
			this.addFirst(name, func)
		} { 
			this.insertAtIndex(newIndex, name, func); 
		}
	}

	addAfter { |name, func, othername| 
		var newIndex; 
		this.removeAt(name); 
		this.postln;
		
		newIndex = names.indexOf(othername).postln; 
		if (newIndex.isNil) { 
			warn("FuncChain:addAfter - othername % not present!\n adding % to tail.".format(othername, name));
			^this.addLast(name, func);
		};
		
		newIndex = newIndex + 1;
		if (newIndex <= names.lastIndex) { 
			this.insertAtIndex(newIndex, name, func); 
		} { 
			this.addLast(name, func);
		}
	}

	replaceAt { |name, func, othername| 
		var index = names.indexOf(othername);
		this.removeAt(name); 
		if (index.notNil) { 
			this.putAtIndex(index, name, func)
		} { 							// add if absent
			warn("FuncChain:replaceAt - othername % not present!\n adding to tail.".format(othername, name));
			this.put(name, func)
		};
	}
			// later
//	moveLast { |name| 
//		var func = this.at(name); 
//		if (func.isNil) { 
//			warn("FuncChain:moveLast - name % not present.\n".format(name));
//		} {  
//			this.addLast(name, func)
//		}
//	}
//
//	moveFirst { |name| 
//		var func = this.at(name); 
//		if (func.isNil) { 
//			warn("FuncChain:moveFirst - name % not present.\n".format(name));
//		} {  
//			this.addFirst(name, func)
//		}
//	}
//
//	moveAfter { |name, othername| 
//		var func = this.at(name); 
//		if (func.isNil) { 
//			warn("FuncChain:moveLast - name % not present.\n".format(name));
//		} {  
//			this.addAfter(name, func, othername)
//		}
//	}
//
//	moveLast { |name| 
//		var func = this.at(name); 
//		if (func.isNil) { 
//			warn("FuncChain:moveLast - name % not present.\n".format(name));
//		} {  
//			this.addLast(name, func)
//		}
//	}
		
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
