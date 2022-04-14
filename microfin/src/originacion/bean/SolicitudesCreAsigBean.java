
package originacion.bean;

import java.util.List;

import general.bean.BaseBean;
public class SolicitudesCreAsigBean {
	private String solicitudAsignaID;
	private String solicitudCreditoID;
	private String usuarioID;
	private String tipoAsignacionID;
	private String productoID;
	private String listaAsignacionSol;

	
	private String nombreCompletoC;
	private String estatusSolicitud;
	private String montoAutorizadoSolicitud;
	private String fechaRegistroSolicitud;
	private String nombreAnalista;
	private String descripcionProducto;
	private String clienteID;
	
	// Reporte pantalla asignacion de solicitudes analistas
	private String fechaInicio;
	private String fechaFin;
	private String fechaSistema;
	private String horaEmision;
	private String tipoReporte;
	private String nombreInstitucion;
	private String nombreUsuario;

	
	private String prospectoID;
	private String creditoID;
	private String nombreEstado;
	private String nombreConvenio;
	private String montoSolicitado;
	private String finalidad;
	private String plazoID;
	private String montoMaximo;
	private String fechaLiberada;
	private String horaLiberada;
	private String fechaAutoriza;
	private String motivoDevolucion;
	private String nombreSucursal;
	private String analistaID;

	
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getTipoAsignacionID() {
		return tipoAsignacionID;
	}
	public void setTipoAsignacionID(String tipoAsignacionID) {
		this.tipoAsignacionID = tipoAsignacionID;
	}

	public String getProductoID() {
		return productoID;
	}
	public void setProductoID(String productoID) {
		this.productoID = productoID;
	}
	public String getSolicitudAsignaID() {
		return solicitudAsignaID;
	}
	public void setSolicitudAsignaID(String solicitudAsignaID) {
		this.solicitudAsignaID = solicitudAsignaID;
	}
	public String getNombreCompletoC() {
		return nombreCompletoC;
	}
	public void setNombreCompletoC(String nombreCompletoC) {
		this.nombreCompletoC = nombreCompletoC;
	}
	public String getEstatusSolicitud() {
		return estatusSolicitud;
	}
	public void setEstatusSolicitud(String estatusSolicitud) {
		this.estatusSolicitud = estatusSolicitud;
	}
	public String getMontoAutorizadoSolicitud() {
		return montoAutorizadoSolicitud;
	}
	public void setMontoAutorizadoSolicitud(String montoAutorizadoSolicitud) {
		this.montoAutorizadoSolicitud = montoAutorizadoSolicitud;
	}
	public String getFechaRegistroSolicitud() {
		return fechaRegistroSolicitud;
	}
	public void setFechaRegistroSolicitud(String fechaRegistroSolicitud) {
		this.fechaRegistroSolicitud = fechaRegistroSolicitud;
	}
	public String getNombreAnalista() {
		return nombreAnalista;
	}
	public void setNombreAnalista(String nombreAnalista) {
		this.nombreAnalista = nombreAnalista;
	}
	public String getListaAsignacionSol() {
		return listaAsignacionSol;
	}
	public void setListaAsignacionSol(String listaAsignacionSol) {
		this.listaAsignacionSol = listaAsignacionSol;
	}
	public String getDescripcionProducto() {
		return descripcionProducto;
	}
	public void setDescripcionProducto(String descripcionProducto) {
		this.descripcionProducto = descripcionProducto;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}
	public String getTipoReporte() {
		return tipoReporte;
	}
	public void setTipoReporte(String tipoReporte) {
		this.tipoReporte = tipoReporte;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getNombreEstado() {
		return nombreEstado;
	}
	public void setNombreEstado(String nombreEstado) {
		this.nombreEstado = nombreEstado;
	}
	public String getNombreConvenio() {
		return nombreConvenio;
	}
	public void setNombreConvenio(String nombreConvenio) {
		this.nombreConvenio = nombreConvenio;
	}
	public String getMontoSolicitado() {
		return montoSolicitado;
	}
	public void setMontoSolicitado(String montoSolicitado) {
		this.montoSolicitado = montoSolicitado;
	}
	public String getFinalidad() {
		return finalidad;
	}
	public void setFinalidad(String finalidad) {
		this.finalidad = finalidad;
	}
	public String getPlazoID() {
		return plazoID;
	}
	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
	}
	public String getMontoMaximo() {
		return montoMaximo;
	}
	public void setMontoMaximo(String montoMaximo) {
		this.montoMaximo = montoMaximo;
	}
	public String getFechaLiberada() {
		return fechaLiberada;
	}
	public void setFechaLiberada(String fechaLiberada) {
		this.fechaLiberada = fechaLiberada;
	}
	public String getHoraLiberada() {
		return horaLiberada;
	}
	public void setHoraLiberada(String horaLiberada) {
		this.horaLiberada = horaLiberada;
	}
	public String getFechaAutoriza() {
		return fechaAutoriza;
	}
	public void setFechaAutoriza(String fechaAutoriza) {
		this.fechaAutoriza = fechaAutoriza;
	}
	public String getMotivoDevolucion() {
		return motivoDevolucion;
	}
	public void setMotivoDevolucion(String motivoDevolucion) {
		this.motivoDevolucion = motivoDevolucion;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getAnalistaID() {
		return analistaID;
	}
	public void setAnalistaID(String analistaID) {
		this.analistaID = analistaID;
	}

	

}
