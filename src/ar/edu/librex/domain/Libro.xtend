package ar.edu.librex.domain

class Libro {
	
	@Property Long id
	@Property String titulo
	@Property String autor
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