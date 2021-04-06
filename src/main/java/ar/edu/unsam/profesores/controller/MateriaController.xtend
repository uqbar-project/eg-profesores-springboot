package ar.edu.unsam.profesores.controller

import ar.edu.unsam.profesores.dao.MateriaRepository
import ar.edu.unsam.profesores.serializer.MateriaDTO
import ar.edu.unsam.profesores.serializer.ProfesorDTO
import io.swagger.annotations.ApiOperation
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMethod
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.server.ResponseStatusException

@RestController
@CrossOrigin(origins = "*", methods= #[RequestMethod.GET])
class MateriaController {
	
	@Autowired
	MateriaRepository materiaRepository
	
	@GetMapping(value = "/materias")
	@ApiOperation("Permite conocer todas las materias cargadas en el sistema")
	def getMaterias() {
		this.materiaRepository.findAll
	}
  
	@GetMapping(value="/materias/{id}")
	@ApiOperation("Dado un identificador de una materia, permite conocer sus datos y todas las personas que la dictan.")
  def getMateria(@PathVariable Long id) {
	
		// Recibimos n registros de materias
  	val materiasDTO = this
  		.materiaRepository
  		.findFullById(id)
  		
  	if (materiasDTO.empty) {
  		throw new ResponseStatusException(HttpStatus.NOT_FOUND, "La materia con identificador " + id + " no existe")
  	}
  	
  	// Agrupamos los profesores de la materia
  	val materia = materiasDTO.head
  	val profesores = materiasDTO.map [ materiaDTO |
  		new ProfesorDTO(materiaDTO.profesorId, materiaDTO.profesorNombre) 
  	]
  	new MateriaDTO(materia.id, materia.nombreLindo, materia.anio, profesores)
  }
  
}