package cliente.bean;

import general.bean.BaseBean;

public class ReportesFOCOOPBean extends BaseBean{
	
	private String empresaID;
	// Beans para Captacion FOCOOP
	private int tipoReporte;
	private String fechaReporte;
	private String numSocio;
	private String nombreSocio;
	private String numCuenta;
	private String sucursal;
	private String fechaApertura;
	private String tipoCuenta;
	private String fechaUltDeposito;
	private String fechaVencimiento;
	private String plazoDeposito;
	private String formaPagRendimientos;
	private String diasCalculoInt;
	private String tasaNominal;
	private String saldoPromedio;
	private String capital;
	private String intDevenNoPagados;
	private String saldoTotalCieMes;
	private String interesesGeneradoMes;
	private String numeroRenov;
	private String numeroReest;
	
	// Beans para Cartera FOCOOP
	private String nombreCompleto;
	private String contrato;
	private String clasificacion;
	private String producto;
	private String modalidaPago;
	private String fechaOtorgamiento;
	private String montoOriginal;	
	private String fechaVencimien;
	private String tasaOrdinaria;
	private String tasaMoratoria;
	private String plazoCredito;
	private String frecuenciaPagoCapital;
	private String frecuenciaPagoIn;
	private String diasMora;
	private String saldoCapitalVigente;
	private String saldoCapitalVencido;
	private String interesDevNoCobVig;
	private String interesDevNoCobVen;
	private String interesDevenNoCobCuentasOrden;
	private String fechaUltPagCap;
	private String montoUltPagCap;
	private String fechaUltPagoInteres;
	private String montoUltPagInteres;
	private String renReesNor;
	private String emproblemado;
	private String vigenteVencido;
	private String cargoDelAcreditado;
	private String montoGarantiaLiquida;
	private String montoGarantiaLiquida1;
	private String cuentaGarantiaLiquida;
	private String cuentaGarantiaLiquida2;
	private String montoGarantiaPrendaria;
	private String montoGarantiaHipoteca;
	private String eprCubierta;
	private String eprExpuesta;
	private String eprInteresesCaVe;
	private String formula;
	
	// beans para Aportaciones
	private String apellidoPaterno;
	private String apellidoMaterno;
	private String CURP;
	private String tipoAportacion;
	private String fechaIngreso;
	private String sexo;
	private String aporteSocio;
	private String interesMoratorio;
	private String garantiaLiquida;
	
	// Auxiliares
	
	private String nombreUsuario;
	private String parFechaEmision;
	private String hora;
	private String nombreInstitucion ; 
	private String tipoRepCar;
	
	// Getter's y Setter's para Captacion FOCOOP	
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public int getTipoReporte() {
		return tipoReporte;
	}
	public void setTipoReporte(int tipoReporte) {
		this.tipoReporte = tipoReporte;
	}
	public String getFechaReporte() {
		return fechaReporte;
	}
	public void setFechaReporte(String fechaReporte) {
		this.fechaReporte = fechaReporte;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getPlazoDeposito() {
		return plazoDeposito;
	}
	public void setPlazoDeposito(String plazoDeposito) {
		this.plazoDeposito = plazoDeposito;
	}
	public String getFormaPagRendimientos() {
		return formaPagRendimientos;
	}
	public void setFormaPagRendimientos(String formaPagRendimientos) {
		this.formaPagRendimientos = formaPagRendimientos;
	}
	public String getDiasCalculoInt() {
		return diasCalculoInt;
	}
	public void setDiasCalculoInt(String diasCalculoInt) {
		this.diasCalculoInt = diasCalculoInt;
	}
	public String getTasaNominal() {
		return tasaNominal;
	}
	public void setTasaNominal(String tasaNominal) {
		this.tasaNominal = tasaNominal;
	}
	public String getSaldoPromedio() {
		return saldoPromedio;
	}
	public void setSaldoPromedio(String saldoPromedio) {
		this.saldoPromedio = saldoPromedio;
	}
	public String getCapital() {
		return capital;
	}
	public void setCapital(String capital) {
		this.capital = capital;
	}
	public String getIntDevenNoPagados() {
		return intDevenNoPagados;
	}
	public void setIntDevenNoPagados(String intDevenNoPagados) {
		this.intDevenNoPagados = intDevenNoPagados;
	}
	public String getSaldoTotalCieMes() {
		return saldoTotalCieMes;
	}
	public void setSaldoTotalCieMes(String saldoTotalCieMes) {
		this.saldoTotalCieMes = saldoTotalCieMes;
	}
	public String getInteresesGeneradoMes() {
		return interesesGeneradoMes;
	}
	public void setInteresesGeneradoMes(String interesesGeneradoMes) {
		this.interesesGeneradoMes = interesesGeneradoMes;
	}
	public String getNumSocio() {
		return numSocio;
	}
	public void setNumSocio(String numSocio) {
		this.numSocio = numSocio;
	}
	public String getNombreSocio() {
		return nombreSocio;
	}
	public void setNombreSocio(String nombreSocio) {
		this.nombreSocio = nombreSocio;
	}
	public String getNumCuenta() {
		return numCuenta;
	}
	public void setNumCuenta(String numCuenta) {
		this.numCuenta = numCuenta;
	}
	public String getFechaApertura() {
		return fechaApertura;
	}
	public void setFechaApertura(String fechaApertura) {
		this.fechaApertura = fechaApertura;
	}
	public String getTipoCuenta() {
		return tipoCuenta;
	}
	public void setTipoCuenta(String tipoCuenta) {
		this.tipoCuenta = tipoCuenta;
	}
	public String getFechaUltDeposito() {
		return fechaUltDeposito;
	}
	public void setFechaUltDeposito(String fechaUltDeposito) {
		this.fechaUltDeposito = fechaUltDeposito;
	}
	
	// Getter's y Setter's para CarteraFOCOOP
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getContrato() {
		return contrato;
	}
	public void setContrato(String contrato) {
		this.contrato = contrato;
	}
	public String getClasificacion() {
		return clasificacion;
	}
	public void setClasificacion(String clasificacion) {
		this.clasificacion = clasificacion;
	}
	public String getProducto() {
		return producto;
	}
	public void setProducto(String producto) {
		this.producto = producto;
	}
	public String getModalidaPago() {
		return modalidaPago;
	}
	public void setModalidaPago(String modalidaPago) {
		this.modalidaPago = modalidaPago;
	}
	public String getFechaOtorgamiento() {
		return fechaOtorgamiento;
	}
	public void setFechaOtorgamiento(String fechaOtorgamiento) {
		this.fechaOtorgamiento = fechaOtorgamiento;
	}
	public String getMontoOriginal() {
		return montoOriginal;
	}
	public void setMontoOriginal(String montoOriginal) {
		this.montoOriginal = montoOriginal;
	}
	public String getFechaVencimien() {
		return fechaVencimien;
	}
	public void setFechaVencimien(String fechaVencimien) {
		this.fechaVencimien = fechaVencimien;
	}
	public String getTasaOrdinaria() {
		return tasaOrdinaria;
	}
	public void setTasaOrdinaria(String tasaOrdinaria) {
		this.tasaOrdinaria = tasaOrdinaria;
	}
	public String getTasaMoratoria() {
		return tasaMoratoria;
	}
	public void setTasaMoratoria(String tasaMoratoria) {
		this.tasaMoratoria = tasaMoratoria;
	}
	public String getPlazoCredito() {
		return plazoCredito;
	}
	public void setPlazoCredito(String plazoCredito) {
		this.plazoCredito = plazoCredito;
	}
	public String getFrecuenciaPagoCapital() {
		return frecuenciaPagoCapital;
	}
	public void setFrecuenciaPagoCapital(String frecuenciaPagoCapital) {
		this.frecuenciaPagoCapital = frecuenciaPagoCapital;
	}
	public String getFrecuenciaPagoIn() {
		return frecuenciaPagoIn;
	}
	public void setFrecuenciaPagoIn(String frecuenciaPagoIn) {
		this.frecuenciaPagoIn = frecuenciaPagoIn;
	}
	public String getDiasMora() {
		return diasMora;
	}
	public void setDiasMora(String diasMora) {
		this.diasMora = diasMora;
	}
	public String getSaldoCapitalVigente() {
		return saldoCapitalVigente;
	}
	public void setSaldoCapitalVigente(String saldoCapitalVigente) {
		this.saldoCapitalVigente = saldoCapitalVigente;
	}
	public String getSaldoCapitalVencido() {
		return saldoCapitalVencido;
	}
	public void setSaldoCapitalVencido(String saldoCapitalVencido) {
		this.saldoCapitalVencido = saldoCapitalVencido;
	}
	public String getInteresDevNoCobVig() {
		return interesDevNoCobVig;
	}
	public void setInteresDevNoCobVig(String interesDevNoCobVig) {
		this.interesDevNoCobVig = interesDevNoCobVig;
	}
	public String getInteresDevNoCobVen() {
		return interesDevNoCobVen;
	}
	public void setInteresDevNoCobVen(String interesDevNoCobVen) {
		this.interesDevNoCobVen = interesDevNoCobVen;
	}
	public String getInteresDevenNoCobCuentasOrden() {
		return interesDevenNoCobCuentasOrden;
	}
	public void setInteresDevenNoCobCuentasOrden(
			String interesDevenNoCobCuentasOrden) {
		this.interesDevenNoCobCuentasOrden = interesDevenNoCobCuentasOrden;
	}
	public String getFechaUltPagCap() {
		return fechaUltPagCap;
	}
	public void setFechaUltPagCap(String fechaUltPagCap) {
		this.fechaUltPagCap = fechaUltPagCap;
	}
	public String getMontoUltPagCap() {
		return montoUltPagCap;
	}
	public void setMontoUltPagCap(String montoUltPagCap) {
		this.montoUltPagCap = montoUltPagCap;
	}
	public String getFechaUltPagoInteres() {
		return fechaUltPagoInteres;
	}
	public void setFechaUltPagoInteres(String fechaUltPagoInteres) {
		this.fechaUltPagoInteres = fechaUltPagoInteres;
	}
	public String getMontoUltPagInteres() {
		return montoUltPagInteres;
	}
	public void setMontoUltPagInteres(String montoUltPagInteres) {
		this.montoUltPagInteres = montoUltPagInteres;
	}
	public String getRenReesNor() {
		return renReesNor;
	}
	public void setRenReesNor(String renReesNor) {
		this.renReesNor = renReesNor;
	}
	public String getEmproblemado() {
		return emproblemado;
	}
	public void setEmproblemado(String emproblemado) {
		this.emproblemado = emproblemado;
	}
	public String getVigenteVencido() {
		return vigenteVencido;
	}
	public void setVigenteVencido(String vigenteVencido) {
		this.vigenteVencido = vigenteVencido;
	}
	public String getCargoDelAcreditado() {
		return cargoDelAcreditado;
	}
	public void setCargoDelAcreditado(String cargoDelAcreditado) {
		this.cargoDelAcreditado = cargoDelAcreditado;
	}
	public String getMontoGarantiaLiquida() {
		return montoGarantiaLiquida;
	}
	public void setMontoGarantiaLiquida(String montoGarantiaLiquida) {
		this.montoGarantiaLiquida = montoGarantiaLiquida;
	}
	public String getMontoGarantiaLiquida1() {
		return montoGarantiaLiquida1;
	}
	public void setMontoGarantiaLiquida1(String montoGarantiaLiquida1) {
		this.montoGarantiaLiquida1 = montoGarantiaLiquida1;
	}
	public String getCuentaGarantiaLiquida() {
		return cuentaGarantiaLiquida;
	}
	public void setCuentaGarantiaLiquida(String cuentaGarantiaLiquida) {
		this.cuentaGarantiaLiquida = cuentaGarantiaLiquida;
	}
	public String getCuentaGarantiaLiquida2() {
		return cuentaGarantiaLiquida2;
	}
	public void setCuentaGarantiaLiquida2(String cuentaGarantiaLiquida2) {
		this.cuentaGarantiaLiquida2 = cuentaGarantiaLiquida2;
	}
	public String getMontoGarantiaPrendaria() {
		return montoGarantiaPrendaria;
	}
	public void setMontoGarantiaPrendaria(String montoGarantiaPrendaria) {
		this.montoGarantiaPrendaria = montoGarantiaPrendaria;
	}
	public String getMontoGarantiaHipoteca() {
		return montoGarantiaHipoteca;
	}
	public void setMontoGarantiaHipoteca(String montoGarantiaHipoteca) {
		this.montoGarantiaHipoteca = montoGarantiaHipoteca;
	}
	public String getEprCubierta() {
		return eprCubierta;
	}
	public void setEprCubierta(String eprCubierta) {
		this.eprCubierta = eprCubierta;
	}
	public String getEprExpuesta() {
		return eprExpuesta;
	}
	public void setEprExpuesta(String eprExpuesta) {
		this.eprExpuesta = eprExpuesta;
	}
	public String getEprInteresesCaVe() {
		return eprInteresesCaVe;
	}
	public void setEprInteresesCaVe(String eprInteresesCaVe) {
		this.eprInteresesCaVe = eprInteresesCaVe;
	}
	public String getApellidoPaterno() {
		return apellidoPaterno;
	}
	public void setApellidoPaterno(String apellidoPaterno) {
		this.apellidoPaterno = apellidoPaterno;
	}
	public String getApellidoMaterno() {
		return apellidoMaterno;
	}
	public void setApellidoMaterno(String apellidoMaterno) {
		this.apellidoMaterno = apellidoMaterno;
	}
	public String getCURP() {
		return CURP;
	}
	public void setCURP(String cURP) {
		CURP = cURP;
	}
	public String getTipoAportacion() {
		return tipoAportacion;
	}
	public void setTipoAportacion(String tipoAportacion) {
		this.tipoAportacion = tipoAportacion;
	}
	public String getFechaIngreso() {
		return fechaIngreso;
	}
	public void setFechaIngreso(String fechaIngreso) {
		this.fechaIngreso = fechaIngreso;
	}
	public String getSexo() {
		return sexo;
	}
	public void setSexo(String sexo) {
		this.sexo = sexo;
	}
	public String getAporteSocio() {
		return aporteSocio;
	}
	public void setAporteSocio(String aporteSocio) {
		this.aporteSocio = aporteSocio;
	}
	public String getInteresMoratorio() {
		return interesMoratorio;
	}
	public void setInteresMoratorio(String interesMoratorio) {
		this.interesMoratorio = interesMoratorio;
	}
	public String getGarantiaLiquida() {
		return garantiaLiquida;
	}
	public void setGarantiaLiquida(String garantiaLiquida) {
		this.garantiaLiquida = garantiaLiquida;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getParFechaEmision() {
		return parFechaEmision;
	}
	public void setParFechaEmision(String parFechaEmision) {
		this.parFechaEmision = parFechaEmision;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getFormula() {
		return formula;
	}
	public void setFormula(String formula) {
		this.formula = formula;
	}
	public String getTipoRepCar() {
		return tipoRepCar;
	}
	public void setTipoRepCar(String tipoRepCar) {
		this.tipoRepCar = tipoRepCar;
	}
	public String getNumeroRenov() {
		return numeroRenov;
	}
	public void setNumeroRenov(String numeroRenov) {
		this.numeroRenov = numeroRenov;
	}
	public String getNumeroReest() {
		return numeroReest;
	}
	public void setNumeroReest(String numeroReest) {
		this.numeroReest = numeroReest;
	}

}
