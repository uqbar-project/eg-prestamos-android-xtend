package ar.edu.librex.util

import java.text.SimpleDateFormat
import java.util.Date

class DateUtil {
	
	public static String FORMATO = "dd/MM/yyyy"
	
	def static asString(Date aDate) {
		new SimpleDateFormat(FORMATO).format(aDate)
	} 
	
	def static asDate(String aString) {
		new SimpleDateFormat(FORMATO).parse(aString)
	}
	
}