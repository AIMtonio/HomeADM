package cliente.bean;

import java.util.List;

import general.bean.BaseBean;

public class ConceptosCalifBean extends BaseBean{
	
	/*ATRIBUTOS DE LA TABLA */
	private String conceptoCalifID;
	private String concepto;
	private String descripcion;
	private String puntos;

	
	/*PARAMETROS DE AUDITORIA */
	private String empresaID;
	private String usuario;
	private String fechaActual;  
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	private List lConceptoCalifID;
	private List lConcepto;
	private List lDescripcion;
	private List lPuntos;

	
	/*============= GET's && SET's ===============*/

	
	public String getConceptoCalifID() {
		return conceptoCalifID;
	}
	public String getConcepto() {
		return concepto;
	}
	public String getDescripcion() {
		return descripcion;
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
	public List getlConceptoCalifID() {
		return lConceptoCalifID;
	}
	public void setConceptoCalifID(String conceptoCalifID) {
		this.conceptoCalifID = conceptoCalifID;
	}
	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
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
	public void setlConceptoCalifID(List lConceptoCalifID) {
		this.lConceptoCalifID = lConceptoCalifID;
	}
	public List getlConcepto() {
		return lConcepto;
	}
	public List getlDescripcion() {
		return lDescripcion;
	}
	public List getlPuntos() {
		return lPuntos;
	}
	public void setlConcepto(List lConcepto) {
		this.lConcepto = lConcepto;
	}
	public void setlDescripcion(List lDescripcion) {
		this.lDescripcion = lDescripcion;
	}
	public void setlPuntos(List lPuntos) {
		this.lPuntos = lPuntos;
	}
	

	
}
