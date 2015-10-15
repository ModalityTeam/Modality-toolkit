+ Dictionary {

	swapKeys {|aKey, bKey|
		var aSrc, bSrc;

		// find name clashes in dict and swap keys if there are. Otherwise "rename" key.
		aSrc = this[aKey];
		bSrc = this[bKey];

		this[aKey] = bSrc;
		this[bKey] = aSrc;
	}

	changeKeyForValue {|newKey, val|
		var oldName, otherVal;

		// find name clashes in dict and swap keys if there are. Otherwise "rename" key.
		oldName = this.findKeyForValue(val);
		otherVal = this[newKey];

		this[oldName] = otherVal;
		this[newKey] = val;
	}

	atKeys { |keys|
		^this.at(keys) ?? { keys.collect (this.at(_)) }
	}

	deepPost { |depth = 0, sort = true|
		var postfunc = { |key, val|
			"%: ".padLeft(depth + 3, "\t").format(key.cs).postln;
			if (val.isKindOf(Dictionary).not) {
				"% \n".padLeft(depth + 4, "\t").format(val.cs).postln;
			} {
				val.deepPost(depth + 1, sort)
			};
		};
		if (sort) {
			this.sortedKeysValuesDo(postfunc);
		} {
			this.keysValuesDo(postfunc);
		}
	}

	traverseAt {|keys|
		var key, otherKeys, preResult;

		# key ... otherKeys = keys;

		preResult = this.at(key);

		if (otherKeys.isEmpty) {
			^preResult
		} {
			^(preResult !? {preResult.traverseAt(otherKeys)})
		}
	}

	traversePut {|keys, value|
		var key, otherKeys, next;

		// do nothing if keys are empty
		if (keys.isNil) {^this};

		# key ... otherKeys = keys;

		if (otherKeys.isEmpty) {
			this.put(key, value);
			^this
		};

		next = this.at(key);
		if (next.isNil) { // create sub-dicts if needed
			this.put(
				key,
				next = this.class.new
			);

		};
		next.traversePut(otherKeys, value);
	}
}

+ SequenceableCollection {

	// unified method for Array/index, Array of assocs and dicts
	valuesKeysDo { |func|
		if (this.isAssociationArray) {
			this.do { |assoc, i|
				func.value(assoc.value, assoc.key, i);
			};
		};
		this.do(func)
	}

	valuesKeysCollect { |func|
		if (this.isAssociationArray) {
			^this.collect { |assoc|
				assoc.key -> func.value(assoc.value, assoc.key);
			};
		};
		^this.collect(func)
	}

	traverseDo { |doAtLeaf, isLeaf, deepKeys, doAtNode|
		var result;
		var canTraverse = { |el| el.mutable and: { el.respondsTo(\traverseDo) } };
		isLeaf = isLeaf ? { |el| (el.mutable and: { el.respondsTo(\traverseDo) }).not };

		this.do { |elem, index|
			var myDeepKeys;
			var isAssoc = elem.isKindOf(Association);
			if (isAssoc) { index = elem.key; elem = elem.value };
			myDeepKeys = deepKeys.asArray ++ index;

			if (isLeaf.(elem, myDeepKeys)) {
				doAtLeaf.(elem, myDeepKeys)
			} {
				if (canTraverse.(elem)) {
					result = elem.traverseCollect(doAtLeaf, isLeaf, myDeepKeys);
					doAtNode.value(result, myDeepKeys);
				} {
					"traverseDo - object is malformed:\n"
					"element % at % is not a leaf and not a collection."
					.format(elem, index);
					elem;
				};
			}
		};
	}

	traverseCollect { |doAtLeaf, isLeaf, deepKeys, doAtNode|

		var canTraverse = { |el| el.mutable and: { el.respondsTo(\traverseCollect) } };
		isLeaf = isLeaf ? { |el| (el.mutable and: { el.respondsTo(\traverseCollect) }).not };
		^this.collect { |elem, index|
			var myDeepKeys, result;
			var isAssoc = elem.isKindOf(Association);
			if (isAssoc) { index = elem.key; elem = elem.value };
			myDeepKeys = deepKeys.asArray ++ index;

			if (isLeaf.(elem, myDeepKeys)) {
				result = doAtLeaf.(elem, myDeepKeys)
			} {
				if (canTraverse.(elem)) {
					result = elem.traverseCollect(doAtLeaf, isLeaf, myDeepKeys);
					result = doAtNode.value(result, myDeepKeys) ? result;
					result;
				} {
					"traverseDo - object is malformed:\n"
					"element % at % is not a leaf and not a collection."
					.format(elem, index);
					elem
				};
			};
			if (isAssoc) { index -> result } { result }
		};
	}

	unpackAssoc { |value, index|

	}
}
+ Dictionary {

	// unified method for Array/index, Array of assocs and dicts
	valuesKeysDo { |func|
		this.keysValuesDo { |key, val, i| func.(val, key, i) }
	}

	valuesKeysCollect { |func|
		^this.collect { |key, val| func.value(val, key) };
	}

	traverseDo { |doAtLeaf, isLeaf, deepKeys, doAtNode|
		var result;
		var canTraverse = { |el| el.mutable and: { el.respondsTo(\traverseDo) } };
		isLeaf = isLeaf ? { |el| (el.mutable and: { el.respondsTo(\traverseDo) }).not };

		this.keysValuesDo { |key, elem|
			var myDeepKeys = deepKeys.asArray ++ key;
			if (isLeaf.(elem)) {
				doAtLeaf.(elem, myDeepKeys)
			} {
				if (canTraverse.(elem)) {
					result = elem.traverseCollect(doAtLeaf, isLeaf, myDeepKeys);
					doAtNode.value(result, myDeepKeys);
				} {
					"traverseDo - object is malformed:\n"
					"element % at % is not a leaf and not a collection."
					.format(elem, key);
					elem
				};
			}
		};
	}

	traverseCollect { |doAtLeaf, isLeaf, deepKeys, doAtNode|
		var canTraverse = { |el| el.mutable and: { el.respondsTo(\traverseDo) } };
		isLeaf = isLeaf ? canTraverse.not;
		^this.collect { |elem, key|
			var result;
			var myDeepKeys = deepKeys.asArray ++ key;
			if (isLeaf.(elem)) {
				result = doAtLeaf.(elem, myDeepKeys)
			} {
				if (canTraverse.(elem)) {
					result = elem.traverseCollect(doAtLeaf, isLeaf, myDeepKeys);
					result = doAtNode.value(result, myDeepKeys) ? result;
				} {
					"traverseCollect - object is malformed: element % at %"
					"is not a leaf and not a traverseable collection."
					.format(elem, key);
					elem
				};
			};
			result
		};
	}
}


