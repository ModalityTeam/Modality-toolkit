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
}

+ Dictionary {
	// atKeys { |keys|
	// 	if (keys.isKindOf(Collection)) {
	// 		^keys.collect (this.at(_))
	// 	};
	// 	^this.at(keys);
	// }
		// now also works for any object as keys in dicts
	// Dictionary[ $a -> 1, $b -> 2, "ab" -> 12 ].atKeys([$a, $b, "abc"]);
		atKeys { |keys|
		^this.at(keys) ?? { keys.collect (this.at(_)) }
	}

}

+ SequenceableCollection {

	traverseDo { |doAtLeaf, isLeaf, deepKeys|
		var canTraverse = { |el| el.mutable and: { el.respondsTo(\traverseDo) } };
		isLeaf = isLeaf ? { |el| (el.mutable and: { el.respondsTo(\traverseDo) }).not };
		this.do { |elem, index|
			var myDeepKeys = deepKeys.asArray ++ index;
			var isAssoc = elem.isKindOf(Association);
			if (isAssoc) { index = elem.key; elem = elem.value };
			if (isLeaf.(elem, myDeepKeys)) {
				doAtLeaf.(elem, myDeepKeys)
			} {
				if (canTraverse.(elem)) {
					elem.traverseDo(doAtLeaf, isLeaf, myDeepKeys);
				} {
					"traverseDo found malformed object:\n"
					"at % element % is not a leaf and not a collection."
					.format(index, elem);
				};
			}
		};
	}
	traverseCollect { |doAtLeaf, isLeaf, deepKeys|
		var canTraverse = { |el| el.mutable and: { el.respondsTo(\traverseCollect) } };
		isLeaf = isLeaf ? { |el| (el.mutable and: { el.respondsTo(\traverseCollect) }).not };
		^this.collect { |elem, index|
			var myDeepKeys = deepKeys.asArray ++ index;
			var result;
			var isAssoc = elem.isKindOf(Association);
			if (isAssoc) { index = elem.key; elem = elem.value };
			if (isLeaf.(elem, myDeepKeys)) {
				result = doAtLeaf.(elem, myDeepKeys)
			} {
				if (canTraverse.(elem)) {
					result = elem.traverseCollect(doAtLeaf, isLeaf, myDeepKeys);
				} {
					"traverseDo found malformed object:\n"
					"at % element % is not a leaf and not a collection.".format(index, elem);
					nil
				};
			};
			if (isAssoc) { index -> result } { result }
		};
	}
	unpackAssoc { |value, index|

	}
}
+ Dictionary {
	traverseDo { |doAtLeaf, isLeaf, deepKeys|
		var canTraverse = { |el| el.mutable and: { el.respondsTo(\traverseDo) } };
		isLeaf = isLeaf ? { |el| (el.mutable and: { el.respondsTo(\traverseDo) }).not };
		this.keysValuesDo { |key, elem|
			var myDeepKeys = deepKeys.asArray ++ key;
			if (isLeaf.(elem)) {
				doAtLeaf.(elem, myDeepKeys)
			} {
				if (canTraverse.(elem)) {
					elem.traverseDo(doAtLeaf, isLeaf, myDeepKeys);
				} {
					"traverseDo should not get here -> object is malformed:\n"
					"at % - element % is not a leaf and not a collection.".format(key, elem);
				};
			}
		};
	}

	traverseCollect { |doAtLeaf, isLeaf, deepKeys|
		var canTraverse = { |el| el.mutable and: { el.respondsTo(\traverseDo) } };
		isLeaf = isLeaf ? { |el| (el.mutable and: { el.respondsTo(\traverseDo) }).not };
		^this.collect { |elem, key|
			var result;
			var myDeepKeys = deepKeys.asArray ++ key;
			if (isLeaf.(elem)) {
				result = doAtLeaf.(elem, myDeepKeys)
			} {
				if (canTraverse.(elem)) {
					result = elem.traverseCollect(doAtLeaf, isLeaf, myDeepKeys);
				} {
					"traverseDo - should not get here, so object is malformed:\n"
					"at % - element % is not a leaf and not a collection.".format(key, elem);
				};
			};
			result
		};
	}
}


