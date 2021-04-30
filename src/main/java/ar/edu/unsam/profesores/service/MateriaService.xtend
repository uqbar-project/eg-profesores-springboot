package ar.edu.unsam.profesores.service

import ar.edu.unsam.profesores.dao.MateriaRepository
import ar.edu.unsam.profesores.errorHandling.NotFoundException
import ar.edu.unsam.profesores.serializer.MateriaDTO
import ar.edu.unsam.profesores.serializer.ProfesorDTO
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service

@Service
class MateriaService {
	
	@Autowired
	MateriaRepository materiaRepository
	
	def todasLasMaterias() {
		this.materiaRepository.findAll
	}
	
	def agruparProfesores(Long id) {
		// Recibimos n registros de materias
  	val materiasDTO = materiaRepository.findFullById(id)
  		
  	if (materiasDTO.empty) {
  		throw new NotFoundException("La materia con identificador " + id + " no existe")
  	}
  	
  	// Agrupamos los profesores de la materia
  	val materia = materiasDTO.head
  	val profesores = materiasDTO.map [ materiaDTO |
  		new ProfesorDTO(materiaDTO.profesorId, materiaDTO.profesorNombre) 
  	]
  	new MateriaDTO(materia.id, materia.nombreLindo, materia.anio, profesores)
	}

}