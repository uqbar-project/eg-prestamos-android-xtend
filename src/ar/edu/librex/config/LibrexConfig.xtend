package ar.edu.librex.config

import android.app.Activity
import ar.edu.librex.persistence.MemoryBasedHomeLibros
import ar.edu.librex.persistence.MemoryBasedHomePrestamos

class LibrexConfig {
	
	def static getHomeLibros(Activity activity) {
		//new SQLiteHomeLibros(activity)
		MemoryBasedHomeLibros.instance
	}
	
	def static getHomePrestamos(Activity activity) {
		MemoryBasedHomePrestamos.instance
	}
}