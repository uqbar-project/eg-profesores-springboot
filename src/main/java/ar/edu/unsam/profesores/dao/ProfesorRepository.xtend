package ar.edu.unsam.profesores.dao

import ar.edu.unsam.profesores.domain.Profesor
import java.util.Optional
import org.springframework.data.jpa.repository.EntityGraph
import org.springframework.data.repository.CrudRepository

interface ProfesorRepository extends CrudRepository<Profesor, Long> {

	@EntityGraph(attributePaths=#["materias"])
	override Optional<Profesor> findById(Long id)

}
