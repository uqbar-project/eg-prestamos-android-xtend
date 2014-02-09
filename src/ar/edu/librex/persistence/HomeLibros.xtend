package ar.edu.librex.persistence

import ar.edu.librex.domain.Libro
import java.util.List

interface HomeLibros {

	def void addLibro(Libro Libro) 
	def List<Libro> getLibros()
	def Libro getLibro(Libro LibroOrigen)
	def Libro getLibro(int posicion)
	def void removeLibro(Libro libro)
	def void eliminarLibros()
	
}