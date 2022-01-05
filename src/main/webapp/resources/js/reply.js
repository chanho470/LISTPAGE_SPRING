/**
 * 
 */

/*console.log("Reply Module..........")
var replyService=(function(){
	return {name:"AAA"}
})();
*/
console.log("Reply Module..........")
var replyService = (function() {
	function add(reply, callback, error) {
		console.log("reply......");
		$.ajax({
			type: 'post',
			url: '/replies/new',
			data: JSON.stringify(reply),//데이터를 제이슨타입으로 
			contentType: "application/json;charset=utf-8",
			success: function(result, status, xhr) {
				if (callback) { callback(result); }//성공하면 결과는 success
			},
			error: function(xhr, status, er) {
				if (error) { error(er); }
			}
		});
	}
	
	
	/*unction getList(param , callback ,error){
		var bno = param.bno;
		var page = param.page||1;
		$.getJSON("/replies/pages/"+bno+"/"+page+".json",
		function(data){
			if(callback){callback(data.replyCnt , data.list);}
		}).fail(function(xhr,status,err){
			if(error){error();}
		});
	}//getList*/
	   function getList(param, callback, error) {
      var bno = param.bno;
      var page = param.page || 1;
	
      $.getJSON("/replies/pages/" + bno + "/" + page + ".json", function(data) {
         if (callback) { callback(data.replyCnt, data.list); }
      }).fail(function(xhr, status, err) {
         if (error) { error(); }
      });
   }   //getList
	
	function remove(rno,callback,error){
		$.ajax({
			type:'delete',
			url: '/replies/'+rno,
			success: function(deleteResult, status, xhr) {
				if (callback) { callback(deleteResult); }//성공하면 결과는 success
			},
			error: function(xhr, status, er) {
				if (error) { error(er); }
			}
			
		});
	}//remove
	
	function update(reply,callback,error){
		$.ajax({
			type:'put',
			url:'/replies/'+reply.rno,
			data:JSON.stringify(reply),
			contentType: "application/json;charset=utf-8",
			success: function(result, status, xhr) {
				if (callback) { callback(result); }//성공하면 결과는 success
			},
			error: function(xhr, status, er) {
				if (error) { error(er); }
			}
		});
	}//수정 어려움 ...
	
	function get(rno,callback,error){
		$.get("/replies/"+rno+".json",function(result){
			if (callback) { callback(result); }
		}).fail(function(xhr,status,err){
			if(error){error();}
		});
	}//특정 데이터 조회
	
	function displayTime(timeValue){
		var today = new Date();
		var gap = today.getTime() - timeValue;
		var dateObj = new Date(timeValue);
		var str ="";
		if(gap < (1000*60*60*24)){
			var hh = dateObj.getHours();
			var mi = dateObj.getMinutes();
			var ss = dateObj.getSeconds();
			return [(hh>9?'':'0')+hh,':',(mi>9?'':'0')+mi,':',(ss>9?'':'0')+ss].join('');
		}
		else{
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth()+1;
			var dd = dateObj.getDate();
			return [yy,'/',(mm>9?'':'0')+mm,'/',(dd>9?'':'0')+dd].join('');
		}
	}
	return { getList: getList ,add: add ,remove:remove,update:update,get:get,displayTime:displayTime};
})();

