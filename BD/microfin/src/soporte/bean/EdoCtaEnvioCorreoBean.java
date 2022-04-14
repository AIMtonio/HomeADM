package soporte.bean;

import general.bean.BaseBean;

import java.util.List;

public class EdoCtaEnvioCorreoBean extends BaseBean {
	private String anioMes;
	private String sucursalID;
	private String clienteID;
	private String nombreCliente;
	private String correo;
	private String rutaPDF;
	private String rutaXML;
	private String EstatusEdoCta;
	private String EstatusEnvio;
	private String FechaEnvio;
	private String usuarioEnvia;
	private String pdfGenerado;
	private List<String> listaPeriodos;
	private List<String> listaSucursales;
	private List<String> listaClientes;
	private List<String> listaPDF;
	private List<String> listaXML;
	private List<String> listaCorreos;
	
	//Transferencia de archivos
	private String rutaCompletaOrigen;
	private String rutaCompletaDestino;
	
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
	public String getRutaXML() {
		return rutaXML;
	}
	public void setRutaXML(String rutaXML) {
		this.rutaXML = rutaXML;
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
	public List<String> getListaPeriodos() {
		return listaPeriodos;
	}
	public void setListaPeriodos(List<String> listaPeriodos) {
		this.listaPeriodos = listaPeriodos;
	}
	public List<String> getListaSucursales() {
		return listaSucursales;
	}
	public void setListaSucursales(List<String> listaSucursales) {
		this.listaSucursales = listaSucursales;
	}
	public List<String> getListaClientes() {
		return listaClientes;
	}
	public void setListaClientes(List<String> listaClientes) {
		this.listaClientes = listaClientes;
	}
	public List<String> getListaPDF() {
		return listaPDF;
	}
	public void setListaPDF(List<String> listaPDF) {
		this.listaPDF = listaPDF;
	}
	public List<String> getListaXML() {
		return listaXML;
	}
	public void setListaXML(List<String> listaXML) {
		this.listaXML = listaXML;
	}
	public List<String> getListaCorreos() {
		return listaCorreos;
	}
	public void setListaCorreos(List<String> listaCorreos) {
		this.listaCorreos = listaCorreos;
	}
	
	public String getRutaCompletaOrigen() {
		return rutaCompletaOrigen;
	}

	public void setRutaCompletaOrigen(String rutaCompletaOrigen) {
		this.rutaCompletaOrigen = rutaCompletaOrigen;
	}

	public String getRutaCompletaDestino() {
		return rutaCompletaDestino;
	}

	public void setRutaCompletaDestino(String rutaCompletaDestino) {
		this.rutaCompletaDestino = rutaCompletaDestino;
	}
}
