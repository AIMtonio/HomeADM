package cobranza.bean;

import general.bean.BaseBean;

public class RepBitacoraSegCobBean extends BaseBean{
	//filtros busqueda
	private String fechaIniReg;
	private String fechaFinReg;
	private String usuarioReg;
	private String accionID;
	private String fechaIniProm;

	private String respuestaID;
	private String fechaFinProm;
	private String limiteReglones;
	
	//campos reporte
	private String fechaRegistro;
	private String usuarioID;
	private String nombreSucursal;
	private String creditoID;	
	private String clienteID;
	
	private String descAccion;
	private String descRespuesta;
	private String comentarios;
	private String etapaCobranza;
	private String fechaEntregaDoc;
	
	private String fechaPromPago;
	private String montoPromPago;
	private String comentariosProm;
	private String fechaSis;
	private String claveUsuario;

	private String nombreInstitucion;
	private String nombreCliente;
	private String desUsuRec;
	
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public String getComentarios() {
		return comentarios;
	}
	public String getEtapaCobranza() {
		return etapaCobranza;
	}
	public String getFechaEntregaDoc() {
		return fechaEntregaDoc;
	}
	public String getFechaPromPago() {
		return fechaPromPago;
	}
	public String getMontoPromPago() {
		return montoPromPago;
	}
	public String getComentariosProm() {
		return comentariosProm;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
	}
	public void setEtapaCobranza(String etapaCobranza) {
		this.etapaCobranza = etapaCobranza;
	}
	public void setFechaEntregaDoc(String fechaEntregaDoc) {
		this.fechaEntregaDoc = fechaEntregaDoc;
	}
	public void setFechaPromPago(String fechaPromPago) {
		this.fechaPromPago = fechaPromPago;
	}
	public void setMontoPromPago(String montoPromPago) {
		this.montoPromPago = montoPromPago;
	}
	public void setComentariosProm(String comentariosProm) {
		this.comentariosProm = comentariosProm;
	}
	public String getUsuarioReg() {
		return usuarioReg;
	}
	public String getAccionID() {
		return accionID;
	}
	public String getFechaIniProm() {
		return fechaIniProm;
	}
	public String getRespuestaID() {
		return respuestaID;
	}
	public String getFechaFinProm() {
		return fechaFinProm;
	}
	public String getLimiteReglones() {
		return limiteReglones;
	}
	public String getDescAccion() {
		return descAccion;
	}
	public String getDescRespuesta() {
		return descRespuesta;
	}
	public String getFechaSis() {
		return fechaSis;
	}
	public String getClaveUsuario() {
		return claveUsuario;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setUsuarioReg(String usuarioReg) {
		this.usuarioReg = usuarioReg;
	}
	public void setAccionID(String accionID) {
		this.accionID = accionID;
	}
	public void setFechaIniProm(String fechaIniProm) {
		this.fechaIniProm = fechaIniProm;
	}
	public void setRespuestaID(String respuestaID) {
		this.respuestaID = respuestaID;
	}
	public void setFechaFinProm(String fechaFinProm) {
		this.fechaFinProm = fechaFinProm;
	}
	public void setLimiteReglones(String limiteReglones) {
		this.limiteReglones = limiteReglones;
	}
	public void setDescAccion(String descAccion) {
		this.descAccion = descAccion;
	}
	public void setDescRespuesta(String descRespuesta) {
		this.descRespuesta = descRespuesta;
	}
	public void setFechaSis(String fechaSis) {
		this.fechaSis = fechaSis;
	}
	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getFechaIniReg() {
		return fechaIniReg;
	}
	public String getFechaFinReg() {
		return fechaFinReg;
	}
	public void setFechaIniReg(String fechaIniReg) {
		this.fechaIniReg = fechaIniReg;
	}
	public void setFechaFinReg(String fechaFinReg) {
		this.fechaFinReg = fechaFinReg;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getDesUsuRec() {
		return desUsuRec;
	}
	public void setDesUsuRec(String desUsuRec) {
		this.desUsuRec = desUsuRec;
	}
}
