package sms.bean;

import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class SMSEnvioMensajeBean extends BaseBean{

	private MultipartFile file;
	private String envioID;
	private String estatus;
	private String remitente;
	private String receptor;
	private String fechaRealEnvio;
	private String msjenviar;
	private String colMensaje;
	private String fechaProgEnvio;
	private String codExitoError;
	private String campaniaID;
	private String codigoRespuesta;
	private String fechaRespuesta;
	private String cuentaAsociada;
	private String clienteID;
	private String datosCliente;
	private String sistemaID;

	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	// de ayuda para generar mensajes masivos
	private String msjgenerado;
	private String encontrado;	// auxiliar que verifica no hay coicidencias entre el celular y la BD
	private String enviar;		// Enviar correos si se encontraron coincidencias
	
	private String cuentaAhoID;
	private String cantidadMov;
	
	public MultipartFile getFile() {
		return file;
	}
	public void setFile(MultipartFile file) {
		this.file = file;
	}
	public String getEnvioID() {
		return envioID;
	}
	public void setEnvioID(String envioID) {
		this.envioID = envioID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getRemitente() {
		return remitente;
	}
	public void setRemitente(String remitente) {
		this.remitente = remitente;
	}
	public String getReceptor() {
		return receptor;
	}
	public void setReceptor(String receptor) {
		this.receptor = receptor;
	}
	public String getFechaRealEnvio() {
		return fechaRealEnvio;
	}
	public void setFechaRealEnvio(String fechaRealEnvio) {
		this.fechaRealEnvio = fechaRealEnvio;
	}
	public String getMsjenviar() {
		return msjenviar;
	}
	public void setMsjenviar(String msjenviar) {
		this.msjenviar = msjenviar;
	}
	public String getColMensaje() {
		return colMensaje;
	}
	public void setColMensaje(String colMensaje) {
		this.colMensaje = colMensaje;
	}
	public String getFechaProgEnvio() {
		return fechaProgEnvio;
	}
	public void setFechaProgEnvio(String fechaProgEnvio) {
		this.fechaProgEnvio = fechaProgEnvio;
	}
	public String getCodExitoError() {
		return codExitoError;
	}
	public void setCodExitoError(String codExitoError) {
		this.codExitoError = codExitoError;
	}
	public String getCampaniaID() {
		return campaniaID;
	}
	public void setCampaniaID(String campaniaID) {
		this.campaniaID = campaniaID;
	}
	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}
	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}
	public String getFechaRespuesta() {
		return fechaRespuesta;
	}
	public void setFechaRespuesta(String fechaRespuesta) {
		this.fechaRespuesta = fechaRespuesta;
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
	
	public String getMsjgenerado() {
		return msjgenerado;
	}
	public void setMsjgenerado(String msjgenerado) {
		this.msjgenerado = msjgenerado;
	}
	public String getEncontrado() {
		return encontrado;
	}
	public void setEncontrado(String encontrado) {
		this.encontrado = encontrado;
	}
	public String getEnviar() {
		return enviar;
	}
	public void setEnviar(String enviar) {
		this.enviar = enviar;
	}
	public String getCuentaAsociada() {
		return cuentaAsociada;
	}
	public void setCuentaAsociada(String cuentaAsociada) {
		this.cuentaAsociada = cuentaAsociada;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getDatosCliente() {
		return datosCliente;
	}
	public void setDatosCliente(String datosCliente) {
		this.datosCliente = datosCliente;
	}
	public String getSistemaID() {
		return sistemaID;
	}
	public void setSistemaID(String sistemaID) {
		this.sistemaID = sistemaID;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getCantidadMov() {
		return cantidadMov;
	}
	public void setCantidadMov(String cantidadMov) {
		this.cantidadMov = cantidadMov;
	}
}
