package ar.edu.librex.domain

class Libro {
	
	@Property String titulo
	@Property String autor
	
	new() {
		
	}
	
	new(String pTitulo, String pAutor) {
		titulo = pTitulo
		autor = pAutor
	}
	
	override String toString() {
		titulo + " (" + autor + ")"
	}
}