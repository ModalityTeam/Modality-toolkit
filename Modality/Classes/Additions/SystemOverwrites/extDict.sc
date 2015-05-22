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

/*
// traversing nested/mixed Arrays and Dictionaries:

a = [1, 2, (a: 3, b: 4), [5, 6, "seven", (c: 8, d: [9])]];

// prettyPost
a.traverseDo({ |el, deepKeys|
	deepKeys.size.do { $\t.post };
	[el, deepKeys].postln;
});

// get a flat list of all elements:
b = nil; a.traverseDo({ |el| b = b.add(el) }); b;
// -> [ 1, 2, 3, 4, 5, 6, seven, 8, 9 ]


// flat list of selected leaves
b = nil;
a.traverseDo({ |el|
	if (el.isNumber and: { el.even }) { b = b.add(el) }
});
b; // [ 2, 4, 6, 8 ]

b = a.traverseCollect({ |el, deepKeys| if (el.isNumber) { el + 100 } { el } });
b.printAll;"";

b = a.traverseCollect({ |el, deepKeys| [el, deepKeys] });
b.printAll;

// deepAt could be safer
a.deepAt();
a.deepAt(5);
a.deepAt(2, \a);
a.deepAt(3, 1);

*/

+ SequenceableCollection {

	traverseDo { |doAtLeaf, isLeaf, deepKeys|
		var canTraverse = { |el| el.mutable and: { el.respondsTo(\traverseDo) } };
		isLeaf = isLeaf ? { |el| (el.mutable and: { el.respondsTo(\traverseDo) }).not };
		this.do { |elem, index|
			var myDeepKeys = deepKeys.asArray ++ index;
			if (isLeaf.(elem, myDeepKeys)) {
				doAtLeaf.(elem, myDeepKeys)
			} {
				if (canTraverse.(elem)) {
					elem.traverseDo(doAtLeaf, isLeaf, myDeepKeys);
				} {
					"traverseDo found malformed object:\n"
					"at % element % is not a leaf and not a collection.".format(index, elem);
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
			result
		};
	}
}
+ Dictionary {
	traverseDo { |doAtLeaf, isLeaf, deepKeys|
		var canTraverse = { |el| el.mutable and: { el.respondsTo(\traverseDo) } };
		isLeaf = isLeaf ? { |el| (el.mutable and: { el.respondsTo(\traverseDo) }).not };
		this.keysValuesDo { |key, elem|
			deepKeys = deepKeys ++ key;
			if (isLeaf.(elem)) {
				doAtLeaf.(elem, deepKeys)
			} {
				if (canTraverse.(elem)) {
					elem.traverseDo(doAtLeaf, isLeaf, deepKeys);
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
			deepKeys = deepKeys ++ key;
			if (isLeaf.(elem)) {
				result = doAtLeaf.(elem, deepKeys)
			} {
				if (canTraverse.(elem)) {
					result = elem.traverseCollect(doAtLeaf, isLeaf, deepKeys);
				} {
					"traverseDo - should not get here, so object is malformed:\n"
					"at % - element % is not a leaf and not a collection.".format(key, elem);
				};
			};
			result
		};
	}
}


