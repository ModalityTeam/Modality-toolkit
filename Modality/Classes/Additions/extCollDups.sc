+ Collection {
	itemsHisto {
		var dict = Dictionary.new;
		this.do { |el| var n = dict[el] ? 0; dict[el] = n + 1 };
		^dict
	}
	duplicates {
		^this.itemsHisto.select(_ > 1).keys(Array)
	}
}