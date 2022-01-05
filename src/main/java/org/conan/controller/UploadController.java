package org.conan.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import lombok.extern.log4j.Log4j;

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
		for(MultipartFile multipartFile : uploadFile) {
			log.info("---------------------------------");
			log.info("업로드 파일이름"+multipartFile.getOriginalFilename());
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
	
	@PostMapping("/uploadAjaxAction")
	public void uploadAjaxPost(MultipartFile[] uploadFile) { //MultipartResolver Bean가 등록되어 별도의 생성없이 손쉽게 다룰수있게하는 핸들러
		String uploadFolder = "c:/upload";
		
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
			
			String uploadFileName = multipartFile.getOriginalFilename();
			uploadFileName = uuid.toString()+"_"+uploadFileName;
			File saveFile = new File(uploadPath,uploadFileName); //동일한 파일을 업로드하면 모든 파일의 이름을 랜덤하게 다르게 설정하여 만들어준다 
			//업로드 경로에 파일의 이름을 넣어준다.
			//File saveFile = new File(uploadPath,multipartFile.getOriginalFilename());
			try {
				multipartFile.transferTo(saveFile); 
				//multipartFile : 파일의 정보 데이터 
				//saveFile : 경로 
				// 파일의 정보를 경로에 이동하여 저장함
			}catch(Exception e) {
				log.error(e.getMessage());
			}
		}
	}
	
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); //파일의 경로를 날짜를 받아 폴더를 생성해준다
		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator);//년 월 일 별로 나누어서 폴더를 만들어준다 
	}
}
