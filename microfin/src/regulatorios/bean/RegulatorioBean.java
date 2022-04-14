package regulatorios.bean;

import general.bean.BaseBean;

public class RegulatorioBean extends BaseBean{
	
	private String anio;
	private String mes;
	private String saldo;
	private String saldoPromedio;
	private String cuentaCNBV;
	private String concepto;
	private String consecutivo;
	private String numClientes;
	private String valorFijo1;
	private String valorFijo2;
	private String valorFijo3;	
	private String indicador;
	private String formulaSaldo;
	private String FormulaSaldoProm;
	private String formulaIndicador;	
	private String colorCeldaSaldo;		
	private String colorCeldaSaldoProm;
	private String colorCeldaIndicador;	
	private String saldoEsNegrita;	
	private String descripcionEsNegrita;
	private String indicadorEsNegrita;	
	
	private String periodo;	        
	private String claveEntidad;	
	private String claveFormulario;	
	private String estadoID;		
	private String municipioID;		
	private String numSucursales;	
	private String numCajerosATM;	
	private String numMujeres;			
	private String numHombres;			
	private String parteSocial;			
	private String numContrato;			
	private String saldoAcum;			
	private String numContratoPlazo;	
	private String saldoAcumPlazo;		
	private String numContratoTD;		
	private String saldoAcumTD;			
	private String numContratoTDRecar;	
	private String saldoAcumTDRecar;
	private String numCreditos;				
	private String saldoVigenteCre;			
	private String saldoVencidoCre;			
	private String numMicroCreditos;		
	private String saldoVigenteMicroCre;	
	private String saldoVencidoMicroCre;	
	private String numContratoTC;			
	private String saldoVigenteTC;			
	private String saldoVencidoTC;			
	private String numCreConsumo;
	private String saldoVencidoCreConsumo;	
	private String numCreVivienda;			
	private String saldoVigenteCreVivienda;
	private String saldoVencidoCreVivienda;
	private String numRemesas;		
	private String montoRemesas;	
	
	private String valor;

	
	/*PARAMETROS DE AUDITORIA */
	private String empresaID;
	private String usuario;
	private String fechaActual;  
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	
	
	public String getValor() {
		return valor;
	}
	public void setValor(String valor) {
		this.valor = valor;
	}
	
	public String getNumClientes() {
		return numClientes;
	}
	public void setNumClientes(String numClientes) {
		this.numClientes = numClientes;
	}
	public String getConsecutivo() {
		return consecutivo;
	}
	public void setConsecutivo(String consecutivo) {
		this.consecutivo = consecutivo;
	}
	public String getIndicador() {
		return indicador;
	}
	public void setIndicador(String indicador) {
		this.indicador = indicador;
	}
	public String getCuentaCNBV() {
		return cuentaCNBV;
	}
	public void setCuentaCNBV(String cuentaCNBV) {
		this.cuentaCNBV = cuentaCNBV;
	}
	public String getSaldoPromedio() {
		return saldoPromedio;
	}
	public void setSaldoPromedio(String saldoPromedio) {
		this.saldoPromedio = saldoPromedio;
	}
	private String saldoVigenteCreConsumo;	
	

	public String getValorFijo1() {
		return valorFijo1;
	}
	public void setValorFijo1(String valorFijo1) {
		this.valorFijo1 = valorFijo1;
	}
	public String getValorFijo2() {
		return valorFijo2;
	}
	public void setValorFijo2(String valorFijo2) {
		this.valorFijo2 = valorFijo2;
	}
	public String getValorFijo3() {
		return valorFijo3;
	}
	public void setValorFijo3(String valorFijo3) {
		this.valorFijo3 = valorFijo3;
	}
	public String getColorCeldaSaldoProm() {
		return colorCeldaSaldoProm;
	}
	public void setColorCeldaSaldoProm(String colorCeldaSaldoProm) {
		this.colorCeldaSaldoProm = colorCeldaSaldoProm;
	}
	public String getDescripcionEsNegrita() {
		return descripcionEsNegrita;
	}
	public void setDescripcionEsNegrita(String descripcionEsNegrita) {
		this.descripcionEsNegrita = descripcionEsNegrita;
	}
	public String getFormulaSaldoProm() {
		return FormulaSaldoProm;
	}
	public void setFormulaSaldoProm(String formulaSaldoProm) {
		FormulaSaldoProm = formulaSaldoProm;
	}
	public String getFormulaSaldo() {
		return formulaSaldo;
	}
	public void setFormulaSaldo(String formulaSaldo) {
		this.formulaSaldo = formulaSaldo;
	}
	public String getFormulaIndicador() {
		return formulaIndicador;
	}
	public void setFormulaIndicador(String formulaIndicador) {
		this.formulaIndicador = formulaIndicador;
	}
	public String getColorCeldaSaldo() {
		return colorCeldaSaldo;
	}
	public void setColorCeldaSaldo(String colorCeldaSaldo) {
		this.colorCeldaSaldo = colorCeldaSaldo;
	}
	public String getColorCeldaIndicador() {
		return colorCeldaIndicador;
	}
	public void setColorCeldaIndicador(String colorCeldaIndicador) {
		this.colorCeldaIndicador = colorCeldaIndicador;
	}
	public String getSaldoEsNegrita() {
		return saldoEsNegrita;
	}
	public void setSaldoEsNegrita(String saldoEsNegrita) {
		this.saldoEsNegrita = saldoEsNegrita;
	}
	public String getIndicadorEsNegrita() {
		return indicadorEsNegrita;
	}
	public void setIndicadorEsNegrita(String indicadorEsNegrita) {
		this.indicadorEsNegrita = indicadorEsNegrita;
	}

	
	
	
	public String getNumCreditos() {
		return numCreditos;
	}
	public void setNumCreditos(String numCreditos) {
		this.numCreditos = numCreditos;
	}
	public String getSaldoVigenteCre() {
		return saldoVigenteCre;
	}
	public void setSaldoVigenteCre(String saldoVigenteCre) {
		this.saldoVigenteCre = saldoVigenteCre;
	}
	public String getSaldoVencidoCre() {
		return saldoVencidoCre;
	}
	public void setSaldoVencidoCre(String saldoVencidoCre) {
		this.saldoVencidoCre = saldoVencidoCre;
	}
	public String getNumMicroCreditos() {
		return numMicroCreditos;
	}
	public void setNumMicroCreditos(String numMicroCreditos) {
		this.numMicroCreditos = numMicroCreditos;
	}
	public String getSaldoVigenteMicroCre() {
		return saldoVigenteMicroCre;
	}
	public void setSaldoVigenteMicroCre(String saldoVigenteMicroCre) {
		this.saldoVigenteMicroCre = saldoVigenteMicroCre;
	}
	public String getSaldoVencidoMicroCre() {
		return saldoVencidoMicroCre;
	}
	public void setSaldoVencidoMicroCre(String saldoVencidoMicroCre) {
		this.saldoVencidoMicroCre = saldoVencidoMicroCre;
	}
	public String getNumContratoTC() {
		return numContratoTC;
	}
	public void setNumContratoTC(String numContratoTC) {
		this.numContratoTC = numContratoTC;
	}
	public String getSaldoVigenteTC() {
		return saldoVigenteTC;
	}
	public void setSaldoVigenteTC(String saldoVigenteTC) {
		this.saldoVigenteTC = saldoVigenteTC;
	}
	public String getSaldoVencidoTC() {
		return saldoVencidoTC;
	}
	public void setSaldoVencidoTC(String saldoVencidoTC) {
		this.saldoVencidoTC = saldoVencidoTC;
	}
	public String getNumCreConsumo() {
		return numCreConsumo;
	}
	public void setNumCreConsumo(String numCreConsumo) {
		this.numCreConsumo = numCreConsumo;
	}
	public String getSaldoVigenteCreConsumo() {
		return saldoVigenteCreConsumo;
	}
	public void setSaldoVigenteCreConsumo(String saldoVigenteCreConsumo) {
		this.saldoVigenteCreConsumo = saldoVigenteCreConsumo;
	}
	public String getSaldoVencidoCreConsumo() {
		return saldoVencidoCreConsumo;
	}
	public void setSaldoVencidoCreConsumo(String saldoVencidoCreConsumo) {
		this.saldoVencidoCreConsumo = saldoVencidoCreConsumo;
	}
	public String getNumCreVivienda() {
		return numCreVivienda;
	}
	public void setNumCreVivienda(String numCreVivienda) {
		this.numCreVivienda = numCreVivienda;
	}
	public String getSaldoVigenteCreVivienda() {
		return saldoVigenteCreVivienda;
	}
	public void setSaldoVigenteCreVivienda(String saldoVigenteCreVivienda) {
		this.saldoVigenteCreVivienda = saldoVigenteCreVivienda;
	}
	public String getSaldoVencidoCreVivienda() {
		return saldoVencidoCreVivienda;
	}
	public void setSaldoVencidoCreVivienda(String saldoVencidoCreVivienda) {
		this.saldoVencidoCreVivienda = saldoVencidoCreVivienda;
	}
	public String getNumRemesas() {
		return numRemesas;
	}
	public void setNumRemesas(String numRemesas) {
		this.numRemesas = numRemesas;
	}
	public String getMontoRemesas() {
		return montoRemesas;
	}
	public void setMontoRemesas(String montoRemesas) {
		this.montoRemesas = montoRemesas;
	}
	public String getNumMujeres() {
		return numMujeres;
	}
	public void setNumMujeres(String numMujeres) {
		this.numMujeres = numMujeres;
	}
	public String getNumHombres() {
		return numHombres;
	}
	public void setNumHombres(String numHombres) {
		this.numHombres = numHombres;
	}
	public String getParteSocial() {
		return parteSocial;
	}
	public void setParteSocial(String parteSocial) {
		this.parteSocial = parteSocial;
	}
	public String getNumContrato() {
		return numContrato;
	}
	public void setNumContrato(String numContrato) {
		this.numContrato = numContrato;
	}
	public String getSaldoAcum() {
		return saldoAcum;
	}
	public void setSaldoAcum(String saldoAcum) {
		this.saldoAcum = saldoAcum;
	}
	public String getNumContratoPlazo() {
		return numContratoPlazo;
	}
	public void setNumContratoPlazo(String numContratoPlazo) {
		this.numContratoPlazo = numContratoPlazo;
	}
	public String getSaldoAcumPlazo() {
		return saldoAcumPlazo;
	}
	public void setSaldoAcumPlazo(String saldoAcumPlazo) {
		this.saldoAcumPlazo = saldoAcumPlazo;
	}
	public String getNumContratoTD() {
		return numContratoTD;
	}
	public void setNumContratoTD(String numContratoTD) {
		this.numContratoTD = numContratoTD;
	}
	public String getSaldoAcumTD() {
		return saldoAcumTD;
	}
	public void setSaldoAcumTD(String saldoAcumTD) {
		this.saldoAcumTD = saldoAcumTD;
	}
	public String getNumContratoTDRecar() {
		return numContratoTDRecar;
	}
	public void setNumContratoTDRecar(String numContratoTDRecar) {
		this.numContratoTDRecar = numContratoTDRecar;
	}
	public String getSaldoAcumTDRecar() {
		return saldoAcumTDRecar;
	}
	public void setSaldoAcumTDRecar(String saldoAcumTDRecar) {
		this.saldoAcumTDRecar = saldoAcumTDRecar;
	}
	public String getPeriodo() {
		return periodo;
	}
	public void setPeriodo(String periodo) {
		this.periodo = periodo;
	}
	public String getClaveEntidad() {
		return claveEntidad;
	}
	public void setClaveEntidad(String claveEntidad) {
		this.claveEntidad = claveEntidad;
	}
	public String getClaveFormulario() {
		return claveFormulario;
	}
	public void setClaveFormulario(String claveFormulario) {
		this.claveFormulario = claveFormulario;
	}
	public String getEstadoID() {
		return estadoID;
	}
	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
	}
	public String getMunicipioID() {
		return municipioID;
	}
	public void setMunicipioID(String municipioID) {
		this.municipioID = municipioID;
	}
	public String getNumSucursales() {
		return numSucursales;
	}
	public void setNumSucursales(String numSucursales) {
		this.numSucursales = numSucursales;
	}
	public String getNumCajerosATM() {
		return numCajerosATM;
	}
	public void setNumCajerosATM(String numCajerosATM) {
		this.numCajerosATM = numCajerosATM;
	}
	public String getConcepto() {
		return concepto;
	}
	public void setConcepto(String concepto) {
		this.concepto = concepto;
	}
	public String getSaldo() {
		return saldo;
	}
	public void setSaldo(String saldo) {
		this.saldo = saldo;
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
	
	
}
