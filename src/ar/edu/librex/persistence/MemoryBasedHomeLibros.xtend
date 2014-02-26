package ar.edu.librex.persistence

import ar.edu.librex.domain.Libro
import java.util.ArrayList
import java.util.List

class MemoryBasedHomeLibros implements HomeLibros {

	/**
	 * ******************************************************************************
	 *   IMPLEMENTACION DEL SINGLETON 
	 * ****************************************************************************** 
	 */
	static HomeLibros instance
	
	static def getInstance() {
		if (instance == null) {
			instance = new MemoryBasedHomeLibros
		}
		instance
	}
	
	List<Libro> libros
	
	private new() {
		libros = new ArrayList<Libro>
	}

	override addLibroSiNoExiste(Libro libro) {
		if (this.getLibro(libro) == null) {
			this.addLibro(libro)
			libro.id = new Long(libros.size - 1)
		}	
		libro
	}
	
	override getLibro(int posicion) {
		libros.get(posicion)
	}
	
	override getLibro(Libro otroLibro) {
		libros.findFirst [ Libro libro | libro.titulo.equals(otroLibro.titulo) ]
	}
	
	override addLibro(Libro libro) {
		libros.add(libro)
	}
	
	override removeLibro(Libro libro) {
		libros.remove(libro)
	}

	override removeLibro(int posicion) {
		libros.remove(posicion)
	}

	override getLibros() {
		libros
	}	
	
	override eliminarLibros() {
		libros.clear
	}
	
	override getLibrosPrestables() {
		libros.filter [ libro | libro.estaDisponible ].toList
	}

}