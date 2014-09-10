/**
 * 解析通用的数据json
 * @param json
 * @param tempData
 * @returns
 */

function parseJson(json, tempData) {
	tempData = parseJson0(json, tempData, "23:59:59");
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
	tempData = parseJson0(json, tempData, nowTimeStr);
//	tempData = parseJson0(json, tempData, "23:59:59");
	return tempData;
}

function parseJson0(json,tempData, endTime) {
	if (json.length == 0) {
		var elem = {"time":endTime,"figure":fushu};
		json.push(elem);
	} else {
		var lastElem = json[json.length -1];
		if (lastElem.time != endTime) {
			var elem = {"time":endTime,"figure":fushu};
			json.push(elem);
		}
	}

	var startDate = fixedDateStartTime;
	var startTimeInMills = startDate.getTime();
	var startSeconds = 0;
	for (var i = 0; i < json.length; i++) {
		var hhmmssi = json[i].time;
		var hi = hhmmssi.split(":")[0];
		var mi = hhmmssi.split(":")[1];
		var si = hhmmssi.split(":")[2];

		var nowSencodsi = (Number(hi) * 60 * 60) + (Number(mi) * 60) + Number(si);
		if (nowSencodsi - startSeconds > timeInterval) {
			var h = (nowSencodsi - startSeconds) / (timeInterval);
			for ( var g = 0; g < parseInt(h); g++) {
				//在当前点和上一个点之间push 负数，如果负数对应的时间秒数大于或者等于当前点（json[i].time）对应的描述，则跳出
				if(((startSeconds + (g+1) * timeInterval) >= nowSencodsi)) {
					break;
				}
				//if (g == 0 || g == (parseInt(h) - 1)) {  
				tempData.push([startTimeInMills + ((g+1) * timeInterval * 1000), fushu ]);
				//}
			}
		}
		var currDate = new Date(fixedDate + " " + json[i].time);
		tempData.push([currDate.getTime() ,json[i].figure]);
		
		startDate = currDate;
		startTimeInMills = startDate.getTime();
		startSeconds = nowSencodsi;
	}
	
	return tempData;
}
