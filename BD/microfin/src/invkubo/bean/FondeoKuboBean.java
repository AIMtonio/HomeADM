package invkubo.bean;

public class FondeoKuboBean {
	
		private String fondeoKuboID;
		private String clienteID;
		private String creditoID;
		private String cuentaAhoID;
		private String solicitudCreditoID;
		private String consecutivo;
		private String folio;
		private String calcInteresID;
		private String tasaBaseID;
		private String sobreTasa;
		private String tasaFija;
		private String pisoTasa;
		private String techoTasa;
		private String montoFondeo;
		private String porcentajeFondeo;
		private String monedaID;
		private String fechaInicio;
		private String fechaVencimiento;
		private String tipoFondeo;
		private String numCuotas;
		private String numRetirosMes;
		private String porcentajeMora;
		private String porcentajeComisi;
		private String estatus;
		private String saldoCapVigente;
		private String saldoCapExigible;
		private String saldoInteres;
		private String provisionAcum;
		private String moratorioPagado;
		private String comFalPagPagada;
		private String intOrdRetenido;
		private String intMorRetenido;
		private String comFalPagRetenido;
		private String diasAtraso; // para consulta de saldos y pagos de pantalla de originacion (detalle inversiones)
		private String totalSaldo; 
		private String totalrecibido; 
		private String totalRetenido; 
		private String capitalRecibido; 
		private String interesRecibido; 
		private String moraRecibido; 
		private String comisionRecibido; 

		
		
		//variables para ws de consulta inversiones
		private String gananciaAnuTot;
		private String interesCobrado;
		private String pagTotalRecib;
		private String saldoTotal;
		private String numeroEfectivoDispon;
		private String saldoEfectivoDispon;
		private String numeroInverEnProceso;
		private String saldoInverEnProceso;
		private String numeroInvActivas;
		private String saldoInvActivas;
		private String numeroIntDevengados;
		private String saldoIntDevengados;
		private String numeroTotInversiones;
		private String numeroInvActivasResumen;
		private String SaldoInvActivasResumen;
		private String numeroInvAtrasadas1a15Resumen;
		private String saldoInvAtrasadas1a15Resumen;
		private String numeroInvAtrasadas16a30Resumen;
		private String saldoInvAtrasadas16a30Resumen;
		private String numeroInvAtrasadas31a90Resumen;
		private String saldoInvAtrasadas31a90Resumen;
		private String numeroInvVencidas91a120Resumen;
		private String saldoInvVencidas91a120Resumen;
		private String numeroInvVencidas121a180Resumen;
		private String saldoInvVencidas121a180Resumen;
		private String numeroInvQuebrantadasResumen;
		private String saldoInvQuebrantadasResumen;
		private String numeroInvLiquidadasResumen;
		private String saldoInvLiquidadasResumen;
		
		// ----------------------------------------------------
		
		
		private String empresaID;
		private String usuario;
		private String sucursal;
		private String fechaActual;
		private String direccionIP;
		private String programaID;
		private String numTransaccion;
		
		
		
		
		public String getInteresRecibido() {
			return interesRecibido;
		}
		public void setInteresRecibido(String interesRecibido) {
			this.interesRecibido = interesRecibido;
		}
		public String getMoraRecibido() {
			return moraRecibido;
		}
		public void setMoraRecibido(String moraRecibido) {
			this.moraRecibido = moraRecibido;
		}
		public String getComisionRecibido() {
			return comisionRecibido;
		}
		public void setComisionRecibido(String comisionRecibido) {
			this.comisionRecibido = comisionRecibido;
		}
		public String getCapitalRecibido() {
			return capitalRecibido;
		}
		public void setCapitalRecibido(String capitalRecibido) {
			this.capitalRecibido = capitalRecibido;
		}
		public String getDiasAtraso() {
			return diasAtraso;
		}
		public void setDiasAtraso(String diasAtraso) {
			this.diasAtraso = diasAtraso;
		}
		public String getTotalSaldo() {
			return totalSaldo;
		}
		public void setTotalSaldo(String totalSaldo) {
			this.totalSaldo = totalSaldo;
		}
		public String getTotalrecibido() {
			return totalrecibido;
		}
		public void setTotalrecibido(String totalrecibido) {
			this.totalrecibido = totalrecibido;
		}
		public String getTotalRetenido() {
			return totalRetenido;
		}
		public void setTotalRetenido(String totalRetenido) {
			this.totalRetenido = totalRetenido;
		}
		public String getFondeoKuboID() {
			return fondeoKuboID;
		}
		public void setFondeoKuboID(String fondeoKuboID) {
			this.fondeoKuboID = fondeoKuboID;
		}
		public String getClienteID() {
			return clienteID;
		}
		public void setClienteID(String clienteID) {
			this.clienteID = clienteID;
		}
		public String getCreditoID() {
			return creditoID;
		}
		public void setCreditoID(String creditoID) {
			this.creditoID = creditoID;
		}
		public String getCuentaAhoID() {
			return cuentaAhoID;
		}
		public void setCuentaAhoID(String cuentaAhoID) {
			this.cuentaAhoID = cuentaAhoID;
		}
		public String getSolicitudCreditoID() {
			return solicitudCreditoID;
		}
		public void setSolicitudCreditoID(String solicitudCreditoID) {
			this.solicitudCreditoID = solicitudCreditoID;
		}
		public String getConsecutivo() {
			return consecutivo;
		}
		public void setConsecutivo(String consecutivo) {
			this.consecutivo = consecutivo;
		}
		public String getFolio() {
			return folio;
		}
		public void setFolio(String folio) {
			this.folio = folio;
		}
		public String getCalcInteresID() {
			return calcInteresID;
		}
		public void setCalcInteresID(String calcInteresID) {
			this.calcInteresID = calcInteresID;
		}
		public String getTasaBaseID() {
			return tasaBaseID;
		}
		public void setTasaBaseID(String tasaBaseID) {
			this.tasaBaseID = tasaBaseID;
		}
		public String getSobreTasa() {
			return sobreTasa;
		}
		public void setSobreTasa(String sobreTasa) {
			this.sobreTasa = sobreTasa;
		}
		public String getTasaFija() {
			return tasaFija;
		}
		public void setTasaFija(String tasaFija) {
			this.tasaFija = tasaFija;
		}
		public String getPisoTasa() {
			return pisoTasa;
		}
		public void setPisoTasa(String pisoTasa) {
			this.pisoTasa = pisoTasa;
		}
		public String getTechoTasa() {
			return techoTasa;
		}
		public void setTechoTasa(String techoTasa) {
			this.techoTasa = techoTasa;
		}
		public String getMontoFondeo() {
			return montoFondeo;
		}
		public void setMontoFondeo(String montoFondeo) {
			this.montoFondeo = montoFondeo;
		}
		public String getPorcentajeFondeo() {
			return porcentajeFondeo;
		}
		public void setPorcentajeFondeo(String porcentajeFondeo) {
			this.porcentajeFondeo = porcentajeFondeo;
		}
		public String getMonedaID() {
			return monedaID;
		}
		public void setMonedaID(String monedaID) {
			this.monedaID = monedaID;
		}
		public String getFechaInicio() {
			return fechaInicio;
		}
		public void setFechaInicio(String fechaInicio) {
			this.fechaInicio = fechaInicio;
		}
		public String getFechaVencimiento() {
			return fechaVencimiento;
		}
		public void setFechaVencimiento(String fechaVencimiento) {
			this.fechaVencimiento = fechaVencimiento;
		}
		public String getTipoFondeo() {
			return tipoFondeo;
		}
		public void setTipoFondeo(String tipoFondeo) {
			this.tipoFondeo = tipoFondeo;
		}
		public String getNumCuotas() {
			return numCuotas;
		}
		public void setNumCuotas(String numCuotas) {
			this.numCuotas = numCuotas;
		}
		public String getNumRetirosMes() {
			return numRetirosMes;
		}
		public void setNumRetirosMes(String numRetirosMes) {
			this.numRetirosMes = numRetirosMes;
		}
		public String getPorcentajeMora() {
			return porcentajeMora;
		}
		public void setPorcentajeMora(String porcentajeMora) {
			this.porcentajeMora = porcentajeMora;
		}
		public String getPorcentajeComisi() {
			return porcentajeComisi;
		}
		public void setPorcentajeComisi(String porcentajeComisi) {
			this.porcentajeComisi = porcentajeComisi;
		}
		public String getEstatus() {
			return estatus;
		}
		public void setEstatus(String estatus) {
			this.estatus = estatus;
		}
		public String getSaldoCapVigente() {
			return saldoCapVigente;
		}
		public void setSaldoCapVigente(String saldoCapVigente) {
			this.saldoCapVigente = saldoCapVigente;
		}
		public String getSaldoCapExigible() {
			return saldoCapExigible;
		}
		public void setSaldoCapExigible(String saldoCapExigible) {
			this.saldoCapExigible = saldoCapExigible;
		}
		public String getSaldoInteres() {
			return saldoInteres;
		}
		public void setSaldoInteres(String saldoInteres) {
			this.saldoInteres = saldoInteres;
		}
		public String getProvisionAcum() {
			return provisionAcum;
		}
		public void setProvisionAcum(String provisionAcum) {
			this.provisionAcum = provisionAcum;
		}
		public String getMoratorioPagado() {
			return moratorioPagado;
		}
		public void setMoratorioPagado(String moratorioPagado) {
			this.moratorioPagado = moratorioPagado;
		}
		public String getComFalPagPagada() {
			return comFalPagPagada;
		}
		public void setComFalPagPagada(String comFalPagPagada) {
			this.comFalPagPagada = comFalPagPagada;
		}
		public String getIntOrdRetenido() {
			return intOrdRetenido;
		}
		public void setIntOrdRetenido(String intOrdRetenido) {
			this.intOrdRetenido = intOrdRetenido;
		}
		public String getIntMorRetenido() {
			return intMorRetenido;
		}
		public void setIntMorRetenido(String intMorRetenido) {
			this.intMorRetenido = intMorRetenido;
		}
		public String getComFalPagRetenido() {
			return comFalPagRetenido;
		}
		public void setComFalPagRetenido(String comFalPagRetenido) {
			this.comFalPagRetenido = comFalPagRetenido;
		}
		public String getGananciaAnuTot() {
			return gananciaAnuTot;
		}
		public void setGananciaAnuTot(String gananciaAnuTot) {
			this.gananciaAnuTot = gananciaAnuTot;
		}
		public String getInteresCobrado() {
			return interesCobrado;
		}
		public void setInteresCobrado(String interesCobrado) {
			this.interesCobrado = interesCobrado;
		}
		public String getPagTotalRecib() {
			return pagTotalRecib;
		}
		public void setPagTotalRecib(String pagTotalRecib) {
			this.pagTotalRecib = pagTotalRecib;
		}
		public String getSaldoTotal() {
			return saldoTotal;
		}
		public void setSaldoTotal(String saldoTotal) {
			this.saldoTotal = saldoTotal;
		}
		public String getNumeroEfectivoDispon() {
			return numeroEfectivoDispon;
		}
		public void setNumeroEfectivoDispon(String numeroEfectivoDispon) {
			this.numeroEfectivoDispon = numeroEfectivoDispon;
		}
		public String getSaldoEfectivoDispon() {
			return saldoEfectivoDispon;
		}
		public void setSaldoEfectivoDispon(String saldoEfectivoDispon) {
			this.saldoEfectivoDispon = saldoEfectivoDispon;
		}
		public String getNumeroInverEnProceso() {
			return numeroInverEnProceso;
		}
		public void setNumeroInverEnProceso(String numeroInverEnProceso) {
			this.numeroInverEnProceso = numeroInverEnProceso;
		}
		public String getSaldoInverEnProceso() {
			return saldoInverEnProceso;
		}
		public void setSaldoInverEnProceso(String saldoInverEnProceso) {
			this.saldoInverEnProceso = saldoInverEnProceso;
		}
		public String getNumeroInvActivas() {
			return numeroInvActivas;
		}
		public void setNumeroInvActivas(String numeroInvActivas) {
			this.numeroInvActivas = numeroInvActivas;
		}
		public String getSaldoInvActivas() {
			return saldoInvActivas;
		}
		public void setSaldoInvActivas(String saldoInvActivas) {
			this.saldoInvActivas = saldoInvActivas;
		}
		public String getNumeroIntDevengados() {
			return numeroIntDevengados;
		}
		public void setNumeroIntDevengados(String numeroIntDevengados) {
			this.numeroIntDevengados = numeroIntDevengados;
		}
		public String getSaldoIntDevengados() {
			return saldoIntDevengados;
		}
		public void setSaldoIntDevengados(String saldoIntDevengados) {
			this.saldoIntDevengados = saldoIntDevengados;
		}
		public String getNumeroTotInversiones() {
			return numeroTotInversiones;
		}
		public void setNumeroTotInversiones(String numeroTotInversiones) {
			this.numeroTotInversiones = numeroTotInversiones;
		}
		public String getNumeroInvActivasResumen() {
			return numeroInvActivasResumen;
		}
		public void setNumeroInvActivasResumen(String numeroInvActivasResumen) {
			this.numeroInvActivasResumen = numeroInvActivasResumen;
		}
		public String getSaldoInvActivasResumen() {
			return SaldoInvActivasResumen;
		}
		public void setSaldoInvActivasResumen(String saldoInvActivasResumen) {
			SaldoInvActivasResumen = saldoInvActivasResumen;
		}
		public String getNumeroInvAtrasadas1a15Resumen() {
			return numeroInvAtrasadas1a15Resumen;
		}
		public void setNumeroInvAtrasadas1a15Resumen(
				String numeroInvAtrasadas1a15Resumen) {
			this.numeroInvAtrasadas1a15Resumen = numeroInvAtrasadas1a15Resumen;
		}
		public String getSaldoInvAtrasadas1a15Resumen() {
			return saldoInvAtrasadas1a15Resumen;
		}
		public void setSaldoInvAtrasadas1a15Resumen(String saldoInvAtrasadas1a15Resumen) {
			this.saldoInvAtrasadas1a15Resumen = saldoInvAtrasadas1a15Resumen;
		}
		public String getNumeroInvAtrasadas16a30Resumen() {
			return numeroInvAtrasadas16a30Resumen;
		}
		public void setNumeroInvAtrasadas16a30Resumen(
				String numeroInvAtrasadas16a30Resumen) {
			this.numeroInvAtrasadas16a30Resumen = numeroInvAtrasadas16a30Resumen;
		}
		public String getSaldoInvAtrasadas16a30Resumen() {
			return saldoInvAtrasadas16a30Resumen;
		}
		public void setSaldoInvAtrasadas16a30Resumen(
				String saldoInvAtrasadas16a30Resumen) {
			this.saldoInvAtrasadas16a30Resumen = saldoInvAtrasadas16a30Resumen;
		}
		public String getNumeroInvAtrasadas31a90Resumen() {
			return numeroInvAtrasadas31a90Resumen;
		}
		public void setNumeroInvAtrasadas31a90Resumen(
				String numeroInvAtrasadas31a90Resumen) {
			this.numeroInvAtrasadas31a90Resumen = numeroInvAtrasadas31a90Resumen;
		}
		public String getSaldoInvAtrasadas31a90Resumen() {
			return saldoInvAtrasadas31a90Resumen;
		}
		public void setSaldoInvAtrasadas31a90Resumen(
				String saldoInvAtrasadas31a90Resumen) {
			this.saldoInvAtrasadas31a90Resumen = saldoInvAtrasadas31a90Resumen;
		}
		public String getNumeroInvVencidas91a120Resumen() {
			return numeroInvVencidas91a120Resumen;
		}
		public void setNumeroInvVencidas91a120Resumen(
				String numeroInvVencidas91a120Resumen) {
			this.numeroInvVencidas91a120Resumen = numeroInvVencidas91a120Resumen;
		}
		public String getSaldoInvVencidas91a120Resumen() {
			return saldoInvVencidas91a120Resumen;
		}
		public void setSaldoInvVencidas91a120Resumen(
				String saldoInvVencidas91a120Resumen) {
			this.saldoInvVencidas91a120Resumen = saldoInvVencidas91a120Resumen;
		}
		public String getNumeroInvVencidas121a180Resumen() {
			return numeroInvVencidas121a180Resumen;
		}
		public void setNumeroInvVencidas121a180Resumen(
				String numeroInvVencidas121a180Resumen) {
			this.numeroInvVencidas121a180Resumen = numeroInvVencidas121a180Resumen;
		}
		public String getSaldoInvVencidas121a180Resumen() {
			return saldoInvVencidas121a180Resumen;
		}
		public void setSaldoInvVencidas121a180Resumen(
				String saldoInvVencidas121a180Resumen) {
			this.saldoInvVencidas121a180Resumen = saldoInvVencidas121a180Resumen;
		}
		public String getNumeroInvQuebrantadasResumen() {
			return numeroInvQuebrantadasResumen;
		}
		public void setNumeroInvQuebrantadasResumen(String numeroInvQuebrantadasResumen) {
			this.numeroInvQuebrantadasResumen = numeroInvQuebrantadasResumen;
		}
		public String getSaldoInvQuebrantadasResumen() {
			return saldoInvQuebrantadasResumen;
		}
		public void setSaldoInvQuebrantadasResumen(String saldoInvQuebrantadasResumen) {
			this.saldoInvQuebrantadasResumen = saldoInvQuebrantadasResumen;
		}
		public String getNumeroInvLiquidadasResumen() {
			return numeroInvLiquidadasResumen;
		}
		public void setNumeroInvLiquidadasResumen(String numeroInvLiquidadasResumen) {
			this.numeroInvLiquidadasResumen = numeroInvLiquidadasResumen;
		}
		public String getSaldoInvLiquidadasResumen() {
			return saldoInvLiquidadasResumen;
		}
		public void setSaldoInvLiquidadasResumen(String saldoInvLiquidadasResumen) {
			this.saldoInvLiquidadasResumen = saldoInvLiquidadasResumen;
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
		public String getSucursal() {
			return sucursal;
		}
		public void setSucursal(String sucursal) {
			this.sucursal = sucursal;
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
		public String getNumTransaccion() {
			return numTransaccion;
		}
		public void setNumTransaccion(String numTransaccion) {
			this.numTransaccion = numTransaccion;
		}


}