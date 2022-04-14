package arrendamiento.bean;

import general.bean.BaseBean;

public class ArrendamientosBean extends BaseBean{

	// ATRIBUTOS DE LA TABLA 
	private String arrendaID; 
	private String lineaArrendaID;
	private String clienteID;
	private String numTransacSim;
	private String tipoArrenda;
	private String monedaID;
	/**/private String productoArrendaID;
	private String montoArrenda;
	private String ivaMontoArrenda;
	private String montoEnganche;
	private String ivaEnganche;
	private String porcEnganche;
	private String montoFinanciado;
	private String seguroArrendaID;
	private String tipoPagoSeguro;
	private String montoSeguroAnual;
	private String seguroVidaArrendaID;
	private String tipoPagoSeguroVida;
	private String montoSeguroVidaAnual;
	private String montoResidual;
	private String fechaRegistro;
	private String fechaApertura;
	private String fechaPrimerVen;
	private String fechaUltimoVen;
	private String fechaLiquida;
	private String plazo;
	private String frecuenciaPlazo;
	private String tasaFijaAnual;
	private String montoRenta;
	private String montoSeguro;
	private String montoSeguroVida;
	private String cantRentaDepo;
	private String montoDeposito;
	private String ivaDeposito;
	private String montoComApe;
	private String ivaComApe;
	private String otroGastos;
	private String ivaOtrosGastos;
	private String totalPagoInicial;
	private String tipCobComMorato;
	private String factorMora;
	private String cantCuota;
	private String montoCuota;
	private String estatus;
	private String sucursalID;
	private String usuarioAlta;
	private String usuarioAutoriza;
	private String fechaAutoriza;
	private String fechaTraspasaVen;
	private String fechaRegulariza;
	private String usuarioCancela;
	private String fechaCancela;
	private String motivoCancela;
	private String saldoCapVigente;
	private String saldoCapAtrasad;
	private String saldoCapVencido;
	private String montoIVACapital;
	private String saldoInteresVigent;
	private String saldoInteresAtras;
	private String saldoInteresVen;
	private String montoIVAInteres;
	private String saldoSeguro;
	private String montoIVASeguro;
	private String saldoSeguroVida;
	private String montoIVASeguroVida;
	private String saldoMoratorios;
	private String montoIVAMora;
	private String saldComFaltPago;
	private String montoIVAComFalPag;
	private String saldoOtrasComis;
	private String montoIVAComisi;
	private String diaPagoProd;
	private String pagareImpreso;
	private String fechaInhabil;
	private String tipoPrepago;
	private String nombreCliente;
	private String productoArrendaDescri;
	private String diasGracia;
	private String seguroDescri;
	private String seguroVidaDescri;

	public static int LONGITUD_ID = 10;
	private String nombreSucursal;
	private String nombreProducto;
	private String fecha;
	private String monedaDescri;
	private String diasFaltaPago;
	private String fechaProxPago;
	private String totalCapital;
	private String totalInteres;
	private String cuentaID;
	private String montoPagarArrendamiento;
	
	// CAMPOS DE AUDITORIA
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	//Auxiliares
	private String nombreCompleto; 
	private String descripProducto;
	
	private String rentaAnticipada;
	private String rentasAdelantadas;
	private String adelanto;
	
	private String concRentaAnticipada;
	private String concIvaRentaAnticipada;
	private String concRentasAdelantadas;
	private String concIvaRentasAdelantadas;
	
	// codigo y mensaje de error
	private String codigoError;
	private String mensajeError;
	
	public String getDescripProducto() {
		return descripProducto;
	}
	public void setDescripProducto(String descripProducto) {
		this.descripProducto = descripProducto;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getArrendaID() {
		return arrendaID;
	}
	public void setArrendaID(String arrendaID) {
		this.arrendaID = arrendaID;
	}
	public String getLineaArrendaID() {
		return lineaArrendaID;
	}
	public void setLineaArrendaID(String lineaArrendaID) {
		this.lineaArrendaID = lineaArrendaID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNumTransacSim() {
		return numTransacSim;
	}
	public void setNumTransacSim(String numTransacSim) {
		this.numTransacSim = numTransacSim;
	}
	public String getTipoArrenda() {
		return tipoArrenda;
	}
	public void setTipoArrenda(String tipoArrenda) {
		this.tipoArrenda = tipoArrenda;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getProductoArrendaID() {
		return productoArrendaID;
	}
	public void setProductoArrendaID(String productoArrendaID) {
		this.productoArrendaID = productoArrendaID;
	}
	public String getMontoArrenda() {
		return montoArrenda;
	}
	public void setMontoArrenda(String montoArrenda) {
		this.montoArrenda = montoArrenda;
	}
	public String getIvaMontoArrenda() {
		return ivaMontoArrenda;
	}
	public void setIvaMontoArrenda(String ivaMontoArrenda) {
		this.ivaMontoArrenda = ivaMontoArrenda;
	}
	public String getMontoEnganche() {
		return montoEnganche;
	}
	public void setMontoEnganche(String montoEnganche) {
		this.montoEnganche = montoEnganche;
	}
	public String getIvaEnganche() {
		return ivaEnganche;
	}
	public void setIvaEnganche(String ivaEnganche) {
		this.ivaEnganche = ivaEnganche;
	}
	public String getPorcEnganche() {
		return porcEnganche;
	}
	public void setPorcEnganche(String porcEnganche) {
		this.porcEnganche = porcEnganche;
	}
	public String getMontoFinanciado() {
		return montoFinanciado;
	}
	public void setMontoFinanciado(String montoFinanciado) {
		this.montoFinanciado = montoFinanciado;
	}
	public String getSeguroArrendaID() {
		return seguroArrendaID;
	}
	public void setSeguroArrendaID(String seguroArrendaID) {
		this.seguroArrendaID = seguroArrendaID;
	}
	public String getTipoPagoSeguro() {
		return tipoPagoSeguro;
	}
	public void setTipoPagoSeguro(String tipoPagoSeguro) {
		this.tipoPagoSeguro = tipoPagoSeguro;
	}
	public String getMontoSeguroAnual() {
		return montoSeguroAnual;
	}
	public void setMontoSeguroAnual(String montoSeguroAnual) {
		this.montoSeguroAnual = montoSeguroAnual;
	}
	public String getSeguroVidaArrendaID() {
		return seguroVidaArrendaID;
	}
	public void setSeguroVidaArrendaID(String seguroVidaArrendaID) {
		this.seguroVidaArrendaID = seguroVidaArrendaID;
	}
	public String getTipoPagoSeguroVida() {
		return tipoPagoSeguroVida;
	}
	public void setTipoPagoSeguroVida(String tipoPagoSeguroVida) {
		this.tipoPagoSeguroVida = tipoPagoSeguroVida;
	}
	public String getMontoSeguroVidaAnual() {
		return montoSeguroVidaAnual;
	}
	public void setMontoSeguroVidaAnual(String montoSeguroVidaAnual) {
		this.montoSeguroVidaAnual = montoSeguroVidaAnual;
	}
	public String getMontoResidual() {
		return montoResidual;
	}
	public void setMontoResidual(String montoResidual) {
		this.montoResidual = montoResidual;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getFechaApertura() {
		return fechaApertura;
	}
	public void setFechaApertura(String fechaApertura) {
		this.fechaApertura = fechaApertura;
	}
	public String getFechaPrimerVen() {
		return fechaPrimerVen;
	}
	public void setFechaPrimerVen(String fechaPrimerVen) {
		this.fechaPrimerVen = fechaPrimerVen;
	}
	public String getFechaUltimoVen() {
		return fechaUltimoVen;
	}
	public void setFechaUltimoVen(String fechaUltimoVen) {
		this.fechaUltimoVen = fechaUltimoVen;
	}
	public String getFechaLiquida() {
		return fechaLiquida;
	}
	public void setFechaLiquida(String fechaLiquida) {
		this.fechaLiquida = fechaLiquida;
	}
	public String getPlazo() {
		return plazo;
	}
	public void setPlazo(String plazo) {
		this.plazo = plazo;
	}
	public String getFrecuenciaPlazo() {
		return frecuenciaPlazo;
	}
	public void setFrecuenciaPlazo(String frecuenciaPlazo) {
		this.frecuenciaPlazo = frecuenciaPlazo;
	}
	public String getTasaFijaAnual() {
		return tasaFijaAnual;
	}
	public void setTasaFijaAnual(String tasaFijaAnual) {
		this.tasaFijaAnual = tasaFijaAnual;
	}
	public String getMontoRenta() {
		return montoRenta;
	}
	public void setMontoRenta(String montoRenta) {
		this.montoRenta = montoRenta;
	}
	public String getMontoSeguro() {
		return montoSeguro;
	}
	public void setMontoSeguro(String montoSeguro) {
		this.montoSeguro = montoSeguro;
	}
	public String getMontoSeguroVida() {
		return montoSeguroVida;
	}
	public void setMontoSeguroVida(String montoSeguroVida) {
		this.montoSeguroVida = montoSeguroVida;
	}
	public String getCantRentaDepo() {
		return cantRentaDepo;
	}
	public void setCantRentaDepo(String cantRentaDepo) {
		this.cantRentaDepo = cantRentaDepo;
	}
	public String getMontoDeposito() {
		return montoDeposito;
	}
	public void setMontoDeposito(String montoDeposito) {
		this.montoDeposito = montoDeposito;
	}
	public String getIvaDeposito() {
		return ivaDeposito;
	}
	public void setIvaDeposito(String ivaDeposito) {
		this.ivaDeposito = ivaDeposito;
	}
	public String getMontoComApe() {
		return montoComApe;
	}
	public void setMontoComApe(String montoComApe) {
		this.montoComApe = montoComApe;
	}
	public String getIvaComApe() {
		return ivaComApe;
	}
	public void setIvaComApe(String ivaComApe) {
		this.ivaComApe = ivaComApe;
	}
	public String getOtroGastos() {
		return otroGastos;
	}
	public void setOtroGastos(String otroGastos) {
		this.otroGastos = otroGastos;
	}
	public String getIvaOtrosGastos() {
		return ivaOtrosGastos;
	}
	public void setIvaOtrosGastos(String ivaOtrosGastos) {
		this.ivaOtrosGastos = ivaOtrosGastos;
	}
	public String getTotalPagoInicial() {
		return totalPagoInicial;
	}
	public void setTotalPagoInicial(String totalPagoInicial) {
		this.totalPagoInicial = totalPagoInicial;
	}
	public String getTipCobComMorato() {
		return tipCobComMorato;
	}
	public void setTipCobComMorato(String tipCobComMorato) {
		this.tipCobComMorato = tipCobComMorato;
	}
	public String getFactorMora() {
		return factorMora;
	}
	public void setFactorMora(String factorMora) {
		this.factorMora = factorMora;
	}
	public String getCantCuota() {
		return cantCuota;
	}
	public void setCantCuota(String cantCuota) {
		this.cantCuota = cantCuota;
	}
	public String getMontoCuota() {
		return montoCuota;
	}
	public void setMontoCuota(String montoCuota) {
		this.montoCuota = montoCuota;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getUsuarioAlta() {
		return usuarioAlta;
	}
	public void setUsuarioAlta(String usuarioAlta) {
		this.usuarioAlta = usuarioAlta;
	}
	public String getUsuarioAutoriza() {
		return usuarioAutoriza;
	}
	public void setUsuarioAutoriza(String usuarioAutoriza) {
		this.usuarioAutoriza = usuarioAutoriza;
	}
	public String getFechaAutoriza() {
		return fechaAutoriza;
	}
	public void setFechaAutoriza(String fechaAutoriza) {
		this.fechaAutoriza = fechaAutoriza;
	}
	public String getFechaTraspasaVen() {
		return fechaTraspasaVen;
	}
	public void setFechaTraspasaVen(String fechaTraspasaVen) {
		this.fechaTraspasaVen = fechaTraspasaVen;
	}
	public String getFechaRegulariza() {
		return fechaRegulariza;
	}
	public void setFechaRegulariza(String fechaRegulariza) {
		this.fechaRegulariza = fechaRegulariza;
	}
	public String getUsuarioCancela() {
		return usuarioCancela;
	}
	public void setUsuarioCancela(String usuarioCancela) {
		this.usuarioCancela = usuarioCancela;
	}
	public String getFechaCancela() {
		return fechaCancela;
	}
	public void setFechaCancela(String fechaCancela) {
		this.fechaCancela = fechaCancela;
	}
	public String getMotivoCancela() {
		return motivoCancela;
	}
	public void setMotivoCancela(String motivoCancela) {
		this.motivoCancela = motivoCancela;
	}
	public String getSaldoCapVigente() {
		return saldoCapVigente;
	}
	public void setSaldoCapVigente(String saldoCapVigente) {
		this.saldoCapVigente = saldoCapVigente;
	}
	public String getSaldoCapAtrasad() {
		return saldoCapAtrasad;
	}
	public void setSaldoCapAtrasad(String saldoCapAtrasad) {
		this.saldoCapAtrasad = saldoCapAtrasad;
	}
	public String getSaldoCapVencido() {
		return saldoCapVencido;
	}
	public void setSaldoCapVencido(String saldoCapVencido) {
		this.saldoCapVencido = saldoCapVencido;
	}
	public String getMontoIVACapital() {
		return montoIVACapital;
	}
	public void setMontoIVACapital(String montoIVACapital) {
		this.montoIVACapital = montoIVACapital;
	}
	public String getSaldoInteresVigent() {
		return saldoInteresVigent;
	}
	public void setSaldoInteresVigent(String saldoInteresVigent) {
		this.saldoInteresVigent = saldoInteresVigent;
	}
	public String getSaldoInteresAtras() {
		return saldoInteresAtras;
	}
	public void setSaldoInteresAtras(String saldoInteresAtras) {
		this.saldoInteresAtras = saldoInteresAtras;
	}
	public String getSaldoInteresVen() {
		return saldoInteresVen;
	}
	public void setSaldoInteresVen(String saldoInteresVen) {
		this.saldoInteresVen = saldoInteresVen;
	}
	public String getMontoIVAInteres() {
		return montoIVAInteres;
	}
	public void setMontoIVAInteres(String montoIVAInteres) {
		this.montoIVAInteres = montoIVAInteres;
	}
	public String getSaldoSeguro() {
		return saldoSeguro;
	}
	public void setSaldoSeguro(String saldoSeguro) {
		this.saldoSeguro = saldoSeguro;
	}
	public String getMontoIVASeguro() {
		return montoIVASeguro;
	}
	public void setMontoIVASeguro(String montoIVASeguro) {
		this.montoIVASeguro = montoIVASeguro;
	}
	public String getSaldoSeguroVida() {
		return saldoSeguroVida;
	}
	public void setSaldoSeguroVida(String saldoSeguroVida) {
		this.saldoSeguroVida = saldoSeguroVida;
	}
	public String getMontoIVASeguroVida() {
		return montoIVASeguroVida;
	}
	public void setMontoIVASeguroVida(String montoIVASeguroVida) {
		this.montoIVASeguroVida = montoIVASeguroVida;
	}
	public String getSaldoMoratorios() {
		return saldoMoratorios;
	}
	public void setSaldoMoratorios(String saldoMoratorios) {
		this.saldoMoratorios = saldoMoratorios;
	}
	public String getMontoIVAMora() {
		return montoIVAMora;
	}
	public void setMontoIVAMora(String montoIVAMora) {
		this.montoIVAMora = montoIVAMora;
	}
	public String getSaldComFaltPago() {
		return saldComFaltPago;
	}
	public void setSaldComFaltPago(String saldComFaltPago) {
		this.saldComFaltPago = saldComFaltPago;
	}
	public String getMontoIVAComFalPag() {
		return montoIVAComFalPag;
	}
	public void setMontoIVAComFalPag(String montoIVAComFalPag) {
		this.montoIVAComFalPag = montoIVAComFalPag;
	}
	public String getSaldoOtrasComis() {
		return saldoOtrasComis;
	}
	public void setSaldoOtrasComis(String saldoOtrasComis) {
		this.saldoOtrasComis = saldoOtrasComis;
	}
	public String getMontoIVAComisi() {
		return montoIVAComisi;
	}
	public void setMontoIVAComisi(String montoIVAComisi) {
		this.montoIVAComisi = montoIVAComisi;
	}
	public String getDiaPagoProd() {
		return diaPagoProd;
	}
	public void setDiaPagoProd(String diaPagoProd) {
		this.diaPagoProd = diaPagoProd;
	}
	public String getPagareImpreso() {
		return pagareImpreso;
	}
	public void setPagareImpreso(String pagareImpreso) {
		this.pagareImpreso = pagareImpreso;
	}
	public String getFechaInhabil() {
		return fechaInhabil;
	}
	public void setFechaInhabil(String fechaInhabil) {
		this.fechaInhabil = fechaInhabil;
	}
	public String getTipoPrepago() {
		return tipoPrepago;
	}
	public void setTipoPrepago(String tipoPrepago) {
		this.tipoPrepago = tipoPrepago;
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

	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}

	public String getProductoArrendaDescri() {
		return productoArrendaDescri;
	}
	public void setProductoArrendaDescri(String productoArrendaDescri) {
		this.productoArrendaDescri = productoArrendaDescri;
	}

	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getNombreProducto() {
		return nombreProducto;
	}
	public void setNombreProducto(String nombreProducto) {
		this.nombreProducto = nombreProducto;
	}
	public static int getLONGITUD_ID() {
		return LONGITUD_ID;
	}
	public static void setLONGITUD_ID(int lONGITUD_ID) {
		LONGITUD_ID = lONGITUD_ID;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getMonedaDescri() {
		return monedaDescri;
	}
	public void setMonedaDescri(String monedaDescri) {
		this.monedaDescri = monedaDescri;
	}
	public String getDiasFaltaPago() {
		return diasFaltaPago;
	}
	public void setDiasFaltaPago(String diasFaltaPago) {
		this.diasFaltaPago = diasFaltaPago;
	}
	public String getFechaProxPago() {
		return fechaProxPago;
	}
	public void setFechaProxPago(String fechaProxPago) {
		this.fechaProxPago = fechaProxPago;
	}
	public String getTotalCapital() {
		return totalCapital;
	}
	public void setTotalCapital(String totalCapital) {
		this.totalCapital = totalCapital;
	}
	public String getTotalInteres() {
		return totalInteres;
	}
	public void setTotalInteres(String totalInteres) {
		this.totalInteres = totalInteres;
	}

	public String getDiasGracia() {
		return diasGracia;
	}
	public void setDiasGracia(String diasGracia) {
		this.diasGracia = diasGracia;
	}
	
	public String getCuentaID() {
		return cuentaID;
	}
	public void setCuentaID(String cuentaID) {
		this.cuentaID = cuentaID;
	}
	public String getMontoPagarArrendamiento() {
		return montoPagarArrendamiento;
	}
	public void setMontoPagarArrendamiento(String montoPagarArrendamiento) {
		this.montoPagarArrendamiento = montoPagarArrendamiento;
	}
	public String getSeguroDescri() {
		return seguroDescri;
	}
	public void setSeguroDescri(String seguroDescri) {
		this.seguroDescri = seguroDescri;
	}
	public String getSeguroVidaDescri() {
		return seguroVidaDescri;
	}
	public void setSeguroVidaDescri(String seguroVidaDescri) {
		this.seguroVidaDescri = seguroVidaDescri;
	}
	public String getRentaAnticipada() {
		return rentaAnticipada;
	}
	public void setRentaAnticipada(String rentaAnticipada) {
		this.rentaAnticipada = rentaAnticipada;
	}
	public String getRentasAdelantadas() {
		return rentasAdelantadas;
	}
	public void setRentasAdelantadas(String rentasAdelantadas) {
		this.rentasAdelantadas = rentasAdelantadas;
	}
	public String getAdelanto() {
		return adelanto;
	}
	public void setAdelanto(String adelanto) {
		this.adelanto = adelanto;
	}
	public String getConcRentaAnticipada() {
		return concRentaAnticipada;
	}
	public void setConcRentaAnticipada(String concRentaAnticipada) {
		this.concRentaAnticipada = concRentaAnticipada;
	}
	public String getConcIvaRentaAnticipada() {
		return concIvaRentaAnticipada;
	}
	public void setConcIvaRentaAnticipada(String concIvaRentaAnticipada) {
		this.concIvaRentaAnticipada = concIvaRentaAnticipada;
	}
	public String getConcRentasAdelantadas() {
		return concRentasAdelantadas;
	}
	public void setConcRentasAdelantadas(String concRentasAdelantadas) {
		this.concRentasAdelantadas = concRentasAdelantadas;
	}
	public String getConcIvaRentasAdelantadas() {
		return concIvaRentasAdelantadas;
	}
	public void setConcIvaRentasAdelantadas(String concIvaRentasAdelantadas) {
		this.concIvaRentasAdelantadas = concIvaRentasAdelantadas;
	}
	
	public String getCodigoError() {
		return codigoError;
	}
	public void setCodigoError(String codigoError) {
		this.codigoError = codigoError;
	}
	public String getMensajeError() {
		return mensajeError;
	}
	public void setMensajeError(String mensajeError) {
		this.mensajeError = mensajeError;
	}
}
