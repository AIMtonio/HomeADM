package tesoreria.bean;

import java.util.List;
 
public class PresupuestoSucursalBean {
	
 private	String folio;
 private 	String usuario;
 private	String nombreUsuario;
 private	String sucursal;
 private	String fecha;
 private	String estatusPre;
 private	String estatusPet;
 private	String descripcionPet;
 private	String conceptoPet;
 private  	String montoPet;
 private	String mesPresupuesto;
 private	String anioPresupuesto;
 private	String eliminados;
 private	String montoDispon;
 private	String nombreSucursal;
 private 	String observaciones;
		
 private 	List folioID;
 private	List concepto;
 private	List descripcion;
 private	List estatus;
 private	List monto;
 private	List lobservaciones;

 // Parametros de reporte 
 private String mesInicio;
 private String anioInicio;
 private String mesFin;
 private String anioFin;
 
 private String nombreEstatus;
 private String nombreInstitucion;
 private String nombreMesFin;
 private String nombreMesIni;
 private String parFechaEmision;
 private String nomEstatusMov;

 
	
	
	public String getNomEstatusMov() {
		return nomEstatusMov;
	}

	public void setNomEstatusMov(String nomEstatusMov) {
		this.nomEstatusMov = nomEstatusMov;
	}

	public String getNombreEstatus() {
		return nombreEstatus;
	}

	public void setNombreEstatus(String nombreEstatus) {
		this.nombreEstatus = nombreEstatus;
	}

	public String getNombreInstitucion() {
		return nombreInstitucion;
	}

	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}

	public String getNombreMesFin() {
		return nombreMesFin;
	}

	public void setNombreMesFin(String nombreMesFin) {
		this.nombreMesFin = nombreMesFin;
	}

	public String getNombreMesIni() {
		return nombreMesIni;
	}

	public void setNombreMesIni(String nombreMesIni) {
		this.nombreMesIni = nombreMesIni;
	}

	public String getParFechaEmision() {
		return parFechaEmision;
	}

	public void setParFechaEmision(String parFechaEmision) {
		this.parFechaEmision = parFechaEmision;
	}

	public String getMesInicio() {
		return mesInicio;
	}

	public void setMesInicio(String mesInicio) {
		this.mesInicio = mesInicio;
	}

	public String getAnioInicio() {
		return anioInicio;
	}

	public void setAnioInicio(String anioInicio) {
		this.anioInicio = anioInicio;
	}

	public String getMesFin() {
		return mesFin;
	}

	public void setMesFin(String mesFin) {
		this.mesFin = mesFin;
	}

	public String getAnioFin() {
		return anioFin;
	}

	public void setAnioFin(String anioFin) {
		this.anioFin = anioFin;
	}

	public String getNombreSucursal() {
		return nombreSucursal;
	}
	
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	
	public String getMontoDispon() {
		return montoDispon;
	}
	public void setMontoDispon(String montoDispon) {
		this.montoDispon = montoDispon;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getEliminados() {
		return eliminados;
	}
	public void setEliminados(String eliminados) {
		this.eliminados = eliminados;
	}
	public String getMesPresupuesto() {
		return mesPresupuesto;
	}
	public void setMesPresupuesto(String mesPresupuesto) {
		this.mesPresupuesto = mesPresupuesto;
	}
	public String getAnioPresupuesto() {
		return anioPresupuesto;
	}
	public void setAnioPresupuesto(String anioPresupuesto) {
		this.anioPresupuesto = anioPresupuesto;
	}
	public String getEstatusPre() {
		return estatusPre;
	}
	public void setEstatusPre(String estatusPre) {
		this.estatusPre = estatusPre;
	}
	public List getFolioID() {
		return folioID;
	}
	public void setFolioID(List folioID) {
		this.folioID = folioID;
	}
	public String getFolio() {
		return folio;
	}
	public void setFolio(String folio) {
		this.folio = folio;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public List getConcepto() {
		return concepto;
	}
	public void setConcepto(List concepto) {
		this.concepto = concepto;
	}
	public List getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(List descripcion) {
		this.descripcion = descripcion;
	}
	public List getEstatus() {
		return estatus;
	}
	public void setEstatus(List estatus) {
		this.estatus = estatus;
	}
	public List getMonto() {
		return monto;
	}
	public void setMonto(List monto) {
		this.monto = monto;
	}
	public String getEstatusPet() {
		return estatusPet;
	}
	public void setEstatusPet(String estatusPet) {
		this.estatusPet = estatusPet;
	}
	public String getDescripcionPet() {
		return descripcionPet;
	}
	public void setDescripcionPet(String descripcionPet) {
		this.descripcionPet = descripcionPet;
	}
	public String getConceptoPet() {
		return conceptoPet;
	}
	public void setConceptoPet(String conceptoPet) {
		this.conceptoPet = conceptoPet;
	}
	public String getMontoPet() {
		return montoPet;
	}
	public void setMontoPet(String montoPet) {
		this.montoPet = montoPet;
	}

	public List getLobservaciones() {
		return lobservaciones;
	}

	public void setLobservaciones(List lobservaciones) {
		this.lobservaciones = lobservaciones;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	
	

}
