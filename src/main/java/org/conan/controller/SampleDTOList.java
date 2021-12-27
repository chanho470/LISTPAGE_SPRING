package org.conan.controller;

import java.util.ArrayList;
import java.util.List;

import org.conan.domain.SampleDTO;

import lombok.Data;

@Data
public class SampleDTOList {
	private List<SampleDTO> list;
	public SampleDTOList() {
		list = new ArrayList<>();
	}
}
