package ar.edu.unsam.profesores.errorHandling

import org.springframework.web.bind.annotation.ResponseStatus

@ResponseStatus(NOT_FOUND)
class NotFoundException extends RuntimeException {

	new(String message) {
		super(message)
	}
}

@ResponseStatus(BAD_REQUEST)
class UserException extends RuntimeException {

	new(String message) {
		super(message)
	}
}
