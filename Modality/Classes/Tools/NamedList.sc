NamedList : List {
	var <names, <dict, <>know = true;

	// very clear
	*new { |pairs|
		^this.fromPairs(pairs);
	}

	// very efficient
	*newUsing { |array, names|
		^super.newUsing(array ?? {[]}).init(names);

	}

	// conversions
	*fromPairs { |pairs|
		var names, values;
		pairs = pairs ?? {[]};
		#values, names = pairs.clump(2).flop;
		^this.newUsing(names, values);
	}

	*fromAssocs { |assocArray|
		^this.newUsing(
			assocArray.collect(_.value),
			assocArray.collect(_.key)
		);
	}

	*fromDict { |dict, names, sortFunc|
		if (names.isNil or: { sortFunc.notNil }) {
			names = SortedList(dict.size, sortFunc);
			dict.keysDo(names.add(_));
		} {
		};

		^this.newUsing(
			names.collect(dict[_]),
			names
		);
	}

	// make names and dict
	init { |argnames|
		if (argnames.isNil) {
			names = (1..array.size).collect(_.asSymbol);
			dict = ();
			names.do { |name, i| dict.put(name, array[i]) };
			^this;
		};

		if (argnames.size != array.size) {
			warn("NamedList: unequal size of array and names:");
			"array: % - %\n".postf(array.size, array);
			"names: % - %\n".postf(argnames.size, argnames);
			^nil
		};

		names = argnames;
		dict = ();
		names.do { |name, i| dict.put(name, array[i]) };
	}

	at { |keyOrNum|
		case {
			keyOrNum.isKindOf(SimpleNumber) } {
			^array[keyOrNum.asInteger] } {
			keyOrNum.isKindOf(Symbol) } {
			^dict[keyOrNum] } {
			keyOrNum.isKindOf(Collection) } {
			^keyOrNum.collect (this.at(_)) } {
			warn(
				"NamedList: keys can only be symbols,"
				"numbers or collections of symbols or numbers.");
				^nil
			};
	}

	// replaces if name is there
	basicAdd { |key, val|
		var index = names.indexOf(key);
		if (index.notNil) {
			array.put(index, val);
			dict.put(key, val);
			^this
		};
		array = array.add(val);
		names = names.add(key);
		dict.put(key, val);
	}
	// synonym
	replace { |name, item|
		this.basicAdd(name, item);
	}

	// remove by identity
	remove { |item|
		var index = array.indexOf(item);
		if (index.notNil) {
			names.removeAt(index);
			dict.removeAt(names[index]);
			^array.removeAt(index);
		};
	}

	removeAt { |keyOrNum|
		var name, item, index;
		case
			{ keyOrNum.isKindOf(Collection) } {
				^keyOrNum.collect (this.removeAt(_)) }

			{ keyOrNum.isKindOf(SimpleNumber) } {
				index = keyOrNum.asInteger;
				item = array.removeAt(index);
				name = names.removeAt(index);
				if (name.notNil) { dict.removeAt(name) };
				^item
			}

			{ keyOrNum.isKindOf(Symbol) } {
				name = keyOrNum;
				index = names.indexOf(name);
				dict.removeAt(name);
				if (index.notNil) {
					item = array.removeAt(index);
					names.removeAt(index);
				};
				^item
			}
	}

	// qualified add - select method
	add { |name, item, active = true, addAction = \replace, otherName|
		this.perform(addAction, name, item, otherName);
	}

	addLast { |name, item, active = true| // no where
		if (item.isNil) { ^this };
		this.removeAt(name);
		this.basicAdd(name, item);
	}

	addFirst { |name, item, active = true| // no where
		if (item.isNil) { ^this };
		this.removeAt(name);
		dict.put(name, item);
		array = array.addFirst(item);
		names = names.addFirst(name);
	}

	addBefore { |name, item, otherName|
		var newIndex;
		if (item.isNil) { ^this };
		this.removeAt(name);
		dict.put(name, item);
		newIndex = names.indexOf(otherName);
		if (newIndex.notNil) {
			names = names.insert(newIndex, name);
			array = array.insert(newIndex, item);
			^this
		};
		// no index, so put at beginning?
		warn("% - otherName '%' not found.! adding to head."
			.format(thisMethod, name));
		this.addFirst(name, item);
	}

	addAfter { |name, item, otherName|
		var newIndex;
		if (item.isNil) { ^this };
		this.removeAt(name);
		dict.put(name, item);
		newIndex = names.indexOf(otherName);
		if (newIndex.notNil) {
			newIndex = newIndex + 1;
			if (newIndex == names.size) {
				^this.basicAdd(name, item);
			} {
				names = names.insert(newIndex, name);
				array = array.insert(newIndex, item);
				^this
			};
		};

		// no index, so put at beginning?
		warn("% - otherName '%' not found.! adding to end."
			.format(thisMethod, name));
		this.basicAdd(name, item);
	}

	do { |func|
		names.do { |key, i| func.value(dict[key], key, i) };
	}

	collect { |func|
		var newvals = names.collect { |key, i|
			func.value(dict[key], key, i)
		};
		^this.class.newUsing(newvals, names.copy);
	}


	put { |keyOrNum, val|
		case
			{ keyOrNum.isKindOf(SimpleNumber) } { ^array[keyOrNum.asInteger] = val }
			{ keyOrNum.isKindOf(Symbol) } { ^this.add(keyOrNum, val) }
			{
				warn("NamedList: put keys can only be symbols or numbers.");
				^this
			};
	}

	// support event-like object modeling
	doesNotUnderstand { arg selector ... args;
		if (know) {
			if (selector.isSetter) {
				^this.add(selector.asGetter, *args);
			};
			^dict.performList(selector, args);
		};
		^this.superPerformList(\doesNotUnderstand, selector, args);
	}

	dump {
		"% dict:\n".postf(this.class);
		dict.keysValuesDo { |k, v|
			"	%: %".format(k, v).postln;
		};
		"NamedList's names/array:\n".post;
		names.do { |name, i|
			"	%: %: %\n".postf(i, name.cs, array[i].cs);
		};
	}

	printOn { |stream| this.storeOn(stream) }

	storeOn { |stream|
		stream << this.class.name << "(["
		<<<* this.storeArgs << "])";
	}

	// inefficient, but reads well
	storeArgs { ^[names, array].flop.flat }
}