package ar.edu.unsam.profesores.dao

import ar.edu.unsam.profesores.domain.Materia
import java.util.List
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.CrudRepository
import ar.edu.unsam.profesores.serializer.MateriaFullRowDTO

interface MateriaRepository extends CrudRepository<Materia, Long> {
	
	@Query("SELECT m.id as id, m.nombre as nombre, m.anio as anio, p.id as profesorId, p.nombreCompleto as profesorNombre FROM Profesor p INNER JOIN p.materias m WHERE m.id = :id")
	def List<MateriaFullRowDTO> findFullById(Long id)

	def List<Materia> findByNombre(String nombreMateria)
}
