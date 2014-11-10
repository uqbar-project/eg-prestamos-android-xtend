package ar.edu.librex.persistence

import ar.edu.librex.domain.Prestamo
import java.util.ArrayList
import java.util.List

class MemoryBasedHomePrestamos implements RepoPrestamos {

	/**
	 * ******************************************************************************
	 *   IMPLEMENTACION DEL SINGLETON 
	 * ****************************************************************************** 
	 */
	static RepoPrestamos instance
	
	static def getInstance() {
		if (instance == null) {
			instance = new MemoryBasedHomePrestamos
		}
		instance
	}
	
	List<Prestamo> prestamos
	
	private new() {
		prestamos = new ArrayList<Prestamo>
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