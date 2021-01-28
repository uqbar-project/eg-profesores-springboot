package ar.edu.unsam.profesores.serializer

import ar.edu.unsam.profesores.domain.Profesor
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class ProfesorBasicoDTO {
	
	Long id
	String nombreCompleto

	private new() {}
	
	def static fromProfesor(Profesor profesor) {
		new ProfesorBasicoDTO => [
			id = profesor.id
			nombreCompleto = profesor.nombreCompleto
		]
	}

}
