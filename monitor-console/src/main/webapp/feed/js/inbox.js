
	//获得收件箱最新动态
	function getInBoxNewestFeedsByUserName(userName){
		changeQueryType(3);
//		var userName=document.getElementById("userName").value;
		var feedId=document.getElementById("newestFeedId").value;
		$.getJSON(
				"/feed/getInBoxNewestFeedsByUserName.htm",//产生JSON数据的服务端页面
				{'userName':userName,
				'feedId':feedId
				},//向服务器发出的查询字符串（此参数可选）
				//对返回的JSON数据进行处理，本例以列表的形式呈现
				function(data){
					showFeed(data,2);
				}); 
	}
	
	//获得发件箱更多动态
	function getInBoxMoreFeedsByUserName(userName){
		changeQueryType(3);
//		var userName=document.getElementById("userName").value;
		var feedId=document.getElementById("moreFeedId").value;
		$.getJSON(
				"/feed/getInBoxMoreFeedsByUserName.htm",//产生JSON数据的服务端页面
				{'userName':userName,
				 'feedId':feedId
				},//向服务器发出的查询字符串（此参数可选）
				//对返回的JSON数据进行处理，本例以列表的形式呈现
				function(data){
					showFeed(data,1);
				}); 
	}
	
	
	
	
	//根据分类获得收件箱最新动态
	function getInBoxNewestFeedsByTag(userName){
		changeQueryType(4);
//		var userName=document.getElementById("userName").value;
		var tagType=document.getElementById("feedType").value;
		var feedId=document.getElementById("newestFeedId").value;
		$.getJSON(
				"/feed/getInBoxNewestFeedsByTag.htm",//产生JSON数据的服务端页面
				{'userName':userName,
				'tagType':tagType,
				'feedId':feedId
				},//向服务器发出的查询字符串（此参数可选）
				//对返回的JSON数据进行处理，本例以列表的形式呈现
				function(data){
					showFeed(data,2);
				}); 
	}
	
	
	
	//根据分类获得收件箱更多动态
	function getInBoxMoreFeedsByTag(userName){
		changeQueryType(4);
//		var userName=document.getElementById("userName").value;
		var tagType=document.getElementById("feedType").value;
		var feedId=document.getElementById("moreFeedId").value;
		
		$.getJSON(
				"/feed/getInBoxMoreFeedsByTag.htm",//产生JSON数据的服务端页面
				{'userName':userName,
				 'tagType':tagType,
				 'feedId':feedId
				},//向服务器发出的查询字符串（此参数可选）
				//对返回的JSON数据进行处理，本例以列表的形式呈现
				function(data){
					showFeed(data,1);
				}); 
	}