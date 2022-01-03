package org.conan.mapper;

import org.conan.domain.ReplyVO;

public interface ReplyMapper {
	public int insert(ReplyVO vo);
	
	public ReplyVO read(Long rno);
	
	public int delete(Long rno);
	
	public int update(ReplyVO vo);
}
