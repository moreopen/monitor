<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<% 
	java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy-MM-dd"); 
	java.util.Date currentTime = new java.util.Date();//得到当前系统时间 
	String today = formatter.format(currentTime); //将日期时间格式化 
%>
 <title>HTML5 Chart jQuery Plugin - Creating Basic Chart </title>
 
 	<link rel="stylesheet" type="text/css" href="/css/easyui.css">
 	<link rel="stylesheet" type="text/css" href="/css/icon.css">
 	
 	<script src="/js/jquery-1.8.2.min.js"></script>
 	<script type="text/javascript" src="/js/jquery.easyui.min.js"></script>
 	<script type="text/javascript" src="/js/quxian_parseJson.js"></script>
 	<script type="text/javascript" src="/js/quxian_function.js"></script>
	
	<script src="/js/highstock.js"></script>

 	<script type="text/javascript">
 	/**
 	日曲线对比的 技术难点：
 	要让同一个业务不同天数的数据曲线能够在垂直方向对比，那么这个曲线必须具有相同的年月日，不同的时分秒
 	在本代码中将这个”相同的年月日”定为2013/01/01
 	**/
 	/**
 		position主要用来占位的数组,主要用来打两个点：起始和终止点，
 		避免在当在今天最新数据附近放大的时候，navigator跳到scrollbar最右边的bug
 	**/
 		var forEverTag=null;//setTimeout 是否继续的标志
		var timeInterval=300;//监控点的时间间隔, 默认300s
		var refreshInterval=180;//页面刷新的时间间隔
		var fushu=0;
		var ip="";//默认不传IP，表示所有的IP
		var rangeSelected=2;
		var fixedDate = "2013/01/01";
		var fixedDateStartTime = new Date(fixedDate + " 00:00:00");
		var fixedDateEndTime = new Date(fixedDate + " 23:59:59"); 
   		var todayData=[];//装载今天的数据	
 		var position=[];
	 	position.push([fixedDateStartTime.getTime(),-10]);
	   	position.push([fixedDateEndTime.getTime(),-10]);
		
		var now = new Date();
	   	var years = now.getFullYear();
	   	var month =(now.getMonth()+1)>9?(now.getMonth()+1):'0'+(now.getMonth()+1);
	   	var days = now.getDate()>9?now.getDate():'0'+now.getDate();
	   	var yyyyMMdd = years+"/"+month+"/"+days;
	   	var todayStartMilSec = (new Date(yyyyMMdd+" 00:00:00")).getTime();
	   	var todayEndMilSec = (new Date(yyyyMMdd+" 23:59:59")).getTime();
	   	
	   	//chart object
	   	var chart;
	   
 		//点击添加更多天数
 	   function clickForappendContent(){
         	appendDays();
        }
 		//追加日期
 		function appendDays(){
 			$("#devide").html("");
        	var dateNum=$("#dateNum").val();
 	      	for(var i=0;i<dateNum;i++){
 	      		var myDate = new Date();
 	      		var ms= myDate.getTime();
 	      		var newTime = new Date(ms-1000*60*60*24*(i+1));
 	      		
 	      		var years = newTime.getFullYear();
 		       	var month =(newTime.getMonth()+1)>9?(newTime.getMonth()+1):'0'+(newTime.getMonth()+1);
 		       	var days = newTime.getDate()>9?newTime.getDate():'0'+newTime.getDate();
 	      		$("#devide").append("<div><label><input type=\"checkbox\"  class=\"dayCheckbox\" value=\""+years+"/"+month+"/"+days+"\" index=\""+(i+1)+"\">"+years+"-"+month+"-"+days+"&nbsp;"+(i+1)+"天前</label></div>");
 	      	}
         }
 		
 		var times=0;//循环调用次数
        var tt="";
 		var createTimeoutCb=function(time){
 			return function(){
 				getTodayDataForever(time)
 			}
 		}
 		/**
 		*循环获取今天的数据
 		**/
 		function getTodayDataForever(eventCreateTime){
 			var todaySeries=chart.get("today");
 			if(todaySeries==null){
 				chart.addSeries({
 					id:"today",
			        name:"today",
			        data:[],
			        type:"spline"
 				});
 			} 
 			chart.showLoading("loading data from servers...");
        	$.ajax({
 				type:"POST",
 				url:"/monitor/dataEvent/getDataForEver.htm?menuCode="+$("#menuCode").val()+"&eventCreateTime="+eventCreateTime+"&ip="+ip,
        		dataType:"json",
        		success:function(json){
   					var series =chart.get("today");
   					
        			var lastEventCreateTime="";//最近的一条事件创建时间
        			if(json.length==0){//没有数据
        				lastEventCreateTime=(new Date()).getTime();
        			}else{
        				lastEventCreateTime=json[json.length-1].eventCreateTime+"";
        			}	
        			
        			if(times==0){//如果是第一次请求
        				todayData.length=0;
       					parseTodayJson(json,todayData,times);
       				}else{
       					var extremeEndDate;
               			if(json.length==0){
               				var _currDate = fakeCurrDate(); 
                   			todayData.push([_currDate.getTime(),fushu]);
                   			extremeEndDate = _currDate;
               			}else{
                       		//检查 json 第一项数据是否和 todayData 最后一项数据对应的时间相等，如相等，则删除 todayData 中最后一项
               				var x = new Date(fixedDate + " " + json[0].time).getTime();
                       		if ((x - todayData[todayData.length - 1][0]) == 0) {
                       			todayData.pop();
                       		}

               				for(var i=0;i<json.length;i++){
               					var date = new Date(fixedDate + " " + json[i].time); 
               					todayData.push([date.getTime(), json[i].figure]);
                       			if (i == json.length - 1) {
                       				extremeEndDate = date;
                       			}
                       			//series.data.push([x,y]);
                       			//series.addPoint([x,y], false);
               				}
               				//chart.redraw();//for addPoint(, false)
               			}
       				}
        			//alert(todayData);
        			series.setData(todayData);
        			 
       				chart.hideLoading();
       				resetExtremes(extremeEndDate);
       				
        			times++;
        			forEverTag=setTimeout(createTimeoutCb(lastEventCreateTime),1000*refreshInterval);
        		},
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    alert("获取今天数据出错!");
                }
 			})
            
 		}
 		
 		
 		function dayCheckLive(){
 			
 			$(".dayCheckbox").live('click',function(){
    			ip = $("input[name='ipradio']:checked").val();
    			var tempData=[];
    			var thisObj = $(this);
    			if(thisObj.attr("index")==0){//表示勾选的是当天
    				clearTimeout(forEverTag);//停止循环
    				
    				var series = chart.get("today");
    				if(thisObj.attr("checked")){
    					times=0;
    					getTodayDataForever(todayStartMilSec);
    					//getTodayRisk();//获取今天所有的风险事件

    				}else{
    					todayData.length=0;
    					series.remove();
    					//removeTodayRisk();//移除今天的所有事件
    				}
    			}else{
	    			if($(this).attr("checked")){
	    				chart.showLoading("loading data from server...");
	    				var thisObj=$(this);
		    				$.ajax({
				        		type:"POST",
				        		url:"/monitor/dataEvent/getOneDayData.htm?menuCode="+$("#menuCode").val()+"&date="+$(this).val()+"&ip="+ip,
				        		success:function(msg){
				        			chart.hideLoading();
				        			if(msg=="[]"){
				        				alert("该日期没有数据!");
				        				thisObj.attr("checked",false);
				        				return;
				        			}else{
					        			var json=eval("("+msg+")");
					        			parseJson(json,tempData);
					        			chart.addSeries({
				 							id	 : thisObj.val(),
				 							name : thisObj.val(),
				 							data : tempData,
				 							type:"spline"
				 						});
				 						//getSpecialDayRisk(thisObj.val(),ip);
				        			}
				        		}
				        	})
	    				
	    			}else{
	    				chart.get(thisObj.val()).remove();
	    				tempData.length=0;;
	    				//removeSpecialDayRisk(thisObj.val());//移除当天的 风险标记
	    			}
    			}
    		})
 			
 		}
 		
 		//拼接IP地址
 		function appendRadio(){
         	$.ajax({
         		type:"POST",
         		url:"/monitor/ipport/getHostsByMonitorCode.htm?menuCode="+$("#menuCode").val(),
         		success:function(msg){
         			var json=eval("("+msg+")");
         			for(var i=0;i<json.length;i++){
         				$("#ipdiv").append("<div><label><input type=\"radio\" name=\"ipradio\" class=\"ipradio\" value=\""+json[i]+"\">"+json[i]+"</label></div>");
         			}
         		}
         	})
         }
 		
 		function ipradioLive(){
 			
 			$(".ipradio").live("click",function(){
 				
    			var thisObj=$(this);
    			if (ip == thisObj.val()) {
    				//double click the selected radio, ignore
    				return;
    			}
    			ip=thisObj.val();
    			alert(ip);
    			
	    		//对所有的已经勾选的日期进行数据重加载
	    		$(".dayCheckbox:checked").each(function(){
	    		 var tempData=[];
   	    		 var dayObj=$(this);
   	    		 if(dayObj.attr("index")==0){//表示目前操作的是今天的数据
   	    		 	todayData.length=0;
 	    			chart.get("today").setData(todayData);
 			       	times=0;
 			 		clearTimeout(forEverTag);//先停止原来的循环
 			 		getTodayDataForever(todayStartMilSec);//再调用循环
 			 		//removeTodayRisk();//去掉原先的风险事件
 			 		//getTodayRisk(ip);//再获取今天所有的数据
   	    		 }else{
	      			var series=chart.get(dayObj.val());
	      			series.setData([null]);
   	    			 $.ajax({
   			        		type:"POST",
   			        		url:"/monitor/dataEvent/getOneDayData.htm?menuCode="+$("#menuCode").val()+"&date="+dayObj.val()+"&ip="+ip,
   			        		success:function(msg){
   			        			if(msg=="[]"){
   			        				/* dayObj.attr("checked",false);
   			        				alert(dayObj.val()+"在"+ip+"没有数据，已自动去掉该日期的勾选!");
   			        				series.remove(); */
   			        				//removeSpecialDayRisk(dayObj.val());//同时清除原来所有的风险标记
   			        			}else{
   				        			var json=eval("("+msg+")");
   				        			parseJson(json,tempData);
   				        			series.setData(tempData);
   				        			//removeSpecialDayRisk(dayObj.val());//先清除原来所有的风险标记
   				        			//getSpecialDayRisk(dayObj.val(),ip);
   			        			}
   			        		}
   			        	})
   	    		 }
	    		 })
    			
    		});
 			
 			
 		}
 		var quxianType = "fenshi";//default value
		function quxianTypeRadioLive(){
 			
 			$(".quxianTypeRadio").live("click",function(){
 				
    			var thisObj=$(this);
    			if (thisObj.val() == quxianType) {
					alert("double check");
    				return;
    			}
    			quxianType = thisObj.val();
    			document.location = "/monitor/dataEvent/dailyPage.htm?menuCode="+$("#menuCode").val()+"&quxianType="+quxianType;
 			});
    	}
 		
 		/**
 		**增加风险事件的方法,//注释掉关于风险报警的处理
 		**/
 		/* function addDataRisk(){
 			var riskEventId=$("#riskEventId").val().trim();
 			var riskEventName=$("#riskEventName").val().trim();
 			var riskDescribe=$("#riskDescribe").val().trim();
 			var riskLevel=$("#riskLevel").val().trim();
 			var eventCreateTime=$("#eventCreateTime").val().trim();
 			var HMS=eventCreateTime.split(" ")[1];
 			var createTime=(new Date(eventCreateTime)).getTime();
 			if(riskEventId==""){
 				alert("请输入风险事件ID!");
 				return;
 			}
 			if(riskEventName==""){
 				alert("请输入风险名称!");
 				return;
 			}
 			if(riskDescribe==""){
 				alert("请输入风险描述!");
 				return;
 			}
 			if(riskLevel==""){
 				alert("请输入风险级别!");
 				return;
 			}
 			$.ajax({
 				type:"POST",
 				url:"/monitor/admin/addDataRisk.htm?"+$("#requestUrl").val(),
 				data:{riskEventId:riskEventId,riskEventName:riskEventName,riskDescribe:riskDescribe,riskLevel:riskLevel,eventCreateTime:createTime},
 				dataType:"text",
 				success:function(msg){
 					if(msg=="hasData"){
 						alert("风险事件ID已经存在，请重新输入!");
 						$("#riskEventId").focus();
 						return;
 					}else{
	 					chart.addSeries({
	 					        id:"flags",
	 					        name:"test",
	 					        type:"flags",
	 					        onSeries : $("#seriesIdForThisFlag").val(),
	 							shape : 'squarepin',
	 							width : 16,
	 							showInLegend:false,
	 					        data:[{
	 					                    x : (new Date(fixedDate + " " + HMS)).getTime(),
	 										title : riskEventName,
	 										text : riskDescribe
	 					            }]
	 					    });
	 					$("#riskEventId").val("");
	 		 			$("#riskEventName").val("");
	 		 			$("#riskDescribe").val("");
	 		 			$("#riskLevel").val("");
	 		 			$("#eventCreateTime").val("");
	 					$("#addDataRiskDlg").dialog("close");
 					}
 				}
 			})
 		}
 		
 		function updateDataRisk(){
 			var id=$("#editRiskId").val();
 			var riskEventId=$("#editRiskEventId").val().trim();
 			var riskEventName=$("#editRiskEventName").val().trim();
 			var riskDescribe=$("#editRiskDescribe").val().trim();
 			var riskLevel=$("#editRiskLevel").val().trim();
 			var eventCreateTime=$("#editEventCreateTime").val().trim();
 			var HMS=eventCreateTime.split(" ")[1];
 			var createTime=(new Date(eventCreateTime)).getTime();
 			var riskDealwithDescribe=$("#editRiskDealwithDescribe").val().trim();
 			if(riskEventId==""){
 				alert("请输入风险事件ID!");
 				return;
 			}
 			if(riskEventName==""){
 				alert("请输入风险名称!");
 				return;
 			}
 			if(riskDescribe==""){
 				alert("请输入风险描述!");
 				return;
 			}
 			if(riskLevel==""){
 				alert("请输入风险级别!");
 				return;
 			}
 			$.ajax({
 				type:"POST",
 				url:"/monitor/admin/updateDataRisk.htm",
 				data:{riskEventId:riskEventId,riskEventName:riskEventName,riskDescribe:riskDescribe,riskLevel:riskLevel,id:id,riskDealwithDescribe:riskDealwithDescribe},
 				dataType:"text",
 				success:function (msg){
 					
 						if(msg=="hasData"){
 							alert("风险事件ID已经存在，请重新输入!");
 							$("#editRiskEventId").focus();
 						}else{
 							$("#editRiskEventId").val("");
 	 						$("#editEventCreateTime").val("");
 	 						$("#editRiskEventName").val("");
 	 						$("#editRiskDescribe").val("");
 	 						$("#editRiskLevel").val("");
 	 						$("#editRiskId").val("");
 	 						$("#editDataRiskDlg").dialog("close");
 						}
 					
 						
 				}
 			})
 		} */
 		
 		/**
 			覆写 rangeSelector 的 click 事件，使滚动条的时间以当前时间为基准（默认是当天的 23:59:59 为基准）
 		 */
 		function rangeClicked(event) {
 			
 			var _currDate = fakeCurrDate(); 
 			var eventText = event.currentTarget.textContent;
 			if (eventText == '10m') {
 				//chart.rangeSelector.clickButton(0,{type:'minute',count:10},true);
 				chart.xAxis[0].setExtremes(
	 	           new Date(_currDate.getTime() - 10*60*1000),
	 	           _currDate
	 	        );
	 			chart.rangeSelector.buttons[0].setState(2);
	 			chart.rangeSelector.buttons[1].setState(0);
	 			chart.rangeSelector.buttons[2].setState(0);
	 			rangeSelected = 0;
 			} else if (eventText == '1h') {
 				chart.xAxis[0].setExtremes(
 		 	           new Date(_currDate.getTime() - 60*60*1000),
 		 	           _currDate
 		 	        );
 		 		chart.rangeSelector.buttons[1].setState(2);
 		 		chart.rangeSelector.buttons[0].setState(0);
 		 		chart.rangeSelector.buttons[2].setState(0);
 		 		rangeSelected = 1;
 			} else if (eventText == 'All') {
 				chart.xAxis[0].setExtremes(
  		 	           fixedDateStartTime,
  		 	           _currDate
  		 	        );
  		 		chart.rangeSelector.buttons[2].setState(2);
  		 		chart.rangeSelector.buttons[0].setState(0);
  		 		chart.rangeSelector.buttons[1].setState(0);
  		 		rangeSelected = 2;
  		 		//chart.redraw();
 			}
 	        
 		}
 		
 		function fakeCurrDate() {
 			var currDate = new Date();
	 		var hours = currDate.getHours();
	 		var minutes = currDate.getMinutes();
	 		var seconds = currDate.getSeconds();
	 		return new Date(fixedDate + " " + hours + ":" + minutes + ":" + seconds);
 		}
 		
 		//update extremes when auto refresh for today data
 		function resetExtremes(endDate) {
 			if (rangeSelected == 2 && endDate != null) {
 				chart.xAxis[0].setExtremes(fixedDateStartTime, endDate);
 			}
 		}
 		
 		function initialize(){
 			appendRadio();//拼接IP地址
			ipradioLive();
 			appendDays();//拼接天数
			dayCheckLive();
			quxianTypeRadioLive();
			
			Highcharts.setOptions({
				global: {
					useUTC: false
				}
			});
			        			
     			$("#container").highcharts("StockChart",{
      				chart:{
      					zoomType:"x",
      					margin:40,
      					borderWidth:2,
      					events: {
                             load: function () {
                                //获得范围选中按钮
                                var buttons = this.rangeSelector.buttons;
                                for (var i = 0; i < buttons.length; i++) {
                                    //绑定事件 这里开启也是可以的
	                                buttons[i].on("click", function () {
	                                    rangeClicked(event);
	                                });
                                }
                            }
                        }
      				},
      				navigator: {
      			    	margin: 40
      			    }, 
      			    yAxis: {
      			    	//lineWidth: 2,
      			    	offset: 2,
      			    	labels: {
      			    		align: 'right',
      			    		x: -3,
      			    		y: 6
      			    	},
      			    	showLastLabel: true
      			    },
      			   plotOptions:{
      		            spline:{
      		            	dataGrouping: { enabled: true, approximation: "sum", forced:true, units: [['minute',[5]]]},
      		            	//dataGrouping: { enabled: true, approximation: "sum", forced:true},
      		            	//dataGrouping: { enabled: false},
      		                /* point:{
      		                    events:{
      		                        click:function(){
	      		                       
	      		                        var ymd=this.series.name;
	      		                        if(this.series.name=="today"){
	      		                        	ymd=yyyyMMdd;
	      		                        }
	      		                        
	      		                      var eventCreateTime=(new Date( ymd+" "+Highcharts.dateFormat('%H:%M:%S', this.x))).getTime();
	      		                      var thisPointObject=this;
	      		                      $.ajax({
		      		                       	type:"POST",
			      		       				url:"/monitor/admin/getPointRisk.htm?"+$("#requestUrl").val(),
			      		       				data:{eventCreateTime:eventCreateTime},
			      		       				dataType:"text",
			      		       				success:function(msg){
			      		       					if(msg=="noData"){//没查到事件
			      		       					//把点所对应的eventCreateTime 设置进去
				      		                        $("#eventCreateTime").val(ymd+" "+Highcharts.dateFormat('%H:%M:%S', thisPointObject.x));
				      		                        $("#seriesIdForThisFlag").val(thisPointObject.series.name);
				      		                       	$("#addDataRiskDlg").dialog("open");
			      		       					}else{//如果查到事件,则打开编辑框
			      		       						var riskJson=eval("("+msg+")");
			      		       						$("#editRiskEventId").val(riskJson.riskEventId);
			      		       						var eventCreateTime=riskJson.eventCreateTime;
			      		       						var d = new Date(eventCreateTime);
			      		       						$("#editEventCreateTime").val(d.getFullYear()+"-"+(d.getMonth()+1)+"-"+d.getDate()+" "+d.getHours()+":"+d.getMinutes()+":"+d.getSeconds());
			      		       						$("#editRiskEventName").val(riskJson.riskEventName);
			      		       						$("#editRiskDescribe").val(riskJson.riskDescribe);
			      		       						$("#editRiskLevel").val(riskJson.riskLevel);
			      		       						$("#editRiskId").val(riskJson.id);
			      		       						$("#editRiskDealwithDescribe").val(riskJson.riskDealwithDescribe);
			      		       						
			      		       						$("#editDataRiskDlg").dialog("open");
			      		       					}
			      		       				}
	      		                       	});
      		                        }
      		                    }
      		                } */
      		            },
      		            series:{
      		            	cursor:"pointer"
      		            }
      		        },
      				
      				rangeSelector : {
      					inputEnabled:false,//禁用日期选择框
      					selected : 2,//表示选中第几个按钮,set rangeSelected=2
      					buttons:[
      					 
      		                {
      		                	type: 'minute',
      		                    count:10,
      		                    text:'10m'
      		                },
      		                {
      		                    type:"minute",
      		                    count:60,
      		                    text:'1h'
      		                },
      		                {
      							type: 'all',
      							text: 'All'
      						}
      	            	]
      				},
      				tooltip:{
      					shared:false,
      	    			formatter:function (){
	      	    			var s = '<b>'+ this.series.name + ' ' + Highcharts.dateFormat('%H:%M:%S', this.x);
	      	    			s += "," + this.y + '</b>';
	      	  				/* $.each(this.points, function(i, point) {
	      	  					//alert(this.series.name);
	      	  					//alert(this.series);
	      	  					//alert(this.series.type);
	      	  					//if(this.series.type=="line"){
	      	  						//s += ","+ point.y;
	      	  						//s += +' (' + point.series.name + ')';
	      	  					//}
	      	  				}); */
	      	  				return s;
      	    			}
      					
      	    		},
      				// 配置是否显示图例
      	    		legend: {
      	    			enabled: true,
      	    			verticalAlign: 'top',
      	    			 navigation: {
      	    				arrowSize: 3
      	    			 }
      	    		},
      	    		
      				series:[
      				      	{
    				        	id:"position",
    				        	showInLegend:false,
    				        	data:position,
    				        	color:'#FFFFFF',
    				        	type:'spline'
    				        },
       				        {
       				        	id:"today",
       				        	name:"today",
       				        	data:todayData,
       				        	color:"red",
       				        	type:'spline'
       				        }
      				 ]
      			});
        	chart = $("#container").highcharts();
     		chart.get("position").hide();//隐藏占位的serie
     		getTodayDataForever(todayStartMilSec);
     		rangeSelected = 2;
     		
        	//getTodayRisk(ip);//获取今天所有的风险事件
 		}
 		
 		$(document).ready(function(){
 			
			initialize();
		})
 	</script>
   
</head>
<body>

<input  id="menuCode" value="<%=request.getAttribute("menuCode")%>" type="hidden"/>

<div style="font-size:12px;margin:10px">
	<input type="radio"  name="quxianTypeRadio" value="fenshi" class="quxianTypeRadio" checked/>分时
	<input type="radio"  name="quxianTypeRadio" value="daily" class="quxianTypeRadio"/>日统计(按月)
</div>
    <table width="100%" style="table-layout:fixed;">
    	<tr>
    	<td >
    		<div id="container" style="height: 500px;"></div>
    	</td>
    	<td width="150px">
    		<div id="ip-date-tabs"  class="easyui-tabs" fit="true" style="width:200px">
			<div title="日期"> 
				<input id="dateNum" type="text" style="padding:3px;margin:3px;width:50px" value="7"/>
				<input type="button"  value="确认" onclick="clickForappendContent()"/>
				
				<div><label><input type="checkbox" class="dayCheckbox" id="today" checked="true" value="<%=today%>" index="0"><%=today%></label></div>
				<div id="devide" style="height=10px"></div>
				
			</div>
			<div title="主机" style="padding:10px" id="ipdiv">
				<div><input type="radio" name ="ipradio" class="ipradio" value="" checked/>全部</div>
				<hr/>
   			</div>
		</div>
    	</td>
    	</tr>
    </table>
    <!-- ===============================================================暂时注释掉关于风险报警的处理===================================================================== -->
    <!-- ===============================================================暂时注释掉关于风险报警的处理===================================================================== -->
    <!-- ===============================================================暂时注释掉关于风险报警的处理===================================================================== -->
    <!-- 添加risk Dialog -->
	<!--div id="risk-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="addDataRisk()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#addDataRiskDlg').dialog('close')">取消</a>
	</div>
	<div id="addDataRiskDlg" class="easyui-dialog" title="&nbsp;&nbsp;添加风险事件" style="width:450px;height:340px;padding:10px"
			data-options="
				iconCls: 'icon-list',
				buttons: '#risk-buttons',
				closed: true,
				modal: true,
				fitColumns:true
			">
			<input id="seriesIdForThisFlag" type="hidden" style="width:200px;height:30px;padding:3px"/>
			<table>
				<tr>
					<td align="right">风险事件ID</td>
					<td><input id="riskEventId" type="text" style="width:200px;height:30px;padding:3px"/></td>
				</tr>
				<tr>
					<td align="right">风险事件发生时间</td>
					<td><input id="eventCreateTime" type="text" style="width:200px;height:30px;padding:3px" disabled/></td>
				</tr>
				<tr>
					<td align="right">风险事件名称</td>
					<td><input id="riskEventName" type="text" style="width:200px;height:30px;padding:3px"/></td>
				</tr>
				<tr>
					<td align="right">风险描述</td>
					<td><input id="riskDescribe" type="text" style="width:200px;height:30px;padding:3px"/></td>
				</tr>
				<tr>
					<td align="right">风险级别</td>
					<td>
						<select id="riskLevel">
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
						</select>*值越大，表示风险越高
					</td>
				</tr>
			</table>
	</div-->
	
	<!-- 编辑risk Dialog -->
	<!--
	<div id="risk-buttons">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="updateDataRisk()">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#editDataRiskDlg').dialog('close')">取消</a>
	</div>
	<div id="editDataRiskDlg" class="easyui-dialog" title="&nbsp;&nbsp;编辑风险事件" style="width:450px;height:380px;padding:10px"
			data-options="
				iconCls: 'icon-list',
				buttons: '#risk-buttons',
				closed: true,
				modal: true,
				fitColumns:true
			">
			<input type="hidden" id="editRiskId"/>
			<table>
				<tr>
					<td align="right">风险事件ID</td>
					<td><input id="editRiskEventId" type="text" style="width:200px;height:30px;padding:3px"/></td>
				</tr>
				<tr>
					<td align="right">风险事件发生时间</td>
					<td><input id="editEventCreateTime" type="text" style="width:200px;height:30px;padding:3px" disabled/></td>
				</tr>
				<tr>
					<td align="right">风险事件名称</td>
					<td><input id="editRiskEventName" type="text" style="width:200px;height:30px;padding:3px"/></td>
				</tr>
				<tr>
					<td align="right">风险描述</td>
					<td><input id="editRiskDescribe" type="text" style="width:200px;height:30px;padding:3px"/></td>
				</tr>
				<tr>
					<td align="right">风险级别</td>
					<td>
						<select id="editRiskLevel">
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
						</select>*值越大，表示风险越高
					</td>
				</tr>
				<tr>
					<td align="right">处理意见</td>
					<td><input id="editRiskDealwithDescribe" type="text" style="width:200px;height:30px;padding:3px"/></td>
				</tr>
			</table>
	</div-->
</body>
</html>