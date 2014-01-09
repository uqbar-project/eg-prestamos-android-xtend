package ar.edu.librex.domain

class Contacto {

	@Property String id
	@Property String nombre
	@Property String numero
	@Property String email  
	@Property String foto
	
	new() {
		
	}	
	
	new(String pId) {
		id = pId
	}
	
	new(String pId, String pNumero, String pNombre, String pEMail, String pFoto) {
		id = pId
		numero = pNumero
		nombre = pNombre
		email = pEMail
		foto = pFoto
	}
	
	override toString() {
		nombre
	}
	
}