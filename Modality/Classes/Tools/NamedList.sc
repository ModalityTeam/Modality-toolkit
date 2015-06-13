NamedList : List {
	var <names, <dict, <>know = true;

	// very clear
	*new { |pairs|
		^this.fromPairs(pairs);
	}

	// very efficient
	*newUsing { |array, names|
		^super.newUsing(array).init(names);

	}

	// conversions
	*fromPairs { |keyValArray|
		var names, values;
		#values, names = keyValArray.clump(2).flop;
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
		case
			{ keyOrNum.isKindOf(SimpleNumber) } { ^array[keyOrNum.asInteger] }
			{ keyOrNum.isKindOf(Symbol) } { ^dict[keyOrNum] }
			{ keyOrNum.isKindOf(Collection) } { ^keyOrNum.collect (this.at(_)) }
			{ warn(
				"NamedList: keys can only be symbols,"
				"numbers or collections of symbols or numbers.");
				^nil
			};
	}

	// replaces if name is there
	add { |key, val|
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
		"NamedList's dict:\n".post; dict.dump;
		"NamedList's names/array:\n".post;
		names.do { |name, i|
			"% : %\n".postf(name.cs, array[i].cs);
		};
	}

	printOn { |stream|
		stream << this.class.name << "(["
		<<<* this.simplifyStoreArgs(this.storeArgs) << "])";
	}

	storeArgs { ^[names, array].flop.flat }
}