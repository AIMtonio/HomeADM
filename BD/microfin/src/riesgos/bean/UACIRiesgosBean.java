package riesgos.bean;

import general.bean.BaseBean;
import java.util.List;

public class UACIRiesgosBean  extends BaseBean{
	private String empresaID;
	private String porcCaptadosDia;
	private String porcCarteraVen;
	private String porcPagParcial;
	private String porcPagUnico;
	
	private String porcMayor;
	private String porcZonaGeo;
	private String porcCredConsumo;
	private String porcCredEdad;
	
	private String porcPasCortoPlazo;
	private String porcSumAhoInv;

	private String fechaOperacion;
	private String montoCaptadoDia;
	private String depositoExigibilidad;
	private String ahorroOrdinario;
	private String ahorroVista;
	
	private String depositoInversion;
	private String montoPlazo30;
	private String montoPlazo60;
	private String montoPlazo90;
	private String montoPlazo120;
	
	private String montoPlazo180;
	private String montoPlazo360;
	private String captacionTradicional;
	private String carteraDiaAnterior;
	private String carteraCredVigente;
	
	private String carteraCredVencida;
	private String totalCarteraCredito;
	private String resultadoPorcentual;
	private String parametroPorcentaje;
	private String difLimiteEstablecido;
	
	private String saldoCarteraCredito;
	private String saldoCarteraCreVen;
	private String montoCarteraCredVen;
	private String montoCarteraAnterior;
	private String montoCarteraZona;
	
	private String carteraPuebla;
	private String carteraOaxaca;
	private String carteraVeracruz;
	private String porcentualPuebla;
	private String porcentualOaxaca;
	
	private String porcentualVeracruz;
	private String porcentajePuebla;
	private String porcentajeOaxaca;
	private String porcentajeVeracruz;
	private String limitePuebla;
	
	private String limiteOaxaca;
	private String limiteVeracruz;
	private String creditoConsumo;
	private String creditoComercial;
	private String creditoVivienda;
	
	private String porcentualConsumo;
	private String porcentualComercial;
	private String porcentualVivienda;
	private String porcentajeConsumo;
	private String porcentajeComercial;
	
	private String porcentajeVivienda;
	private String limiteConsumo;
	private String limiteComercial;
	private String limiteVivienda;
	
	private String montoCarteraSocios;
	private String montoCapCierreDia;
	private String capitalNetoMensual;
	
	private String nombreInstitucion;
	private String anio;
	private String mes;
	private String consecutivo;
	private String creditoID;
	
	private String saldoInsoluto;
	private String sucursalID;
	private String totalCreditoPF;
	private String totalCreditoPM;
	private String difMontoCapNeto;
	
	private String montoProductoCredito;
	private String descProducto;
	private String montoCartera;
	private String productoCreditoID;
	private String montoCarteraProducto;
	
	private String difLimiteProd;
	private String montoActEconomica;
	private String descActEconomica;
	private String resPorcentualSecEcon;
	private String paramPorcentajeSecEcon;
	
	private String difLimiteSecEcon;
	private String montoCarteraSucursal;
	private String descSucursal;
	private String resPorcentualSuc;
	private String paramPorcentajeSuc;
	
	private String difLimiteSuc;
	private String clienteID;
	private String montoAhorro;
	private String montoInversion;
	private String sumAhorro;
	private String sumInversion;
	
	private String paramRiesgosID;
	private String descripcion;
	private String dinamico;
	private String porcentaje;
	private String referenciaID;
	
	private List lparamRiesgosID;
	private List lporcentaje;
	private List ldescripcion;
	private List lreferencia;
	
	private String ahorroPlazo;
	private String ahorroMenores;
	private String totalSaldoInsolutoPF;
	private String totalSaldoInsolutoPM;
	private String totalSaldoInsoluto;
	
	private String porcentualAhorroVista;
	private String porcentualInversiones;
	private String porcentajeAhorroVista;
	private String porcentajeInversiones;
	private String diferenciaAhorroVista;
	
	private String diferenciaInversiones;
	private String institucionID;
	private String tipoInversion;
	private String resultadoPorcCar;
	private String difLimiteEstabCar;
	
	private String parametroPorcCar;
	private String saldoCarteraCreVencida;
	private String saldoTotalCartera;
	private String resultadoPorcCredito;
	private String parametroPorcCredito;
	
	private String difLimiteEstabCredito;
	private String saldoCartera;
	private String saldoCarteraZona;
	private String carteraPue;
	private String carteraOax;
	
	private String carteraVer;
	private String porcentualPue;
	private String porcentualOax;
	private String porcentualVer;
	private String porcentajePue;
	
	private String porcentajeOax;
	private String porcentajeVer;
	private String limitePue;
	private String limiteOax;
	private String limiteVer;
	
	private String credConsumo;
	private String credComercial;
	private String credVivienda;
	private String porcentConsumo;
	private String porcentComercial;
	
	private String porcentVivienda;
	private String porcConsumo;
	private String porcComercial;
	private String porcVivienda;
	private String diferenciaConsumo;
	
	private String diferenciaComercial;
	private String diferenciaVivienda;
	private String resPorcentualPro;
	private String paramPorcentajePro;
	private String difLimitePro;
	
	private String saldoCaptadoDia;
	private String salAhorroMenores;
	private String salAhorroOrdinario;
	private String salAhorroVista;
	private String saldoPlazo30;
	
	private String saldoPorcentual;
	private String saldoPorcentaje;
	private String saldoDiferencia;
	private String saldDepExigibilidad;
	private String saldDepInversion;
	
	private String saldoPlazo60;
	private String saldoPlazo90;
	private String saldoPlazo120;
	private String saldoPlazo180;
	private String saldoPlazo360;
	
	private String salCapTradicional;
	private String salCapitalNetoMensual;
	private String salAhorroPlazo;
	private String saldoCredVigente;
	private String saldoCredVencida;
	
	private String saldoInversion;
	private String salPorcentualAhorroVista;
	private String salPorcentualInversiones;
	private String salPorcentajeAhorroVista;
	private String salPorcentajeInversiones;
	
	private String salDiferenciaAhorroVista;
	private String salDiferenciaInversiones;
	private String cuentaSinMov;
	private String salCuentaSinMov;
	private String montoInteresMensual;
	
	private String saldoInteresMensual;
	private String SaldoOrdinario;
	private String sumAhorroOrdin;
	private String sumAhorroVista;

    private String montoVistaOrdinario;
    private String saldoVistaOrdinario;
	
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getPorcCaptadosDia() {
		return porcCaptadosDia;
	}
	public void setPorcCaptadosDia(String porcCaptadosDia) {
		this.porcCaptadosDia = porcCaptadosDia;
	}
	public String getPorcCarteraVen() {
		return porcCarteraVen;
	}
	public void setPorcCarteraVen(String porcCarteraVen) {
		this.porcCarteraVen = porcCarteraVen;
	}
	public String getPorcPagParcial() {
		return porcPagParcial;
	}
	public void setPorcPagParcial(String porcPagParcial) {
		this.porcPagParcial = porcPagParcial;
	}
	public String getPorcPagUnico() {
		return porcPagUnico;
	}
	public void setPorcPagUnico(String porcPagUnico) {
		this.porcPagUnico = porcPagUnico;
	}
	public String getPorcMayor() {
		return porcMayor;
	}
	public void setPorcMayor(String porcMayor) {
		this.porcMayor = porcMayor;
	}
	public String getPorcZonaGeo() {
		return porcZonaGeo;
	}
	public void setPorcZonaGeo(String porcZonaGeo) {
		this.porcZonaGeo = porcZonaGeo;
	}
	public String getPorcCredConsumo() {
		return porcCredConsumo;
	}
	public void setPorcCredConsumo(String porcCredConsumo) {
		this.porcCredConsumo = porcCredConsumo;
	}
	public String getPorcCredEdad() {
		return porcCredEdad;
	}
	public void setPorcCredEdad(String porcCredEdad) {
		this.porcCredEdad = porcCredEdad;
	}
	public String getPorcPasCortoPlazo() {
		return porcPasCortoPlazo;
	}
	public void setPorcPasCortoPlazo(String porcPasCortoPlazo) {
		this.porcPasCortoPlazo = porcPasCortoPlazo;
	}
	public String getPorcSumAhoInv() {
		return porcSumAhoInv;
	}
	public void setPorcSumAhoInv(String porcSumAhoInv) {
		this.porcSumAhoInv = porcSumAhoInv;
	}
	public String getFechaOperacion() {
		return fechaOperacion;
	}
	public void setFechaOperacion(String fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}
	public String getMontoCaptadoDia() {
		return montoCaptadoDia;
	}
	public void setMontoCaptadoDia(String montoCaptadoDia) {
		this.montoCaptadoDia = montoCaptadoDia;
	}
	public String getDepositoExigibilidad() {
		return depositoExigibilidad;
	}
	public void setDepositoExigibilidad(String depositoExigibilidad) {
		this.depositoExigibilidad = depositoExigibilidad;
	}
	public String getAhorroOrdinario() {
		return ahorroOrdinario;
	}
	public void setAhorroOrdinario(String ahorroOrdinario) {
		this.ahorroOrdinario = ahorroOrdinario;
	}
	public String getAhorroVista() {
		return ahorroVista;
	}
	public void setAhorroVista(String ahorroVista) {
		this.ahorroVista = ahorroVista;
	}
	public String getDepositoInversion() {
		return depositoInversion;
	}
	public void setDepositoInversion(String depositoInversion) {
		this.depositoInversion = depositoInversion;
	}
	public String getMontoPlazo30() {
		return montoPlazo30;
	}
	public void setMontoPlazo30(String montoPlazo30) {
		this.montoPlazo30 = montoPlazo30;
	}
	public String getMontoPlazo60() {
		return montoPlazo60;
	}
	public void setMontoPlazo60(String montoPlazo60) {
		this.montoPlazo60 = montoPlazo60;
	}
	public String getMontoPlazo90() {
		return montoPlazo90;
	}
	public void setMontoPlazo90(String montoPlazo90) {
		this.montoPlazo90 = montoPlazo90;
	}
	public String getMontoPlazo120() {
		return montoPlazo120;
	}
	public void setMontoPlazo120(String montoPlazo120) {
		this.montoPlazo120 = montoPlazo120;
	}
	public String getMontoPlazo180() {
		return montoPlazo180;
	}
	public void setMontoPlazo180(String montoPlazo180) {
		this.montoPlazo180 = montoPlazo180;
	}
	
	public String getMontoPlazo360() {
		return montoPlazo360;
	}
	public void setMontoPlazo360(String montoPlazo360) {
		this.montoPlazo360 = montoPlazo360;
	}
	public String getCaptacionTradicional() {
		return captacionTradicional;
	}
	public void setCaptacionTradicional(String captacionTradicional) {
		this.captacionTradicional = captacionTradicional;
	}
	public String getCarteraDiaAnterior() {
		return carteraDiaAnterior;
	}
	public void setCarteraDiaAnterior(String carteraDiaAnterior) {
		this.carteraDiaAnterior = carteraDiaAnterior;
	}
	public String getCarteraCredVigente() {
		return carteraCredVigente;
	}
	public void setCarteraCredVigente(String carteraCredVigente) {
		this.carteraCredVigente = carteraCredVigente;
	}
	public String getCarteraCredVencida() {
		return carteraCredVencida;
	}
	public void setCarteraCredVencida(String carteraCredVencida) {
		this.carteraCredVencida = carteraCredVencida;
	}
	public String getTotalCarteraCredito() {
		return totalCarteraCredito;
	}
	public void setTotalCarteraCredito(String totalCarteraCredito) {
		this.totalCarteraCredito = totalCarteraCredito;
	}
	public String getResultadoPorcentual() {
		return resultadoPorcentual;
	}
	public void setResultadoPorcentual(String resultadoPorcentual) {
		this.resultadoPorcentual = resultadoPorcentual;
	}
	public String getParametroPorcentaje() {
		return parametroPorcentaje;
	}
	public void setParametroPorcentaje(String parametroPorcentaje) {
		this.parametroPorcentaje = parametroPorcentaje;
	}
	public String getDifLimiteEstablecido() {
		return difLimiteEstablecido;
	}
	public void setDifLimiteEstablecido(String difLimiteEstablecido) {
		this.difLimiteEstablecido = difLimiteEstablecido;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getSaldoCarteraCredito() {
		return saldoCarteraCredito;
	}
	public void setSaldoCarteraCredito(String saldoCarteraCredito) {
		this.saldoCarteraCredito = saldoCarteraCredito;
	}
	public String getSaldoCarteraCreVen() {
		return saldoCarteraCreVen;
	}
	public void setSaldoCarteraCreVen(String saldoCarteraCreVen) {
		this.saldoCarteraCreVen = saldoCarteraCreVen;
	}
	public String getMontoCarteraCredVen() {
		return montoCarteraCredVen;
	}
	public void setMontoCarteraCredVen(String montoCarteraCredVen) {
		this.montoCarteraCredVen = montoCarteraCredVen;
	}
	public String getMontoCarteraAnterior() {
		return montoCarteraAnterior;
	}
	public void setMontoCarteraAnterior(String montoCarteraAnterior) {
		this.montoCarteraAnterior = montoCarteraAnterior;
	}
	public String getMontoCarteraZona() {
		return montoCarteraZona;
	}
	public void setMontoCarteraZona(String montoCarteraZona) {
		this.montoCarteraZona = montoCarteraZona;
	}
	public String getCarteraPuebla() {
		return carteraPuebla;
	}
	public void setCarteraPuebla(String carteraPuebla) {
		this.carteraPuebla = carteraPuebla;
	}
	public String getCarteraOaxaca() {
		return carteraOaxaca;
	}
	public void setCarteraOaxaca(String carteraOaxaca) {
		this.carteraOaxaca = carteraOaxaca;
	}
	public String getCarteraVeracruz() {
		return carteraVeracruz;
	}
	public void setCarteraVeracruz(String carteraVeracruz) {
		this.carteraVeracruz = carteraVeracruz;
	}
	public String getPorcentualPuebla() {
		return porcentualPuebla;
	}
	public void setPorcentualPuebla(String porcentualPuebla) {
		this.porcentualPuebla = porcentualPuebla;
	}
	public String getPorcentualOaxaca() {
		return porcentualOaxaca;
	}
	public void setPorcentualOaxaca(String porcentualOaxaca) {
		this.porcentualOaxaca = porcentualOaxaca;
	}
	public String getPorcentualVeracruz() {
		return porcentualVeracruz;
	}
	public void setPorcentualVeracruz(String porcentualVeracruz) {
		this.porcentualVeracruz = porcentualVeracruz;
	}
	public String getPorcentajePuebla() {
		return porcentajePuebla;
	}
	public void setPorcentajePuebla(String porcentajePuebla) {
		this.porcentajePuebla = porcentajePuebla;
	}
	public String getPorcentajeOaxaca() {
		return porcentajeOaxaca;
	}
	public void setPorcentajeOaxaca(String porcentajeOaxaca) {
		this.porcentajeOaxaca = porcentajeOaxaca;
	}
	public String getPorcentajeVeracruz() {
		return porcentajeVeracruz;
	}
	public void setPorcentajeVeracruz(String porcentajeVeracruz) {
		this.porcentajeVeracruz = porcentajeVeracruz;
	}
	public String getLimitePuebla() {
		return limitePuebla;
	}
	public void setLimitePuebla(String limitePuebla) {
		this.limitePuebla = limitePuebla;
	}
	public String getLimiteOaxaca() {
		return limiteOaxaca;
	}
	public void setLimiteOaxaca(String limiteOaxaca) {
		this.limiteOaxaca = limiteOaxaca;
	}
	public String getLimiteVeracruz() {
		return limiteVeracruz;
	}
	public void setLimiteVeracruz(String limiteVeracruz) {
		this.limiteVeracruz = limiteVeracruz;
	}
	public String getCreditoConsumo() {
		return creditoConsumo;
	}
	public void setCreditoConsumo(String creditoConsumo) {
		this.creditoConsumo = creditoConsumo;
	}
	public String getCreditoComercial() {
		return creditoComercial;
	}
	public void setCreditoComercial(String creditoComercial) {
		this.creditoComercial = creditoComercial;
	}
	public String getCreditoVivienda() {
		return creditoVivienda;
	}
	public void setCreditoVivienda(String creditoVivienda) {
		this.creditoVivienda = creditoVivienda;
	}
	public String getPorcentualConsumo() {
		return porcentualConsumo;
	}
	public void setPorcentualConsumo(String porcentualConsumo) {
		this.porcentualConsumo = porcentualConsumo;
	}
	public String getPorcentualComercial() {
		return porcentualComercial;
	}
	public void setPorcentualComercial(String porcentualComercial) {
		this.porcentualComercial = porcentualComercial;
	}
	public String getPorcentualVivienda() {
		return porcentualVivienda;
	}
	public void setPorcentualVivienda(String porcentualVivienda) {
		this.porcentualVivienda = porcentualVivienda;
	}
	public String getPorcentajeConsumo() {
		return porcentajeConsumo;
	}
	public void setPorcentajeConsumo(String porcentajeConsumo) {
		this.porcentajeConsumo = porcentajeConsumo;
	}
	public String getPorcentajeComercial() {
		return porcentajeComercial;
	}
	public void setPorcentajeComercial(String porcentajeComercial) {
		this.porcentajeComercial = porcentajeComercial;
	}
	public String getPorcentajeVivienda() {
		return porcentajeVivienda;
	}
	public void setPorcentajeVivienda(String porcentajeVivienda) {
		this.porcentajeVivienda = porcentajeVivienda;
	}
	public String getLimiteConsumo() {
		return limiteConsumo;
	}
	public void setLimiteConsumo(String limiteConsumo) {
		this.limiteConsumo = limiteConsumo;
	}
	public String getLimiteComercial() {
		return limiteComercial;
	}
	public void setLimiteComercial(String limiteComercial) {
		this.limiteComercial = limiteComercial;
	}
	public String getLimiteVivienda() {
		return limiteVivienda;
	}
	public void setLimiteVivienda(String limiteVivienda) {
		this.limiteVivienda = limiteVivienda;
	}
	public String getMontoCarteraSocios() {
		return montoCarteraSocios;
	}
	public void setMontoCarteraSocios(String montoCarteraSocios) {
		this.montoCarteraSocios = montoCarteraSocios;
	}
	public String getMontoCapCierreDia() {
		return montoCapCierreDia;
	}
	public void setMontoCapCierreDia(String montoCapCierreDia) {
		this.montoCapCierreDia = montoCapCierreDia;
	}
	public String getCapitalNetoMensual() {
		return capitalNetoMensual;
	}
	public void setCapitalNetoMensual(String capitalNetoMensual) {
		this.capitalNetoMensual = capitalNetoMensual;
	}
	public String getAnio() {
		return anio;
	}
	public void setAnio(String anio) {
		this.anio = anio;
	}
	public String getMes() {
		return mes;
	}
	public void setMes(String mes) {
		this.mes = mes;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getSaldoInsoluto() {
		return saldoInsoluto;
	}
	public void setSaldoInsoluto(String saldoInsoluto) {
		this.saldoInsoluto = saldoInsoluto;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getTotalCreditoPF() {
		return totalCreditoPF;
	}
	public void setTotalCreditoPF(String totalCreditoPF) {
		this.totalCreditoPF = totalCreditoPF;
	}
	public String getTotalCreditoPM() {
		return totalCreditoPM;
	}
	public void setTotalCreditoPM(String totalCreditoPM) {
		this.totalCreditoPM = totalCreditoPM;
	}
	public String getDifMontoCapNeto() {
		return difMontoCapNeto;
	}
	public void setDifMontoCapNeto(String difMontoCapNeto) {
		this.difMontoCapNeto = difMontoCapNeto;
	}
	public String getMontoProductoCredito() {
		return montoProductoCredito;
	}
	public void setMontoProductoCredito(String montoProductoCredito) {
		this.montoProductoCredito = montoProductoCredito;
	}
	public String getDescProducto() {
		return descProducto;
	}
	public void setDescProducto(String descProducto) {
		this.descProducto = descProducto;
	}
	public String getMontoCartera() {
		return montoCartera;
	}
	public void setMontoCartera(String montoCartera) {
		this.montoCartera = montoCartera;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getMontoCarteraProducto() {
		return montoCarteraProducto;
	}
	public void setMontoCarteraProducto(String montoCarteraProducto) {
		this.montoCarteraProducto = montoCarteraProducto;
	}
	public String getDifLimiteProd() {
		return difLimiteProd;
	}
	public void setDifLimiteProd(String difLimiteProd) {
		this.difLimiteProd = difLimiteProd;
	}
	public String getResPorcentualSecEcon() {
		return resPorcentualSecEcon;
	}
	public void setResPorcentualSecEcon(String resPorcentualSecEcon) {
		this.resPorcentualSecEcon = resPorcentualSecEcon;
	}
	public String getParamPorcentajeSecEcon() {
		return paramPorcentajeSecEcon;
	}
	public void setParamPorcentajeSecEcon(String paramPorcentajeSecEcon) {
		this.paramPorcentajeSecEcon = paramPorcentajeSecEcon;
	}
	public String getDifLimiteSecEcon() {
		return difLimiteSecEcon;
	}
	public void setDifLimiteSecEcon(String difLimiteSecEcon) {
		this.difLimiteSecEcon = difLimiteSecEcon;
	}
	public String getMontoActEconomica() {
		return montoActEconomica;
	}
	public void setMontoActEconomica(String montoActEconomica) {
		this.montoActEconomica = montoActEconomica;
	}
	public String getDescActEconomica() {
		return descActEconomica;
	}
	public void setDescActEconomica(String descActEconomica) {
		this.descActEconomica = descActEconomica;
	}
	public String getMontoCarteraSucursal() {
		return montoCarteraSucursal;
	}
	public void setMontoCarteraSucursal(String montoCarteraSucursal) {
		this.montoCarteraSucursal = montoCarteraSucursal;
	}
	public String getDescSucursal() {
		return descSucursal;
	}
	public void setDescSucursal(String descSucursal) {
		this.descSucursal = descSucursal;
	}
	public String getResPorcentualSuc() {
		return resPorcentualSuc;
	}
	public void setResPorcentualSuc(String resPorcentualSuc) {
		this.resPorcentualSuc = resPorcentualSuc;
	}
	public String getParamPorcentajeSuc() {
		return paramPorcentajeSuc;
	}
	public void setParamPorcentajeSuc(String paramPorcentajeSuc) {
		this.paramPorcentajeSuc = paramPorcentajeSuc;
	}
	public String getDifLimiteSuc() {
		return difLimiteSuc;
	}
	public void setDifLimiteSuc(String difLimiteSuc) {
		this.difLimiteSuc = difLimiteSuc;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getMontoAhorro() {
		return montoAhorro;
	}
	public void setMontoAhorro(String montoAhorro) {
		this.montoAhorro = montoAhorro;
	}
	public String getMontoInversion() {
		return montoInversion;
	}
	public void setMontoInversion(String montoInversion) {
		this.montoInversion = montoInversion;
	}
	public String getSumAhorro() {
		return sumAhorro;
	}
	public void setSumAhorro(String sumAhorro) {
		this.sumAhorro = sumAhorro;
	}
	public String getSumInversion() {
		return sumInversion;
	}
	public void setSumInversion(String sumInversion) {
		this.sumInversion = sumInversion;
	}
	public String getParamRiesgosID() {
		return paramRiesgosID;
	}
	public void setParamRiesgosID(String paramRiesgosID) {
		this.paramRiesgosID = paramRiesgosID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getDinamico() {
		return dinamico;
	}
	public void setDinamico(String dinamico) {
		this.dinamico = dinamico;
	}
	public String getPorcentaje() {
		return porcentaje;
	}
	public void setPorcentaje(String porcentaje) {
		this.porcentaje = porcentaje;
	}
	public List getLparamRiesgosID() {
		return lparamRiesgosID;
	}
	public void setLparamRiesgosID(List lparamRiesgosID) {
		this.lparamRiesgosID = lparamRiesgosID;
	}
	public List getLporcentaje() {
		return lporcentaje;
	}
	public void setLporcentaje(List lporcentaje) {
		this.lporcentaje = lporcentaje;
	}
	public List getLdescripcion() {
		return ldescripcion;
	}
	public void setLdescripcion(List ldescripcion) {
		this.ldescripcion = ldescripcion;
	}
	public List getLreferencia() {
		return lreferencia;
	}
	public void setLreferencia(List lreferencia) {
		this.lreferencia = lreferencia;
	}
	public String getReferenciaID() {
		return referenciaID;
	}
	public void setReferenciaID(String referenciaID) {
		this.referenciaID = referenciaID;
	}
	public String getAhorroPlazo() {
		return ahorroPlazo;
	}
	public void setAhorroPlazo(String ahorroPlazo) {
		this.ahorroPlazo = ahorroPlazo;
	}
	public String getAhorroMenores() {
		return ahorroMenores;
	}
	public void setAhorroMenores(String ahorroMenores) {
		this.ahorroMenores = ahorroMenores;
	}
	public String getTotalSaldoInsolutoPF() {
		return totalSaldoInsolutoPF;
	}
	public void setTotalSaldoInsolutoPF(String totalSaldoInsolutoPF) {
		this.totalSaldoInsolutoPF = totalSaldoInsolutoPF;
	}
	public String getTotalSaldoInsolutoPM() {
		return totalSaldoInsolutoPM;
	}
	public void setTotalSaldoInsolutoPM(String totalSaldoInsolutoPM) {
		this.totalSaldoInsolutoPM = totalSaldoInsolutoPM;
	}
	public String getTotalSaldoInsoluto() {
		return totalSaldoInsoluto;
	}
	public void setTotalSaldoInsoluto(String totalSaldoInsoluto) {
		this.totalSaldoInsoluto = totalSaldoInsoluto;
	}
	public String getPorcentualAhorroVista() {
		return porcentualAhorroVista;
	}
	public void setPorcentualAhorroVista(String porcentualAhorroVista) {
		this.porcentualAhorroVista = porcentualAhorroVista;
	}
	public String getPorcentualInversiones() {
		return porcentualInversiones;
	}
	public void setPorcentualInversiones(String porcentualInversiones) {
		this.porcentualInversiones = porcentualInversiones;
	}
	public String getPorcentajeAhorroVista() {
		return porcentajeAhorroVista;
	}
	public void setPorcentajeAhorroVista(String porcentajeAhorroVista) {
		this.porcentajeAhorroVista = porcentajeAhorroVista;
	}
	public String getPorcentajeInversiones() {
		return porcentajeInversiones;
	}
	public void setPorcentajeInversiones(String porcentajeInversiones) {
		this.porcentajeInversiones = porcentajeInversiones;
	}
	public String getDiferenciaAhorroVista() {
		return diferenciaAhorroVista;
	}
	public void setDiferenciaAhorroVista(String diferenciaAhorroVista) {
		this.diferenciaAhorroVista = diferenciaAhorroVista;
	}
	public String getDiferenciaInversiones() {
		return diferenciaInversiones;
	}
	public void setDiferenciaInversiones(String diferenciaInversiones) {
		this.diferenciaInversiones = diferenciaInversiones;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getTipoInversion() {
		return tipoInversion;
	}
	public void setTipoInversion(String tipoInversion) {
		this.tipoInversion = tipoInversion;
	}
	public String getResultadoPorcCar() {
		return resultadoPorcCar;
	}
	public void setResultadoPorcCar(String resultadoPorcCar) {
		this.resultadoPorcCar = resultadoPorcCar;
	}
	public String getDifLimiteEstabCar() {
		return difLimiteEstabCar;
	}
	public void setDifLimiteEstabCar(String difLimiteEstabCar) {
		this.difLimiteEstabCar = difLimiteEstabCar;
	}
	public String getParametroPorcCar() {
		return parametroPorcCar;
	}
	public void setParametroPorcCar(String parametroPorcCar) {
		this.parametroPorcCar = parametroPorcCar;
	}
	public String getSaldoCarteraCreVencida() {
		return saldoCarteraCreVencida;
	}
	public void setSaldoCarteraCreVencida(String saldoCarteraCreVencida) {
		this.saldoCarteraCreVencida = saldoCarteraCreVencida;
	}
	public String getSaldoTotalCartera() {
		return saldoTotalCartera;
	}
	public void setSaldoTotalCartera(String saldoTotalCartera) {
		this.saldoTotalCartera = saldoTotalCartera;
	}
	public String getResultadoPorcCredito() {
		return resultadoPorcCredito;
	}
	public void setResultadoPorcCredito(String resultadoPorcCredito) {
		this.resultadoPorcCredito = resultadoPorcCredito;
	}
	public String getParametroPorcCredito() {
		return parametroPorcCredito;
	}
	public void setParametroPorcCredito(String parametroPorcCredito) {
		this.parametroPorcCredito = parametroPorcCredito;
	}
	public String getDifLimiteEstabCredito() {
		return difLimiteEstabCredito;
	}
	public void setDifLimiteEstabCredito(String difLimiteEstabCredito) {
		this.difLimiteEstabCredito = difLimiteEstabCredito;
	}
	public String getSaldoCartera() {
		return saldoCartera;
	}
	public void setSaldoCartera(String saldoCartera) {
		this.saldoCartera = saldoCartera;
	}
	public String getSaldoCarteraZona() {
		return saldoCarteraZona;
	}
	public void setSaldoCarteraZona(String saldoCarteraZona) {
		this.saldoCarteraZona = saldoCarteraZona;
	}
	public String getCarteraPue() {
		return carteraPue;
	}
	public void setCarteraPue(String carteraPue) {
		this.carteraPue = carteraPue;
	}
	public String getCarteraOax() {
		return carteraOax;
	}
	public void setCarteraOax(String carteraOax) {
		this.carteraOax = carteraOax;
	}
	public String getCarteraVer() {
		return carteraVer;
	}
	public void setCarteraVer(String carteraVer) {
		this.carteraVer = carteraVer;
	}
	public String getPorcentualPue() {
		return porcentualPue;
	}
	public void setPorcentualPue(String porcentualPue) {
		this.porcentualPue = porcentualPue;
	}
	public String getPorcentualOax() {
		return porcentualOax;
	}
	public void setPorcentualOax(String porcentualOax) {
		this.porcentualOax = porcentualOax;
	}
	public String getPorcentualVer() {
		return porcentualVer;
	}
	public void setPorcentualVer(String porcentualVer) {
		this.porcentualVer = porcentualVer;
	}
	public String getPorcentajePue() {
		return porcentajePue;
	}
	public void setPorcentajePue(String porcentajePue) {
		this.porcentajePue = porcentajePue;
	}
	public String getPorcentajeOax() {
		return porcentajeOax;
	}
	public void setPorcentajeOax(String porcentajeOax) {
		this.porcentajeOax = porcentajeOax;
	}
	public String getPorcentajeVer() {
		return porcentajeVer;
	}
	public void setPorcentajeVer(String porcentajeVer) {
		this.porcentajeVer = porcentajeVer;
	}
	public String getLimitePue() {
		return limitePue;
	}
	public void setLimitePue(String limitePue) {
		this.limitePue = limitePue;
	}
	public String getLimiteOax() {
		return limiteOax;
	}
	public void setLimiteOax(String limiteOax) {
		this.limiteOax = limiteOax;
	}
	public String getLimiteVer() {
		return limiteVer;
	}
	public void setLimiteVer(String limiteVer) {
		this.limiteVer = limiteVer;
	}
	public String getCredConsumo() {
		return credConsumo;
	}
	public void setCredConsumo(String credConsumo) {
		this.credConsumo = credConsumo;
	}
	public String getCredComercial() {
		return credComercial;
	}
	public void setCredComercial(String credComercial) {
		this.credComercial = credComercial;
	}
	public String getCredVivienda() {
		return credVivienda;
	}
	public void setCredVivienda(String credVivienda) {
		this.credVivienda = credVivienda;
	}
	public String getPorcentConsumo() {
		return porcentConsumo;
	}
	public void setPorcentConsumo(String porcentConsumo) {
		this.porcentConsumo = porcentConsumo;
	}
	public String getPorcentComercial() {
		return porcentComercial;
	}
	public void setPorcentComercial(String porcentComercial) {
		this.porcentComercial = porcentComercial;
	}
	public String getPorcentVivienda() {
		return porcentVivienda;
	}
	public void setPorcentVivienda(String porcentVivienda) {
		this.porcentVivienda = porcentVivienda;
	}
	public String getPorcConsumo() {
		return porcConsumo;
	}
	public void setPorcConsumo(String porcConsumo) {
		this.porcConsumo = porcConsumo;
	}
	public String getPorcComercial() {
		return porcComercial;
	}
	public void setPorcComercial(String porcComercial) {
		this.porcComercial = porcComercial;
	}
	public String getPorcVivienda() {
		return porcVivienda;
	}
	public void setPorcVivienda(String porcVivienda) {
		this.porcVivienda = porcVivienda;
	}
	public String getDiferenciaConsumo() {
		return diferenciaConsumo;
	}
	public void setDiferenciaConsumo(String diferenciaConsumo) {
		this.diferenciaConsumo = diferenciaConsumo;
	}
	public String getDiferenciaComercial() {
		return diferenciaComercial;
	}
	public void setDiferenciaComercial(String diferenciaComercial) {
		this.diferenciaComercial = diferenciaComercial;
	}
	public String getDiferenciaVivienda() {
		return diferenciaVivienda;
	}
	public void setDiferenciaVivienda(String diferenciaVivienda) {
		this.diferenciaVivienda = diferenciaVivienda;
	}
	public String getResPorcentualPro() {
		return resPorcentualPro;
	}
	public void setResPorcentualPro(String resPorcentualPro) {
		this.resPorcentualPro = resPorcentualPro;
	}
	public String getParamPorcentajePro() {
		return paramPorcentajePro;
	}
	public void setParamPorcentajePro(String paramPorcentajePro) {
		this.paramPorcentajePro = paramPorcentajePro;
	}
	public String getDifLimitePro() {
		return difLimitePro;
	}
	public void setDifLimitePro(String difLimitePro) {
		this.difLimitePro = difLimitePro;
	}
	public String getSaldoCaptadoDia() {
		return saldoCaptadoDia;
	}
	public void setSaldoCaptadoDia(String saldoCaptadoDia) {
		this.saldoCaptadoDia = saldoCaptadoDia;
	}
	public String getSalAhorroMenores() {
		return salAhorroMenores;
	}
	public void setSalAhorroMenores(String salAhorroMenores) {
		this.salAhorroMenores = salAhorroMenores;
	}
	public String getSalAhorroOrdinario() {
		return salAhorroOrdinario;
	}
	public void setSalAhorroOrdinario(String salAhorroOrdinario) {
		this.salAhorroOrdinario = salAhorroOrdinario;
	}
	public String getSalAhorroVista() {
		return salAhorroVista;
	}
	public void setSalAhorroVista(String salAhorroVista) {
		this.salAhorroVista = salAhorroVista;
	}
	public String getSaldoPlazo30() {
		return saldoPlazo30;
	}
	public void setSaldoPlazo30(String saldoPlazo30) {
		this.saldoPlazo30 = saldoPlazo30;
	}
	public String getSaldoPorcentual() {
		return saldoPorcentual;
	}
	public void setSaldoPorcentual(String saldoPorcentual) {
		this.saldoPorcentual = saldoPorcentual;
	}
	public String getSaldoPorcentaje() {
		return saldoPorcentaje;
	}
	public void setSaldoPorcentaje(String saldoPorcentaje) {
		this.saldoPorcentaje = saldoPorcentaje;
	}
	public String getSaldoDiferencia() {
		return saldoDiferencia;
	}
	public void setSaldoDiferencia(String saldoDiferencia) {
		this.saldoDiferencia = saldoDiferencia;
	}
	public String getSaldDepExigibilidad() {
		return saldDepExigibilidad;
	}
	public void setSaldDepExigibilidad(String saldDepExigibilidad) {
		this.saldDepExigibilidad = saldDepExigibilidad;
	}
	public String getSaldDepInversion() {
		return saldDepInversion;
	}
	public void setSaldDepInversion(String saldDepInversion) {
		this.saldDepInversion = saldDepInversion;
	}
	public String getSaldoPlazo60() {
		return saldoPlazo60;
	}
	public void setSaldoPlazo60(String saldoPlazo60) {
		this.saldoPlazo60 = saldoPlazo60;
	}
	public String getSaldoPlazo90() {
		return saldoPlazo90;
	}
	public void setSaldoPlazo90(String saldoPlazo90) {
		this.saldoPlazo90 = saldoPlazo90;
	}
	public String getSaldoPlazo120() {
		return saldoPlazo120;
	}
	public void setSaldoPlazo120(String saldoPlazo120) {
		this.saldoPlazo120 = saldoPlazo120;
	}
	public String getSaldoPlazo180() {
		return saldoPlazo180;
	}
	public void setSaldoPlazo180(String saldoPlazo180) {
		this.saldoPlazo180 = saldoPlazo180;
	}
	public String getSaldoPlazo360() {
		return saldoPlazo360;
	}
	public void setSaldoPlazo360(String saldoPlazo360) {
		this.saldoPlazo360 = saldoPlazo360;
	}
	public String getSalCapTradicional() {
		return salCapTradicional;
	}
	public void setSalCapTradicional(String salCapTradicional) {
		this.salCapTradicional = salCapTradicional;
	}
	public String getSalCapitalNetoMensual() {
		return salCapitalNetoMensual;
	}
	public void setSalCapitalNetoMensual(String salCapitalNetoMensual) {
		this.salCapitalNetoMensual = salCapitalNetoMensual;
	}
	public String getSalAhorroPlazo() {
		return salAhorroPlazo;
	}
	public void setSalAhorroPlazo(String salAhorroPlazo) {
		this.salAhorroPlazo = salAhorroPlazo;
	}
	public String getSaldoCredVigente() {
		return saldoCredVigente;
	}
	public void setSaldoCredVigente(String saldoCredVigente) {
		this.saldoCredVigente = saldoCredVigente;
	}
	public String getSaldoCredVencida() {
		return saldoCredVencida;
	}
	public void setSaldoCredVencida(String saldoCredVencida) {
		this.saldoCredVencida = saldoCredVencida;
	}
	public String getSaldoInversion() {
		return saldoInversion;
	}
	public void setSaldoInversion(String saldoInversion) {
		this.saldoInversion = saldoInversion;
	}
	public String getSalPorcentualAhorroVista() {
		return salPorcentualAhorroVista;
	}
	public void setSalPorcentualAhorroVista(String salPorcentualAhorroVista) {
		this.salPorcentualAhorroVista = salPorcentualAhorroVista;
	}
	public String getSalPorcentualInversiones() {
		return salPorcentualInversiones;
	}
	public void setSalPorcentualInversiones(String salPorcentualInversiones) {
		this.salPorcentualInversiones = salPorcentualInversiones;
	}
	public String getSalPorcentajeAhorroVista() {
		return salPorcentajeAhorroVista;
	}
	public void setSalPorcentajeAhorroVista(String salPorcentajeAhorroVista) {
		this.salPorcentajeAhorroVista = salPorcentajeAhorroVista;
	}
	public String getSalPorcentajeInversiones() {
		return salPorcentajeInversiones;
	}
	public void setSalPorcentajeInversiones(String salPorcentajeInversiones) {
		this.salPorcentajeInversiones = salPorcentajeInversiones;
	}
	public String getSalDiferenciaAhorroVista() {
		return salDiferenciaAhorroVista;
	}
	public void setSalDiferenciaAhorroVista(String salDiferenciaAhorroVista) {
		this.salDiferenciaAhorroVista = salDiferenciaAhorroVista;
	}
	public String getSalDiferenciaInversiones() {
		return salDiferenciaInversiones;
	}
	public void setSalDiferenciaInversiones(String salDiferenciaInversiones) {
		this.salDiferenciaInversiones = salDiferenciaInversiones;
	}
	public String getCuentaSinMov() {
		return cuentaSinMov;
	}
	public void setCuentaSinMov(String cuentaSinMov) {
		this.cuentaSinMov = cuentaSinMov;
	}
	public String getSalCuentaSinMov() {
		return salCuentaSinMov;
	}
	public void setSalCuentaSinMov(String salCuentaSinMov) {
		this.salCuentaSinMov = salCuentaSinMov;
	}
	public String getMontoInteresMensual() {
		return montoInteresMensual;
	}
	public void setMontoInteresMensual(String montoInteresMensual) {
		this.montoInteresMensual = montoInteresMensual;
	}
	public String getSaldoInteresMensual() {
		return saldoInteresMensual;
	}
	public void setSaldoInteresMensual(String saldoInteresMensual) {
		this.saldoInteresMensual = saldoInteresMensual;
	}
	public String getSaldoOrdinario() {
		return SaldoOrdinario;
	}
	public void setSaldoOrdinario(String saldoOrdinario) {
		SaldoOrdinario = saldoOrdinario;
	}
	public String getSumAhorroOrdin() {
		return sumAhorroOrdin;
	}
	public void setSumAhorroOrdin(String sumAhorroOrdin) {
		this.sumAhorroOrdin = sumAhorroOrdin;
	}
	public String getSumAhorroVista() {
		return sumAhorroVista;
	}
	public void setSumAhorroVista(String sumAhorroVista) {
		this.sumAhorroVista = sumAhorroVista;
	}
	public String getMontoVistaOrdinario() {
		return montoVistaOrdinario;
	}
	public void setMontoVistaOrdinario(String montoVistaOrdinario) {
		this.montoVistaOrdinario = montoVistaOrdinario;
	}
	public String getSaldoVistaOrdinario() {
		return saldoVistaOrdinario;
	}
	public void setSaldoVistaOrdinario(String saldoVistaOrdinario) {
		this.saldoVistaOrdinario = saldoVistaOrdinario;
	}

}
