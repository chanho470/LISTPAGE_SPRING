<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<script src="http://code.jquery.com/jquery-latest.js"></script> <!-- 푸터에 있음 -->
<%@include file="../includes/header.jsp"%>
<%@include file="../includes/footer.jsp"%>
<div id="page-wrapper">
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">Board Read</h1>
		</div>
		<!-- /.col-lg-12 -->
	</div>
	<!-- /.row -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">게시글 조회</div>
				<!-- /.panel-heading -->
				<div class="panel-body">
					<form role="form" action="/board/modify" method="post">
						<div class="form-group">
							<label>Bno</label><input class="form-control" name="bno" value='<c:out value="${board.bno}"/>'readonly="readonly">
						</div>
						<div class="form-group">
							<label>Title</label><input class="form-control" name="title" value='<c:out value="${board.title}"/>'>
							<%-- <label>Title</label><input class="form-control" name="title" value="${board.title}"/> --%>
						</div>
						<div class="form-group">
							<label>Content</label>
							<textarea class="form-control" name="content" rows="3">${board.content}</textarea>
						</div>
						<div class="form-group">
							<label>Writer</label><input class="form-control" name="writer" value='<c:out value="${board.writer}"/>'readonly="readonly">
						</div>
						<div class="form-group">
							<label>regDate</label><input class="form-control" name="regDate" value='<fmt:formatDate value="${board.regDate}" pattern="yyyy/MM/dd"/>' readonly="readonly">
						</div>
						<div class="form-group">
							<label>updateDate</label><input class="form-control" name="updateDate" value='<fmt:formatDate value="${board.updateDate}" pattern="yyyy/MM/dd"/>' readonly="readonly">
						</div>
						
						<input type="hidden" name="pageNum" value="<c:out value="${cri.pageNum }"/>">
						<input type="hidden" name="amount" value="<c:out value="${cri.amount }"/>">
						
						<input type="hidden" name="type" value='<c:out value="${cri.type}"/>'> 
                     	<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
						
						<button type="submit" data-oper="modify" class="btn btn-info" >Modify</button>
						<button type="submit" data-oper="remove" class="btn btn-danger" >Remove</button>
						<button type="submit" data-oper="list" class="btn btn-success" >List</button>
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
		var formObj = $("form");
		$('button').on("click",function(e){
			e.preventDefault();
			var operation = $(this).data("oper");
			console.log(operation);
			if(operation === 'remove'){
				formObj.attr("action","/board/remove");
				
			}
			else if(operation === 'list'){
				formObj.attr("action","/board/list").attr("method","get");
				var pagNumTag = $("input[name='pageNum']").clone(); //잠시 보관용 필요한 데이터만 선택해서 가져왔음 데이터가 많기 때문이다 
				var amountTag = $("input[name='amount']").clone();
				var typeTag = $("input[name='type']").clone(); //잠시 보관용
				var keywordTag = $("input[name='keyword']").clone();
				formObj.empty();//제거
				
				formObj.append(pageNumTag); //필요한 테그들만 추가 
				formObj.append(amountTag);
				formObj.append(typeTag); //필요한 테그들만 추가 
				formObj.append(keywordTag);
				
			}
			formObj.submit();
		});
	});
	
</script>

</body>


</html>