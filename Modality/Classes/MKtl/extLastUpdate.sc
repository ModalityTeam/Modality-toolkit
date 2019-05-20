/*
MKtl.all.collect(_.timeSinceLast);
*/


+ MKtl {
	timeSinceLast { ^elementGroup.timeSinceLast }
	lastUpdatedElement  { ^elementGroup.lastUpdatedElement }
	lastUpdateTime { ^elementGroup.lastUpdateTime }
}

+ MKtlElementGroup {
	timeSinceLast {
		^Main.elapsedTime - this.lastUpdateTime
	}
	lastUpdatedElement {
		^elements.maxItem(_.lastUpdateTime)
	}
	lastUpdateTime {
		^elements.maxItem(_.lastUpdateTime).lastUpdateTime
	}
}