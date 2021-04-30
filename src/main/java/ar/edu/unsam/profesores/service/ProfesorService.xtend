package ar.edu.unsam.profesores.service

import ar.edu.unsam.profesores.dao.ProfesorRepository
import ar.edu.unsam.profesores.domain.Profesor
import ar.edu.unsam.profesores.errorHandling.NotFoundException
import ar.edu.unsam.profesores.serializer.ProfesorBasicoDTO
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service

@Service
class ProfesorService {
	
	@Autowired
	ProfesorRepository profesorRepository
	
	def todosLosProfesores() {
		profesorRepository.findAll.map [ ProfesorBasicoDTO.fromProfesor(it) ].toList
	}
	
	def buscarPorId(Long id) {
		profesorRepository.findById(id).orElseThrow([
			throw new NotFoundException("El profesor con identificador " + id + " no existe")
		])
	}
	
	def actualizarProfesor(Profesor profesorNuevo, Long id) {
		profesorRepository.findById(id).map([ profesor |
			profesor => [
				nombreCompleto = profesorNuevo.nombreCompleto
				materias = profesorNuevo.materias
			]
			//
			profesorRepository.save(profesor)
		])
		.orElseThrow([
			throw new NotFoundException("El profesor con identificador " + id + " no existe")
		])
	}
	
}