package ar.edu.librex.ui

import ar.edu.librex.domain.Libro

interface Callbacks {
	
	def void onItemSelected(Libro libro)
	
}