package org.conan.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
	private int startPage;//화면에 보여지는 페이지의 시작번호
	private int endPage; //화면에 보여지는 페이지의 끝번호
	private boolean prev, next; //이전 , 다음페이지의 존재여부
	private int total; //전체데이터수
	private Criteria cri;
	public PageDTO( Criteria cri,int total) {
		
		this.total = total;
		this.cri = cri;
		
		this.endPage = (int)(Math.ceil(cri.getPageNum()/10.))*10;
		this.startPage = this.endPage-9;
		
		int realEnd= (int)(Math.ceil((total*1.0)/cri.getAmount()));
		if(realEnd < this.endPage) {
			this.endPage =realEnd;
		}
		this.prev = this.startPage>1;
		this.next = this.endPage<realEnd;
	}
	
}
