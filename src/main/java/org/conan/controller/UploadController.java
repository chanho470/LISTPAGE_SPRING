package org.conan.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.conan.domain.AttachFileDTO;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {
	@GetMapping("/uploadForm")
	public void uploadForm() {
		log.info("upload form");
	}
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
		String uploadFolder ="c:/upload";
		for(MultipartFile multipartFile : uploadFile) { // 파일정보를 배열로 받아와서 하나씩 조회한다. 
			log.info("---------------------------------");
			log.info("업로드 파일이름"+multipartFile.getOriginalFilename()); //  getOriginalFilename() : 이미지이름
			log.info("업로드 파일사이즈"+multipartFile.getSize());
			File saveFile = new File(uploadFolder,multipartFile.getOriginalFilename());
			try {
				multipartFile.transferTo(saveFile);
			}catch(Exception e) {
				log.error(e.getMessage());
			}
		}
	}
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		log.info("upload ajax");
	}
	
	@PostMapping(value = "/uploadAjaxAction" ,produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) { //MultipartResolver Bean가 등록되어 별도의 생성없이 손쉽게 다룰수있게하는 핸들러
		String uploadFolder = "c:/upload";
		
		List<AttachFileDTO> list = new ArrayList();
		
		File uploadPath = new File(uploadFolder , getFolder()); //.파일을 업로드하는데 기본으로는 업로드 경로에 넣어주는데 생성한 경로도 추가 함
		log.info("uploadPath"+uploadPath);
		
		UUID uuid= UUID.randomUUID(); // 랜덤으로 만든거 
		
		if(uploadPath.exists() == false) { // 아직까지 생성된 폴더가 없으면 
			uploadPath.mkdirs(); // 위에서 언급한 폴더 경로를 생성한다.
		}
		
		for(MultipartFile multipartFile : uploadFile) {//각 하나씩 가져와 multipartFile에지정
			log.info("---------------------------------");
			log.info("업로드 파일이름"+multipartFile.getOriginalFilename());
			log.info("업로드 파일사이즈"+multipartFile.getSize());
			AttachFileDTO attachDTO = new AttachFileDTO();
			
			String uploadFileName = multipartFile.getOriginalFilename();
			attachDTO.setFileName(uploadFileName);
			
			uploadFileName = uuid.toString()+"_"+uploadFileName;
			File saveFile = new File(uploadPath,uploadFileName); //동일한 파일을 업로드하면 모든 파일의 이름을 랜덤하게 다르게 설정하여 만들어준다 
			//업로드 경로에 파일의 이름을 넣어준다.
			//File saveFile = new File(uploadPath,multipartFile.getOriginalFilename());
			
			
			try {
				multipartFile.transferTo(saveFile); 
				//multipartFile : 파일의 정보 데이터 
				//saveFile : 경로 
				// 파일의 정보를 경로에 이동하여 저장함
				
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(getFolder());
				
				if(checkImageType(saveFile)) { //섬네일 이미지를 만든다 
					
					attachDTO.setImage(true);
					FileOutputStream thumbnail
					= new FileOutputStream(new File(uploadPath,"S_"+uploadFileName));//이미지 파일이면 s를 붙임
					Thumbnailator.createThumbnail(multipartFile.getInputStream(),thumbnail,100,100);//섬네일의 사이즈는 100by100이다 
					thumbnail.close();
				}
				list.add(attachDTO);
				log.info("attachDTO 뭐라고 나오니? ................."+attachDTO);
			}catch(Exception e) {
				log.error(e.getMessage());
			}
		}
		return new ResponseEntity<>(list , HttpStatus.OK);
	}
	
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); //파일의 경로를 날짜를 받아 폴더를 생성해준다
		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator);//년 월 일 별로 나누어서 폴더를 만들어준다 
	}
	
	
	private boolean checkImageType(File file) { // 이미지 파일인지 아닌지 검사하기 
		try {
			String contentType = Files.probeContentType(file.toPath()); //파일의 경로를 찾아와 확장자를 찾아온다 
			return contentType.startsWith("image"); // 확장자가 이미지로 시작하는지? 트루
		}
		catch(IOException e){
			e.printStackTrace();
		}
		return false;
	}
	
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]>getFile(String fileName){
		log.info("file name ..........." +fileName);
		File file = new File("c:/upload/"+fileName);
		log.info("file : "+ file);
		ResponseEntity<byte[]> result = null;
		try {
			HttpHeaders header = new HttpHeaders();
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file),header,HttpStatus.OK);
		}
		catch(IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@GetMapping(value ="/download", produces =MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(String fileName){
		
		log.info("다운로드 파일 ,,,,,,,"+fileName);
		Resource resource = new FileSystemResource("c:/upload/"+fileName);
		log.info("리소스............"+resource);
		
		String resourceName = resource.getFilename();
		HttpHeaders headers = new HttpHeaders();
		
		if(resource.exists()== false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_")+1);
		log.info("진짜이름 유아이디없는"+resourceOriginalName);
		
		try {
			headers.add("Content-Disposition", "attachment; fileName="
					+ new String(resourceOriginalName.getBytes("utf-8"),"ISO-8859-1"));
		}
		catch(UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		
		return new ResponseEntity<Resource>(resource,headers,HttpStatus.OK);
	}
}
