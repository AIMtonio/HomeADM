package originacion.bean;

public class RatiosBean {
	private String solicitudCreditoID;
	private String prospectoID;
	private String clienteID;
	private String productoCreditoID;
	private String plazoID;
	private String porcGarLiq;
	
	private String ratiosPorClasifID;
	private String ratiosPuntosID;
	private String descripcion;
	
	
	private String morosidadCredito;
	private String maximoMorosidad;
	private String calificaBuro;
	
	
	private String deudaActual;
	private String deudaActualConCredito;
	private String cobertura;
	private String gastosActuales;
	private String gastosConCredito;
	
	private String estabilidadEmpleo;
	private String tieneNegocio;
	private String ventasMensuales;
	private String liquidez;
	private String situacionMercado;
	
	private String activosTerrenos;
	private String vivienda;
	private String activosVehiculos;
	private String otrosActivos;
	
	
	private String totalResidencia;
	private String totalOCupacion;
	private String totalMora;
	private String totalAfiliacion;
	private String totalDeudaActual;
	private String totalDeudaCredito;
	private String totalCobertura;
	private String totalGastos;
	private String totalGastosCredito;
	private String totalEstabilidadIng;
	private String totalNegocio;
	private String puntosTotal;
	private String nivelRiesgo;
	private String descripcionNivel;
	
	private String garantizado;
	private String estatus;
	private String cuotaMaxima;
	private String sucursalID;
	private String empresaID;
	private String nAvales;
	private String colaterales;		// puntos para Colaterales C5
	/*Rechazo y autorizacion*/
	private String usuarioID;
	private String motivo;
	private String usuarioClave;
	
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public String getPlazoID() {
		return plazoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
	}
	public String getPorcGarLiq() {
		return porcGarLiq;
	}
	public void setPorcGarLiq(String porcGarLiq) {
		this.porcGarLiq = porcGarLiq;
	}
	public String getRatiosPorClasifID() {
		return ratiosPorClasifID;
	}
	public void setRatiosPorClasifID(String ratiosPorClasifID) {
		this.ratiosPorClasifID = ratiosPorClasifID;
	}
	public String getRatiosPuntosID() {
		return ratiosPuntosID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setRatiosPuntosID(String ratiosPuntosID) {
		this.ratiosPuntosID = ratiosPuntosID;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getMorosidadCredito() {
		return morosidadCredito;
	}
	public String getMaximoMorosidad() {
		return maximoMorosidad;
	}
	public String getCalificaBuro() {
		return calificaBuro;
	}
	public String getDeudaActual() {
		return deudaActual;
	}
	public String getDeudaActualConCredito() {
		return deudaActualConCredito;
	}
	public String getCobertura() {
		return cobertura;
	}
	public String getGastosActuales() {
		return gastosActuales;
	}
	public String getGastosConCredito() {
		return gastosConCredito;
	}
	public String getEstabilidadEmpleo() {
		return estabilidadEmpleo;
	}
	public String getTieneNegocio() {
		return tieneNegocio;
	}
	public String getVentasMensuales() {
		return ventasMensuales;
	}
	public String getLiquidez() {
		return liquidez;
	}
	public String getSituacionMercado() {
		return situacionMercado;
	}
	public void setMorosidadCredito(String morosidadCredito) {
		this.morosidadCredito = morosidadCredito;
	}
	public void setMaximoMorosidad(String maximoMorosidad) {
		this.maximoMorosidad = maximoMorosidad;
	}
	public void setCalificaBuro(String calificaBuro) {
		this.calificaBuro = calificaBuro;
	}
	public void setDeudaActual(String deudaActual) {
		this.deudaActual = deudaActual;
	}
	public void setDeudaActualConCredito(String deudaActualConCredito) {
		this.deudaActualConCredito = deudaActualConCredito;
	}
	public void setCobertura(String cobertura) {
		this.cobertura = cobertura;
	}
	public void setGastosActuales(String gastosActuales) {
		this.gastosActuales = gastosActuales;
	}
	public void setGastosConCredito(String gastosConCredito) {
		this.gastosConCredito = gastosConCredito;
	}
	public void setEstabilidadEmpleo(String estabilidadEmpleo) {
		this.estabilidadEmpleo = estabilidadEmpleo;
	}
	public void setTieneNegocio(String tieneNegocio) {
		this.tieneNegocio = tieneNegocio;
	}
	public void setVentasMensuales(String ventasMensuales) {
		this.ventasMensuales = ventasMensuales;
	}
	public void setLiquidez(String liquidez) {
		this.liquidez = liquidez;
	}
	public void setSituacionMercado(String situacionMercado) {
		this.situacionMercado = situacionMercado;
	}
	public String getTotalResidencia() {
		return totalResidencia;
	}
	public String getTotalOCupacion() {
		return totalOCupacion;
	}
	public String getTotalMora() {
		return totalMora;
	}
	public String getTotalAfiliacion() {
		return totalAfiliacion;
	}
	public String getTotalDeudaActual() {
		return totalDeudaActual;
	}
	public String getTotalDeudaCredito() {
		return totalDeudaCredito;
	}
	public String getTotalCobertura() {
		return totalCobertura;
	}
	public String getTotalGastos() {
		return totalGastos;
	}
	public String getTotalGastosCredito() {
		return totalGastosCredito;
	}
	public String getTotalEstabilidadIng() {
		return totalEstabilidadIng;
	}
	public String getTotalNegocio() {
		return totalNegocio;
	}
	public String getPuntosTotal() {
		return puntosTotal;
	}
	public String getNivelRiesgo() {
		return nivelRiesgo;
	}
	public void setTotalResidencia(String totalResidencia) {
		this.totalResidencia = totalResidencia;
	}
	public void setTotalOCupacion(String totalOCupacion) {
		this.totalOCupacion = totalOCupacion;
	}
	public void setTotalMora(String totalMora) {
		this.totalMora = totalMora;
	}
	public void setTotalAfiliacion(String totalAfiliacion) {
		this.totalAfiliacion = totalAfiliacion;
	}
	public void setTotalDeudaActual(String totalDeudaActual) {
		this.totalDeudaActual = totalDeudaActual;
	}
	public void setTotalDeudaCredito(String totalDeudaCredito) {
		this.totalDeudaCredito = totalDeudaCredito;
	}
	public void setTotalCobertura(String totalCobertura) {
		this.totalCobertura = totalCobertura;
	}
	public void setTotalGastos(String totalGastos) {
		this.totalGastos = totalGastos;
	}
	public void setTotalGastosCredito(String totalGastosCredito) {
		this.totalGastosCredito = totalGastosCredito;
	}
	public void setTotalEstabilidadIng(String totalEstabilidadIng) {
		this.totalEstabilidadIng = totalEstabilidadIng;
	}
	public void setTotalNegocio(String totalNegocio) {
		this.totalNegocio = totalNegocio;
	}
	public void setPuntosTotal(String puntosTotal) {
		this.puntosTotal = puntosTotal;
	}
	public void setNivelRiesgo(String nivelRiesgo) {
		this.nivelRiesgo = nivelRiesgo;
	}
	public String getDescripcionNivel() {
		return descripcionNivel;
	}
	public void setDescripcionNivel(String descripcionNivel) {
		this.descripcionNivel = descripcionNivel;
	}
	public String getActivosTerrenos() {
		return activosTerrenos;
	}
	public String getVivienda() {
		return vivienda;
	}
	public String getActivosVehiculos() {
		return activosVehiculos;
	}
	public String getOtrosActivos() {
		return otrosActivos;
	}
	public void setActivosTerrenos(String activosTerrenos) {
		this.activosTerrenos = activosTerrenos;
	}
	public void setVivienda(String vivienda) {
		this.vivienda = vivienda;
	}
	public void setActivosVehiculos(String activosVehiculos) {
		this.activosVehiculos = activosVehiculos;
	}
	public void setOtrosActivos(String otrosActivos) {
		this.otrosActivos = otrosActivos;
	}
	public String getGarantizado() {
		return garantizado;
	}
	public void setGarantizado(String garantizado) {
		this.garantizado = garantizado;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getCuotaMaxima() {
		return cuotaMaxima;
	}
	public void setCuotaMaxima(String cuotaMaxima) {
		this.cuotaMaxima = cuotaMaxima;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getMotivo() {
		return motivo;
	}
	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}
	public String getUsuarioClave() {
		return usuarioClave;
	}
	public void setUsuarioClave(String usuarioClave) {
		this.usuarioClave = usuarioClave;
	}
	public String getnAvales() {
		return nAvales;
	}
	public void setnAvales(String nAvales) {
		this.nAvales = nAvales;
	}
	public String getColaterales() {
		return colaterales;
	}
	public void setColaterales(String colaterales) {
		this.colaterales = colaterales;
	}

}
