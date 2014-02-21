package ar.edu.librex.domain

import java.text.SimpleDateFormat
import java.util.Date

class Prestamo {
	
	@Property Long id
	@Property Date fechaPrestamo
	@Property Date fechaDevolucion
	@Property Contacto contacto
	@Property Libro libro
	
	new() {
		
	}
	
	new(int pId, Contacto pContacto, Libro pLibro) {
		id = new Long(pId)
		fechaPrestamo = new Date
		contacto = pContacto
		libro = pLibro
	}
	
	def estaPendiente() {
		fechaDevolucion == null
	}

	override String toString() {
		libro.toString() + " - " + datosPrestamo
	}
	
	def getDatosPrestamo() {
		new SimpleDateFormat("dd/MM/yyyy").format(fechaPrestamo) + " a " + contacto.toString
	}
	
	def getTelefono() {
		contacto.numero
	}

	def getContactoMail() {
		contacto.email
	}	
}