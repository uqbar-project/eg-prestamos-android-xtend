package ar.edu.librex.domain

import java.text.SimpleDateFormat
import java.util.Date
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors class Prestamo {
	
	Long id
	Date fechaPrestamo
	Date fechaDevolucion
	Contacto contacto
	Libro libro
	
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
	
	def prestar() {
		if (libro == null) {
			throw new BusinessException("Debe ingresar libro")
		}
		if (contacto == null) {
			throw new 
			BusinessException("Debe ingresar contacto")
		}
		fechaPrestamo = new Date
		libro.prestar
	}
	
}