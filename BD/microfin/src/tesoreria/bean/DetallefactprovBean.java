package tesoreria.bean;

import general.bean.BaseBean;

public class DetallefactprovBean extends BaseBean {
	
	private String proveedorID;
	private String noFactura;
	private String noPartidaID;
	private String tipoGastoID;
	private String cantidad;
	private String precioUnitario;
	private String importe;
	private String descripcion;
	private String gravable;
	private String gravaCero;
	private String centroCostoID;
	private String fechaFactura;
	
	private String tipoProveedorID;
	private String impuestoID;
	private String descripCorta;
	private String tasa;
	private String gravaRetiene;
	private String baseCalculo;
	private String impuestoCalculo;
	private String importeImpuesto;
	
	//variables auxiliares para el prorrateo del iva y pago anticipado
	private String partidasIVA;
	private String pagoAnticipado;
	private String cenCostoManualID;
	private String prorrateaImp;
	private String tipoPagoAnt;
	private String cenCostoAntID;
	private String noEmpleadoID;
	
	private String empresaID; 
	private String usuario; 
	private String fechaActual; 
	private String direccionIP;
	private String programaID;
	private String sucursal; 
	private String numTransaccion;
	private String tipoPago;
	private String descripcionGT;
	private String estatus;
	private String noTotalImpuesto;
	private String consecutivo;
	
	
	public String getGravable() {
		return gravable;
	}
	public void setGravable(String gravable) {
		this.gravable = gravable;
	}
	public String getProveedorID() {
		return proveedorID;
	}
	public void setProveedorID(String proveedorID) {
		this.proveedorID = proveedorID;
	}
	public String getNoFactura() {
		return noFactura;
	}
	public void setNoFactura(String noFactura) {
		this.noFactura = noFactura;
	}
	public String getNoPartidaID() {
		return noPartidaID;
	}
	public void setNoPartidaID(String noPartidaID) {
		this.noPartidaID = noPartidaID;
	}
	public String getTipoGastoID() {
		return tipoGastoID;
	}
	public void setTipoGastoID(String tipoGastoID) {
		this.tipoGastoID = tipoGastoID;
	}
	public String getCantidad() {
		return cantidad;
	}
	public void setCantidad(String cantidad) {
		this.cantidad = cantidad;
	}
	public String getPrecioUnitario() {
		return precioUnitario;
	}
	public void setPrecioUnitario(String precioUnitario) {
		this.precioUnitario = precioUnitario;
	}
	public String getImporte() {
		return importe;
	}
	public void setImporte(String importe) {
		this.importe = importe;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
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
	public String getCentroCostoID() {
		return centroCostoID;
	}
	public void setCentroCostoID(String centroCostoID) {
		this.centroCostoID = centroCostoID;
	}
	public String getFechaFactura() {
		return fechaFactura;
	}
	public void setFechaFactura(String fechaFactura) {
		this.fechaFactura = fechaFactura;
	}
	public String getPagoAnticipado() {
		return pagoAnticipado;
	}
	public void setPagoAnticipado(String pagoAnticipado) {
		this.pagoAnticipado = pagoAnticipado;
	}
	public String getCenCostoManualID() {
		return cenCostoManualID;
	}
	public void setCenCostoManualID(String cenCostoManualID) {
		this.cenCostoManualID = cenCostoManualID;
	}
	public String getProrrateaImp() {
		return prorrateaImp;
	}
	public void setProrrateaImp(String prorrateaImp) {
		this.prorrateaImp = prorrateaImp;
	}
	public String getTipoPagoAnt() {
		return tipoPagoAnt;
	}
	public void setTipoPagoAnt(String tipoPagoAnt) {
		this.tipoPagoAnt = tipoPagoAnt;
	}
	public String getCenCostoAntID() {
		return cenCostoAntID;
	}
	public void setCenCostoAntID(String cenCostoAntID) {
		this.cenCostoAntID = cenCostoAntID;
	}
	public String getGravaCero() {
		return gravaCero;
	}
	public void setGravaCero(String gravaCero) {
		this.gravaCero = gravaCero;
	}
	public String getPartidasIVA() {
		return partidasIVA;
	}
	public void setPartidasIVA(String partidasIVA) {
		this.partidasIVA = partidasIVA;
	}
	public String getNoEmpleadoID() {
		return noEmpleadoID;
	}
	public void setNoEmpleadoID(String noEmpleadoID) {
		this.noEmpleadoID = noEmpleadoID;
	}
	public String getTipoPago() {
		return tipoPago;
	}
	public void setTipoPago(String tipoPago) {
		this.tipoPago = tipoPago;
	}
	public String getDescripcionGT() {
		return descripcionGT;
	}
	public void setDescripcionGT(String descripcionGT) {
		this.descripcionGT = descripcionGT;
	}
	public String getTipoProveedorID() {
		return tipoProveedorID;
	}
	public void setTipoProveedorID(String tipoProveedorID) {
		this.tipoProveedorID = tipoProveedorID;
	}
	public String getImpuestoID() {
		return impuestoID;
	}
	public void setImpuestoID(String impuestoID) {
		this.impuestoID = impuestoID;
	}
	public String getDescripCorta() {
		return descripCorta;
	}
	public void setDescripCorta(String descripCorta) {
		this.descripCorta = descripCorta;
	}
	public String getTasa() {
		return tasa;
	}
	public void setTasa(String tasa) {
		this.tasa = tasa;
	}
	public String getGravaRetiene() {
		return gravaRetiene;
	}
	public void setGravaRetiene(String gravaRetiene) {
		this.gravaRetiene = gravaRetiene;
	}
	public String getBaseCalculo() {
		return baseCalculo;
	}
	public void setBaseCalculo(String baseCalculo) {
		this.baseCalculo = baseCalculo;
	}
	public String getImpuestoCalculo() {
		return impuestoCalculo;
	}
	public void setImpuestoCalculo(String impuestoCalculo) {
		this.impuestoCalculo = impuestoCalculo;
	}
	public String getImporteImpuesto() {
		return importeImpuesto;
	}
	public void setImporteImpuesto(String importeImpuesto) {
		this.importeImpuesto = importeImpuesto;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getNoTotalImpuesto() {
		return noTotalImpuesto;
	}
	public void setNoTotalImpuesto(String noTotalImpuesto) {
		this.noTotalImpuesto = noTotalImpuesto;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
	
	
}
