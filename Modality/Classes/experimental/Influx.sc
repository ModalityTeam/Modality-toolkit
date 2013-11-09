Influx {
	var <inNames, <outNames, <inValDict, <specs;
	var <weights, <outValDict, <action;

	*new { |ins, outs, vals, specs|
		^super.newCopyArgs(ins, outs, vals, specs).init;
	}
	init {
		inValDict = inValDict ?? { () };
		specs = specs ?? {()};
		[inNames, outNames].flat.do { |name|
			if (specs[name].isNil) {
				specs.put(name, \pan.asSpec)
			};
		};

		outValDict = ();
		weights = { 0 ! inNames.size } ! outNames.size;
		this.rand;

		action = FuncChain.new;
	}

	rand { |drift = 1.0|
		weights = weights.collect { |row|
			row.collect { |val, i|
				(val + drift.rand2).fold2(1.0)
			}
		}
	}

	set { |...keyValPairs|
		keyValPairs.pairsDo { |key, val|
			inValDict.put(key, val);
		};
		this.calcOutVals;
		action.value(this);
	}

	calcOutVals {
		weights.do { |line, i|
			var outVal = line.sum({ |weight, j|
				weight * inValDict[inNames[j]]
			});
			outValDict.put(outNames[i], outVal);
		};
	}
}