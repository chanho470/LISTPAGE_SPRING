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
	
	
	function getList(param , callback ,error){
		var bno = param.bno;
		var page = param/page||1;
		$.getJSON("/replies/pages/"+bno+"/"+page+".json",
		function(data){
			if(callback){callback(data);}
		}).fail(function(xhr,status,err){
			if(error){error();}
		});
	}//getList
	
	
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
	}//수정
	
	function get(rno,callback,error){
		$.get("/replies/"+rno+".json",function(result){
			if (callback) { callback(result); }
		}).fail(function(xhr,status,err){
			if(error){error();}
		});
	}//특정 데이터 조회
	return { getList: getList ,add: add ,remove:remove,update:update,get:get};
})();

