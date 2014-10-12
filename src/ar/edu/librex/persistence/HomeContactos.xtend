package ar.edu.librex.persistence

import ar.edu.librex.domain.Contacto
import java.util.List

interface HomeContactos {

	def void addContactoSiNoExiste(Contacto contacto)
	def void addContacto(Contacto contacto) 
	def List<Contacto> getContactos()
	def Contacto getContacto(Contacto contactoOrigen)
	def void eliminarContactos()

} 
