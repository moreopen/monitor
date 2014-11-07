<%@page import="java.util.Date"%>
<%@page import="com.moreopen.monitor.console.utils.DateTools"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%  
	String month = DateTools.monthFormat(new Date());
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
   		var monthData=[];//装载当月的数据	   	
	   	//chart object
	   	var chart;
 		
 		function getThisMonthData(){
 			var monthSeries=chart.get("thisMonth");
 			if(monthSeries==null){
 				chart.addSeries({
 					id:"thisMonth",
			        name:"thisMonth",
			        data:[],
			        type:"spline"
 				});
 			} 
 			chart.showLoading("loading data from servers...");
        	$.ajax({
 				type:"POST",
 				url:"/monitor/dataEvent/getDailyData.htm?menuCode="+$("#menuCode").val(),
        		dataType:"json",
        		success:function(json){
   					var series =chart.get("thisMonth");
   					monthData.length=0;
       				parseMonitorData(json,monthData);
       				series.setData(monthData);
        			chart.hideLoading();
        		},
                error: function(XMLHttpRequest, textStatus, errorThrown) {
                    alert("获取日统计数据出错!");
                }
 			})
            
 		}
 		
 		function parseMonitorData(json, monthData) {
 			for (var i = 0; i < json.length; i++) {
 				var date = new Date(json[i].day);
 				// 确保 x 轴是固定的，x 轴 value 只能设为 date.getDate()
 				monthData.push([date.getDate(), json[i].figure]);
 			}
 		}
 		
 		function initialize(){
 			quxianTypeRadioLive();
 			appendMonth();
 			monthCheckLive();
 			
			Highcharts.setOptions({
				global: {
					useUTC: false
				}
			});
			        			
     			$("#container").highcharts({
      				chart:{
      					zoomType:"y",
      					margin:40,
      					borderWidth:2,
      					events: {
                             /* load: function () {
                                //获得范围选中按钮
                                var buttons = this.rangeSelector.buttons;
                                for (var i = 0; i < buttons.length; i++) {
                                    //绑定事件 这里开启也是可以的
	                                buttons[i].on("click", function () {
	                                    rangeClicked(event);
	                                });
                                }
                            } */
                        }
      				},
      				navigator: {
      			    	margin: 40
      			    }, 
	      			xAxis: {
	      			    //tickInterval: 1 * 24 * 3600 * 1000,
	      			    type:"category",
	                    labels: {
	                        formatter: function () { 
	                            //return Highcharts.dateFormat('%d', this.value);
	                            return this.value;
	                        }
	                    }
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
      		            	//dataGrouping: { enabled: true, approximation: "sum", forced:true, units: [['minute',[5]]]},
      		            	//dataGrouping: { enabled: true, approximation: "sum", forced:true},
      		            	dataGrouping: { enabled: false},
      		            	lineWidth: 0.5,  
      		              	fillOpacity: 0.1,
      		            },
      		            series:{
      		            	cursor:"pointer"
      		            }
      		        },
      				tooltip:{
      					shared:false,
      	    			formatter:function (){
	      	    			var s = '<b>'+ this.series.name + '-' + this.x;
	      	    			s += "," + this.y + '</b>';
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
       				        	id:"thisMonth",
       				        	name:"<%=month%>",
       				        	data:monthData,
       				        	color:"red",
       				        	type:'line'
       				        }
      				 ],
      				 title: {  
      		            text: '',//标题  
					 }  
      			});
        	chart = $("#container").highcharts();
     		getThisMonthData();
 		}
 		
 		$(document).ready(function(){
 			initialize();
		})
		
		var quxianType = "daily";//default value
		function quxianTypeRadioLive(){
 			
 			$(".quxianTypeRadio").live("click",function() {
 				
    			var thisObj=$(this);
    			if (thisObj.val() == quxianType) {
    				return;
    			}
    			quxianType = thisObj.val();
    			document.location = "/monitor/dataEvent/dataEventPage.htm?menuCode="+$("#menuCode").val()+"&quxianType="+quxianType;
 			});
    	}
		
		function monthCheckLive(){
 			
 			$(".monthCheckbox").live('click',function(){
    			
    			var tempData=[];
    			var thisObj = $(this);
    			if(thisObj.attr("index")==0){//表示勾选的是当月
    				var series = chart.get("thisMonth");
    				if(thisObj.attr("checked")){
    					times=0;
    					getThisMonthData();
					}else{
    					monthData.length=0;
    					series.remove();
    				}
    			}else{
	    			if($(this).attr("checked")){
	    				chart.showLoading("loading data from server...");
	    				var thisObj=$(this);
		    				$.ajax({
				        		type:"POST",
				        		url:"/monitor/dataEvent/getDailyData.htm?menuCode="+$("#menuCode").val()+"&month="+$(this).val(),
				        		success:function(msg){
				        			chart.hideLoading();
				        			var json=eval("("+msg+")");
				        			parseMonitorData(json,tempData);
				        			chart.addSeries({
			 							id	 : thisObj.val(),
			 							name : thisObj.val(),
			 							data : tempData,
			 							type:"line"
			 						});
				        		}
				        	})
	    				
	    			}else{
	    				chart.get(thisObj.val()).remove();
	    				tempData.length=0;
	    			}
    			}
    		})
 			
 		}
		
		//追加月份
 		function appendMonth(){
 			$("#devide").html("");
        	var monthNum=$("#monthNum").val();
 	      	for(var i=0;i<monthNum;i++){
 	      		var currentDate = new Date();
 	      		var date = new Date(currentDate.getFullYear(), currentDate.getMonth() - (i+1), currentDate.getDate());
 	      		var year = date.getFullYear();
 	      		var month = date.getMonth()+1;
 	      		month = month > 9 ? month : '0' + month;
 	      		$("#devide").append("<div><label><input type=\"checkbox\"  class=\"monthCheckbox\" value=\""+year+"-"+month+"\" index=\""+(i+1)+"\">"+year+"-"+month+"</label></div>");
 	      	}
         }
 	</script>
   
</head>
<body>
<input  id="menuCode" value="<%=request.getAttribute("menuCode")%>" type="hidden"/>

<div style="font-size:12px;margin:10px">
	<input type="radio"  name="quxianTypeRadio" value="fenshi" class="quxianTypeRadio"/>分时
	<input type="radio"  name="quxianTypeRadio" value="daily" class="quxianTypeRadio" checked/>日统计(按月)
</div>

    <table width="100%" style="table-layout:fixed;">
    	<tr>
	    	<td >
	    		<div id="container" style="height: 500px;"></div>
	    	</td>
	    	<td width="150px">
	    		<div id="month-tabs"  class="easyui-tabs" fit="true" style="width:200px">
				<div title="月份"> 
					<input id="monthNum" type="text" style="padding:3px;margin:3px;width:50px" value="7"/>
					<input type="button"  value="确认" onclick="appendMonth()"/>
					
					<div><label><input type="checkbox" class="monthCheckbox" id="month" checked="true" value="<%=month%>" index="0"><%=month%></label></div>
					<div id="devide" style="height=10px"></div>
					
				</div>
			</div>
	    	</td>
    	</tr>
    </table>
</body>
</html>