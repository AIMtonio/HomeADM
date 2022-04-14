package cedes.bean;

import general.bean.BaseBean;

public class CedesBean extends BaseBean {

	private String cedeID;
	private String clienteID;
	private String cuentaAhoID;
	private String tipoCedeID;
	private String fechaInicio;
	private String fechaVencimiento;
	private String pisoTasa;
	private String techoTasa;
	private String monto;
	private String monedaID;
	private String plazo;
	private String plazoOriginal;
	private String tasa;
	private String tasaBruta;
	private String tasaISR;
	private String tasaNeta;
	private String interesGenerado;
	private String interesRecibir;
	private String interesRetener;
	private String fechaVenAnt;
	private String nombreCliente;
	private String estatus;
	private String usuarioID;
	private String estatusImpresion;
	private String etiqueta;
	private String valorGat; //para nuevo campo en la pantalla donde se calcula el Gasto Anual Total para pantalla aperturaInversion.jsp
	private String valorGatReal;
	private String nombreCompleto;
	private String reinvertir;
	private String desReinvertir;
	private String cajaRetiro;
	
	private String sucursalID;
	private String nombreUsuario;
	private String nombreInstitucion;
	private String descripcionTipoInv;
	private String nombreMoneda;
	private String nombreSucursal;
	private String fechaActual;
	
	private String usuarioAutorizaID;
	private String contraseniaUsuarioAutoriza;
	private String diasTrans;
	private String saldoProvision;
	private String tipoInversion;
	private String descripcion;
	private String fechaFin;	
	private String tasaFija;
	private String tasaBase;
	private String sobreTasa;
	private String tipoPagoInt;
	private String diasPeriodo;
	private String pagoIntCal;

	private String totalCapital;
	private String totalInteres;
	private String totalISR;
	private String totalFinal;
	private String numCedes;
	
	private String tasaBaseID;
	private String segmentacion;
	private String relaciones;
	private String productoSAFI;

	//Autorización de Cedes
	private String direccion;
	private String telefono;
	private String saldoCuenta;
	private String totalRecibir;
	private String calculoInteres;
	
	private String direccionInstit;
	private String desCalculoInteres;


	/*Simulador*/
	private String numTran;
	private String consecutivo;
	private String fecha;
	private String fechaPago;
	private String capital;
	private String interes;
	private String isr;
	private String total;


	//Auxiliares para reporte
	private String promotorID;
	private String fechaEmision;
	private String fechaApertura;
	
	private String reinversion;
	private String montosAnclados;
	private String interesesAnclados;
	private String cedeMadreID;
	private String polizaID;
	private String nuevaTasa;
	private String nombrePromotor;
	private String desEstatus;
	private String desTasaBase;
	private String desTipoCede;
	private String formulaInteres;
	
	//CalculoPatrimonial
	private String contrato;
	private String constancia;
	private String tipoPersona;
	private String inicioPeriodo;
	private String finPeriodo;
	
	private String interesesPeriodo;
	private String porcentajeISR;	
	private String isrPeriodo;
	private String promedio;
	
	private String intAcuPeriodoAnt;
	private String intTotalesAcu;
	private String isrTotalAcu;	
	private String diasPlazo;
	private String clientesAct;
	
	private String montoInverCierre;
	private String interesesDeven;
	private String inteMontoInver;	
	private String interesesPagados;
	private String inteDevenxPag;
	
	private String tipoReporte;
	private String iniPerReporte;
	private String finPerReporte;
	private String estatusISR;
	
	public final String conceptoAperturaCEDES 		= "501"; //APERTURA DE CEDE TABLA DE TIPOSMOVSAHO
	public final String conceptoMovCEDES 			= "900";
	public final String descripcionMovCEDES 		= "APERTURA CEDE";
	public final String conceptooAhorroCedeCapi		= "1";
	
	public final String conceptoCancelaCEDES 		= "508"; //CANCELACION DE CEDES DE TIPOSMOVSAHO
	public final String conceptoMovCanCEDES 		= "906";
	public final String descripcionMovCanCEDES 		= "CANCELACION CEDE";
	public final String conceptoAhorroCanCedeCapi	= "1";
	
	public final String concVenAntCede 				= "907";  // CANCELACION CEDES
	public final String descVenAntCede 				= "VENCIMIENTO ANTICIPADO CEDE";
	
	public String getDireccionInstit() {
		return direccionInstit;
	}
	public void setDireccionInstit(String direccionInstit) {
		this.direccionInstit = direccionInstit;
	}
	public String getTasa() {
		return tasa;
	}
	public void setTasa(String tasa) {
		this.tasa = tasa;
	}
	public String getTasaBruta() {
		return tasaBruta;
	}
	public void setTasaBruta(String tasaBruta) {
		this.tasaBruta = tasaBruta;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
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
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getPlazo() {
		return plazo;
	}
	public void setPlazo(String plazo) {
		this.plazo = plazo;
	}
	
	
	public String getPlazoOriginal() {
		return plazoOriginal;
	}
	public void setPlazoOriginal(String plazoOriginal) {
		this.plazoOriginal = plazoOriginal;
	}
	public String getTasaISR() {
		return tasaISR;
	}
	public void setTasaISR(String tasaISR) {
		this.tasaISR = tasaISR;
	}
	public String getTasaNeta() {
		return tasaNeta;
	}
	public void setTasaNeta(String tasaNeta) {
		this.tasaNeta = tasaNeta;
	}
	public String getInteresGenerado() {
		return interesGenerado;
	}
	public void setInteresGenerado(String interesGenerado) {
		this.interesGenerado = interesGenerado;
	}
	public String getInteresRecibir() {
		return interesRecibir;
	}
	public void setInteresRecibir(String interesRecibir) {
		this.interesRecibir = interesRecibir;
	}
	public String getInteresRetener() {
		return interesRetener;
	}
	public void setInteresRetener(String interesRetener) {
		this.interesRetener = interesRetener;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getEstatusImpresion() {
		return estatusImpresion;
	}
	public void setEstatusImpresion(String estatusImpresion) {
		this.estatusImpresion = estatusImpresion;
	}
	public String getEtiqueta() {
		return etiqueta;
	}
	public void setEtiqueta(String etiqueta) {
		this.etiqueta = etiqueta;
	}
	public String getValorGat() {
		return valorGat;
	}
	public void setValorGat(String valorGat) {
		this.valorGat = valorGat;
	}
	public String getValorGatReal() {
		return valorGatReal;
	}
	public void setValorGatReal(String valorGatReal) {
		this.valorGatReal = valorGatReal;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getDescripcionTipoInv() {
		return descripcionTipoInv;
	}
	public void setDescripcionTipoInv(String descripcionTipoInv) {
		this.descripcionTipoInv = descripcionTipoInv;
	}
	public String getNombreMoneda() {
		return nombreMoneda;
	}
	public void setNombreMoneda(String nombreMoneda) {
		this.nombreMoneda = nombreMoneda;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public String getUsuarioAutorizaID() {
		return usuarioAutorizaID;
	}
	public void setUsuarioAutorizaID(String usuarioAutorizaID) {
		this.usuarioAutorizaID = usuarioAutorizaID;
	}
	public String getContraseniaUsuarioAutoriza() {
		return contraseniaUsuarioAutoriza;
	}
	public void setContraseniaUsuarioAutoriza(String contraseniaUsuarioAutoriza) {
		this.contraseniaUsuarioAutoriza = contraseniaUsuarioAutoriza;
	}
	public String getDiasTrans() {
		return diasTrans;
	}
	public void setDiasTrans(String diasTrans) {
		this.diasTrans = diasTrans;
	}
	public String getSaldoProvision() {
		return saldoProvision;
	}
	public void setSaldoProvision(String saldoProvision) {
		this.saldoProvision = saldoProvision;
	}
	public String getTipoInversion() {
		return tipoInversion;
	}
	public void setTipoInversion(String tipoInversion) {
		this.tipoInversion = tipoInversion;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getCedeID() {
		return cedeID;
	}
	public void setCedeID(String cedeID) {
		this.cedeID = cedeID;
	}
	public String getTipoCedeID() {
		return tipoCedeID;
	}
	public void setTipoCedeID(String tipoCedeID) {
		this.tipoCedeID = tipoCedeID;
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
	public String getFechaVenAnt() {
		return fechaVenAnt;
	}
	public void setFechaVenAnt(String fechaVenAnt) {
		this.fechaVenAnt = fechaVenAnt;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getTelefono() {
		return telefono;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	public String getSaldoCuenta() {
		return saldoCuenta;
	}
	public void setSaldoCuenta(String saldoCuenta) {
		this.saldoCuenta = saldoCuenta;
	}
	public String getTotalRecibir() {
		return totalRecibir;
	}
	public void setTotalRecibir(String totalRecibir) {
		this.totalRecibir = totalRecibir;
	}
	public String getTasaFija() {
		return tasaFija;
	}
	public void setTasaFija(String tasaFija) {
		this.tasaFija = tasaFija;
	}
	public String getTasaBase() {
		return tasaBase;
	}
	public void setTasaBase(String tasaBase) {
		this.tasaBase = tasaBase;
	}
	public String getSobreTasa() {
		return sobreTasa;
	}
	public void setSobreTasa(String sobreTasa) {
		this.sobreTasa = sobreTasa;
	}
	public String getCalculoInteres() {
		return calculoInteres;
	}
	public void setCalculoInteres(String calculoInteres) {
		this.calculoInteres = calculoInteres;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getCapital() {
		return capital;
	}
	public void setCapital(String capital) {
		this.capital = capital;
	}
	public String getInteres() {
		return interes;
	}
	public void setInteres(String interes) {
		this.interes = interes;
	}
	public String getIsr() {
		return isr;
	}
	public void setIsr(String isr) {
		this.isr = isr;
	}
	public String getTotal() {
		return total;
	}
	public void setTotal(String total) {
		this.total = total;
	}
	public String getNumTran() {
		return numTran;
	}
	public void setNumTran(String numTran) {
		this.numTran = numTran;
	}
	public String getPromotorID() {
		return promotorID;
	}
	public void setPromotorID(String promotorID) {
		this.promotorID = promotorID;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getFechaApertura() {
		return fechaApertura;
	}
	public void setFechaApertura(String fechaApertura) {
		this.fechaApertura = fechaApertura;
	}
	public String getDesCalculoInteres() {
		return desCalculoInteres;
	}
	public void setDesCalculoInteres(String desCalculoInteres) {
		this.desCalculoInteres = desCalculoInteres;
	}
	public String getTipoPagoInt() {
		return tipoPagoInt;
	}
	public void setTipoPagoInt(String tipoPagoInt) {
		this.tipoPagoInt = tipoPagoInt;
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
	public String getTotalISR() {
		return totalISR;
	}
	public void setTotalISR(String totalISR) {
		this.totalISR = totalISR;
	}
	public String getTotalFinal() {
		return totalFinal;
	}
	public void setTotalFinal(String totalFinal) {
		this.totalFinal = totalFinal;
	}
	public String getTasaBaseID() {
		return tasaBaseID;
	}
	public void setTasaBaseID(String tasaBaseID) {
		this.tasaBaseID = tasaBaseID;
	}
	public String getNumCedes() {
		return numCedes;
	}
	public void setNumCedes(String numCedes) {
		this.numCedes = numCedes;
	}
	public String getSegmentacion() {
		return segmentacion;
	}
	public String getRelaciones() {
		return relaciones;
	}
	public void setSegmentacion(String segmentacion) {
		this.segmentacion = segmentacion;
	}
	public void setRelaciones(String relaciones) {
		this.relaciones = relaciones;
	}
	public String getProductoSAFI() {
		return productoSAFI;
	}
	public void setProductoSAFI(String productoSAFI) {
		this.productoSAFI = productoSAFI;
	}
	public String getReinvertir() {
		return reinvertir;
	}
	public void setReinvertir(String reinvertir) {
		this.reinvertir = reinvertir;
	}
	public String getDesReinvertir() {
		return desReinvertir;
	}
	public void setDesReinvertir(String desReinvertir) {
		this.desReinvertir = desReinvertir;
	}
	public String getReinversion() {
		return reinversion;
	}
	public void setReinversion(String reinversion) {
		this.reinversion = reinversion;
	}
	public String getMontosAnclados() {
		return montosAnclados;
	}
	public void setMontosAnclados(String montosAnclados) {
		this.montosAnclados = montosAnclados;
	}
	public String getInteresesAnclados() {
		return interesesAnclados;
	}
	public void setInteresesAnclados(String interesesAnclados) {
		this.interesesAnclados = interesesAnclados;
	}
	public String getCedeMadreID() {
		return cedeMadreID;
	}
	public void setCedeMadreID(String cedeMadreID) {
		this.cedeMadreID = cedeMadreID;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getNuevaTasa() {
		return nuevaTasa;
	}
	public void setNuevaTasa(String nuevaTasa) {
		this.nuevaTasa = nuevaTasa;
	}
	public String getNombrePromotor() {
		return nombrePromotor;
	}
	public void setNombrePromotor(String nombrePromotor) {
		this.nombrePromotor = nombrePromotor;
	}
	public String getDesEstatus() {
		return desEstatus;
	}
	public void setDesEstatus(String desEstatus) {
		this.desEstatus = desEstatus;
	}
	public String getDesTipoCede() {
		return desTipoCede;
	}
	public void setDesTipoCede(String desTipoCede) {
		this.desTipoCede = desTipoCede;
	}
	public String getFormulaInteres() {
		return formulaInteres;
	}
	public void setFormulaInteres(String formulaInteres) {
		this.formulaInteres = formulaInteres;
	}
	public String getDesTasaBase() {
		return desTasaBase;
	}
	public void setDesTasaBase(String desTasaBase) {
		this.desTasaBase = desTasaBase;
	}
	public String getFechaPago() {
		return fechaPago;
	}
	public void setFechaPago(String fechaPago) {
		this.fechaPago = fechaPago;
	}
	public String getCajaRetiro() {
		return cajaRetiro;
	}
	public void setCajaRetiro(String cajaRetiro) {
		this.cajaRetiro = cajaRetiro;
	}
	public String getContrato() {
		return contrato;
	}
	public void setContrato(String contrato) {
		this.contrato = contrato;
	}
	public String getConstancia() {
		return constancia;
	}
	public void setConstancia(String constancia) {
		this.constancia = constancia;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getInicioPeriodo() {
		return inicioPeriodo;
	}
	public void setInicioPeriodo(String inicioPeriodo) {
		this.inicioPeriodo = inicioPeriodo;
	}
	public String getFinPeriodo() {
		return finPeriodo;
	}
	public void setFinPeriodo(String finPeriodo) {
		this.finPeriodo = finPeriodo;
	}
	public String getInteresesPeriodo() {
		return interesesPeriodo;
	}
	public void setInteresesPeriodo(String interesesPeriodo) {
		this.interesesPeriodo = interesesPeriodo;
	}
	public String getDiasPeriodo() {
		return diasPeriodo;
	}
	public void setDiasPeriodo(String diasPeriodo) {
		this.diasPeriodo = diasPeriodo;
	}
	public String getPorcentajeISR() {
		return porcentajeISR;
	}
	public void setPorcentajeISR(String porcentajeISR) {
		this.porcentajeISR = porcentajeISR;
	}
	public String getIsrPeriodo() {
		return isrPeriodo;
	}
	public void setIsrPeriodo(String isrPeriodo) {
		this.isrPeriodo = isrPeriodo;
	}
	public String getPromedio() {
		return promedio;
	}
	public void setPromedio(String promedio) {
		this.promedio = promedio;
	}
	public String getIntAcuPeriodoAnt() {
		return intAcuPeriodoAnt;
	}
	public void setIntAcuPeriodoAnt(String intAcuPeriodoAnt) {
		this.intAcuPeriodoAnt = intAcuPeriodoAnt;
	}
	public String getIntTotalesAcu() {
		return intTotalesAcu;
	}
	public void setIntTotalesAcu(String intTotalesAcu) {
		this.intTotalesAcu = intTotalesAcu;
	}
	public String getIsrTotalAcu() {
		return isrTotalAcu;
	}
	public void setIsrTotalAcu(String isrTotalAcu) {
		this.isrTotalAcu = isrTotalAcu;
	}
	public String getDiasPlazo() {
		return diasPlazo;
	}
	public void setDiasPlazo(String diasPlazo) {
		this.diasPlazo = diasPlazo;
	}
	public String getClientesAct() {
		return clientesAct;
	}
	public void setClientesAct(String clientesAct) {
		this.clientesAct = clientesAct;
	}
	public String getMontoInverCierre() {
		return montoInverCierre;
	}
	public void setMontoInverCierre(String montoInverCierre) {
		this.montoInverCierre = montoInverCierre;
	}
	public String getInteresesDeven() {
		return interesesDeven;
	}
	public void setInteresesDeven(String interesesDeven) {
		this.interesesDeven = interesesDeven;
	}
	public String getInteMontoInver() {
		return inteMontoInver;
	}
	public void setInteMontoInver(String inteMontoInver) {
		this.inteMontoInver = inteMontoInver;
	}
	public String getInteresesPagados() {
		return interesesPagados;
	}
	public void setInteresesPagados(String interesesPagados) {
		this.interesesPagados = interesesPagados;
	}
	public String getInteDevenxPag() {
		return inteDevenxPag;
	}
	public void setInteDevenxPag(String inteDevenxPag) {
		this.inteDevenxPag = inteDevenxPag;
	}
	public String getTipoReporte() {
		return tipoReporte;
	}
	public void setTipoReporte(String tipoReporte) {
		this.tipoReporte = tipoReporte;
	}
	public String getIniPerReporte() {
		return iniPerReporte;
	}
	public void setIniPerReporte(String iniPerReporte) {
		this.iniPerReporte = iniPerReporte;
	}
	public String getFinPerReporte() {
		return finPerReporte;
	}
	public void setFinPerReporte(String finPerReporte) {
		this.finPerReporte = finPerReporte;
	}
	public String getPagoIntCal() {
		return pagoIntCal;
	}
	public void setPagoIntCal(String pagoIntCal) {
		this.pagoIntCal = pagoIntCal;
	}
	public String getEstatusISR() {
		return estatusISR;
	}
	public void setEstatusISR(String estatusISR) {
		this.estatusISR = estatusISR;
	}
}