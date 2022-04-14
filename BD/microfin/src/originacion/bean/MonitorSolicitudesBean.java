package originacion.bean;

import java.util.List;

public class MonitorSolicitudesBean {
	private String fechaInicio;
	private String fechaFin;
	private String sucursalID;
	private String productoCreditoID;	
	private String promotorID;
	private String estatus;
	private String tipoEstatus;
	private String totalEstatus;
	private String solicitudCreditoID;
	private String creditoID;	
	private String clienteID;
	private String nombreCliente;
	private String idPromotor;
	private String nombrePromotor;
	private String usuarioID;
	private String nombreUsuario;
	private String totalEstUsuario;
	private String comentarioSol;
	private String fechaComentario;
	private String estatusValor;
	private String claveUsuario;
	private String tipoCanalIng;
	private String totalCanalIng;
	private String valorSolventar;
	private String comentario;
	private List lsolicitud;
	private List lcredito;	
	private List lcomentario;
	private List lvalorSolventar;
	private String numError;	
	private String numTransaccion;
	
	private String claveAnalista;
	private String descripcionRegreso;
	private String estatusSolicitud;
	private String nombreSucursal;
	private String descripcionProducto;
	private String montoOtorgado;
	private String motivoRechazoID;
	private String tipoAsignacionID;
	private String detalleEstatus;
	
	public String getNumError() {
		return numError;
	}
	public void setNumError(String numError) {
		this.numError = numError;
	}
	public String getComentario() {
		return comentario;
	}
	public List getLsolicitud() {
		return lsolicitud;
	}
	public void setLsolicitud(List lsolicitud) {
		this.lsolicitud = lsolicitud;
	}
	public List getLcomentario() {
		return lcomentario;
	}
	public void setLcomentario(List lcomentario) {
		this.lcomentario = lcomentario;
	}
	public List getLvalorSolventar() {
		return lvalorSolventar;
	}
	public void setLvalorSolventar(List lvalorSolventar) {
		this.lvalorSolventar = lvalorSolventar;
	}
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}		
	public String getValorSolventar() {
		return valorSolventar;
	}
	public void setValorSolventar(String valorSolventar) {
		this.valorSolventar = valorSolventar;
	}
	public String getTipoCanalIng() {
		return tipoCanalIng;
	}
	public void setTipoCanalIng(String tipoCanalIng) {
		this.tipoCanalIng = tipoCanalIng;
	}
	public String getTotalCanalIng() {
		return totalCanalIng;
	}
	public void setTotalCanalIng(String totalCanalIng) {
		this.totalCanalIng = totalCanalIng;
	}
	public String getClaveUsuario() {
		return claveUsuario;
	}
	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}
	public String getEstatusValor() {
		return estatusValor;
	}
	public void setEstatusValor(String estatusValor) {
		this.estatusValor = estatusValor;
	}
	public String getComentarioSol() {
		return comentarioSol;
	}
	public void setComentarioSol(String comentarioSol) {
		this.comentarioSol = comentarioSol;
	}
	public String getFechaComentario() {
		return fechaComentario;
	}
	public void setFechaComentario(String fechaComentario) {
		this.fechaComentario = fechaComentario;
	}
	public String getTotalEstUsuario() {
		return totalEstUsuario;
	}
	public void setTotalEstUsuario(String totalEstUsuario) {
		this.totalEstUsuario = totalEstUsuario;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
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
	public String getIdPromotor() {
		return idPromotor;
	}
	public void setIdPromotor(String idPromotor) {
		this.idPromotor = idPromotor;
	}
	public String getNombrePromotor() {
		return nombrePromotor;
	}
	public void setNombrePromotor(String nombrePromotor) {
		this.nombrePromotor = nombrePromotor;
	}
	
	public String getTipoEstatus() {
		return tipoEstatus;
	}
	public void setTipoEstatus(String tipoEstatus) {
		this.tipoEstatus = tipoEstatus;
	}
	public String getTotalEstatus() {
		return totalEstatus;
	}
	public void setTotalEstatus(String totalEstatus) {
		this.totalEstatus = totalEstatus;
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
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getPromotorID() {
		return promotorID;
	}
	public void setPromotorID(String promotorID) {
		this.promotorID = promotorID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	
	public List getLcredito() {
		return lcredito;
	}
	public void setLcredito(List lcredito) {
		this.lcredito = lcredito;
	}
	public String getClaveAnalista() {
		return claveAnalista;
	}
	public void setClaveAnalista(String claveAnalista) {
		this.claveAnalista = claveAnalista;
	}
	public String getDescripcionRegreso() {
		return descripcionRegreso;
	}
	public void setDescripcionRegreso(String descripcionRegreso) {
		this.descripcionRegreso = descripcionRegreso;
	}
	public String getEstatusSolicitud() {
		return estatusSolicitud;
	}
	public void setEstatusSolicitud(String estatusSolicitud) {
		this.estatusSolicitud = estatusSolicitud;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getDescripcionProducto() {
		return descripcionProducto;
	}
	public void setDescripcionProducto(String descripcionProducto) {
		this.descripcionProducto = descripcionProducto;
	}
	public String getMontoOtorgado() {
		return montoOtorgado;
	}
	public void setMontoOtorgado(String montoOtorgado) {
		this.montoOtorgado = montoOtorgado;
	}
	public String getMotivoRechazoID() {
		return motivoRechazoID;
	}
	public void setMotivoRechazoID(String motivoRechazoID) {
		this.motivoRechazoID = motivoRechazoID;
	}
	public String getTipoAsignacionID() {
		return tipoAsignacionID;
	}
	public void setTipoAsignacionID(String tipoAsignacionID) {
		this.tipoAsignacionID = tipoAsignacionID;
	}
	public String getDetalleEstatus() {
		return detalleEstatus;
	}
	public void setDetalleEstatus(String detalleEstatus) {
		this.detalleEstatus = detalleEstatus;
	}

	
	

	
 
}
