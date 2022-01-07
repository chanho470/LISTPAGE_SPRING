<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<script src="http://code.jquery.com/jquery-latest.js"></script> <!-- 푸터에 있음 -->
<%@include file="../includes/header.jsp"%>
<%@include file="../includes/footer.jsp"%>
<style>
	.uploadResult{
		width :100%;
		background-color : #ddd;
	}
	.uploadResult ul{
		display:flex;
		flex-flow:row;
		justify-content:center;
		align-items:center;
	}
	.uploadResult ul li{
		list-style:none;
		padding : 10px;
	}
	.uploadResult ul li img{
		width:20px
	}
	.uploadResult ul li span{
		color:white;
	}
	.bigPictureWrapper{
		position:absolute;
		display:none ;
		justify-content:center;
		align-items:center;
		top:0%;
		width:100%;
		height:100%;
		background-color:gray;
		z-index :100;
		background:rgba(255,255,255,0.5);
	}
	.bigPicture{
		position:relative;
		display:flex;
		justify-content:center;
		align-items:center;
	}
	.bigPicture img{
		width: 400px
	}
	
</style>
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
	
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
			<div class="panel-heading">File Attach</div>
			<div class ="panel-body">
				<div class="form-group uploadDiv">
					<input type="file" name='uploadFile' multiple>
				</div>
				<div class= "uploadResult">
					<ul></ul>
				</div>
				
				<div class= "bigPictureWrapper">
					<div class="bigPicture"></div>
				</div>
				
			</div>
			</div>
		</div>
	
	</div>
</div>
<!-- /.row -->

<!-- /#page-wrapper -->

<script type="text/javascript">

var formObj = $("form[role='form']");
$("button[type='submit']").on("click",function(e){
	e.preventDefault();
	console.log("submit clicked");
	var str = "";
	$(".uploadResult ul li").each(function(i , obj){
		var jobj = $(obj);
		console.dir(obj);
		str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
		str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
		str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
		str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
		
	});
	formObj.append(str);
	formObj.submit();
});


	$(document).ready(function(){
		var formObj = $("form");
//========================================================================================================================================		
	
	var bnoValue='<c:out value="${board.bno}"/>';
	$.getJSON("/board/getAttachList",{bno:bnoValue},function(arr){
			console.log(arr);
			var str="";
			$(arr).each(function(i,obj){
				if(!obj.fileType){//이미지 아님 클릭하면 다운로드 경로로 이동하여 다운함.
					 var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
					 str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename = '"+obj.fileName+"' data-type ='"+obj.image+"'><div>";
					 str += "<span>"+obj.fileName+"<span>";
					str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' class ='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					 str += "<img src='/resources/images/attach.png'></a>";
					 str += "</div></li>";

				}else{//이미지			
					var fileCallPath = 
						encodeURIComponent(obj.uploadPath+"/S_"+obj.uuid+"_"+obj.fileName);	
					var originPath = obj.uploadPath +"/"+obj.uuid + "_" +obj.fileName;
					originPath = originPath.replace(new RegExp(/\\/g),"/");
					str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename = '"+obj.fileName+"' data-type ='"+obj.image+"'><div>";
					str += "<span>"+obj.fileName+"<span>";
					str += "<button type='button'  data-file=\'"+fileCallPath+"\' data-type='image' class = 'btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str += "<a href=\"javascript:showImage(\'"+originPath+"\')\"><img src='/display?fileName="+fileCallPath+"'></a>";
					str += "</div></li>";
				}
			});
			$(".uploadResult ul").html(str);
		});
		
		
		$(".uploadResult").on("click","button",function(e){
			var targetFile = $(this).data("file");
			var type = $(this).data("type");	
			if (confirm("이파일을 삭제하시겟습니까?")){
				var targetLi = $(this).closest("li");
				targetLi.remove();
			}
			$.ajax({
				url:'/deleteFile',
				data:{fileName:targetFile,type:type},
					dataType : 'text',
					type:'post',
					success:function(result){
					alert(result);
					
					}
				});
			});
		
		var cloneObj = $(".uploadDiv").clone(); // 
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880;
		function checkExtension(fileName , fileSize){
			if(fileSize >= maxSize){
				alert("파일 사이즈 초과");
				return false;
			}
			if(regex.test(fileName)){
				alert("해당 정류의 파일은 업로드 불가 ");
				return false;
			}
			return true;
		}
		
		$(document).on('change', "input[type='file']", function(e) {
			var formData = new FormData(); //가상의 폼데이터를 만든다 
			var inputFile = $("input[name = 'uploadFile']"); // 입력을 받은거 
			var files = inputFile[0].files; // 인풋이 하나이기때문이다 ex input 이 2개 이상인경우  inputFile[1 ++ ] 늘어난다. 
			var uploadResult = $(".uploadResult ul"); 
			function showUploadedFile(uploadResultArr){
				if(!uploadResultArr || uploadResultArr.length == 0){return;}
				var uploadUL = $(".uploadResult ul");
				var str = "" ;
				$(uploadResultArr).each(function(i,obj){
					if(!obj.image){//이미지 아님 클릭하면 다운로드 경로로 이동하여 다운함.
						 var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
						
						 str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename = '"+obj.fileName+"' data-type ='"+obj.image+"'><div>";
						 str += "<span>"+obj.fileName+"<span>";
						 str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' class ='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
						 str += "<img src='/resources/images/attach.png'></a>";
						 str += "</div></li>";
					}else{//이미지			
						//str += "<li>" +obj.fileName+"</li>";
						var fileCallPath = 
							encodeURIComponent(obj.uploadPath+"/S_"+obj.uuid+"_"+obj.fileName);
						str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename = '"+obj.fileName+"' data-type ='"+obj.image+"'><div>";
						str += "<span>"+obj.fileName+"<span>";
						str += "<button type='button'  data-file=\'"+fileCallPath+"\' data-type='image' class = 'btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
						str += "<img src='/display?fileName="+fileCallPath+"'>";
						str += "</div></li>";						
					}
				});
				uploadUL.append(str);
			}
			console.log(files);
			for(var i=0; i < files.length;i++){
				if(!checkExtension(files[i].name,files[i].size)){
					return false;
				}
				formData.append("uploadFile",files[i]); //가상의 폼에다가 저장한다.
			}
			
			console.log("files.length : "+files.length);
			 $.ajax({
		         url : '/uploadAjaxAction', //이동경로 
		         processData : false,// 전달할 데이터를 query string을 만들지 말 것
		         contentType : false,// 
		         data : formData,//전달할 데이터 위에 만들어 놓은 값(폼) 전달  보내는 타입
		         type : 'POST',
		         dataType:'json', //뭐라고 했더라 
		         success : function(result){//업로드가 성공하면~~
		            alert("Uploaded");
		            console.log(result);
		            showUploadedFile(result);
					$(".uploadDiv").html(cloneObj.html()); //업로드후 업로드 부분을 초기화함 
		         }
		      }); 
		}); 
		
//================================================================================================================================================		
		
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
				
			}else if(operation === 'modify'){
				console.log("submit clicked");
				var str ="";
				$(".uploadResult ul li").each(function(i, obj){
					var jobj = $(obj);
					str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
				});
				formObj.append(str);
			}
			formObj.submit();
		});

		
	});
	
</script>



</body>


</html>