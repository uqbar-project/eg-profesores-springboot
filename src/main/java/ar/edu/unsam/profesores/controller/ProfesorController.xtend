package ar.edu.unsam.profesores.controller

import ar.edu.unsam.profesores.dao.ProfesorRepository
import ar.edu.unsam.profesores.domain.Profesor
import ar.edu.unsam.profesores.serializer.ProfesorBasicoDTO
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.server.ResponseStatusException

@RestController
@CrossOrigin(origins = "*")
class ProfesorController {

	@Autowired
	ProfesorRepository profesorRepository

	@GetMapping("/profesores")
	def getProfesores() {
		val result = this.profesorRepository.findAll.map [ ProfesorBasicoDTO.fromProfesor(it) ].toList
		println("result " + result.map [ id ])
		result
	}

	@GetMapping("/profesores/{id}")
	def getProfesor(@PathVariable Long id) {
		this.profesorRepository.findById(id).map([ profesor | 
			profesor
		]).orElseThrow([
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "El profesor con identificador " + id + " no existe")
		])
	}

	@PutMapping("/profesores/{id}")
	def actualizarCandidato(@RequestBody Profesor profesorNuevo, @PathVariable Long id) {

		profesorRepository.findById(id).map([ profesor |
			profesor => [
				nombreCompleto = profesorNuevo.nombreCompleto
				materias = profesorNuevo.materias
			]
			//
			profesorRepository.save(profesor)
		])
		.orElseThrow([
			throw new ResponseStatusException(HttpStatus.NOT_FOUND, "El profesor con identificador " + id + " no existe")
		])

		return ResponseEntity.ok.body("El profesor fue actualizado correctamente")
	}
}
