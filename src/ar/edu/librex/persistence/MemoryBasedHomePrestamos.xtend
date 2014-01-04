package ar.edu.librex.persistence

import ar.edu.librex.domain.Contacto
import ar.edu.librex.domain.Libro
import ar.edu.librex.domain.Prestamo
import java.util.ArrayList
import java.util.List

class MemoryBasedHomePrestamos implements HomePrestamos {
	
	/**
	 * ******************************************************************************
	 *   IMPLEMENTACION DEL SINGLETON 
	 * ****************************************************************************** 
	 */
	static HomePrestamos instance
	
	static def getInstance() {
		if (instance == null) {
			instance = new MemoryBasedHomePrestamos
		}
		instance
	}
	
	List<Prestamo> prestamos
	
	private new() {
		prestamos = new ArrayList<Prestamo>
		prestamos.add(new Prestamo(1, new Contacto("2"), new Libro("El Aleph", "J.L. Borges")))
		prestamos.add(new Prestamo(2, new Contacto("2"), new Libro("La novela de Perón", "T.E. Martínez")))
		prestamos.add(new Prestamo(3, new Contacto("4"), new Libro("Cartas marcadas", "A. Dolina")))
	}
	
	override getPrestamosPendientes() {
		prestamos.filter [ prestamo | prestamo.estaPendiente ].toList
	}
	
	override getPrestamo(Long id) {
		prestamos.findFirst [ prestamo | prestamo.id.equals(id) ]
	}
	
	override addPrestamo(Prestamo prestamo) {
		prestamos.add(prestamo)
	}
	
	override removePrestamo(Prestamo prestamo) {
		prestamos.remove(prestamo)
	}
	
}