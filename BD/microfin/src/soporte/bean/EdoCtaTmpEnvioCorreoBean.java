package soporte.bean;

import general.bean.BaseBean;

import java.util.List;

public class EdoCtaTmpEnvioCorreoBean extends BaseBean {
	private String anioMes;
	private String sucursalID;
	private String clienteID;
	private String nombreCliente;
	private String correo;
	private String rutaPDF;
	private String EstatusEdoCta;
	private String EstatusEnvio;
	private String FechaEnvio;
	private String usuarioEnvia;
	private String pdfGenerado;
	
	
	public String getAnioMes() {
		return anioMes;
	}
	public void setAnioMes(String anioMes) {
		this.anioMes = anioMes;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getCorreo() {
		return correo;
	}
	public void setCorreo(String correo) {
		this.correo = correo;
	}
	public String getRutaPDF() {
		return rutaPDF;
	}
	public String getEstatusEdoCta() {
		return EstatusEdoCta;
	}
	public void setEstatusEdoCta(String estatusEdoCta) {
		EstatusEdoCta = estatusEdoCta;
	}
	public String getEstatusEnvio() {
		return EstatusEnvio;
	}
	public void setEstatusEnvio(String estatusEnvio) {
		EstatusEnvio = estatusEnvio;
	}
	public String getFechaEnvio() {
		return FechaEnvio;
	}
	public void setFechaEnvio(String fechaEnvio) {
		FechaEnvio = fechaEnvio;
	}
	public void setRutaPDF(String rutaPDF) {
		this.rutaPDF = rutaPDF;
	}
	public String getUsuarioEnvia() {
		return usuarioEnvia;
	}
	public void setUsuarioEnvia(String usuarioEnvia) {
		this.usuarioEnvia = usuarioEnvia;
	}
	public String getPdfGenerado() {
		return pdfGenerado;
	}
	public void setPdfGenerado(String pdfGenerado) {
		this.pdfGenerado = pdfGenerado;
	}
	
}
