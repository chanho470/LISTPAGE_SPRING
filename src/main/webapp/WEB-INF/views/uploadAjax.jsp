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
		align-items:center;/*display:flex; 자식들을 상속을 해줌 flex 정렬 방식중 하나  */
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
<body>

<div class="uploadDiv">
	<input type="file" name="uploadFile" multiple>
</div>
<div class= "uploadResult">
	<ul></ul>
</div>

<div class= "bigPictureWrapper">
	<div class="bigPicture"></div>
</div>
<button id="uploadBtn">Upload</button>


<script type="text/javascript">
	function showImage(fileCallPath){ // 섬네일 이미지 경로 + 이름를 받아옴
		$(".bigPictureWrapper").css("display","flex").show();
		$(".bigPicture").html("<img src='/display?fileName="+encodeURI(fileCallPath)+"'>").animate({width:'100%',height:'100%'},1000);
		//encodeURI 풀경로의 한글같은거 처리해줌 ~~ 안전하게 
		$(".bigPictureWrapper").on("click",function(e){
			
			$(".bigPicture").animate({width:'0%',height:'0%'},1000);
			setTimeout(function(){
				$(".bigPictureWrapper").hide();// div 숨김
			},1000);
		});//click
	}

	$(document).ready(function(){
		
		var cloneObj = $(".uploadDiv").clone(); // 영역 백업하는느낌
		
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
			
			function showUploadedFile(uploadResultArr){ // 업로드 파일이 많아지면 배열로~~
				var str = "" ;
				$(uploadResultArr).each(function(i,obj){
					
					if(!obj.image){//이미지 아님 클릭하면 다운로드 경로로 이동하여 다운함.
						 var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName); //full경로+ uuid + 파일이름 
						str += "<li><div><a href='/download?fileName="+fileCallPath+"'><img src='/resources/images/attach.png'>"+ obj.fileName+"</a>" //다운로드 링크를 만들어줌
								+"<span data-file=\' "+fileCallPath+"\' data-type='file'>X</span></div></li>"; //x 는 삭제하기 위함
					}else{//이미지			
						//str += "<li>" +obj.fileName+"</li>";
						var fileCallPath = 
							encodeURIComponent(obj.uploadPath+"/S_"+obj.uuid+"_"+obj.fileName); //섬네일 이미지를 불러옴 
						
						var originPath = obj.uploadPath +"/"+obj.uuid + "_" +obj.fileName; //그냥 이미지의 경로를 불러옴
						originPath = originPath.replace(new RegExp(/\\/g),"/"); //경로 안의 걍로 설정 문자를 / 퉁침
						
						str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\"><img src='display?fileName="+fileCallPath+"'></a>"
								+"<span data-file=\'"+fileCallPath+"\' data-type='image'>X</span></li>";
					}
				});
				uploadResult.append(str); //str 값을 실제로 넣어줌 (덮어쓰기 ) 
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
		         dataType:'json', //제이슨 혀ㅇ태 
		         success : function(result){//업로드가 성공하면~~
		            alert("Uploaded");
		            console.log("뭐냐??????????????????????"+result);
		            showUploadedFile(result);
					$(".uploadDiv").html(cloneObj.html()); //업로드후 업로드 부분을 초기화함 
		         }
		      }); // $.ajax

			 //폼이 없이 가상의 폼으로 만들어서 전달하는ㄴ 방식으로 에이젝스를 이용함
			 
			 
			 $(".uploadResult").on("click","span",function(e){
					var targetFile = $(this).data("file"); // 삭제할 파일의 경로
					var type = $(this).data("type"); // 삭제할 파일의 형식
					console.log("aaaaaaaaaaaaaaaaa"+targetFile);
					console.log("ㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠ"+type);
					$.ajax({
						url:'/deleteFile',
						data:{fileName:targetFile,type:type},
						dataType : 'text', //string으로 보내니깐
						type:'post',
						success:function(result){alert(result);} // result는 컨트롤러에서 받아와 deleted로 가져온다.
					});
				});
				
			 
		}); //btn click
		
		
	});
</script>
</body>
</html>