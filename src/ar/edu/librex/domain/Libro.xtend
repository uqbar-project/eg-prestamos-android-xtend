package ar.edu.librex.domain

import java.io.Serializable
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors class Libro implements Serializable {
	
	Long id
	String titulo
	String autor
	boolean prestado
	
	new() {
		initialize()
	}
	
	new(String pTitulo, String pAutor) {
		initialize()
		titulo = pTitulo
		autor = pAutor
	}
	
	def initialize() {
		prestado = false	
	}
	
	override String toString() {
		titulo + " (" + autor + ")"
	}
	
	def prestar() {
		prestado = true
	}

	def devolver() {
		prestado = false
	}
	
	def estaPrestado() {
		prestado
	}

	def estaDisponible() {
		!prestado
	}
	
}