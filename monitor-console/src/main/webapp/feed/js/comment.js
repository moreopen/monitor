


function publishComment(){
	var commentUserName = $("#commentUserName")[0].value; 
	var commentNiceName = $("#commentNiceName")[0].value;
	var feedId = $("#feedId")[0].value;
	var commentMsg = $("#commentMsg")[0].value;
	  $.post("/feed/publishComment.htm", 
			 {'commentUserName':commentUserName,
		      'commentNiceName':commentNiceName,
		      'feedId':feedId,
		      'commentMsg':commentMsg
			 },
			   function(data){
				 showComment(data,5);
			   }); 
}

function removeComment(commentUserName,commentId){
	 $.post("/feed/removeComment.htm", 
			 {'commentUserName':commentUserName,
		      'commentId':commentId
			 },
			   function(data){
				 document.getElementById("status"+commentId).value="2";
//				 showComment(data,5);
			   }); 
}

function getNewestComment(){
	var feedId=document.getElementById("feedId").value;
	var commentId=document.getElementById("newestCommentId").value;
	$.getJSON(
			"/feed/getNewestComment.htm",//产生JSON数据的服务端页面
			{'commentId':commentId,
			'feedId':feedId
			},//向服务器发出的查询字符串（此参数可选）
			//对返回的JSON数据进行处理，本例以列表的形式呈现
			function(data){
				showComment(data,2);
			}); 
}


function getMoreComment(){
	var feedId=document.getElementById("feedId").value;
	var commentId=document.getElementById("moreCommentId").value;
	
	$.getJSON(
			"/feed/getMoreComment.htm",//产生JSON数据的服务端页面
			{'commentId':commentId,
			'feedId':feedId
			},//向服务器发出的查询字符串（此参数可选）
			//对返回的JSON数据进行处理，本例以列表的形式呈现
			function(data){
				showComment(data,1);
			}); 
}



function showComment(data,operationFlag){
	 var json;
 	if(operationFlag==5){//发表动态
		  json=eval("("+data+")");
 	}else{
 		json=data;
 	}
	
	 var msgCode=eval("("+json.msgCode+")");
		var dataObj=eval("("+json.data+")");//转换为json对象
		if(msgCode==0){//成功
			
			
			if(operationFlag==5){//发表删除评论
				//显示最新评论
				 initCommentData();
				 getNewestComment();
			}else{
				var outputHtml="";
				 for( i=0; i < dataObj.length; i++){
					 
					 	outputHtml+="<tr>";
					 	outputHtml+="<td><img  id='headImageUrl' src='"+dataObj[i]['headImageUrl']+"' width='40' height='40' />";
					 	//("+dataObj[i]['commentId']+")
					 	 var createTime=dataObj[i]['createTime']*1;
					 	outputHtml+=dataObj[i]['niceName']+"(<input id='status"+dataObj[i]['commentId']+"' value='"+dataObj[i]['status']+"' size='1' />)在"+getSmpFormatDateByLong(createTime,true);
					 	outputHtml+="说:"+dataObj[i]['commentMsg']+"</td>";
					 	var userNameTemp=dataObj[i]['userName'];
					 	var commentIdTemp=dataObj[i]['commentId'];
						outputHtml+="<td><a href='#' onClick=javascript:removeComment('"+userNameTemp+"','"+commentIdTemp+"'); >删除评论</a></td>";
						outputHtml+="</tr>";
						
						if(i==dataObj.length-1 ){
							if(operationFlag==1 ){//更多
								if(document.getElementById("moreCommentId").value==dataObj[i]['commentId']){
									operationFlag=3;
								}
								document.getElementById("moreCommentId").value=dataObj[i]['commentId'];
								if(document.getElementById("newestCommentId").value==""){
									document.getElementById("newestCommentId").value=dataObj[0]['commentId'];
								}
							}else if(operationFlag==2 ){//最新
								
								if(document.getElementById("newestCommentId").value==dataObj[0]['commentId']){
									operationFlag=3;
								}
								document.getElementById("newestCommentId").value=dataObj[0]['commentId'];
								if(document.getElementById("moreCommentId").value==""){
									document.getElementById("moreCommentId").value=dataObj[i]['commentId'];
								}
							}
						}
					  }  
				 if(operationFlag==1){//更多
					  document.getElementById("feedDetailCommentList").innerHTML+=outputHtml;
				 }else  if(operationFlag==2){//最新
					 document.getElementById("feedDetailCommentList").innerHTML=outputHtml+document.getElementById("feedDetailCommentList").innerHTML;
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