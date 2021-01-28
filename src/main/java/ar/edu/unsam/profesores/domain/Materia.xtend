package ar.edu.unsam.profesores.domain

import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import org.eclipse.xtend.lib.annotations.Accessors

@Entity
@Accessors
class Materia {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	Long id

	@Column
	String nombre

	@Column
	int anio
	
	// Hibernate necesita un constructor sin argumentos
	// si creás un constructor con parámetros debés agregar uno sin ninguno
	
	override toString() {
		nombre + " (" + anio + ")"
	}
		
}