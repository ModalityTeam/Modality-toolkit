/* ToDo:
	auto-add addresses, keep messages

			/* lots to do here:
			- resize/scale
			- show list of addrs found on lines
			- show list of message names found
			- switch display lines from id by sender to message name
			- buttons for verbose, postInfo
			auto-refresh every 0.5 sec?
			*/

*/
OSCMon {
	classvar <colors;
	var <>bufsize, <>timeWindow, <func, <>action, <addresses, <msgNames;
	var <list, <w, <u;
	var <>verbose = false, <>watchStatus = false;
	var <>trackAddrs = true, <>trackMsgs = true;
	var <enabled = false;
	var <anaDict;

	*prepColors {
		colors = colors ?? {
			[Color.black] ++ 8.collect { |i| Color.hsv(i / 8, 0.8, 0.8, 0.7) }
			.at([0, 4, 2, 6, 1, 5, 3, 7]);
		};
	}

	*new { |bufsize = 100, timeWindow = 60, action|
		^super.newCopyArgs(bufsize, timeWindow, action).init(action);
	}

	addAddr { |addr|
		if (addresses.includesEqual(addr).not) { addresses = addresses.add(addr) }
	}
	removeAddr { |addr| addresses.remove(addr) }
	clearAddrs { addresses.clear }

	addMsgName { |name|
		if (msgNames.includesEqual(name).not) { msgNames = msgNames.add(name) }
	}

	removeMsgName { |name| msgNames.remove(name) }
	clearMsgNames { msgNames.clear }

	refreshAddrsAndNames {
		this.clearMsgNames.clearAddrs;
		list.do { |entry|
			this.addAddr(entry[1]).addMsgName(entry[2][0]);
		};
	}

	enable { thisProcess.addOSCRecvFunc(func); enabled = true }
	disable { thisProcess.removeOSCRecvFunc(func); enabled = false }

	addNickname { |name, addr|
		anaDict[\nicknames].put(addr, name);
	}
	removeNickname { |name, addr|
		anaDict[\nicknames].removeAt(addr, name);
	}
	nameOrAddr { |addr| ^anaDict[\nicknames][addr] ? addr }

	addDefaultNicknames {
		this.addNickname(\homeserver, Server.default.addr);
		this.addNickname(\homeclient, NetAddr.localAddr);
	}

	init { |argAction|
		this.class.prepColors;

		action = argAction;
		list = [];
		addresses = List[];
		msgNames = List[];
		anaDict = (nicknames: Dictionary[],
			messagesByAddr: (),
			msgNamesByAddr: ()
		);

		this.addDefaultNicknames;

		func = { |msg, t, sender|
			var arr, addrOrNick;
			if (trackAddrs) { this.addAddr(sender) };
			if (trackMsgs) { this.addMsgName(msg[0]) };

			addrOrNick = (anaDict[\nicknames][sender] ? sender);

			if (addresses.isEmpty or: { addresses.any(_ == sender) }) {
				if (watchStatus or: { msg[0] != '/status.reply' }) {

					arr = [t, addrOrNick, msg];
					if (verbose, { arr.postln });
					this.addToList(arr);
					this.analyse(addrOrNick, msg);
					action.value(this);
					this.refresh;
				};
			};
		}
	}

	analyse { |addr, msg|
		var msgList = anaDict[\messagesByAddr][addr];
		var msgNameList = anaDict[\msgNamesByAddr][addr];
		var msgName = msg[0];

		if (msgList.isNil) { msgList = List[];
			anaDict[\messagesByAddr][addr] = msgList;
		};
		msgList = msgList.add(msg).keep(bufsize);

		if (msgNameList.isNil) { msgNameList = List[];
			anaDict[\msgNamesByAddr][addr] = msgNameList;
		};
		if (msgNameList.includes(msgName).not) {
			msgNameList.add(msgName);
		};
	}

	addToList { |arr|
		var endIndex;
		var now = arr[0];

		list = list.addFirst(arr);
		endIndex = list.size;
		// find last index within time limit:
		while {
			endIndex = endIndex - 1;
			(endIndex >= 0) and:
			{ (now - list[endIndex][0]) > timeWindow };
		};
		// then cut by bufsize or time
		list = list.keep(min(bufsize, endIndex + 1));



	}

	postInfo {
		"----\nOSCMon: % messages in last % seconds.\n".postf(
			list.size, thisThread.seconds - list.last[0]);
		"addresses: %\n".postf(list.collectAs(_[1], Set));
		"msgNames: %\n----\n".postf(list.collectAs({ |msg| msg[2][0] }, Set));
	}

	refresh {
		defer { if (w.notNil and: { w.isClosed.not }) { w.refresh } };
	}

	free {
		this.disable;
		w.close; w = u = nil;
	}

	show { |name, bounds|
		if (w.isNil or: { w.isClosed }) {
			bounds = bounds ?? { Rect(20, 20, 200, 100) };
			w = Window("osc msg mon", bounds).front;
			w.addFlowLayout;

			Button(w, Rect(0,0, 40, 20)).states_(
				[[\on, Color.black, Color.grey(0.7)],
				[\off, Color.black, Color.green(0.9)]])
			.action_({ |b|
				if (b.value > 0) { this.enable } {this.disable };
			})
			.value_(enabled.binaryValue);
			Button(w, Rect(0,0, 40, 20)).states_(
				[[\verbose, Color.black, Color.grey(0.7)],
				 [\verbose, Color.black, Color.green(0.9)]])
			.action_({ |b|
				this.verbose = b.value > 0;
			}).value_(verbose.binaryValue);
			Button(w, Rect(0,0, 40, 20)).states_(
				[[\status, Color.black, Color.grey(0.7)],
				 [\status, Color.black, Color.green(0.9)]])
			.action_({ |b|
				this.watchStatus = b.value > 0;
			}).value_(watchStatus.binaryValue);
			Button(w, Rect(0,0, 40, 20)).states_(
				[[\INFO, Color.black, Color.grey(0.7)]])
			.action_({ this.postInfo; });


			u = UserView(w, w.bounds.moveTo(0,0).insetBy(4, 4).height_(64));
			u.background_(Color.white);
			u.resize_(5);

			u.drawFunc = {
				var ubounds = u.bounds;
				var point, size;
				var rescale = min(ubounds.width / 200,ubounds.height / 64);

				if (list.notEmpty) {
					var firstDur = thisThread.seconds;
					var lastDur = list.last[0];
					var totalDur = firstDur - lastDur;
					var scaler = 180 / totalDur.max(1);

					Pen.scale(rescale, rescale);

					list.do { |event, i|
						// var index = i % 8;
						var numTracks = addresses.size;
						var addrOrName = event[1];
						var nameOrAddr = event[1];


						var index = (addresses.indexOfEqual(addrOrName)
							?? { addresses.indexOfEqual(nameOrAddr) }
							? 0) % numTracks;
						Pen.color = colors[index];
						point = ((firstDur - event[0] * scaler
							+ (32/numTracks)).round(0.01)
							@ (index * 10 + 10));
						Pen.addOval(Rect.aboutPoint(point, 2, event[2].size));
						Pen.stroke;
					};
				};
			};
			u.animate_(true).frameRate_(10);

			u.keyDownAction { |u, char|
				if (char == $ ) { this.enable };
				if (char == $.) { this.disable };
				if (char == $s) { this.watchStatus = true };
				if (char == $x) { this.watchStatus = false };
				if (char == $?) { this.postInfo };
			};
		};
	}
}
