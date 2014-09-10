/**
 * 解析通用的数据json
 * @param json
 * @param tempData
 * @returns
 */
function parseJson(json,tempData) {
	
	if (json.length == 1) {// 如果只有1个点
		var hhmmss = json[0].time;
		var h = hhmmss.split(":")[0];
		var m = hhmmss.split(":")[1];
		var s = hhmmss.split(":")[2];
		var nowSencods = (Number(h) * 60 * 60) + (Number(m) * 60) + Number(s);
		if ((nowSencods - timeInterval <= 0)) {// 表示当前值是今天的第一个值
			tempData.push([ new Date("2013/01/01 " + json[0].time),
					json[0].figure ]);
			// 后面的全为负值
			var n = (23 * 60 * 60 + 59 * 60 + 59 - nowSencods) / timeInterval;
			for ( var w = 0; w < n; w++) {
				var starttime = "2013/01/01 " + json[0].time;
				var starttimeHaoMiao = (new Date(starttime)).getTime(); // 得到毫秒数
				tempData.push([
						new Date(starttimeHaoMiao + (w * timeInterval * 1000)),
						fushu ]);
			}

		} else {
			var m = nowSencods / timeInterval;
			for ( var k = 0; k < m; k++) {// 前面的时间段都为负值
				var starttime = "2013/01/01 00:00:00";
				var starttimeHaoMiao = (new Date(starttime)).getTime(); // 得到毫秒数
				tempData.push([
						new Date(starttimeHaoMiao + (k * timeInterval * 1000)),
						fushu ]);
			}
			tempData.push([ new Date("2013/01/01 " + json[0].time),
					json[0].figure ]);
			if (json[0].time != "23:59:59") {// 如果不是59:59秒的值
				var n = (23 * 60 * 60 + 59 * 60 + 59 - nowSencods)
						/ timeInterval;
				if (n > 1) {
					for ( var w = 0; w < n; w++) {
						var starttime = "2013/01/01 " + json[0].time;
						var starttimeHaoMiao = (new Date(starttime)).getTime(); // 得到毫秒数
						tempData.push([
								new Date(starttimeHaoMiao
										+ (w * timeInterval * 1000)), fushu ]);
					}
				}
			}

		}
	}

	if ((json.length == 2)) {
		// 先判断第一个点
		var hhmmss = json[0].time;
		var h = hhmmss.split(":")[0];
		var m = hhmmss.split(":")[1];
		var s = hhmmss.split(":")[2];
		var nowSencods = (Number(h) * 60 * 60) + (Number(m) * 60) + Number(s);
		if ((nowSencods - timeInterval <= 0)) {// 表示当前值是今天的第一个值
			tempData.push([ new Date("2013/01/01 " + json[0].time),
					json[0].figure ]);
		} else {
			var m = nowSencods / timeInterval;
			for ( var k = 0; k < m; k++) {// 前面的时间段都为负值
				var starttime = "2013/01/01 00:00:00";
				var starttimeHaoMiao = (new Date(starttime)).getTime(); // 得到毫秒数
				tempData.push([
						new Date(starttimeHaoMiao + (k * timeInterval * 1000)),
						fushu ]);
			}
			tempData.push([ new Date("2013/01/01 " + json[0].time),
					json[0].figure ]);
		}

		// 再判断第二个点
		var hhmmss2 = json[1].time;
		var h2 = hhmmss.split(":")[0];
		var m2 = hhmmss.split(":")[1];
		var s2 = hhmmss.split(":")[2];
		var nowSencods2 = (Number(h2) * 60 * 60) + (Number(m2) * 60)
				+ Number(s2);
		if ((nowSencods2 - nowSencods <= timeInterval)) {
			tempData.push([ new Date("2013/01/01 " + json[1].time),
					json[1].figure ]);
		} else {
			var u = (nowSencods2 - nowSencods) / timeInterval;
			for ( var q = 0; q < u; q++) {
				var starttime = "2013/01/01 " + json[0].time;
				var starttimeHaoMiao = (new Date(starttime)).getTime();
				tempData.push([
						new Date(starttimeHaoMiao + (q * timeInterval * 1000)),
						fushu ]);
			}
			tempData.push([ new Date("2013/01/01 " + json[1].time),
					json[1].figure ]);
		}
		if (json[1].time != "23:59:59") {// 如果不是59:59秒的值
			var n = (23 * 60 * 60 + 59 * 60 + 59 - nowSencods2) / timeInterval;
			if (n > 1) {
				for ( var w = 0; w < n; w++) {
					var starttime = "2013/01/01 " + json[1].time;
					var starttimeHaoMiao = (new Date(starttime)).getTime(); // 得到毫秒数
					tempData.push([
							new Date(starttimeHaoMiao
									+ (w * timeInterval * 1000)), fushu ]);
				}
			}
		}
	}

	var tt = "";
	if ((json.length > 2)) {
		for ( var i = 0; i < json.length; i++) {

			if (i == 0) {
				var hhmmss = json[0].time;
				var h = hhmmss.split(":")[0];
				var m = hhmmss.split(":")[1];
				var s = hhmmss.split(":")[2];

				var nowSencods = Number(h) * 60 * 60 + Number(m) * 60
						+ Number(s);
				if ((nowSencods - timeInterval > 0)) {// 表示当前值不是今天的第一个值
					var m = nowSencods / timeInterval;
					for ( var k = 0; k < m; k++) {// 前面的时间段都为负值
						var starttime = "2013/01/01 00:00:00";
						var starttimeHaoMiao = (new Date(starttime)).getTime(); // 得到毫秒数
						tempData.push([
								new Date(starttimeHaoMiao
										+ (k * timeInterval * 1000)), fushu ]);
					}
				}
				tempData.push([ new Date("2013/01/01 " + json[0].time),
						json[0].figure ]);
			} else if (i == json.length - 1) {

				var hhmmss = json[i].time;
				var h = hhmmss.split(":")[0];
				var m = hhmmss.split(":")[1];
				var s = hhmmss.split(":")[2];
				var nowSencods = Number(h) * 60 * 60 + Number(m) * 60
						+ Number(s);

				if (json[i].time != "23:59:59") {// 如果不是59:59秒的值
					tempData.push([ new Date("2013/01/01 " + json[i].time),
							json[i].figure ]);// 先加进去，避免折线
					var n = (23 * 60 * 60 + 59 * 60 + 59 - nowSencods)
							/ timeInterval;
					if (n > 1) {
						for ( var w = 0; w < n; w++) {
							var starttime = "2013/01/01 " + json[i].time;
							var starttimeHaoMiao = (new Date(starttime))
									.getTime(); // 得到毫秒数
							tempData.push([
									new Date(starttimeHaoMiao
											+ (w * timeInterval * 1000)), fushu ]);
						}
					}
				} else {
					tempData.push([ new Date("2013/01/01 " + json[i].time),
							json[i].figure ]);
				}

			} else {
				var hhmmssi = json[i].time;
				var hhmmssi_1 = json[i - 1].time;

				var hi = hhmmssi.split(":")[0];
				var mi = hhmmssi.split(":")[1];
				var si = hhmmssi.split(":")[2];

				var nowSencodsi = (Number(hi) * 60 * 60) + (Number(mi) * 60)
						+ Number(si);

				var hi_1 = hhmmssi_1.split(":")[0];
				var mi_1 = hhmmssi_1.split(":")[1];
				var si_1 = hhmmssi_1.split(":")[2];
				var nowSencodsi_1 = (Number(hi_1) * 60 * 60)+ (Number(mi_1) * 60) + Number(si_1);

				if (nowSencodsi - nowSencodsi_1 > timeInterval) {
					var h = (nowSencodsi - nowSencodsi_1) / (timeInterval);
					
					var starttime = "2013/01/01 "+hi_1+":"+mi_1+":"+si_1;
					var starttimeHaoMiao = (new Date(starttime)).getTime(); // 得到毫秒数
					
					for ( var g = 0; g < h; g++) {
						tempData.push([new Date(starttimeHaoMiao+ (g * timeInterval * 1000)), fushu ]);
					}
				}

				tempData.push([ new Date("2013/01/01 " + json[i].time),json[i].figure ]);
			}
		}
	}
	return tempData;
}
/**
 * 解析今天的JSON
 * 和上面方法的区别就是，只能判断到当前时间，而不是判断到23:59:59秒
 * 而且只是第一次加载的时候调用
 * @param json
 * @param tempData
 * @returns
 */
function parseTodayJson(json,tempData,times) {
	if(times!=0){
		return "parsed";
		
	}
	
	var myDate=new Date();
	var hours=myDate.getHours();
	var minutes=myDate.getMinutes();
	var secondes=myDate.getSeconds();
	var nowTimeStr=hours+":"+minutes+":"+secondes;
	
	if (json.length == 0) {// 如果1个点都没有，表示截止目前没有数据，那么之前都应该显示为-1
		
		var myDate=new Date();
		var hours=myDate.getHours();
		var minutes=myDate.getMinutes();
		var secondes=myDate.getSeconds();
		
		var nowSencods = (Number(hours) * 60 * 60) + (Number(minutes) * 60) + Number(secondes);
		// 到当前时间全为负值
			var n = nowSencods / timeInterval;
			for ( var w = 0; w < n; w++) {
				var starttime = "2013/01/01 00:00:00";
				var starttimeHaoMiao = (new Date(starttime)).getTime(); // 得到毫秒数
				tempData.push([new Date(starttimeHaoMiao + (w * timeInterval * 1000)),fushu ]);
			}
	}
	
	if (json.length == 1) {// 如果只有1个点
		var hhmmss = json[0].time;
		var h = hhmmss.split(":")[0];
		var m = hhmmss.split(":")[1];
		var s = hhmmss.split(":")[2];
		var nowSencods = (Number(h) * 60 * 60) + (Number(m) * 60) + Number(s);
		if ((nowSencods - timeInterval <= 0)) {// 表示当前值是今天的第一个值
			tempData.push([ new Date("2013/01/01 " + json[0].time),
					json[0].figure ]);
			// 到当前时间全为负值
			var n = ((Number(hours) * 60 * 60) + (Number(minutes) * 60) + Number(secondes) - nowSencods) / timeInterval;
			for ( var w = 0; w < n; w++) {
				var starttime = "2013/01/01 " + json[0].time;
				var starttimeHaoMiao = (new Date(starttime)).getTime(); // 得到毫秒数
				tempData.push([
						new Date(starttimeHaoMiao + (w * timeInterval * 1000)),
						fushu ]);
			}

		} else {
			var m = nowSencods / timeInterval;
			for ( var k = 0; k < m; k++) {// 前面的时间段都为负值
				var starttime = "2013/01/01 00:00:00";
				var starttimeHaoMiao = (new Date(starttime)).getTime(); // 得到毫秒数
				tempData.push([
						new Date(starttimeHaoMiao + (k * timeInterval * 1000)),
						-1 ]);
			}
			tempData.push([ new Date("2013/01/01 " + json[0].time),
					json[0].figure ]);
			if (json[0].time != nowTimeStr) {// 如果不是当前值
				var n = ((Number(hours) * 60 * 60) + (Number(minutes) * 60) + Number(secondes) - nowSencods)/ timeInterval;
				if (n > 1) {
					for ( var w = 0; w < n; w++) {
						var starttime = "2013/01/01 " + json[0].time;
						var starttimeHaoMiao = (new Date(starttime)).getTime(); // 得到毫秒数
						tempData.push([
								new Date(starttimeHaoMiao
										+ (w * timeInterval * 1000)), fushu ]);
					}
				}
			}

		}
	}

	if ((json.length == 2)) {
		// 先判断第一个点
		var hhmmss = json[0].time;
		var h = hhmmss.split(":")[0];
		var m = hhmmss.split(":")[1];
		var s = hhmmss.split(":")[2];
		var nowSencods = (Number(h) * 60 * 60) + (Number(m) * 60) + Number(s);
		if ((nowSencods - timeInterval <= 0)) {// 表示当前值是今天的第一个值
			tempData.push([ new Date("2013/01/01 " + json[0].time),
					json[0].figure ]);
		} else {
			var m = nowSencods / timeInterval;
			for ( var k = 0; k < m; k++) {// 前面的时间段都为负值
				var starttime = "2013/01/01 00:00:00";
				var starttimeHaoMiao = (new Date(starttime)).getTime(); // 得到毫秒数
				tempData.push([
						new Date(starttimeHaoMiao + (k * timeInterval * 1000)),
						fushu ]);
			}
			tempData.push([ new Date("2013/01/01 " + json[0].time),
					json[0].figure ]);
		}

		// 再判断第二个点
		var hhmmss2 = json[1].time;
		var h2 = hhmmss.split(":")[0];
		var m2 = hhmmss.split(":")[1];
		var s2 = hhmmss.split(":")[2];
		var nowSencods2 = (Number(h2) * 60 * 60) + (Number(m2) * 60)
				+ Number(s2);
		if ((nowSencods2 - nowSencods <= timeInterval)) {
			tempData.push([ new Date("2013/01/01 " + json[1].time),
					json[1].figure ]);
		} else {
			var u = (nowSencods2 - nowSencods) / timeInterval;
			for ( var q = 0; q < u; q++) {
				var starttime = "2013/01/01 " + json[0].time;
				var starttimeHaoMiao = (new Date(starttime)).getTime();
				tempData.push([
						new Date(starttimeHaoMiao + (q * timeInterval * 1000)),
						-1 ]);
			}
			tempData.push([ new Date("2013/01/01 " + json[1].time),
					json[1].figure ]);
		}
		if (json[1].time != nowTimeStr) {// 如果不是当前时间
			var n = ((Number(hours) * 60 * 60) + (Number(minutes) * 60) + Number(secondes) - nowSencods2) / timeInterval;
			if (n > 1) {
				for ( var w = 0; w < n; w++) {
					var starttime = "2013/01/01 " + json[1].time;
					var starttimeHaoMiao = (new Date(starttime)).getTime(); // 得到毫秒数
					tempData.push([
							new Date(starttimeHaoMiao
									+ (w * timeInterval * 1000)), fushu ]);
				}
			}
		}
	}

	var tt = "";
	if ((json.length > 2)) {
		for ( var i = 0; i < json.length; i++) {

			if (i == 0) {
				var hhmmss = json[0].time;
				var h = hhmmss.split(":")[0];
				var m = hhmmss.split(":")[1];
				var s = hhmmss.split(":")[2];

				var nowSencods = Number(h) * 60 * 60 + Number(m) * 60
						+ Number(s);
				if ((nowSencods - timeInterval > 0)) {// 表示当前值不是今天的第一个值
					var m = nowSencods / timeInterval;
					for ( var k = 0; k < m; k++) {// 前面的时间段都为负值
						var starttime = "2013/01/01 00:00:00";
						var starttimeHaoMiao = (new Date(starttime)).getTime(); // 得到毫秒数
						tempData.push([
								new Date(starttimeHaoMiao
										+ (k * timeInterval * 1000)), fushu ]);
					}
				}
				tempData.push([ new Date("2013/01/01 " + json[0].time),
						json[0].figure ]);
			} else if (i == json.length - 1) {

				var hhmmss = json[i].time;
				var h = hhmmss.split(":")[0];
				var m = hhmmss.split(":")[1];
				var s = hhmmss.split(":")[2];
				var nowSencods = Number(h) * 60 * 60 + Number(m) * 60
						+ Number(s);

				if (json[i].time != nowTimeStr) {// 如果不是59:59秒的值
					tempData.push([ new Date("2013/01/01 " + json[i].time),
							json[i].figure ]);// 先加进去，避免折线
					var n = ((Number(hours) * 60 * 60) + (Number(minutes) * 60) + Number(secondes) - nowSencods)
							/ timeInterval;
					if (n > 1) {
						for ( var w = 0; w < n; w++) {
							var starttime = "2013/01/01 " + json[i].time;
							var starttimeHaoMiao = (new Date(starttime))
									.getTime(); // 得到毫秒数
							tempData.push([
									new Date(starttimeHaoMiao
											+ (w * timeInterval * 1000)), fushu ]);
						}
					}
				} else {
					tempData.push([ new Date("2013/01/01 " + json[i].time),
							json[i].figure ]);
				}

			} else {
				var hhmmssi = json[i].time;
				var hhmmssi_1 = json[i - 1].time;

				var hi = hhmmssi.split(":")[0];
				var mi = hhmmssi.split(":")[1];
				var si = hhmmssi.split(":")[2];

				var nowSencodsi = (Number(hi) * 60 * 60) + (Number(mi) * 60)
						+ Number(si);

				var hi_1 = hhmmssi_1.split(":")[0];
				var mi_1 = hhmmssi_1.split(":")[1];
				var si_1 = hhmmssi_1.split(":")[2];
				var nowSencodsi_1 = (Number(hi_1) * 60 * 60)
						+ (Number(mi_1) * 60) + Number(si_1);

				if (nowSencodsi - nowSencodsi_1 > timeInterval) {
					var h = (nowSencodsi - nowSencodsi_1) / (timeInterval);
					
					var starttime = "2013/01/01 "+hi_1+":"+mi_1+":"+si_1;
					var starttimeHaoMiao = (new Date(starttime)).getTime(); // 得到毫秒数
					
					for ( var g = 0; g < h; g++) {
						tempData.push([new Date(starttimeHaoMiao+ (g * timeInterval * 1000)), fushu ]);
					}
				}

				tempData.push([ new Date("2013/01/01 " + json[i].time),json[i].figure ]);
			}
		}
	}
	return tempData;
}