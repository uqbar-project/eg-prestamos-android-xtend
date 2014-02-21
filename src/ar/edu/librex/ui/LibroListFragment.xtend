package ar.edu.librex.ui

import android.R
import android.app.Activity
import android.os.Bundle
import android.support.v4.app.ListFragment
import android.util.Log
import android.view.View
import android.widget.ArrayAdapter
import android.widget.ListView
import ar.edu.librex.domain.Libro
import java.util.List

import static extension ar.edu.librex.config.LibrexConfig.*

/**
 * A list fragment representing a list of Libros. This fragment also supports
 * tablet devices by allowing list items to be given an 'activated' state upon
 * selection. This helps indicate which item is currently being viewed in a
 * {@link LibroDetailFragment}.
 * <p>
 * Activities containing this fragment MUST implement the {@link Callbacks}
 * interface.
 */
class LibroListFragment extends ListFragment {

	/**
	 * The serialization (saved instance state) Bundle key representing the
	 * activated item position. Only used on tablets.
	 */
	private static final String STATE_ACTIVATED_POSITION = "activated_position"

	/**
	 * The fragment's current callback object, which is notified of list item
	 * clicks.
	 */
	private Callbacks mCallbacks = sDummyCallbacks

	/**
	 * The current activated item position. Only used on tablets.
	 */
	private int mActivatedPosition = ListView.INVALID_POSITION

	/**
	 * A dummy implementation of the {@link Callbacks} interface that does
	 * nothing. Used only when this fragment is not attached to an activity.
	 */
	private static val sDummyCallbacks = [ String param | ] as Callbacks 

	List<Long> idLibros
	
	override def onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState)
		refrescarLibros()
	}

	override def onResume() {
		super.onResume()
		// adapterLibros.notifyDataSetChanged()
		refrescarLibros()
	}

	/** Método nuevo que creamos para compartir en el onCreate y en el onResume */
	def void refrescarLibros() {
		val libros = activity.homeLibros.libros
		// colección paralela que guarda los ids
		idLibros = libros.map [ libro | libro.id ]
		listAdapter = new ArrayAdapter<Libro>(activity, R.layout.simple_list_item_activated_1, R.id.text1, libros)
	}
	
	override def onViewCreated(View view, Bundle savedInstanceState) {
		super.onViewCreated(view, savedInstanceState)

		// Restore the previously serialized activated item position.
		if (savedInstanceState != null && savedInstanceState.containsKey(STATE_ACTIVATED_POSITION)) {
			setActivatedPosition(savedInstanceState.getInt(STATE_ACTIVATED_POSITION))
		}
	}

	override def onAttach(Activity activity) {
		super.onAttach(activity)
		Log.w("Librex", "onAttach de LibroListFragment")
	
		// Activities containing this fragment must implement its callbacks.
		if(!(activity instanceof Callbacks)) {
			throw new IllegalStateException("Activity must implement fragment's callbacks.")
		}
		
		mCallbacks = activity as Callbacks
	}

	override def onDetach() {
		super.onDetach()

		// Reset the active callbacks interface to the dummy implementation.
		mCallbacks = sDummyCallbacks
	}

	override def onListItemClick(ListView listView, View view, int position, long id) {
		super.onListItemClick(listView, view, position, id)
	
		// Notify the active callbacks interface (the activity, if the
		// fragment is attached to one) that an item has been selected.
		val idLibro = idLibros.get(position)
		Log.w("Librex", "el id:" + id + " y el selectedItem: " + idLibro)
		mCallbacks.onItemSelected("" + idLibro)
	}

	override def onSaveInstanceState(Bundle outState) {
		super.onSaveInstanceState(outState)
		if(mActivatedPosition != ListView.INVALID_POSITION) {
			// Serialize and persist the activated item position.
			outState.putInt(STATE_ACTIVATED_POSITION, mActivatedPosition)
		}
	}

	/**
	 * Turns on activate-on-click mode. When this mode is on, list items will be
	 * given the 'activated' state when touched.
	 */
	def void setActivateOnItemClick(boolean activateOnItemClick) {
		// When setting CHOICE_MODE_SINGLE, ListView will automatically
		// give items the 'activated' state when touched.
		if (activateOnItemClick) {
			listView.choiceMode = ListView.CHOICE_MODE_SINGLE
		} else {
			listView.choiceMode = ListView.CHOICE_MODE_NONE
		}
	}

	def private void setActivatedPosition(int position) {
		if(position == ListView.INVALID_POSITION) {
			listView.setItemChecked(mActivatedPosition, false)
		} else {
			listView.setItemChecked(position, true)
		}
		mActivatedPosition = position
	}

}