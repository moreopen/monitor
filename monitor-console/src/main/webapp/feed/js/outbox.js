
	//获得发件箱最新动态
	function getOutBoxNewestFeedsByUserName(userName){
		
		changeQueryType(1);
		
//		var userName=document.getElementById("userName").value;
		var feedId=document.getElementById("newestFeedId").value;
		$.getJSON(
				"/feed/getOutBoxNewestFeedsByUserName.htm",//产生JSON数据的服务端页面
				{'userName':userName,
				'feedId':feedId
				},//向服务器发出的查询字符串（此参数可选）
				//对返回的JSON数据进行处理，本例以列表的形式呈现
				function(data){
					showFeed(data,2);
				}); 
	}
	
	//获得发件箱更多动态
	function getOutBoxMoreFeedsByUserName(userName){
		changeQueryType(1);
//		var userName=document.getElementById("userName").value;
		var feedId=document.getElementById("moreFeedId").value;
		
		$.getJSON(
				"/feed/getOutBoxMoreFeedsByUserName.htm",//产生JSON数据的服务端页面
				{'userName':userName,
				 'feedId':feedId
				},//向服务器发出的查询字符串（此参数可选）
				//对返回的JSON数据进行处理，本例以列表的形式呈现
				function(data){
					showFeed(data,1);
				}); 
	}
	
	
	
	
	//根据分类获得发件箱最新动态
	function getOutBoxNewestFeedsByTag(userName){
		changeQueryType(2);
//		var userName=document.getElementById("userName").value;
		var tagType=document.getElementById("feedType").value;
		var feedId=document.getElementById("newestFeedId").value;
		$.getJSON(
				"/feed/getOutBoxNewestFeedsByTag.htm",//产生JSON数据的服务端页面
				{'userName':userName,
				'tagType':tagType,
				'feedId':feedId
				},//向服务器发出的查询字符串（此参数可选）
				//对返回的JSON数据进行处理，本例以列表的形式呈现
				function(data){
					showFeed(data,2);
				}); 
	}
	
	
	
	//根据分类获得发件箱更多动态
	function getOutBoxMoreFeedsByTag(userName){
		changeQueryType(2);
//		var userName=document.getElementById("userName").value;
		var tagType=document.getElementById("feedType").value;
		var feedId=document.getElementById("moreFeedId").value;
		
		$.getJSON(
				"/feed/getOutBoxMoreFeedsByTag.htm",//产生JSON数据的服务端页面
				{'userName':userName,
				 'tagType':tagType,
				 'feedId':feedId
				},//向服务器发出的查询字符串（此参数可选）
				//对返回的JSON数据进行处理，本例以列表的形式呈现
				function(data){
					showFeed(data,1);
				}); 
	}