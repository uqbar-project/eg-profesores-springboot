package ar.edu.unsam.profesores.controller

import ar.edu.unsam.profesores.dao.MateriaRepository
import ar.edu.unsam.profesores.dao.ProfesorRepository
import ar.edu.unsam.profesores.domain.Profesor
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.ActiveProfiles
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders

import static org.junit.jupiter.api.Assertions.assertEquals

import static extension ar.edu.unsam.profesores.controller.TestHelpers.*

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@DisplayName("Dado un controller de profesores")
class ProfesorControllerTest {

	@Autowired
	MockMvc mockMvc

	@Autowired
	ProfesorRepository repoProfes

	@Autowired
	MateriaRepository repoMaterias
	
	@Test
	@DisplayName("podemos consultar todos los profesores")
	def void profesoresHappyPath() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/profesores")).andReturn.response
		val profesores = responseEntity.contentAsString.fromJsonToList(Profesor)
		assertEquals(200, responseEntity.status)
		assertEquals(3, profesores.size)
		// los profesores no traen las materias
		assertEquals(0, profesores.head.materias.size)
	}

	@Test
	@DisplayName("al traer el dato de un profesor trae las materias en las que participa")
	def void profesorExistenteConMaterias() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/profesores/1")).andReturn.response
		assertEquals(200, responseEntity.status)
		val profesor = responseEntity.contentAsString.fromJson(Profesor)
		assertEquals(2, profesor.materias.size)
	}

	@Test
	@DisplayName("no podemos traer información de un profesor inexistente")
	def void profesorInexistente() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/profesores/100")).andReturn.response
		assertEquals(404, responseEntity.status)
	}

	@Test
	@DisplayName("podemos actualizar la información de un profesor")
	def void actualizarProfesor() {
		val idProfesor = 1L
		val profesor = getProfesor(idProfesor)
		val materias = repoMaterias.findByNombre("Diseño de Sistemas")
		assertEquals(1, materias.size)
		profesor.agregarMateria	(materias.head)
		val profesorBody = mapper.writeValueAsString(profesor)
		val responseEntityPut = mockMvc.perform(
			MockMvcRequestBuilders.put("/profesores/" + idProfesor).contentType("application/json").content(profesorBody)).andReturn.
			response
		assertEquals(200, responseEntityPut.status, "Error al actualizar los profesores " + responseEntityPut.errorMessage)
		val nuevoProfesor = getProfesor(idProfesor)
		val materiasDelProfesor = profesor.materias.size
		assertEquals(materiasDelProfesor, nuevoProfesor.materias.size)
	}

	def Profesor getProfesor(long idProfesor) {
		repoProfes.findById(idProfesor).map [ it ].orElseThrow [ new RuntimeException("Profesor con identificador " + idProfesor + " no existe") ]
	}
}
