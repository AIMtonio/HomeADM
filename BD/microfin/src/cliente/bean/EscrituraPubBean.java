package cliente.bean;

import general.bean.BaseBean;

public class EscrituraPubBean extends BaseBean{
	
	//Declaracion de Constantes
	public static int LONGITUD_ID = 3;
	
	private String clienteID;
	private String consecutivo;
	private String esc_Tipo;
	private String nomApoderado;
	private String RFC_Apoderado;
	private String escrituraPub;
	private String libroEscritura;
	private String volumenEsc;
	private String fechaEsc;
	private String estadoIDEsc;
	private String localidadEsc;
	private String notaria;
	private String direcNotaria;
	private String nomNotario;
	private String registroPub;
	private String folioRegPub;
	private String volumenRegPub;
	private String libroRegPub;
	private String auxiliarRegPub;
	private String fechaRegPub;
	private String localidadRegPub;
	private String estadoIDReg;
	private String estatus;
	private String observaciones;
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
	public String getEsc_Tipo() {
		return esc_Tipo;
	}
	public void setEsc_Tipo(String esc_Tipo) {
		this.esc_Tipo = esc_Tipo;
	}
	public String getNomApoderado() {
		return nomApoderado;
	}
	public void setNomApoderado(String nomApoderado) {
		this.nomApoderado = nomApoderado;
	}
	public String getRFC_Apoderado() {
		return RFC_Apoderado;
	}
	public void setRFC_Apoderado(String rFC_Apoderado) {
		RFC_Apoderado = rFC_Apoderado;
	}
	public String getEscrituraPub() {
		return escrituraPub;
	}
	public void setEscrituraPub(String escrituraPub) {
		this.escrituraPub = escrituraPub;
	}
	public String getLibroEscritura() {
		return libroEscritura;
	}
	public void setLibroEscritura(String libroEscritura) {
		this.libroEscritura = libroEscritura;
	}
	public String getVolumenEsc() {
		return volumenEsc;
	}
	public void setVolumenEsc(String volumenEsc) {
		this.volumenEsc = volumenEsc;
	}
	public String getFechaEsc() {
		return fechaEsc;
	}
	public void setFechaEsc(String fechaEsc) {
		this.fechaEsc = fechaEsc;
	}
	public String getEstadoIDEsc() {
		return estadoIDEsc;
	}
	public void setEstadoIDEsc(String estadoIDEsc) {
		this.estadoIDEsc = estadoIDEsc;
	}
	public String getLocalidadEsc() {
		return localidadEsc;
	}
	public void setLocalidadEsc(String localidadEsc) {
		this.localidadEsc = localidadEsc;
	}
	public String getNotaria() {
		return notaria;
	}
	public void setNotaria(String notaria) {
		this.notaria = notaria;
	}
	public String getDirecNotaria() {
		return direcNotaria;
	}
	public void setDirecNotaria(String direcNotaria) {
		this.direcNotaria = direcNotaria;
	}
	public String getNomNotario() {
		return nomNotario;
	}
	public void setNomNotario(String nomNotario) {
		this.nomNotario = nomNotario;
	}
	public String getRegistroPub() {
		return registroPub;
	}
	public void setRegistroPub(String registroPub) {
		this.registroPub = registroPub;
	}
	public String getFolioRegPub() {
		return folioRegPub;
	}
	public void setFolioRegPub(String folioRegPub) {
		this.folioRegPub = folioRegPub;
	}
	public String getVolumenRegPub() {
		return volumenRegPub;
	}
	public void setVolumenRegPub(String volumenRegPub) {
		this.volumenRegPub = volumenRegPub;
	}
	public String getLibroRegPub() {
		return libroRegPub;
	}
	public void setLibroRegPub(String libroRegPub) {
		this.libroRegPub = libroRegPub;
	}
	public String getAuxiliarRegPub() {
		return auxiliarRegPub;
	}
	public void setAuxiliarRegPub(String auxiliarRegPub) {
		this.auxiliarRegPub = auxiliarRegPub;
	}
	public String getFechaRegPub() {
		return fechaRegPub;
	}
	public void setFechaRegPub(String fechaRegPub) {
		this.fechaRegPub = fechaRegPub;
	}
	public String getLocalidadRegPub() {
		return localidadRegPub;
	}
	public void setLocalidadRegPub(String localidadRegPub) {
		this.localidadRegPub = localidadRegPub;
	}
	public String getEstadoIDReg() {
		return estadoIDReg;
	}
	public void setEstadoIDReg(String estadoIDReg) {
		this.estadoIDReg = estadoIDReg;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	
	
	
	
}
