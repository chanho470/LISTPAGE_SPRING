package org.conan.domain;

import lombok.Data;
import lombok.ToString;

@ToString
@Data
public class Criteria {
	private int pageNum; //페이지 번호
	private int amount; // 한페이지에 출력되는 데이터 수
	
	private String type;
	private String keyword;
	
	public String[] getTypeArr() {
		return type == null ? new String[] {} :type.split("");
	}
			
	public Criteria() {this(1,10);}
	public Criteria(int pageNum, int amount) {
		this.pageNum = pageNum;
		this.amount = amount;
	}
	public void setPageNum(int pageNum) {
		if(pageNum <= 0 ) {
			this.pageNum =1;
			return;
		}
		this.pageNum = pageNum;
	}
	
	public String getType() {return this.type;}
	public String getKeyword() {return this.keyword;}
	
	public void setType(String type) {this.type =type;}
	public void setKeyword(String keyword) {this.keyword = keyword;}
	
	public int getPageNum() {return this.pageNum;}
	public int getAmount() {return this.amount;}
	
	public void setAmount(int amount) {this.amount = amount;}
	public int getPageStart() { //limit 구문에서 시작 위치 지정
		return (this.pageNum-1)*this.amount;
	}
	
	
	
}
