package ar.edu.librex.ui

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.view.ActionMode
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.widget.AdapterView
import android.widget.AdapterView.OnItemLongClickListener
import android.widget.ListView
import ar.edu.librex.domain.Contacto
import ar.edu.librex.domain.Libro
import ar.edu.librex.domain.Prestamo
import ar.edu.librex.persistence.HomeLibros
import java.net.URLEncoder

import static extension ar.edu.librex.config.LibrexConfig.*
import static extension ar.edu.librex.util.ImageUtil.*
import ar.edu.librex.persistence.RepoContactos
import ar.edu.librex.persistence.PhoneBasedRepoContactos

class MainActivity extends Activity implements ActionMode.Callback {

	// nuevo
	ActionMode mActionMode

	// fin nuevo
	override def onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState)
		initialize()
		setContentView(R.layout.activity_main)
		this.llenarPrestamosPendientes()
	}

	override def onResume() {
		super.onResume()
		this.llenarPrestamosPendientes()
	}

	/**
	 * inicializamos la información de la aplicación
	 */
	def initialize() {
		val RepoContactos homeContactos = new PhoneBasedRepoContactos(this)
		homeContactos.addContactoSiNoExiste(
			new Contacto("1", "46425829", "Paula Elffman", "disenia_dora@gmail.com", this.convertToImage("kiarush.png")))
		homeContactos.addContactoSiNoExiste(
			new Contacto("2", "45387743", "Sven Effinge", "capoxtend@yahoo.com.ar", this.convertToImage("andrew.png")))
		homeContactos.addContactoSiNoExiste(
			new Contacto("3", "47067261", "Andres Fermepin", "fermepincho@gmail.com", this.convertToImage("agus.png")))
		homeContactos.addContactoSiNoExiste(
			new Contacto("4", "46050144", "Scarlett Johansson", "rubiadiviiiina@hotmail.com",
				this.convertToImage("scarlett.png")))

		var elAleph = new Libro("El Aleph", "J.L. Borges")
		elAleph.prestar()
		var laNovelaDePeron = new Libro("La novela de Perón", "T.E. Martínez")
		laNovelaDePeron.prestar() 
		var cartasMarcadas = new Libro("Cartas marcadas", "A. Dolina")
		cartasMarcadas.prestar()

		val HomeLibros homeDeLibros = this.homeLibros

		// Cuando necesitemos generar una lista nueva de libros
		// homeDeLibros.eliminarLibros()
		elAleph = homeDeLibros.addLibroSiNoExiste(elAleph)
		laNovelaDePeron = homeDeLibros.addLibroSiNoExiste(laNovelaDePeron)
		cartasMarcadas = homeDeLibros.addLibroSiNoExiste(cartasMarcadas)
		homeDeLibros.addLibroSiNoExiste(new Libro("Rayuela", "J. Cortázar"))
		homeDeLibros.addLibroSiNoExiste(new Libro("No habrá más penas ni olvido", "O. Soriano"))
		homeDeLibros.addLibroSiNoExiste(new Libro("No habrá más penas ni olvido", "O. Soriano"))
		homeDeLibros.addLibroSiNoExiste(new Libro("Cuentos de los años felices", "O. Soriano"))
		homeDeLibros.addLibroSiNoExiste(new Libro("Una sombra ya pronto serás", "O. Soriano"))
		homeDeLibros.addLibroSiNoExiste(new Libro("Octaedro", "J. Cortázar"))
		homeDeLibros.addLibroSiNoExiste(new Libro("Ficciones", "J.L. Borges"))

		val ferme = new Contacto(null, "47067261", null, null, null)
		val paulita = new Contacto(null, null, "Paula Elffman", null, null)

		val homePrestamos = this.homePrestamos
		if (homePrestamos.prestamosPendientes.isEmpty) {
			Log.w("Librex", "Creando préstamos")
			homePrestamos.addPrestamo(new Prestamo(1, homeContactos.getContacto(ferme), elAleph))
			homePrestamos.addPrestamo(new Prestamo(2, homeContactos.getContacto(ferme), laNovelaDePeron))
			homePrestamos.addPrestamo(new Prestamo(3, homeContactos.getContacto(paulita), cartasMarcadas))
		} 
	}

	override def onCreateOptionsMenu(Menu menu) {
		menuInflater.inflate(R.menu.main, menu)
		true
	}

	override def onOptionsItemSelected(MenuItem item) {
		switch (item.itemId) {
			case R.id.action_books: navigate(typeof(LibroListActivity))
			case R.id.action_nuevo_prestamo: navigate(typeof(NuevoPrestamo))
		}
		true
	}

	def void navigate(Class<?> classActivity) {
		val intent = new Intent(this, classActivity)
		intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
		startActivity(intent)
	}

	def llenarPrestamosPendientes() {
		val lvPrestamos = findViewById(R.id.lvPrestamos) as ListView
		val prestamoAdapter = new PrestamoAdapter(this, homePrestamos.prestamosPendientes)
		lvPrestamos.adapter = prestamoAdapter
		lvPrestamos.choiceMode = ListView.CHOICE_MODE_SINGLE

		// lv.multiChoiceModeListener = new PrestamoModeListener(this)
		lvPrestamos.longClickable = true
		lvPrestamos.onItemLongClickListener = [ AdapterView<?> parent, View view, int position, long id |
			if (mActionMode != null) {
				return false
			}
			mActionMode = this.startActionMode(this)
			mActionMode.tag = position
			view.selected = true
			true
		] as OnItemLongClickListener
		registerForContextMenu(lvPrestamos)
	}

	override def onCreateActionMode(ActionMode mode, Menu menu) {
		mode.menuInflater.inflate(R.menu.prestamo_menu, menu)
		true
	}

	override def onActionItemClicked(ActionMode mode, MenuItem item) {
		val posicion = Integer.parseInt(mActionMode.tag.toString)
		val prestamo = homePrestamos.prestamosPendientes.get(posicion)
		switch (item.itemId) {
			case R.id.action_call_contact: llamar(prestamo.telefono)
			case R.id.action_email_contact: enviarMail(prestamo)
			default: return false
		}
		false
	}

	def boolean llamar(String telefono) {
		val callIntent = new Intent(Intent.ACTION_CALL)
		callIntent.setData(Uri.parse("tel:" + telefono))
		try {
			Log.w("Voy a llamar", "CHAU")
			startActivity(callIntent)
		} catch (Exception e) {
			Log.e("ERROR PUTO", e.message)
		}
		true
	}

	def boolean enviarMail(Prestamo prestamo) {
		val uriText = "mailto:" + prestamo.contactoMail + "?subject=" +
			URLEncoder.encode("Libro " + prestamo.libro.titulo) + "&body=" +
			URLEncoder.encode("Por favor te pido que me devuelvas el libro")
		val uri = Uri.parse(uriText)
		val sendIntent = new Intent(Intent.ACTION_SENDTO)
		sendIntent.setData(uri)
		startActivity(Intent.createChooser(intent, "Enviar mail"))
		true
	}

	override def onPrepareActionMode(ActionMode mode, Menu menu) {
		false
	}

	override def onDestroyActionMode(ActionMode mode) {
		mActionMode = null
	}

}
