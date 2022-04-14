package pld.bean;

import general.bean.BaseBean;

public class OpIntPreocupantesBean extends BaseBean{
	
	private String 	fecha;
	private String	opeInterPreoID;
	private String	claveRegistra;
	private String	nombreReg;
	private String	catProcedIntID;
	private String	catMotivPreoID;
	private String	fechaDeteccion;
	private String	categoriaID;
	private String	sucursalID;
	private String	clavePersonaInv;
	private String	nomPersonaInv;
	private String	cteInvolucrado;
	private String	frecuencia;
	private String	desFrecuencia;
	private String	desOperacion;
	private String	estatus;
	private String	comentarioOC;
	private String	fechaCierre;
	private String origenDatos;
	private String periodoInicio;
	private String periodoFin;
	
	//---- auxiliares para generar el reporte a la CNVB
	private String nombreArchivo;
	private String rutaArchivosPLD;
	
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getOpeInterPreoID() {
		return opeInterPreoID;
	}
	public void setOpeInterPreoID(String opeInterPreoID) {
		this.opeInterPreoID = opeInterPreoID;
	}
	public String getClaveRegistra() {
		return claveRegistra;
	}
	public void setClaveRegistra(String claveRegistra) {
		this.claveRegistra = claveRegistra;
	}
	public String getNombreReg() {
		return nombreReg;
	}
	public void setNombreReg(String nombreReg) {
		this.nombreReg = nombreReg;
	}
	public String getCatProcedIntID() {
		return catProcedIntID;
	}
	public void setCatProcedIntID(String catProcedIntID) {
		this.catProcedIntID = catProcedIntID;
	}
	public String getCatMotivPreoID() {
		return catMotivPreoID;
	}
	public void setCatMotivPreoID(String catMotivPreoID) {
		this.catMotivPreoID = catMotivPreoID;
	}
	public String getFechaDeteccion() {
		return fechaDeteccion;
	}
	public void setFechaDeteccion(String fechaDeteccion) {
		this.fechaDeteccion = fechaDeteccion;
	}
	public String getCategoriaID() {
		return categoriaID;
	}
	public void setCategoriaID(String categoriaID) {
		this.categoriaID = categoriaID;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getClavePersonaInv() {
		return clavePersonaInv;
	}
	public void setClavePersonaInv(String clavePersonaInv) {
		this.clavePersonaInv = clavePersonaInv;
	}
	public String getNomPersonaInv() {
		return nomPersonaInv;
	}
	public void setNomPersonaInv(String nomPersonaInv) {
		this.nomPersonaInv = nomPersonaInv;
	}
	public String getCteInvolucrado() {
		return cteInvolucrado;
	}
	public void setCteInvolucrado(String cteInvolucrado) {
		this.cteInvolucrado = cteInvolucrado;
	}
	public String getFrecuencia() {
		return frecuencia;
	}
	public void setFrecuencia(String frecuencia) {
		this.frecuencia = frecuencia;
	}
	public String getDesFrecuencia() {
		return desFrecuencia;
	}
	public void setDesFrecuencia(String desFrecuencia) {
		this.desFrecuencia = desFrecuencia;
	}
	public String getDesOperacion() {
		return desOperacion;
	}
	public void setDesOperacion(String desOperacion) {
		this.desOperacion = desOperacion;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getComentarioOC() {
		return comentarioOC;
	}
	public void setComentarioOC(String comentarioOC) {
		this.comentarioOC = comentarioOC;
	}
	public String getFechaCierre() {
		return fechaCierre;
	}
	public void setFechaCierre(String fechaCierre) {
		this.fechaCierre = fechaCierre;
	}
	public String getNombreArchivo() {
		return nombreArchivo;
	}
	public void setNombreArchivo(String nombreArchivo) {
		this.nombreArchivo = nombreArchivo;
	}
	public String getRutaArchivosPLD() {
		return rutaArchivosPLD;
	}
	public void setRutaArchivosPLD(String rutaArchivosPLD) {
		this.rutaArchivosPLD = rutaArchivosPLD;
	}
	public String getOrigenDatos() {
		return origenDatos;
	}
	public void setOrigenDatos(String origenDatos) {
		this.origenDatos = origenDatos;
	}
	public String getPeriodoInicio() {
		return periodoInicio;
	}
	public void setPeriodoInicio(String periodoInicio) {
		this.periodoInicio = periodoInicio;
	}
	public String getPeriodoFin() {
		return periodoFin;
	}
	public void setPeriodoFin(String periodoFin) {
		this.periodoFin = periodoFin;
	}	
	
}
