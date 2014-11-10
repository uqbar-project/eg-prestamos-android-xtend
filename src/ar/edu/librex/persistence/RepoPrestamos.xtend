package ar.edu.librex.persistence

import ar.edu.librex.domain.Prestamo
import java.util.List

interface RepoPrestamos {
	
	def List<Prestamo> getPrestamosPendientes()
	def Prestamo getPrestamo(Long id)
	def void addPrestamo(Prestamo prestamo)
	def void removePrestamo(Prestamo prestamo)
	
}