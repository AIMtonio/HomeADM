package originacion.beanWS.response;

import general.bean.BaseBeanWS;

public class RegistroSolCreditoBEResponse extends BaseBeanWS{
	private String solicitudCreditoID;
	private String prospectoID;
	private String clienteID;
	private String produCredID;
	private String descripcionProducto;
	private String fechaReg;
	
	private String proyecto;
	private String montoSolic ; 
	private String plazoID;
	private String estatus;

	private String comApertura;
	private String frecuencia;
	private String periodicidad;
	private String numAmorti;
	
	private String CAT;
	private String cuentaClabe;
	private String fechaVencim;
	private String fechaInicio;
	private String cliNombreCompleto;
	private String proNombreCompleto;
	private String formaComApertura;
	
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}
	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}
	public String getMensajeRespuesta() {
		return mensajeRespuesta;
	}
	public void setMensajeRespuesta(String mensajeRespuesta) {
		this.mensajeRespuesta = mensajeRespuesta;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getProduCredID() {
		return produCredID;
	}
	public void setProduCredID(String produCredID) {
		this.produCredID = produCredID;
	}
	public String getFechaReg() {
		return fechaReg;
	}
	public void setFechaReg(String fechaReg) {
		this.fechaReg = fechaReg;
	}
	
	public String getProyecto() {
		return proyecto;
	}
	public void setProyecto(String proyecto) {
		this.proyecto = proyecto;
	}
	
	public String getMontoSolic() {
		return montoSolic;
	}
	public void setMontoSolic(String montoSolic) {
		this.montoSolic = montoSolic;
	}
	public String getPlazoID() {
		return plazoID;
	}
	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
	}
	
	public String getComApertura() {
		return comApertura;
	}
	public void setComApertura(String comApertura) {
		this.comApertura = comApertura;
	}
	public String getFrecuencia() {
		return frecuencia;
	}
	public void setFrecuencia(String frecuencia) {
		this.frecuencia = frecuencia;
	}
	public String getPeriodicidad() {
		return periodicidad;
	}
	public void setPeriodicidad(String periodicidad) {
		this.periodicidad = periodicidad;
	}
	public String getNumAmorti() {
		return numAmorti;
	}
	public void setNumAmorti(String numAmorti) {
		this.numAmorti = numAmorti;
	}
	public String getCAT() {
		return CAT;
	}
	public void setCAT(String cAT) {
		CAT = cAT;
	}
	public String getCuentaClabe() {
		return cuentaClabe;
	}
	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}
	public String getFechaVencim() {
		return fechaVencim;
	}
	public void setFechaVencim(String fechaVencim) {
		this.fechaVencim = fechaVencim;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getCliNombreCompleto() {
		return cliNombreCompleto;
	}
	public void setCliNombreCompleto(String cliNombreCompleto) {
		this.cliNombreCompleto = cliNombreCompleto;
	}
	public String getProNombreCompleto() {
		return proNombreCompleto;
	}
	public void setProNombreCompleto(String proNombreCompleto) {
		this.proNombreCompleto = proNombreCompleto;
	}
	public String getDescripcionProducto() {
		return descripcionProducto;
	}
	public void setDescripcionProducto(String descripcionProducto) {
		this.descripcionProducto = descripcionProducto;
	}
	public String getFormaComApertura() {
		return formaComApertura;
	}
	public void setFormaComApertura(String formaComApertura) {
		this.formaComApertura = formaComApertura;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	
}
