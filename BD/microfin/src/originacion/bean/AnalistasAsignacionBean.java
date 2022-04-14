package originacion.bean;

import java.util.List;

import general.bean.BaseBean;



public class AnalistasAsignacionBean {
	
	
	private String hisAnalistasAsigID;
	private String clave;
	private String nombreCompleto;
	private String detalleAsignacion;
	private String detalleAnalistas;

	
	private String analistasAsigID;
	private String usuarioID;
	private String tipoAsignacionID;
	private String descripcion;
	private String productoID;
	private String fechaAsignacion;
	
	//datos de auditoria
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;

	//datos reporte Productividad Analista
	private String fechaInicio;
	private String fechaFin;
	private String fechaSistema;
	private String horaEmision;
	private String tipoReporte;
	private String nombreInstitucion;
	
	private String nombre;
	private String asignadas;
	private String enRevision;
	private String total;
	private String devoluciones;
	private String canceladas;
	private String autorizadas;
	private String pendGlobal;
	private String rechazadas;
	private String autGlobal;
	private String pendIndv;
	private String terminadas;

	private String totalAsignadas;
	private String totalEnRevision;
	private String totalDevueltas;
	private String totalCanceladas;
	private String totalRechazadas;
	private String totalAutorizadas;
	private String totalPorcPendGlobal;
	private String totalAutoriGlobal;

	
	
	
	public String getHisAnalistasAsigID() {
		return hisAnalistasAsigID;
	}
	public void setHisAnalistasAsigID(String hisAnalistasAsigID) {
		this.hisAnalistasAsigID = hisAnalistasAsigID;
	}
	public String getAnalistasAsigID() {
		return analistasAsigID;
	}
	public void setAnalistasAsigID(String analistasAsigID) {
		this.analistasAsigID = analistasAsigID;
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
	public String getFechaAsignacion() {
		return fechaAsignacion;
	}
	public void setFechaAsignacion(String fechaAsignacion) {
		this.fechaAsignacion = fechaAsignacion;
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
	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getDetalleAsignacion() {
		return detalleAsignacion;
	}
	public void setDetalleAsignacion(String detalleAsignacion) {
		this.detalleAsignacion = detalleAsignacion;
	}
	public String getDetalleAnalistas() {
		return detalleAnalistas;
	}
	public void setDetalleAnalistas(String detalleAnalistas) {
		this.detalleAnalistas = detalleAnalistas;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getAsignadas() {
		return asignadas;
	}
	public void setAsignadas(String asignadas) {
		this.asignadas = asignadas;
	}
	public String getEnRevision() {
		return enRevision;
	}
	public void setEnRevision(String enRevision) {
		this.enRevision = enRevision;
	}
	public String getTotal() {
		return total;
	}
	public void setTotal(String total) {
		this.total = total;
	}
	public String getDevoluciones() {
		return devoluciones;
	}
	public void setDevoluciones(String devoluciones) {
		this.devoluciones = devoluciones;
	}
	public String getCanceladas() {
		return canceladas;
	}
	public void setCanceladas(String canceladas) {
		this.canceladas = canceladas;
	}
	public String getAutorizadas() {
		return autorizadas;
	}
	public void setAutorizadas(String autorizadas) {
		this.autorizadas = autorizadas;
	}
	public String getPendGlobal() {
		return pendGlobal;
	}
	public void setPendGlobal(String pendGlobal) {
		this.pendGlobal = pendGlobal;
	}
	public String getRechazadas() {
		return rechazadas;
	}
	public void setRechazadas(String rechazadas) {
		this.rechazadas = rechazadas;
	}
	public String getAutGlobal() {
		return autGlobal;
	}
	public void setAutGlobal(String autGlobal) {
		this.autGlobal = autGlobal;
	}
	public String getPendIndv() {
		return pendIndv;
	}
	public void setPendIndv(String pendIndv) {
		this.pendIndv = pendIndv;
	}
	public String getTerminadas() {
		return terminadas;
	}
	public void setTerminadas(String terminadas) {
		this.terminadas = terminadas;
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
	public String getTotalAsignadas() {
		return totalAsignadas;
	}
	public void setTotalAsignadas(String totalAsignadas) {
		this.totalAsignadas = totalAsignadas;
	}
	public String getTotalEnRevision() {
		return totalEnRevision;
	}
	public void setTotalEnRevision(String totalEnRevision) {
		this.totalEnRevision = totalEnRevision;
	}
	public String getTotalDevueltas() {
		return totalDevueltas;
	}
	public void setTotalDevueltas(String totalDevueltas) {
		this.totalDevueltas = totalDevueltas;
	}
	public String getTotalCanceladas() {
		return totalCanceladas;
	}
	public void setTotalCanceladas(String totalCanceladas) {
		this.totalCanceladas = totalCanceladas;
	}
	public String getTotalRechazadas() {
		return totalRechazadas;
	}
	public void setTotalRechazadas(String totalRechazadas) {
		this.totalRechazadas = totalRechazadas;
	}
	public String getTotalAutorizadas() {
		return totalAutorizadas;
	}
	public void setTotalAutorizadas(String totalAutorizadas) {
		this.totalAutorizadas = totalAutorizadas;
	}
	public String getTotalPorcPendGlobal() {
		return totalPorcPendGlobal;
	}
	public void setTotalPorcPendGlobal(String totalPorcPendGlobal) {
		this.totalPorcPendGlobal = totalPorcPendGlobal;
	}
	public String getTotalAutoriGlobal() {
		return totalAutoriGlobal;
	}
	public void setTotalAutoriGlobal(String totalAutoriGlobal) {
		this.totalAutoriGlobal = totalAutoriGlobal;
	}
	
	
	
}
