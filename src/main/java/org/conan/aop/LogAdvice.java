package org.conan.aop;

import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

@Aspect
@Log4j
@Component
public class LogAdvice {
	@Before("execution(* org.conan.service.SampleService*.*(..))")
	public void logBefore() {
		log.info("=====================서비스 실행전 실행 ===============");
	}
	@Before("execution(* org.conan.service.SampleService*.doAdd(String,String)) && args(str1 , str2)")
	public void logBeforeWithParam(String str1 , String str2) {
		log.info("str1 : ....."+str1);
		log.info("str2 : ....."+str2);
	}
	@AfterThrowing(pointcut ="execution(* org.conan.service.SampleService*.*(..))" , throwing  ="exception")
	public void logException(Exception exception) {
		
		log.info("예외발생 !!!!  ....."+exception);
	}
}
