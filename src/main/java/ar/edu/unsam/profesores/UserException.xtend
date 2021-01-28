package ar.edu.unsam.profesores

import java.lang.RuntimeException

class UserException extends RuntimeException {
	
	new(String message) { super(message) }
}