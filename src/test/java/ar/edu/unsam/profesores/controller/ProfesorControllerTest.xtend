package ar.edu.unsam.profesores.controller

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

	@Test
	@DisplayName("podemos consultar todos los profesores")
	def void profesoresHappyPath() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/profesores")).andReturn.response
		val profesores = responseEntity.contentAsString.fromJsonToList(Profesor)
		assertEquals(200, responseEntity.status)
		assertEquals(3, profesores.size)
	}

	@Test
	@DisplayName("al traer el dato de un profesor trae las materias en las que participa")
	def void profesorExistenteConMaterias() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/profesores/1")).andReturn.response
		assertEquals(200, responseEntity.status)
	}

	@Test
	@DisplayName("no podemos traer información de un profesor inexistente")
	def void profesorInexistente() {
		val responseEntity = mockMvc.perform(MockMvcRequestBuilders.get("/profesores/100")).andReturn.response
		assertEquals(404, responseEntity.status)
	}

}
