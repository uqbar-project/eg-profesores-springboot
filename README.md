# Ejemplo Profesores y Materias

[![Build Status](https://travis-ci.com/uqbar-project/eg-profesores-springboot.svg?branch=master)](https://travis-ci.com/uqbar-project/eg-profesores-springboot)

## Prerrequisitos

- Necesitás instalar un motor de base de datos relacional (te recomendamos [MySQL](https://www.mysql.com/) que es OpenSource y gratuito)
- En MySQL: hay que crear una base de datos facultad. No hay que correr los scripts, las tablas se recrean cada vez que se levanta la aplicación.

``` sql
CREATE SCHEMA facultad;
```

- Revisá la password para conectarte a la base en el archivo [`application.yml`](./src/main/resources/application.yml):

```yml
    datasource:
        url: jdbc:mysql://localhost/facultad
        username: root
        password:   # acá podés dejarla en blanco si no tenés contraseña o escribir la tuya
```

## Objetivo

Un profesor dicta una o varias materias, y a su vez cada materia es dictada por varies profesores. La solución muestra cómo se traduce esta relación en

- el modelo de objetos, donde simplemente tenemos una colección de materias en profesor (y podríamos tener eventualmente una colección de profesores en materia)
- el modelo relacional, que requiere una entidad que relacione profesor y materia mediante claves foráneas que referencien a sus identificadores. Esto no necesita de una entidad extra en el modelo de objetos porque de esa relación no nacen atributos (aunque podrían, si quisiéramos guardar por ejemplo la fecha en la que el profesor comenzó a dar la materia)

## Endpoints comunes

- `GET ./profesores/`: devuelve la lista de profesores, sin las materias
- `GET ./profesores/{id}`: devuelve los datos de un profesor con sus materias
- `GET ./materias/`: devuelve la lista de materias
- `PUT ./profesores/{id}`: actualiza un profesor con los datos del body

## Endpoint especial

- GET | `./materias/{id}`: devuelve una materia, con sus profesores. 

Una decisión de diseño importante que tomamos fue **no tener referencias bidireccionales** (de profesor a materias y de materia a profesores). El primer motivo es didático, el segundo es que mantener esa relación bidireccional tiene un costo y debemos decidir quién es el dueño de esa relación (para no entrar en loop al agregar un profesor a una materia, además del agregado en cada una de las colecciones). Pueden consultar [este post de Stack overflow](https://stackoverflow.com/questions/22461613/pros-and-cons-of-jpa-bidirectional-relationships) para más información.


Como consecuencia de nuestra decisión de diseño, la materia no tiene la lista de profesores, pero nosotros queremos que este endpoint:

```bash
http://localhost:8080/materias/2
```

nos devuelva

```json
{
    "id": 2,
    "nombre": "Paradigmas de Programacion",
    "anio": 2,
    "profesores": [
        {
            "id": 4,
            "nombre": "Lucas Spigariol"
        },
        {
            "id": 5,
            "nombre": "Nicolás Passerini"
        }
    ]
}
```

Para ello vamos a necesitar dos pasos:

1. Aprovechar que el modelo relacional nos permite hacer un JOIN partiendo de cualquiera de las entidades (tiene una navegación más flexible que el modelo de grafo de objetos). Haremos un query en [JPQL](https://es.wikipedia.org/wiki/Java_Persistence_Query_Language) (Java Persistence Query Language), una variante de SQL que trata de acercarse más al paradigma de objetos.

```xtend
	@Query("SELECT m.id as id, m.nombre as nombre, m.anio as anio, p.id as profesorId, p.nombreCompleto as profesorNombre FROM Profesor p INNER JOIN p.materias m WHERE m.id = :id")
	def List<MateriaFullRowDTO> findFullById(Long id)
```

El resultado de esa consulta son n registros, porque es el producto cartesiano de 1 materia con n profesores.

El DTO es una interfaz, donde por convención los atributos se corresponden con el alias que le pusimos en el query:

```xtend
@Data
class MateriaDTO {
	Long id
	String nombre
	int anio
	List<ProfesorDTO> profesores
}
```

Podemos mapear el atributo de nuestro DTO con otro nombre, mediante la anotación `@Value`:

```xtend
interface MateriaFullRowDTO {
  def Long getId()
  @Value("#{target.nombre}") // el formato es "target".{atributo del query}
  def String getNombreLindo()
  ...
}
```

2. Como queremos que el endpoint devuelva una sola entidad materia, vamos a agrupar todos los profesores en una lista, y tomaremos la información de la materia una sola vez (porque sabemos que las otras filas simplemente repiten el dato):

```xtend
@GetMapping(value="/materias/{id}")
def getMateria(@PathVariable Long id) {

  // Recibimos n registros de materias
  val materiasDTO = this
    .materiaRepository
    .findFullById(id)
    
  if (materiasDTO.empty) {
    throw new ResponseStatusException(HttpStatus.NOT_FOUND, "La materia con identificador " + id + " no existe")
  }
  
  // Agrupamos los profesores de la materia
  val materia = materiasDTO.head
  val profesores = materiasDTO.map [ materiaDTO |
    new ProfesorDTO(materiaDTO.profesorId, materiaDTO.profesorNombre) 
  ]
  new MateriaDTO(materia.id, materia.nombreLindo, materia.anio, profesores)
}
```

## Material adicional

- [Artículo de Baeldung](https://www.baeldung.com/jpa-many-to-many), donde define la relación en forma bidireccional
- [Artículo de Stack Overflow](https://stackoverflow.com/questions/42394095/many-to-many-relationship-between-two-entities-in-spring-boot)

## Diagrama entidad-relación

![Solución](./images/DER.png)

