package ar.edu.unsam.profesores.controller

import ar.edu.unsam.profesores.domain.Profesor
import ar.edu.unsam.profesores.service.ProfesorService
import io.swagger.annotations.ApiOperation
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController

@RestController
@CrossOrigin(origins = "*")
class ProfesorController {

	@Autowired
	ProfesorService profesorService

	@GetMapping("/profesores")
	@ApiOperation("Permite conocer todas las personas que dan clase.")
	def getProfesores() {
		profesorService.todosLosProfesores
	}

	@GetMapping("/profesores/{id}")
	@ApiOperation("Dado un identificador de una persona que es profesora, podemos conocer su información, incluyendo las materias que dicta.")
	def getProfesor(@PathVariable Long id) {
		profesorService.buscarPorId(id)
	}

	@PutMapping("/profesores/{id}")
	@ApiOperation("Permite actualizar la información de una persona que es profesora.")
	def actualizarProfesor(@RequestBody Profesor profesorNuevo, @PathVariable Long id) {
		profesorService.actualizarProfesor(profesorNuevo, id)
		return ResponseEntity.ok.body("El profesor fue actualizado correctamente")
	}
}
