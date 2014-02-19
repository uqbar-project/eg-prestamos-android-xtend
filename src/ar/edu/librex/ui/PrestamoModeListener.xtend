package ar.edu.librex.ui

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.view.ActionMode
import android.view.Menu
import android.view.MenuItem
import android.widget.AbsListView.MultiChoiceModeListener
import android.widget.ListView
import ar.edu.librex.persistence.MemoryBasedHomePrestamos
import android.util.Log

class PrestamoModeListener implements MultiChoiceModeListener {

	//static final int PICK_CONTACT=1

	Activity activity
	int posicionPrestamoSeleccionado
	
	new(Activity mainActivity) {
		activity = mainActivity
	}
	
	override onItemCheckedStateChanged(ActionMode mode, int position, long id, boolean checked) {
		posicionPrestamoSeleccionado = position
	}

	override onActionItemClicked(ActionMode mode, MenuItem item) {
//		val intent = new Intent(Intent.ACTION_PICK, ContactsContract.Contacts.CONTENT_URI)
//		activity.startActivity(intent)
		val callIntent = new Intent(Intent.ACTION_CALL)
		val prestamo = MemoryBasedHomePrestamos.instance.prestamosPendientes.get(posicionPrestamoSeleccionado)
		val phone = prestamo.telefono          
        callIntent.setData(Uri.parse("tel:"+phone))          
        activity.startActivity(callIntent)  
		false
	}

	override onCreateActionMode(ActionMode mode, Menu menu) {
		val inflater = mode.menuInflater
		inflater.inflate(R.menu.prestamo_menu, menu)
		true
	}

	override onDestroyActionMode(ActionMode arg0) {
	}

	override onPrepareActionMode(ActionMode arg0, Menu arg1) {
		false
	}

}
