package com.sp.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sp.app.common.PaginateUtil;
import com.sp.app.common.StorageService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping(value = "/products/*")
public class ProductsController {
	
	private final PaginateUtil paginateUtil;
	private final StorageService storageService;
	
	private String uploadPath;
	
	@GetMapping("write")
	public String writeForm() {
		return "products/write";
	}
 	
	
}
