package org.conan.service;

import java.util.List;

import org.conan.domain.Criteria;
import org.conan.domain.ReplyVO;
import org.conan.mapper.ReplyMapper;
import org.springframework.stereotype.Service;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class ReplyServiceImpl implements ReplyService{
	
	private ReplyMapper mapper;
	@Override
	public int register(ReplyVO vo) {
		log.info("register......."+vo);
		return mapper.insert(vo);
	}
	@Override
	public ReplyVO get(Long rno) {
		// TODO Auto-generated method stub
		log.info("get........"+rno);
		return mapper.read(rno);
		
	}
	@Override
	public int modify(ReplyVO vo) {
		// TODO Auto-generated method stub
		log.info("modify........"+vo);
		return mapper.update(vo);
	}
	@Override
	public int remove(Long rno) {
		// TODO Auto-generated method stub
		log.info("remove........"+rno);
		return mapper.delete(rno);
	}
	@Override
	public List<ReplyVO> getList(Criteria cri, Long bno) {
		log.info("get reply list of a board........"+bno);
		return mapper.getListWithPaging(cri, bno);
	}
	
	
}
