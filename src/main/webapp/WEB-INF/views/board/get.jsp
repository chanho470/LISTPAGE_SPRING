<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<%@include file="../includes/header.jsp"%>
<script src="http://code.jquery.com/jquery-latest.js"></script> <!-- 푸터에 있음 -->

<script src="/resources/js/reply.js"></script>
<div id="page-wrapper">
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">등록 수정</h1>
		</div>
		<!-- /.col-lg-12 -->
	</div>
	<!-- /.row -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">DataTables Advanced Tables</div>
				<!-- /.panel-heading -->
				<div class="panel-body">

					<div class="form-group">
						<label>Bno</label><input class="form-control" name="bno" value='<c:out value="${board.bno}"/>'readonly="readonly">
					</div>
					<div class="form-group">
						<label>Title</label><input class="form-control" name="title" value='<c:out value="${board.title}"/>'readonly="readonly">
						<%-- <label>Title</label><input class="form-control" name="title" value="${board.title}"/> --%>
					</div>
					<div class="form-group">
						<label>Content</label>
						<textarea class="form-control" name="content" rows="3" readonly="readonly">${board.content}</textarea>
					</div>
					<div class="form-group">
						<label>Writer</label><input class="form-control" name="writer" value='<c:out value="${board.writer}"/>'readonly="readonly">
					</div>
					
					<%-- <button data-oper="modify" class="btn btn-default" onclick="location.href='/board/modify?bno=<c:out value="${board.bno}"/>'">Modify</button>
					<button data-oper="list" class="btn btn-default" onclick="location.href='/board/list'">List</button> --%>

			
					<button data-oper='modify' class="btn btn-outline btn-primary">Modify</button>
                  <button data-oper='list' class="btn btn-outline btn-success">List</button>
                  
                  <form id="operForm" action="/board/modify" method="get">
                     <input type="hidden" id="bno" name="bno" value='<c:out value="${board.bno}"/>'>
                     <input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
                     <input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
                     <!--  -->
                     <input type="hidden" name="type" value='<c:out value="${cri.type}"/>'> 
                     <input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
                  </form>

				</div>
				<!-- /.table-responsive -->
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- /.panel -->
	</div>
	<!-- /.col-lg-6 -->
</div>
<!-- /.row -->

<!-- /#page-wrapper -->
<script type="text/javascript">
	$(document).ready(function(){
		var operForm = $("#operForm");
		$('button[data-oper="modify"]').on("click",function(e){
			operForm.attr("action","/board/modify").submit();//컨트롤러에서 작업 수행한다
		});
		$('button[data-oper="list"]').on("click",function(e){
			operForm.find("#bno").remove(); //이전 조회 기록 삭제 
			operForm.attr("action","/board/list");// 페이지 이동 경로를 다시 설정해주는 작업이다
			operForm.submit();
		});
		console.log(replyService);
		
		//댓글 관리 영역
		var bnoValue='<c:out value="${board.bno}"/>';
		replyService.add(
				{reply:"JS TEST",replyer:"js tester",bno:bnoValue},//댓글 데이터
				function(result){
					alert("RESILT :" + result);
				});
		replyService.getList(
				{bno:bnoValue,page:1}
				,function(list){
					for(var i=0,len=list.length||0 ; i<len ;i++){
						console.log(list[i]);
					}
				});
		/* replyService.remove(
				7,//rno
				function(count){
					console.log(count);
					if(count ==="success"){alert("REMOVED");}
				},function(err){
					alert("error occurred");
				
				}); //제거 영역*/ 
				
		replyService.update({
			rno:5,
			bno:bnoValue,
			reply:"modefied reply..."
			},function(result){
				alert("수정완료");
			
		});	
		replyService.get(4,function(data){
			console.log(data);
		});
	});
</script>




<%@include file="../includes/footer.jsp"%>
</body>

</html>