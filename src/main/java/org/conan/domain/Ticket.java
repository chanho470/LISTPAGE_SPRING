package org.conan.domain;

public class Ticket {
	public int tno;
	public String owner;
	public String grade;
	public int getTno() {
		return tno;
	}
	public void setTno(int tno) {
		this.tno = tno;
	}
	public String getOwner() {
		return owner;
	}
	public void setOwner(String owner) {
		this.owner = owner;
	}
	public String getGrade() {
		return grade;
	}
	public void setGrade(String grade) {
		this.grade = grade;
	}
	public Ticket(int tno, String owner, String grade) {
		super();
		this.tno = tno;
		this.owner = owner;
		this.grade = grade;
	}
	public Ticket() {
		
	}
	
	
}
