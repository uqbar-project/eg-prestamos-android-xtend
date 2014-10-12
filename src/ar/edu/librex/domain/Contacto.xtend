package ar.edu.librex.domain

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Contacto {

	String id
	String nombre
	String numero
	String email  
	byte[] foto
	
	new() {
		
	}	
	
	new(String pId) {
		id = pId
	}
	
	new(String pId, String pNumero, String pNombre, String pEMail, byte[] pFoto) {
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