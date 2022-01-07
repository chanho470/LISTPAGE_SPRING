package org.conan.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.conan.domain.BoardAttachVO;
import org.conan.domain.BoardVO;
import org.conan.domain.Criteria;

public interface BoardService {
	public void register(BoardVO board);
	public BoardVO get(Long bno);
	public boolean modify(BoardVO board);
	public boolean remove(Long bno);
	public List<BoardVO> getList();
	public List<BoardVO> getList(Criteria cri);

	/* public int getTotalCount(Criteria cri); */
	int getTotal(Criteria cri);
	List<BoardAttachVO> getAttachList(Long bno);
	
	
	
}
