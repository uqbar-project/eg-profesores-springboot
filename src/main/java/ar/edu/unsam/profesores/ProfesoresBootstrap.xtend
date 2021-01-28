package ar.edu.unsam.profesores

import ar.edu.unsam.profesores.dao.MateriaRepository
import ar.edu.unsam.profesores.dao.ProfesorRepository
import ar.edu.unsam.profesores.domain.Materia
import ar.edu.unsam.profesores.domain.Profesor
import org.springframework.beans.factory.InitializingBean
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service

/**
 * 
 * Para explorar otras opciones
 * https://stackoverflow.com/questions/38040572/spring-boot-loading-initial-data
 */
@Service
class ProfesoresBootstrap implements InitializingBean {

	@Autowired
	MateriaRepository repoMaterias
	
	@Autowired
	ProfesorRepository repoProfes
	
	override afterPropertiesSet() throws Exception {
		println("************************************************************************")
		println("Running initialization")
		println("************************************************************************")
		init
	}
	
	def void init() {
		val	algoritmos = new Materia => [
			nombre = "Algoritmos y Estructura de Datos"
			anio = 1
		]
		val paradigmas = new Materia => [
			nombre = "Paradigmas de Programacion"
			anio = 2
		]
		val disenio = new Materia => [
			nombre = "Diseño de Sistemas"
			anio = 3
		]
		
		repoMaterias.save(algoritmos)
		repoMaterias.save(paradigmas)
		repoMaterias.save(disenio)
		
		val spigariol = new Profesor => [
			nombreCompleto = "Lucas Spigariol"
		]
		spigariol.agregarMateria(algoritmos)
		spigariol.agregarMateria(paradigmas)
		
		val passerini = new Profesor => [
			nombreCompleto = "Nicolás Passerini"
		]
		passerini.agregarMateria(paradigmas)
		passerini.agregarMateria(disenio)
		
		val dodino = new Profesor => [
			nombreCompleto = "Fernando Dodino"
		]
		dodino.agregarMateria(disenio)
		repoProfes.save(spigariol)
		repoProfes.save(passerini)
		repoProfes.save(dodino)
	}

}