package ar.edu.unsam.profesores.serializer

import java.util.List
import org.eclipse.xtend.lib.annotations.Data
import org.springframework.beans.factory.annotation.Value

interface MateriaFullRowDTO {
	def Long getId()
	@Value("#{target.nombre}")
	def String getNombreLindo()
	def int getAnio()
	def Long getProfesorId()
	def String getProfesorNombre()
}

@Data
class MateriaDTO {
	Long id
	String nombre
	int anio
	List<ProfesorDTO> profesores
}

@Data
class ProfesorDTO {
	Long id
	String nombre
}