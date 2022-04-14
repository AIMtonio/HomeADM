package pld.bean;

import general.bean.BaseBean;

public class ParametrosOpRelBean extends BaseBean{
	
	private String monedaLimOPR;
	private String limiteInferior;
	private String fechaInicioVig;
	private String fechaFinVig;
	private String monedaLimMicro;
	private String limMensualMicro;
	private String evaluaOpeAcumMes;
	private String monedaEvalua;
	private String montoEvalua;
	
	private String instrumentMonID; // para pantalla de parametros de operaciones relevantes seccion de tipos de instrumentos
	private String tipoInstruMonID; // para pantalla de parametros de operaciones relevantes seccion de tipos de instrumentos

	
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	//Auxiliares del Bean
	private String nombreusuario;
	private String nombreInstitucion;
	private String fechaEmision;
	private String desMonedaLimOPR;
	
	public String getMonedaLimOPR() {
		return monedaLimOPR;
	}
	public void setMonedaLimOPR(String monedaLimOPR) {
		this.monedaLimOPR = monedaLimOPR;
	}
	public String getLimiteInferior() {
		return limiteInferior;
	}
	public void setLimiteInferior(String limiteInferior) {
		this.limiteInferior = limiteInferior;
	}
	public String getFechaInicioVig() {
		return fechaInicioVig;
	}
	public void setFechaInicioVig(String fechaInicioVig) {
		this.fechaInicioVig = fechaInicioVig;
	}
	public String getFechaFinVig() {
		return fechaFinVig;
	}
	public void setFechaFinVig(String fechaFinVig) {
		this.fechaFinVig = fechaFinVig;
	}
	public String getMonedaLimMicro() {
		return monedaLimMicro;
	}
	public void setMonedaLimMicro(String monedaLimMicro) {
		this.monedaLimMicro = monedaLimMicro;
	}
	public String getLimMensualMicro() {
		return limMensualMicro;
	}
	public void setLimMensualMicro(String limMensualMicro) {
		this.limMensualMicro = limMensualMicro;
	}
	public String getInstrumentMonID() {
		return instrumentMonID;
	}
	public void setInstrumentMonID(String instrumentMonID) {
		this.instrumentMonID = instrumentMonID;
	}
	public String getTipoInstruMonID() {
		return tipoInstruMonID;
	}
	public void setTipoInstruMonID(String tipoInstruMonID) {
		this.tipoInstruMonID = tipoInstruMonID;
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
	
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getNombreusuario() {
		return nombreusuario;
	}
	public void setNombreusuario(String nombreusuario) {
		this.nombreusuario = nombreusuario;
	}
	public String getDesMonedaLimOPR() {
		return desMonedaLimOPR;
	}
	public void setDesMonedaLimOPR(String desMonedaLimOPR) {
		this.desMonedaLimOPR = desMonedaLimOPR;
	}
	public String getEvaluaOpeAcumMes() {
		return evaluaOpeAcumMes;
	}
	public String getMonedaEvalua() {
		return monedaEvalua;
	}
	public String getMontoEvalua() {
		return montoEvalua;
	}
	public void setEvaluaOpeAcumMes(String evaluaOpeAcumMes) {
		this.evaluaOpeAcumMes = evaluaOpeAcumMes;
	}
	public void setMonedaEvalua(String monedaEvalua) {
		this.monedaEvalua = monedaEvalua;
	}
	public void setMontoEvalua(String montoEvalua) {
		this.montoEvalua = montoEvalua;
	}
	
	}

