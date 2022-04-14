
package originacion.bean;

import general.bean.BaseBean;

public class RepRiesgoComunBean extends BaseBean{
	
	// datos de la pantalla
	private String fechaInicio;
	private String fechaFin;
	private String nombreInstitucion;
	private String fechaSistema;
	private String nombreUsuario;
	private String horaEmision;
	private String usuarioID;	
	private String promotorID;
	private String nomUsuario;
	private String numeroCliente;
	private String clienteNombre;

	
	// datos del reporte
	private String fechaRegistro;
	private String NombreSucursal;
	private String solicitudCreditoID;
	private String clienteIDRel;
	private String nombreClienteRel;
	private String creditoID;
	private String clienteID;
	private String nombreCliente;
	private String montoAcumulado;
	private String parentesco;
	private String estatusRep;
	private String clave;	
	private String motivo;
	private String deteccion;	
	private String comentario;	
	private String estatus;
	private String evaluacion;
	private String procesado;
	private String riesgoComun;
	private String persRelacionada;
	private String sucursalSolCredID;
	private String sucursalSolCredNombre;
	
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
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getPromotorID() {
		return promotorID;
	}
	public void setPromotorID(String promotorID) {
		this.promotorID = promotorID;
	}
	public String getNomUsuario() {
		return nomUsuario;
	}
	public void setNomUsuario(String nomUsuario) {
		this.nomUsuario = nomUsuario;
	}
	public String getNumeroCliente() {
		return numeroCliente;
	}
	public void setNumeroCliente(String numeroCliente) {
		this.numeroCliente = numeroCliente;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
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
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getClienteIDRel() {
		return clienteIDRel;
	}
	public void setClienteIDRel(String clienteIDRel) {
		this.clienteIDRel = clienteIDRel;
	}
	public String getNombreClienteRel() {
		return nombreClienteRel;
	}
	public void setNombreClienteRel(String nombreClienteRel) {
		this.nombreClienteRel = nombreClienteRel;
	}
	public String getMotivo() {
		return motivo;
	}
	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}
	public String getComentario() {
		return comentario;
	}
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
	public String getNombreSucursal() {
		return NombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		NombreSucursal = nombreSucursal;
	}
	public String getClienteNombre() {
		return clienteNombre;
	}
	public void setClienteNombre(String clienteNombre) {
		this.clienteNombre = clienteNombre;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getEvaluacion() {
		return evaluacion;
	}
	public void setEvaluacion(String evaluacion) {
		this.evaluacion = evaluacion;
	}
	public String getMontoAcumulado() {
		return montoAcumulado;
	}
	public void setMontoAcumulado(String montoAcumulado) {
		this.montoAcumulado = montoAcumulado;
	}
	public String getParentesco() {
		return parentesco;
	}
	public void setParentesco(String parentesco) {
		this.parentesco = parentesco;
	}
	public String getEstatusRep() {
		return estatusRep;
	}
	public void setEstatusRep(String estatusRep) {
		this.estatusRep = estatusRep;
	}
	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
	}
	public String getDeteccion() {
		return deteccion;
	}
	public void setDeteccion(String deteccion) {
		this.deteccion = deteccion;
	}
	public String getProcesado() {
		return procesado;
	}
	public void setProcesado(String procesado) {
		this.procesado = procesado;
	}
	public String getRiesgoComun() {
		return riesgoComun;
	}
	public void setRiesgoComun(String riesgoComun) {
		this.riesgoComun = riesgoComun;
	}
	public String getPersRelacionada() {
		return persRelacionada;
	}
	public void setPersRelacionada(String persRelacionada) {
		this.persRelacionada = persRelacionada;
	}
	public String getSucursalSolCredID() {
		return sucursalSolCredID;
	}
	public void setSucursalSolCredID(String sucursalSolCredID) {
		this.sucursalSolCredID = sucursalSolCredID;
	}
	public String getSucursalSolCredNombre() {
		return sucursalSolCredNombre;
	}
	public void setSucursalSolCredNombre(String sucursalSolCredNombre) {
		this.sucursalSolCredNombre = sucursalSolCredNombre;
	}
}