package ar.edu.librex.domain

class Contacto {

	String id
	
	new() {
		
	}	
	
	new(String pId) {
		id = pId
	}
	
	override toString() {
		"Señor " + id
	}
	
}