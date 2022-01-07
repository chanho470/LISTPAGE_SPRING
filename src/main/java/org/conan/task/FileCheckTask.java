package org.conan.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.stream.Collectors;

import org.conan.domain.BoardAttachVO;
import org.conan.mapper.BoardAttachMapper;
import org.conan.service.BoardService;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Component
@AllArgsConstructor
public class FileCheckTask {

	BoardAttachMapper attachMapper;
	@Scheduled(cron="0 * * * * *")
	public void checkFiles() throws Exception{
	
	
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();
		List<Path> fileListPaths
				=fileList.stream().map(vo->Paths.get("c:/upload", vo.getUploadPath(),vo.getUuid()+"_"+vo.getFileName())).collect(Collectors.toList());
		
		fileList.stream().filter(vo->vo.isFileType()==true).map(vo->Paths.get("c:/upload",vo.getUploadPath(),"S_"+vo.getUuid()+"_"+vo.getFileName()))
			.forEach(p->log.warn(p));
		log.warn("file check task run");
		log.warn("====================================");
		fileListPaths.forEach(p->log.warn(p));
		File targetDir = Paths.get("c:/upload",getFolderYesterDay()).toFile();
		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath())==false);
		log.warn("====================================");
		for(File file : removeFiles) {
			log.warn(file.getAbsolutePath());
			file.delete();
		}
	}	

	
	private String getFolderYesterDay() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE,-1);
		String str = sdf.format(cal.getTime());
		return str.replace("-", File.separator);
		
	}
}
