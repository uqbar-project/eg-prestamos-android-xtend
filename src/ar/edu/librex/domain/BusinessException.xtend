package ar.edu.librex.domain

import java.lang.RuntimeException

class BusinessException extends RuntimeException {
	
	new(String e) {
		super(e)
	}
	
}