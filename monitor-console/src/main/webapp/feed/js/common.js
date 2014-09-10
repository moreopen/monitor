	//发布动态
	function publishFeed(){
		initDataBeforePublishFeed();
		var userName = $("#userName")[0].value; 
		var niceName = $("#niceName")[0].value;
		var feedMsg = $("#feedMsg")[0].value;
		var feedType = $("#feedType")[0].value;
		  $.post("/feed/publishFeed.htm", 
				 {'userName':userName,
			      'niceName':niceName,
			      'feedMsg':feedMsg,
			      'feedType':feedType
				 },
				   function(data){
					 showFeed(data,5,userName);
				   }); 
	}
	
	//删除动态
	function removeFeed(feedId){
		var userName=document.getElementById("userName").value;
		 $.post("/feed/removeFeed.htm", 
				 {'userName':userName,
			      'feedId':feedId
				 },
				   function(data){
					 document.getElementById("status"+feedId).value="2";
					// showFeed(data,5,userName);
				   }); 
	}
	//查看动态明细
	function getFeedByFeedId(feedId){
		$.getJSON("/feed/getFeedByFeedId.htm", 
				 {'feedId':feedId
				 },
				   function(data){
					 
					 var json=data;
					 var msgCode=eval("("+json.msgCode+")");
						var dataObj=eval("("+json.data+")");//转换为json对象
						if(msgCode==0){//成功
								var outputHtml="";
								 for( i=0; i < dataObj.length; i++){
									 outputHtml+="<tr align='center'>";
									 outputHtml+="<tr><td class='style2'>头像</td>";
									 outputHtml+="<td><img  id='headImageUrl' src='"+dataObj[i]['headImageUrl']+"' /></td></tr>";
									 
									 outputHtml+="<tr><td class='style2'>数字账号</td>";
									 outputHtml+="<td>"+dataObj[i]['userName']+"</td></tr>";
									 
									 outputHtml+="<tr><td class='style2'>昵称</td>";
									 outputHtml+="<td>"+dataObj[i]['niceName']+"</td></tr>";
									 
									 outputHtml+="<tr><td class='style2'>动态内容</td>";
									 outputHtml+="<td>"+dataObj[i]['feedMsg']+"</td></tr>";
									 
									 outputHtml+="<tr><td class='style2'>动态Id</td>";
									 outputHtml+="<td><input id='feedId' value='"+dataObj[i]['feedId']+"' /></td></tr>";
									 
									 outputHtml+="<tr><td class='style2'>动态类型</td>";
									 outputHtml+="<td>"+dataObj[i]['feedType']+"</td></tr>";
									 
									 outputHtml+="<tr><td class='style2'>动态状态</td>";
									 outputHtml+="<td>"+dataObj[i]['status']+"</td></tr>";
									 
									 outputHtml+="<tr><td class='style2'>发布时间</td>";
									 var createTime=dataObj[i]['createTime']*1;
									 outputHtml+="<td>"+getSmpFormatDateByLong(createTime,true)+"</td></tr>";
									  }  
								 document.getElementById("feedDetail").innerHTML=outputHtml;
							
						}else if(msgCode==-1){//失败
							 for( i=0; i < dataObj.length; i++){
								alert(dataObj[i]["msgCode"]);
								alert(dataObj[i]["msg"]);
							  }  
						}else{
							alert("error");
						}
					 getNewestComment();
					 popupDiv('pop-div');
				   }); 
	}
	
	
	/*
	 * 1:更多
	 * 2:最新
	 * 3:do nothing
	 * 5:发布、删除动态
	 * 
	 * */		
    //显示动态
	 function showFeed(data,operationFlag){
		 showFeed(data,operationFlag,"");
	 }
	
	
	/*
	 * 1:更多
	 * 2:最新
	 * 3:do nothing
	 * 5:发布、删除动态
	 * 
	 * */		
    //显示动态
	 function showFeed(data,operationFlag,userName){
		 var json;
    	if(operationFlag==5){//发表动态
		  json=eval("("+data+")");
    	}else{
    		json=data;
    	}
		 var msgCode=eval("("+json.msgCode+")");
			var dataObj=eval("("+json.data+")");//转换为json对象
			if(msgCode==0){//成功
				if(operationFlag==5){//发表动态
					//显示最新动态
					var queryType=document.getElementById("queryType").value;
					if(queryType==1){
						getOutBoxNewestFeedsByUserName(userName);
					}else if(queryType==2){
						getOutBoxNewestFeedsByTag(userName);
					}else if(queryType==3){
						getInBoxNewestFeedsByUserName(userName);
					}else if(queryType==4){
						getInBoxNewestFeedsByTag(userName);
					}
				}else{
					var outputHtml="";
					 for( i=0; i < dataObj.length; i++){
						 
						 if(i==0){
							 outputHtml+="<tr align='center'>";
							 outputHtml+="<td>头像</td><td>数字账号</td><td>昵称</td><td>动态消息</td>";
							 outputHtml+="<td>动态Id</td><td>动态类型</td><td>状态</td><td>发表时间</td>";
							 outputHtml+="<td colspan='2'>操作</td><td>评论</td></tr>";
						 }
							outputHtml+="<tr align='center'>";
							outputHtml+="<td><img  id='headImageUrl' src='"+dataObj[i]['headImageUrl']+"' /></td>";
							outputHtml+="<td>"+dataObj[i]['userName']+"</td>";
							outputHtml+="<td>"+dataObj[i]['niceName']+"</td>";
							outputHtml+="<td>"+dataObj[i]['feedMsg']+"</td>";
							outputHtml+="<td>"+dataObj[i]['feedId']+"</td>";
							outputHtml+="<td>"+dataObj[i]['feedType']+"</td>";
							outputHtml+="<td><input id='status"+dataObj[i]['feedId']+"' value='"+dataObj[i]['status']+"' size='1' /></td>";
							 var createTime=dataObj[i]['createTime']*1;
							outputHtml+="<td>"+getSmpFormatDateByLong(createTime,true)+"</td>";
							var feedIdTemp=dataObj[i]['feedId'];
							outputHtml+="<td><a href='#' onClick=javascript:removeFeed('"+feedIdTemp+"'); >删除</a></td>";
							outputHtml+="<td><a href='#' onClick=javascript:getFeedByFeedId('"+feedIdTemp+"'); >明细</a></td>";
							outputHtml+="<td>评论</td>";
							
							outputHtml+="</tr>";
							
							if(i==dataObj.length-1 ){
								if(operationFlag==1 ){//更多
									
									if(document.getElementById("moreFeedId").value==dataObj[i]['feedId']){
										operationFlag=3;
									}
									document.getElementById("moreFeedId").value=dataObj[i]['feedId'];
									if(document.getElementById("newestFeedId").value==""){
										document.getElementById("newestFeedId").value=dataObj[0]['feedId'];
									}
								}else if(operationFlag==2 ){//最新
									
									if(document.getElementById("newestFeedId").value==dataObj[0]['feedId']){
										operationFlag=3;
									}
									document.getElementById("newestFeedId").value=dataObj[0]['feedId'];
									if(document.getElementById("moreFeedId").value==""){
										document.getElementById("moreFeedId").value=dataObj[i]['feedId'];
									}
								}
							}
						  }  
					 if(operationFlag==1){//更多
						  document.getElementById("feedContent").innerHTML+=outputHtml;
					 }else  if(operationFlag==2){//最新
						 document.getElementById("feedContent").innerHTML=outputHtml+document.getElementById("feedContent").innerHTML;
					 }else   if(operationFlag==3){
						 
					 }
				}
			}else if(msgCode==-1){//失败
				 for( i=0; i < dataObj.length; i++){
					alert(dataObj[i]["msgCode"]);
					alert(dataObj[i]["msg"]);
				  }  
			}else{
				alert("error");
			}
	 }
		/*
		 * 更改查询类型并清空历史记录  
		 * 1:获得发件箱（最新、更多）
		 * 2:根据分类获得发件箱（最新、更多）
		 * 3:获得收件箱（最新、更多）
		 * 4:根据分类获得发件箱（最新、更多）
		 * */
		function changeQueryType(operatonQueryType){
			var queryType=document.getElementById("queryType").value;
			if(queryType!=operatonQueryType){
				document.getElementById("queryType").value=operatonQueryType;
				initData();
			}
			
		}
		//发布动态前清空历史数据
		function initDataBeforePublishFeed(){
			var queryType=document.getElementById("queryType").value;
				initData();
		}
		//初始化Feed数据
		function initData(){
			document.getElementById("newestFeedId").value="";
			document.getElementById("moreFeedId").value="";
			document.getElementById("feedContent").innerHTML="";
		}
		//初始化评论数据
		function initCommentData(){
			document.getElementById("newestCommentId").value="";
			document.getElementById("moreCommentId").value="";
			document.getElementById("feedDetailCommentList").innerHTML="";
		}		
		//弹出页面
		 function popupDiv(div_id)
		    {

		        var div_obj = $("#" + div_id);
		        var windowWidth = document.documentElement.clientWidth;
		        var windowHeight = document.documentElement.clientHeight;
		        var popupHeight = div_obj.height();
		        var popupWidth = div_obj.width();

		        div_obj.css({ "position": "absolute" })
				.animate({ left: windowWidth / 2 - popupWidth / 2, top: windowHeight / 2 - popupHeight / 2, opacity: "show" }, "show");

		    }
		 //隐藏页面
		    function hideDiv(div_id)
		    {
		        $("#TextBox3").val($("#TextBox1").val());    //把TexBox1的值付给TextBox3  
		        $("#" + div_id).animate({ left: 0, top: 0, opacity: "hide" }, "slow"); //关闭弹出的DIV
		    }
		    //关闭页面
		    function closePage(div_id){
		    	initCommentData();
		    	hideDiv(div_id);
		    }
			