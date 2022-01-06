<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<!DOCTYPE html>
<html lang="en">

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
<%@include file="../includes/header.jsp"%>

<div id="page-wrapper">
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">글쓰기 페이지</h1>
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
					<form role="form" action="/board/register" method="post">
						<div class = "form-group">
							<label>Title</label><input class="form-control" name="title">
						</div>
						<div class = "form-group">
							<label>Content</label><textarea class="form-control" name="content" rows="3"></textarea>
						</div>
						<div class = "form-group">
							<label>Writer</label><input class="form-control" name="writer">
						</div>
						<button type ="submit" class="btn btn-default">Submit</button>
						<button type ="reset" class="btn btn-default">Reset</button>
					</form>

				</div>
				<!-- /.table-responsive -->
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- /.panel -->
	</div>
	
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
	<!-- /.col-lg-6 -->
</div>
<!-- /.row -->

<!-- /#page-wrapper -->
<script>
	var formObj = $("form[role='form']");
	$("button[type='submit']").on("click",function(e){
		e.preventDefault();
		console.log("submit clicked");
	})
	
	function showImage(fileCallPath){
		$(".bigPictureWrapper").css("display","flex").show();
		$(".bigPicture").html("<img src='/display?fileName="+encodeURI(fileCallPath)+"'>").animate({width:'100%',height:'100%'},1000);
		
		$(".bigPictureWrapper").on("click",function(e){
			
			$(".bigPicture").animate({width:'0%',height:'0%'},1000);
			setTimeout(function(){
				$(".bigPictureWrapper").hide();
			},1000);
		});//click
	}

	$(document).ready(function(){
		
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
		
		$("input[type='file']").change(function(e){
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
						str += "<li><div><a href='/download?fileName="+fileCallPath+"'><img src='/resources/images/attach.png'>"+ obj.fileName+"</a>"
								+"<span data-file=\' "+fileCallPath+"\' data-type='file'>X</span></div></li>";
					}else{//이미지			
						//str += "<li>" +obj.fileName+"</li>";
						var fileCallPath = 
							encodeURIComponent(obj.uploadPath+"/S_"+obj.uuid+"_"+obj.fileName);
						
						var originPath = obj.uploadPath +"/"+obj.uuid + "_" +obj.fileName;
						originPath = originPath.replace(new RegExp(/\\/g),"/");
						str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\"><img src='/display?fileName="+fileCallPath+"'></a>"
								+"<span data-file=\'"+fileCallPath+"\' data-type='image'>X</span></li>";
					}
				});
				uploadUL.append(str);
				//uploadResult.append(str);
			}
			
			
			console.log(files);
			for(var i=0; i < files.length;i++){
				
				if(!checkExtension(files[i].name,files[i].size)){
					return false;
				}
				formData.append("uploadFile",files[i]); //가상의 폼에다가 저장한다.
			}
			console.log("files.length : "+files.length);
			// ajax 로 넘기기 워한 사전작업
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
		      }); // $.ajax

			 //폼이 없이 가상의 폼으로 만들어서 전달하는ㄴ 방식으로 에이젝스를 이용함
			 
			 
			 $(".uploadResult").on("click","span",function(e){
					var targetFile = $(this).data("file");
					var type = $(this).data("type");
					console.log("aaaaaaaaaaaaaaaaa"+targetFile);
					$.ajax({
						url:'/deleteFile',
						data:{fileName:targetFile,type:type},
						dataType : 'text',
						type:'post',
						success:function(result){alert(result);}
					});
				});
				
			 
		}); //btn click
		
		
	});
	
</script>

<%@include file="../includes/footer.jsp"%>
</body>

</html>