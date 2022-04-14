package tarjetas.bean;

import general.bean.BaseBean;

public class TarDebAclaraBean extends BaseBean{
	//Declaracion de Constantes
	
	private String tipoReporte;
	private String reporteID;
	private String estatus;
	private String tarjetaDebID;
	private String tipoTarjetaID;
	private String institucionID;
	private String operacionID;
	private String tienda;
	private String cajeroID;
	private String montoOperacion;
	private String fechaOperacion;
	private String transaccionID;
	private String detalleReporte;
	private String tipoTarjeta;
	private String clienteID;
	private String nombre;
	private String numCuenta;
	private String tipoCuenta;
	private String corporativoID;
	private String nombreCorp;
	private String nombreInstitucion;	
	private String noAutorizacion;
	//Auxiliares
	private String folioID;
	private String tipoArchivo;
	private String fechaRegistro;
	private String diasAclaracion;
	//Para las Transacciones realizadas con la TD
	private String movimientoID;
	private String numeroTransaccion;
	private String descMovimiento;
	private String montoOpe;
	private String fecha;
	private String claveID;
	private String descripcion;
	private String estatusResult;
	private String detalleResolucion;
	private String usuarioID;
	private String nombreCompleto;
	private String clavePuestoID;
	private String descripcionPuesto;
	private String fechaEmision;
	private String nombreUsuario;
	private String lineaCredito;
	private String nombreProducto;
	private String productoID;
	
	
	public String getTipoReporte() {
		return tipoReporte;
	}
	public void setTipoReporte(String tipoReporte) {
		this.tipoReporte = tipoReporte;
	}
	public String getReporteID() {
		return reporteID;
	}
	public void setReporteID(String reporteID) {
		this.reporteID = reporteID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getTarjetaDebID() {
		return tarjetaDebID;
	}
	public void setTarjetaDebID(String tarjetaDebID) {
		this.tarjetaDebID = tarjetaDebID;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getOperacionID() {
		return operacionID;
	}
	public void setOperacionID(String operacionID) {
		this.operacionID = operacionID;
	}
	public String getTienda() {
		return tienda;
	}
	public void setTienda(String tienda) {
		this.tienda = tienda;
	}
	public String getCajeroID() {
		return cajeroID;
	}
	public void setCajeroID(String cajeroID) {
		this.cajeroID = cajeroID;
	}
	public String getMontoOperacion() {
		return montoOperacion;
	}
	public void setMontoOperacion(String montoOperacion) {
		this.montoOperacion = montoOperacion;
	}
	public String getFechaOperacion() {
		return fechaOperacion;
	}
	public void setFechaOperacion(String fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}
	public String getTransaccionID() {
		return transaccionID;
	}
	public void setTransaccionID(String transaccionID) {
		this.transaccionID = transaccionID;
	}
	public String getDetalleReporte() {
		return detalleReporte;
	}
	public void setDetalleReporte(String detalleReporte) {
		this.detalleReporte = detalleReporte;
	}
	public String getTipoTarjeta() {
		return tipoTarjeta;
	}
	public void setTipoTarjeta(String tipoTarjeta) {
		this.tipoTarjeta = tipoTarjeta;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getNumCuenta() {
		return numCuenta;
	}
	public void setNumCuenta(String numCuenta) {
		this.numCuenta = numCuenta;
	}
	public String getTipoCuenta() {
		return tipoCuenta;
	}
	public void setTipoCuenta(String tipoCuenta) {
		this.tipoCuenta = tipoCuenta;
	}
	public String getCorporativoID() {
		return corporativoID;
	}
	public void setCorporativoID(String corporativoID) {
		this.corporativoID = corporativoID;
	}
	public String getNombreCorp() {
		return nombreCorp;
	}
	public void setNombreCorp(String nombreCorp) {
		this.nombreCorp = nombreCorp;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getFolioID() {
		return folioID;
	}
	public void setFolioID(String folioID) {
		this.folioID = folioID;
	}
	public String getTipoArchivo() {
		return tipoArchivo;
	}
	public void setTipoArchivo(String tipoArchivo) {
		this.tipoArchivo = tipoArchivo;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getMovimientoID() {
		return movimientoID;
	}
	public void setMovimientoID(String movimientoID) {
		this.movimientoID = movimientoID;
	}
	public String getNumeroTransaccion() {
		return numeroTransaccion;
	}
	public void setNumeroTransaccion(String numeroTransaccion) {
		this.numeroTransaccion = numeroTransaccion;
	}
	public String getDescMovimiento() {
		return descMovimiento;
	}
	public void setDescMovimiento(String descMovimiento) {
		this.descMovimiento = descMovimiento;
	}
	public String getMontoOpe() {
		return montoOpe;
	}
	public void setMontoOpe(String montoOpe) {
		this.montoOpe = montoOpe;
	}
	public String getDiasAclaracion() {
		return diasAclaracion;
	}
	public void setDiasAclaracion(String diasAclaracion) {
		this.diasAclaracion = diasAclaracion;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getClaveID() {
		return claveID;
	}
	public void setClaveID(String claveID) {
		this.claveID = claveID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getEstatusResult() {
		return estatusResult;
	}
	public void setEstatusResult(String estatusResult) {
		this.estatusResult = estatusResult;
	}
	public String getDetalleResolucion() {
		return detalleResolucion;
	}
	public void setDetalleResolucion(String detalleResolucion) {
		this.detalleResolucion = detalleResolucion;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getClavePuestoID() {
		return clavePuestoID;
	}
	public void setClavePuestoID(String clavePuestoID) {
		this.clavePuestoID = clavePuestoID;
	}
	public String getDescripcionPuesto() {
		return descripcionPuesto;
	}
	public void setDescripcionPuesto(String descripcionPuesto) {
		this.descripcionPuesto = descripcionPuesto;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getTipoTarjetaID() {
		return tipoTarjetaID;
	}
	public void setTipoTarjetaID(String tipoTarjetaID) {
		this.tipoTarjetaID = tipoTarjetaID;
	}
	public String getNoAutorizacion() {
		return noAutorizacion;
	}
	public void setNoAutorizacion(String noAutorizacion) {
		this.noAutorizacion = noAutorizacion;
	}
	public String getLineaCredito() {
		return lineaCredito;
	}
	public void setLineaCredito(String lineaCredito) {
		this.lineaCredito = lineaCredito;
	}
	public String getNombreProducto() {
		return nombreProducto;
	}
	public void setNombreProducto(String nombreProducto) {
		this.nombreProducto = nombreProducto;
	}
	public String getProductoID() {
		return productoID;
	}
	public void setProductoID(String productoID) {
		this.productoID = productoID;
	}
}