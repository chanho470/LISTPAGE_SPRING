<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
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
</style>
<body>

<div class="uploadDiv">
	<input type="file" name="uploadFile" multiple>
</div>
<div class= "uploadResult">
	<ul></ul>
</div>
<button id="uploadBtn">Upload</button>


<script type="text/javascript">
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
		
		$("#uploadBtn").on("click",function(e){
			var formData = new FormData(); //가상의 폼데이터를 만든다 
			var inputFile = $("input[name = 'uploadFile']"); // 입력을 받은거 
			var files = inputFile[0].files; // 인풋이 하나이기때문이다 ex input 이 2개 이상인경우  inputFile[1 ++ ] 늘어난다. 
			
			var uploadResult = $(".uploadResult ul"); 
			function showUploadedFile(uploadResultArr){
				var str = "" ;
				$(uploadResultArr).each(function(i,obj){
					
					if(!obj.image){//이미지 아님 클릭하면 다운로드 경로로 이동하여 다운함.
						 var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
						str += "<li><a href='/download?fileName="+fileCallPath+"'><img src='/resources/images/attach.png'>"+ obj.fileName+"</li>";
					}else{//이미지			
						//str += "<li>" +obj.fileName+"</li>";
						var fileCallPath = 
							encodeURIComponent(obj.uploadPath+"/S_"+obj.uuid+"_"+obj.fileName);
						str += "<li><img src='display?fileName="+fileCallPath+"'></li>";
					}
				});
				uploadResult.append(str);
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
			 
			 
		}); //btn click
		
		
	});
</script>
</body>
</html>