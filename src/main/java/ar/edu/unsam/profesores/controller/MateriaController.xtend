package ar.edu.unsam.profesores.controller

import ar.edu.unsam.profesores.service.MateriaService
import io.swagger.annotations.ApiOperation
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.CrossOrigin
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMethod
import org.springframework.web.bind.annotation.RestController

@RestController
@CrossOrigin(origins = "*", methods= #[RequestMethod.GET])
class MateriaController {
	
	@Autowired
	MateriaService materiaService
	
	@GetMapping(value = "/materias")
	@ApiOperation("Permite conocer todas las materias cargadas en el sistema")
	def getMaterias() {
		materiaService.todasLasMaterias
	}
  
	@GetMapping(value="/materias/{id}")
	@ApiOperation("Dado un identificador de una materia, permite conocer sus datos y todas las personas que la dictan.")
  def getMateria(@PathVariable Long id) {
		materiaService.agruparProfesores(id)
  }
  
}