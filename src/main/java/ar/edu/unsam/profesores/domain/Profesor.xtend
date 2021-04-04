package ar.edu.unsam.profesores.domain

import java.io.Serializable
import java.util.HashSet
import java.util.Set
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import javax.persistence.ManyToMany
import org.eclipse.xtend.lib.annotations.Accessors

@Entity
@Accessors
class Profesor implements Serializable {
	
	@Id
	// El GenerationType asociado a la TABLE es importante para tener
	// una secuencia de identificadores única para los profesores
	// (para que no dependa de otras entidades anteriormente creadas)
	@GeneratedValue(strategy = GenerationType.TABLE)
	Long id

	@Column
	String nombreCompleto
	
	@ManyToMany(fetch = FetchType.LAZY)
	Set<Materia> materias = new HashSet<Materia>

	// Hibernate necesita un constructor sin argumentos
	// si creás un constructor con parámetros debés agregar uno sin ninguno
		
	def void agregarMateria(Materia materia) {
		materias.add(materia)
	}

	def void quitarMateria(Materia materia) {
		materias.remove(materia)
	}
		
	def boolean dicta(Materia materia) {
		materias.contains(materia)
	}

	override toString() {
		nombreCompleto + " (" + id + ")"
	}
	
	def borrarMaterias() {
		materias.clear()
	}
	
	override equals(Object otroProfesor) {
		id.equals((otroProfesor as Profesor).id)
	}
	
	override hashCode() {
		id.hashCode
	}
	
}