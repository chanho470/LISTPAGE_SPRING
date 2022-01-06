package org.conan.domain;

import lombok.Data;

@Data
public class AttachFileDTO {
	private String fileName; 
	private String uploadPath; 
	private String  uuid;
	private boolean image;
}
//서버에 저장한 이미지를 가져오기위한 디티오