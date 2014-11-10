package ar.edu.librex.config

import android.app.Activity
import ar.edu.librex.persistence.SQLiteHomeLibros
import ar.edu.librex.persistence.SQLiteHomePrestamos
import ar.edu.librex.persistence.PhoneBasedRepoContactos

class LibrexConfig {
	
	def static getHomeLibros(Activity activity) {
		// PERSISTENTE
		new SQLiteHomeLibros(activity)
		// NO PERSISTENTE
		// MemoryBasedHomeLibros.instance
	}
	
	def static getHomePrestamos(Activity activity) {
		// PERSISTENTE
		new SQLiteHomePrestamos(activity)
		// NO PERSISTENTE
		// MemoryBasedHomePrestamos.instance
	}
	
	def static getHomeContactos(Activity activity) {
		new PhoneBasedRepoContactos(activity)
	}
	
}