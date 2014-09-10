//加载“今天”的所有事件
function getTodayRisk(ip){
	$.ajax({
		type:"POST",
		url:"/monitor/admin/getDataRiskByDateIp.htm?"+$("#requestUrl").val(),
		data:{ymd:years+""+month+""+days,ip:ip},
		dataType:'json',
		success:function(msg){
			var flagsData=[];
			for(var i=0;i<msg.length;i++){
				flagsData.push({
	                    x : (new Date("2013/01/01 "+msg[i].hms)).getTime(),
						title : msg[i].riskEventName,
						text : msg[i].riskDescribe
	            });
			}
			var chart=$("#container").highcharts();
			chart.addSeries({
					id:"todayFlags",
			        type:"flags",
			        onSeries : 'today',
					shape : 'squarepin',
					width : 16,
					showInLegend:false,
			        data:flagsData
			    });
		}
		
	})
}
//移除今天的风险事件
function removeTodayRisk(){
	var chart=$("#container").highcharts();
	chart.get("todayFlags").remove();
}
/**
 * yyyyMMdd 为指定某一天，例如 2013/02/02
 * 在ajax传送的时候，把/去掉
 */
function getSpecialDayRisk(yyyyMMdd,ip){
	$.ajax({
		type:"POST",
		url:"/monitor/admin/getDataRiskByDateIp.htm?"+$("#requestUrl").val(),
		data:{ymd:yyyyMMdd.replace(new RegExp("/","gm"),""),ip:ip},
		dataType:'json',
		success:function(msg){
			var flagsData=[];
			for(var i=0;i<msg.length;i++){
				flagsData.push({
	                    x : (new Date("2013/01/01 "+msg[i].hms)).getTime(),
						title : msg[i].riskEventName,
						text : msg[i].riskDescribe
	            });
			}
			var chart=$("#container").highcharts();
			chart.addSeries({
					id:yyyyMMdd+"Flags",
			        type:"flags",
			        onSeries : yyyyMMdd,
					shape : 'squarepin',
					width : 16,
					showInLegend:false,
			        data:flagsData
			    });
		}
		
	})
}
/**
 * yyyyMMdd 为指定某一天，例如 2013/02/02
 */
function removeSpecialDayRisk(yyyyMMdd){
	var chart=$("#container").highcharts();
	chart.get(yyyyMMdd+"Flags").remove();
}