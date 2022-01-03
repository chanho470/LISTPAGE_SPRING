package org.conan.controller;

import java.util.List;

import org.conan.domain.Criteria;
import org.conan.domain.ReplyVO;
import org.conan.service.ReplyService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/replies/*")
@AllArgsConstructor
public class ReplyController {
	
	private ReplyService service;
	
	@PostMapping(value="/new",
			consumes="application/json",
			produces= {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> create(@RequestBody ReplyVO vo){
		log.info("ReplyVO........"+vo);
		int insertCount= service.register(vo);
		log.info("reply insert count"+insertCount);
		return insertCount==1
				? new ResponseEntity<>("success",HttpStatus.OK)
						:new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	} 

	@GetMapping(value="/pages/{bno}/{page}",
			produces= {MediaType.APPLICATION_ATOM_XML_VALUE,MediaType.APPLICATION_JSON_VALUE})
	public ResponseEntity<List<ReplyVO>> getList(
			@PathVariable("page")int page,@PathVariable("bno")Long bno){
		log.info("getList--------");
		Criteria cri = new Criteria(page,5);
		log.info("cri........"+cri);
		return new ResponseEntity<>(service.getList(cri, bno),HttpStatus.OK);
	}
	
}
