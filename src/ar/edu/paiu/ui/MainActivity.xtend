package ar.edu.paiu.ui

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import android.view.Menu
import android.view.MenuItem
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.ListView
import android.widget.TextView
import ar.edu.librex.domain.Contacto
import ar.edu.librex.domain.Libro
import ar.edu.librex.domain.Prestamo
import ar.edu.librex.persistence.HomeContactos
import ar.edu.librex.persistence.MemoryBasedHomePrestamos
import ar.edu.librex.persistence.PhoneBasedContactos
import java.util.List

import static extension ar.edu.librex.util.ImageUtil.*
import ar.edu.librex.persistence.MemoryBasedHomeLibros

class MainActivity extends Activity {

	override def onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState)
		initialize()
		setContentView(R.layout.activity_main)
		this.llenarPrestamosPendientes()
	}

	/**
	 * inicializamos la información de la aplicación
	 */
	def initialize() {
		val HomeContactos homeContactos = new PhoneBasedContactos(this)
		homeContactos.addContactoSiNoExiste(
			new Contacto("1", "46425829", "Paula Elffman", "disenia_dora@gmail.com", this.convertToImage("kiarush.png")))
		homeContactos.addContactoSiNoExiste(
			new Contacto("2", "45387743", "Sven Effinge", "capoxtend@yahoo.com.ar", this.convertToImage("andrew.png")))
		homeContactos.addContactoSiNoExiste(
			new Contacto("3", "47067261", "Andres Fermepin", "fermepincho@gmail.com", this.convertToImage("agus.png")))
		homeContactos.addContactoSiNoExiste(
			new Contacto("4", "46050144", "Scarlett Johansson", "rubiadiviiiina@hotmail.com",
				this.convertToImage("scarlett.png")))

		val elAleph = new Libro("El Aleph", "J.L. Borges")
		val laNovelaDePeron = new Libro("La novela de Perón", "T.E. Martínez")
		val cartasMarcadas = new Libro("Cartas marcadas", "A. Dolina")
		MemoryBasedHomeLibros.instance.addLibro(elAleph)
		MemoryBasedHomeLibros.instance.addLibro(laNovelaDePeron)
		MemoryBasedHomeLibros.instance.addLibro(cartasMarcadas)
		MemoryBasedHomeLibros.instance.addLibro(new Libro("Rayuela", "J. Cortázar"))
		MemoryBasedHomeLibros.instance.addLibro(new Libro("No habrá más penas ni olvido", "O. Soriano"))
		
		val ferme = new Contacto(null, "47067261", null, null, null)
		val paulita = new Contacto(null, null, "Paula Elffman", null, null)
		MemoryBasedHomePrestamos.instance.addPrestamo(
			new Prestamo(1, homeContactos.getContacto(ferme), elAleph))
		MemoryBasedHomePrestamos.instance.addPrestamo(
			new Prestamo(2, homeContactos.getContacto(ferme), laNovelaDePeron))
		MemoryBasedHomePrestamos.instance.addPrestamo(
			new Prestamo(3, homeContactos.getContacto(paulita), cartasMarcadas))
	}

	override def onCreateOptionsMenu(Menu menu) {
		menuInflater.inflate(R.menu.main, menu)
		true
	}

	override def onOptionsItemSelected(MenuItem item) {
		switch (item.itemId) {
			case R.id.action_books: navigate(typeof(LibroListActivity))
		}
		true
	}

	def void navigate(Class classActivity) {
		val intent = new Intent(this, classActivity)
		intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
      	startActivity(intent)
	}

	def llenarPrestamosPendientes() {
		// Primera versión, listview con una sola columna
		// val lv = findViewById(R.id.lvPrestamos) as ListView
		// val arrayAdapter = new ArrayAdapter<Prestamo> (this, android.R.layout.simple_list_item_1, MemoryBasedHomePrestamos.instance.prestamosPendientes)
		// lv.adapter = arrayAdapter
		// Segunda versión, dos columnas
		val lv = findViewById(R.id.lvPrestamos) as ListView
		val prestamoAdapter = new PrestamoAdapter(this, MemoryBasedHomePrestamos.instance.prestamosPendientes)
		lv.adapter = prestamoAdapter
	}

}

class PrestamoAdapter extends BaseAdapter {

	Context context
	List<Prestamo> prestamos

	new() {
	}

	new(Context pContext, List<Prestamo> pPrestamos) {
		context = pContext
		prestamos = pPrestamos
	}

	override getCount() {
		prestamos.size
	}

	override getItem(int position) {
		prestamos.get(position)
	}

	override getItemId(int position) {
		position
	}

	override getView(int position, View convertView, ViewGroup parent) {
		val Prestamo prestamo = getItem(position) as Prestamo
		val inflater = context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
		val row = inflater.inflate(R.layout.prestamo_row, parent, false) as View
		val lblLibro = row.findViewById(R.id.txtLibro) as TextView
		val lblPrestamo = row.findViewById(R.id.txtPrestamo) as TextView
		lblLibro.text = prestamo.libro.toString
		lblPrestamo.text = prestamo.datosPrestamo
		row
	}

}
