package ar.edu.librex.ui

import android.content.Intent
import android.os.Bundle
import android.support.v4.app.FragmentActivity

/**
 * An activity representing a list of Libros. This activity has different
 * presentations for handset and tablet-size devices. On handsets, the activity
 * presents a list of items, which when touched, lead to a
 * {@link LibroDetailActivity} representing item details. On tablets, the
 * activity presents the list of items and item details side-by-side using two
 * vertical panes.
 * <p>
 * The activity makes heavy use of fragments. The list of items is a
 * {@link LibroListFragment} and the item details (if present) is a
 * {@link LibroDetailFragment}.
 * <p>
 * This activity also implements the required
 * {@link LibroListFragment.Callbacks} interface to listen for item selections.
 */
class LibroListActivity extends FragmentActivity implements Callbacks {

	/**
	 * Whether or not the activity is in two-pane mode, i.e. running on a tablet
	 * device.
	 */
	boolean mTwoPane

	override def onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState)
		setContentView(R.layout.activity_libro_list)

		if(findViewById(R.id.libro_detail_container) != null) {

			// The detail container view will be present only in the
			// large-screen layouts (res/values-large and
			// res/values-sw600dp). If this view is present, then the
			// activity should be in two-pane mode.
			mTwoPane = true

			// In two-pane mode, list items should be given the
			// 'activated' state when touched.
			(supportFragmentManager.findFragmentById(R.id.libro_list) as LibroListFragment).activateOnItemClick = true
		}

	// TODO: If exposing deep links into your app, handle intents here.
	}

	/**
	 * Callback method from {@link LibroListFragment.Callbacks} indicating that
	 * the item with the given ID was selected.
	 */
	override def onItemSelected(String id) {
		if(mTwoPane) {
			// In two-pane mode, show the detail view in this activity by
			// adding or replacing the detail fragment using a
			// fragment transaction.
			val arguments = new Bundle
			arguments.putString(LibroDetailFragment.ARG_ITEM_ID, id)
			val fragment = new LibroDetailFragment
			fragment.setArguments(arguments)
			supportFragmentManager.beginTransaction().replace(R.id.libro_detail_container, fragment).commit()
		} else {
			// In single-pane mode, simply start the detail activity
			// for the selected item ID.
			val detailIntent = new Intent(this, typeof(LibroDetailActivity))
			detailIntent.putExtra(LibroDetailFragment.ARG_ITEM_ID, id)
			startActivity(detailIntent)
		}
	}

}
