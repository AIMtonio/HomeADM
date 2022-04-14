package cliente.bean;

import java.util.List;

import general.bean.BaseBean;

public class PuntosConceptoBean extends BaseBean{

	/* Atributos   */
	private String puntosConcepID;
	private String conceptoCalifID;
	private String rangoInferior;
	private String rangoSuperior;
	private String puntos;
	
	private List lPuntosConcepID;
	private List lRangoInferior;
	private List lRangoSuperior;
	private List lPuntos;
	
	/* Atributos Auditoria */
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	
	/* ======== GETTER && SETTER ================= */	
	
	public String getPuntosConcepID() {
		return puntosConcepID;
	}
	public String getConceptoCalifID() {
		return conceptoCalifID;
	}
	public String getRangoInferior() {
		return rangoInferior;
	}
	public String getRangoSuperior() {
		return rangoSuperior;
	}
	public String getPuntos() {
		return puntos;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public String getUsuario() {
		return usuario;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public String getSucursal() {
		return sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setPuntosConcepID(String puntosConcepID) {
		this.puntosConcepID = puntosConcepID;
	}
	public void setConceptoCalifID(String conceptoCalifID) {
		this.conceptoCalifID = conceptoCalifID;
	}
	public void setRangoInferior(String rangoInferior) {
		this.rangoInferior = rangoInferior;
	}
	public void setRangoSuperior(String rangoSuperior) {
		this.rangoSuperior = rangoSuperior;
	}
	public void setPuntos(String puntos) {
		this.puntos = puntos;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public List getlPuntosConcepID() {
		return lPuntosConcepID;
	}
	public List getlRangoInferior() {
		return lRangoInferior;
	}
	public List getlRangoSuperior() {
		return lRangoSuperior;
	}
	public List getlPuntos() {
		return lPuntos;
	}
	public void setlPuntosConcepID(List lPuntosConcepID) {
		this.lPuntosConcepID = lPuntosConcepID;
	}
	public void setlRangoInferior(List lRangoInferior) {
		this.lRangoInferior = lRangoInferior;
	}
	public void setlRangoSuperior(List lRangoSuperior) {
		this.lRangoSuperior = lRangoSuperior;
	}
	public void setlPuntos(List lPuntos) {
		this.lPuntos = lPuntos;
	}

}
