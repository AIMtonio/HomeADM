package tesoreria.bean;

import general.bean.BaseBean;

import org.springframework.web.multipart.commons.CommonsMultipartFile;

public class DepositosRefeBean extends BaseBean{
		
	private String folioCargaID;
	private String cuentaAhoID;
	private String numeroMov;
	private String institucionID;
	private String numCtaInstit;
	private String fechaCarga;
	private String fechaValor;
	private String fechaOperacion;
	private String natMovimiento;
	private String montoMov;
	private String tipoMov;
	private String descripcionMov;
	private String referenciaMov;
	private String status;
	private String montoPendApli;
	private String tipoCanal;
	private String tipoDeposito;
	private String tipoMoneda;
	private String descrMoneda;
	private String referenNoIden;
	private String descripNoIden;
	private String bancoEstandar;
	
	//auxiliares de fechas
	private String fechaCargaInicial;
	private String fechaCargaFinal;
	
	
	private String NumError;
	private String DescError;
	private int LineaError;
	private String validacion;
	private String listaAplicaRef;
	private String numTranAnt;
	private String numVal;
	private String altaPoliza;
	private String polizaID;
	private String numTransaccion;
	private String numIdenArchivo;
	private int numReg;
	private String numeroFila;
	private String aplicarDeposito;
	private String nombreArchivoCarga;
	private String numTran;
	private String cargaLayoutXLSDepRef;
	private String opeInusualID;

	// Auxiliar para Limite de Depositos de Cuentas
	private String grabaLimitesCta;
    
	public String getNumError() {
		return NumError;
	}

	public void setNumError(String numError) {
		NumError = numError;
	}

	public String getDescError() {
		return DescError;
	}

	public void setDescError(String descError) {
		DescError = descError;
	}

	public int getLineaError() {
		return LineaError;
	}

	public void setLineaError(int lineaError) {
		LineaError = lineaError;
	}

	public String getReferenNoIden() {
		return referenNoIden;
	}

	public void setReferenNoIden(String referenNoIden) {
		this.referenNoIden = referenNoIden;
	}

	public String getDescripNoIden() {
		return descripNoIden;
	}

	public void setDescripNoIden(String descripNoIden) {
		this.descripNoIden = descripNoIden;
	}

	public String getDescrMoneda() {
		return descrMoneda;
	}

	public void setDescrMoneda(String descrMoneda) {
		this.descrMoneda = descrMoneda;
	}

	private CommonsMultipartFile file = null;

	public String getFolioCargaID() {
		return folioCargaID;
	}

	public void setFolioCargaID(String folioCargaID) {
		this.folioCargaID = folioCargaID;
	}

	public String getCuentaAhoID() {
		return cuentaAhoID;
	}

	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}

	public String getNumeroMov() {
		return numeroMov;
	}

	public void setNumeroMov(String numeroMov) {
		this.numeroMov = numeroMov;
	}

	public String getInstitucionID() {
		return institucionID;
	}

	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}

	public String getNumCtaInstit() {
		return numCtaInstit;
	}

	public void setNumCtaInstit(String numCtaInstit) {
		this.numCtaInstit = numCtaInstit;
	}

	public String getFechaCarga() {
		return fechaCarga;
	}

	public void setFechaCarga(String fechaCarga) {
		this.fechaCarga = fechaCarga;
	}

	public String getFechaValor() {
		return fechaValor;
	}

	public void setFechaValor(String fechaValor) {
		this.fechaValor = fechaValor;
	}

	public String getFechaOperacion() {
		return fechaOperacion;
	}

	public void setFechaOperacion(String fechaOperacion) {
		this.fechaOperacion = fechaOperacion;
	}

	public String getNatMovimiento() {
		return natMovimiento;
	}

	public void setNatMovimiento(String natMovimiento) {
		this.natMovimiento = natMovimiento;
	}

	public String getMontoMov() {
		return montoMov;
	}

	public void setMontoMov(String montoMov) {
		this.montoMov = montoMov;
	}

	public String getTipoMov() {
		return tipoMov;
	}

	public void setTipoMov(String tipoMov) {
		this.tipoMov = tipoMov;
	}

	public String getDescripcionMov() {
		return descripcionMov;
	}

	public void setDescripcionMov(String descripcionMov) {
		this.descripcionMov = descripcionMov;
	}

	public String getReferenciaMov() {
		return referenciaMov;
	}

	public void setReferenciaMov(String referenciaMov) {
		this.referenciaMov = referenciaMov;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getMontoPendApli() {
		return montoPendApli;
	}

	public void setMontoPendApli(String montoPendApli) {
		this.montoPendApli = montoPendApli;
	}

	public String getTipoCanal() {
		return tipoCanal;
	}

	public void setTipoCanal(String tipoCanal) {
		this.tipoCanal = tipoCanal;
	}

	public String getTipoDeposito() {
		return tipoDeposito;
	}

	public void setTipoDeposito(String tipoDeposito) {
		this.tipoDeposito = tipoDeposito;
	}

	public String getTipoMoneda() {
		return tipoMoneda;
	}

	/**
	 * @return the fechaCargaInicial
	 */
	public String getFechaCargaInicial() {
		return fechaCargaInicial;
	}

	/**
	 * @param fechaCargaInicial the fechaCargaInicial to set
	 */
	public void setFechaCargaInicial(String fechaCargaInicial) {
		this.fechaCargaInicial = fechaCargaInicial;
	}

	/**
	 * @return the fechaCargaFinal
	 */
	public String getFechaCargaFinal() {
		return fechaCargaFinal;
	}

	/**
	 * @param fechaCargaFinal the fechaCargaFinal to set
	 */
	public void setFechaCargaFinal(String fechaCargaFinal) {
		this.fechaCargaFinal = fechaCargaFinal;
	}

	public void setTipoMoneda(String tipoMoneda) {
		this.tipoMoneda = tipoMoneda;
	}

	public CommonsMultipartFile getFile() {
		return file;
	}

	public void setFile(CommonsMultipartFile file) {
		this.file = file;
	}

	public String getBancoEstandar() {
		return bancoEstandar;
	}

	public void setBancoEstandar(String bancoEstandar) {
		this.bancoEstandar = bancoEstandar;
	}

	public String getGrabaLimitesCta() {
		return grabaLimitesCta;
	}

	public void setGrabaLimitesCta(String grabaLimitesCta) {
		this.grabaLimitesCta = grabaLimitesCta;
	}

	public String getValidacion() {
		return validacion;
	}

	public void setValidacion(String validacion) {
		this.validacion = validacion;
	}

	public String getListaAplicaRef() {
		return listaAplicaRef;
	}

	public void setListaAplicaRef(String listaAplicaRef) {
		this.listaAplicaRef = listaAplicaRef;
	}

	public String getNumTranAnt() {
		return numTranAnt;
	}

	public void setNumTranAnt(String numTranAnt) {
		this.numTranAnt = numTranAnt;
	}

	public String getNumVal() {
		return numVal;
	}

	public void setNumVal(String numVal) {
		this.numVal = numVal;
	}

	public String getAltaPoliza() {
		return altaPoliza;
	}

	public void setAltaPoliza(String altaPoliza) {
		this.altaPoliza = altaPoliza;
	}

	public String getPolizaID() {
		return polizaID;
	}

	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}

	public String getNumTransaccion() {
		return numTransaccion;
	}

	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}

	public String getNumIdenArchivo() {
		return numIdenArchivo;
	}

	public void setNumIdenArchivo(String numIdenArchivo) {
		this.numIdenArchivo = numIdenArchivo;
	}

	public int getNumReg() {
		return numReg;
	}

	public void setNumReg(int numReg) {
		this.numReg = numReg;
	}

	public String getNumeroFila() {
		return numeroFila;
	}

	public void setNumeroFila(String numeroFila) {
		this.numeroFila = numeroFila;
	}

	public String getAplicarDeposito() {
		return aplicarDeposito;
	}

	public void setAplicarDeposito(String aplicarDeposito) {
		this.aplicarDeposito = aplicarDeposito;
	}

	public String getNombreArchivoCarga() {
		return nombreArchivoCarga;
	}

	public void setNombreArchivoCarga(String nombreArchivoCarga) {
		this.nombreArchivoCarga = nombreArchivoCarga;
	}

	public String getNumTran() {
		return numTran;
	}

	public void setNumTran(String numTran) {
		this.numTran = numTran;
	}

	public String getCargaLayoutXLSDepRef() {
		return cargaLayoutXLSDepRef;
	}

	public void setCargaLayoutXLSDepRef(String cargaLayoutXLSDepRef) {
		this.cargaLayoutXLSDepRef = cargaLayoutXLSDepRef;
	}

	public String getOpeInusualID() {
		return opeInusualID;
	}

	public void setOpeInusualID(String opeInusualID) {
		this.opeInusualID = opeInusualID;
	}
	
}