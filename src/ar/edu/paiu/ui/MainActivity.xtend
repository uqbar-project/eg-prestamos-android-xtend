package ar.edu.paiu.ui

import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.Menu
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
import java.util.List

class MainActivity extends Activity {

	override def onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState)

		val homeContactos = new HomeContactos(this)
		homeContactos.addContactoSiNoExiste(new Contacto("1", "46425829", "Paula Elffman", "disenia_dora@gmail.com", "kiarush.png"))
		homeContactos.addContactoSiNoExiste(new Contacto("2", "45387743", "Sven Effinge", "capoxtend@yahoo.com.ar", "andrew.png"))
		homeContactos.addContactoSiNoExiste(new Contacto("3", "47067261", "Andres Fermepin", "fermepincho@gmail.com", "agus.png"))
		homeContactos.addContactoSiNoExiste(new Contacto("4", "46050144", "Scarlett Johansson", "rubiadiviiiina@hotmail.com", "scarlett.png"))
		
		//val ferme = new Contacto(null, null, "Andres Fermepin", null)
		val ferme = new Contacto(null, "47067261", null, null, null)
		val paulita = new Contacto(null, null, "Paula Elffman", null, null)
		//val paulita = new Contacto(null, "46425829", null, null, null)
		MemoryBasedHomePrestamos.instance.addPrestamo(new Prestamo(1, homeContactos.getContacto(ferme), new Libro("El Aleph", "J.L. Borges")))
		MemoryBasedHomePrestamos.instance.addPrestamo(new Prestamo(2, homeContactos.getContacto(ferme), new Libro("La novela de Perón", "T.E. Martínez")))
		MemoryBasedHomePrestamos
		.instance.addPrestamo(new Prestamo(3, homeContactos.getContacto(paulita), new Libro("Cartas marcadas", "A. Dolina")))
		
		setContentView(R.layout.activity_main)
		this.llenarPrestamosPendientes()
	}
	
	override def onCreateOptionsMenu(Menu menu) {
		menuInflater.inflate(R.menu.main, menu)
		true
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