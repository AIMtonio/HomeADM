package originacion.bean;

import java.util.List;

import general.bean.BaseBean;

public class EsquemaGarantiaLiqBean extends BaseBean {
	
	/* Atributos de la tabla */
	private String esquemaGarantiaLiqID;
	private String producCreditoID;
	// Lista GRID FOGA
	private String clasificacion;
	private String limiteInferior;
	private String limiteSuperior;
	private String porcentaje;
	private String porcBonificacionFOGA;
	
	// Lista GRID FOGAFI
	private String esquemaGarFOGAFIID;
	private String clasificacionFOGAFI;
	private String limiteInferiorFOGAFI;
	private String limiteSuperiorFOGAFI;
	private String porcentajeFOGAFI;
	private String porcBonificacionFOGAFI;

	
	private String garantiaLiquida;
	private String liberarGaranLiq;
	private String clienteID;
	private String montoSolici;
	private String calificacion;
	
	private String bonificacionFOGA;
	private String desbloqAutFOGA;
	private String garantiaFOGAFI;
	private String modalidadFOGAFI;
	private String bonificacionFOGAFI;
	
	private String desbloqAutFOGAFI;

	
	/* Auxiliares para Grid */
	private List lEsquemaGarantiaLiqID;
	private List lProducCreditoID;
	private List lClasificacion;
	private List lLimiteInferior;
	private List lLimiteSuperior;
	private List lPorcentaje;
	private List lBonificaFOGA;
	
	private List lEsqGarFOGAFIID;
	private List lClasificacionFOGAFI;
	private List lLimiteInferiorFOGAFI;
	private List lLimiteSuperiorFOGAFI;
	private List lPorcentajeFOGAFI;
	private List lBonificaFOGAFI;
	
	/*Parametros de Auditoria*/
	private String empresaID;
	private String usuario;
	private String fechaActual;  
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;

	
	
	
	
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public String getClasificacion() {
		return clasificacion;
	}
	public String getLimiteInferior() {
		return limiteInferior;
	}
	public String getLimiteSuperior() {
		return limiteSuperior;
	}
	public String getPorcentaje() {
		return porcentaje;
	}
	public String getPorcBonificacionFOGA() {
		return porcBonificacionFOGA;
	}
	public String getEsquemaGarFOGAFIID() {
		return esquemaGarFOGAFIID;
	}
	public String getClasificacionFOGAFI() {
		return clasificacionFOGAFI;
	}
	public String getLimiteInferiorFOGAFI() {
		return limiteInferiorFOGAFI;
	}
	public String getLimiteSuperiorFOGAFI() {
		return limiteSuperiorFOGAFI;
	}
	public String getPorcentajeFOGAFI() {
		return porcentajeFOGAFI;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public String getUsuario() {
		return usuario;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public String getSucursal() {
		return sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	public void setClasificacion(String clasificacion) {
		this.clasificacion = clasificacion;
	}
	public void setLimiteInferior(String limiteInferior) {
		this.limiteInferior = limiteInferior;
	}
	public void setLimiteSuperior(String limiteSuperior) {
		this.limiteSuperior = limiteSuperior;
	}
	public void setPorcentaje(String porcentaje) {
		this.porcentaje = porcentaje;
	}
	public void setPorcBonificacionFOGA(String porcBonificacionFOGA) {
		this.porcBonificacionFOGA = porcBonificacionFOGA;
	}
	public void setEsquemaGarFOGAFIID(String esquemaGarFOGAFIID) {
		this.esquemaGarFOGAFIID = esquemaGarFOGAFIID;	}
	
	public void setClasificacionFOGAFI(String clasificacionFOGAFI) {
		this.clasificacionFOGAFI = clasificacionFOGAFI;
	}	
	public void setLimiteInferiorFOGAFI(String limiteInferiorFOGAFI) {
		this.limiteInferiorFOGAFI = limiteInferiorFOGAFI;
	}
	public void setLimiteSuperiorFOGAFI(String limiteSuperiorFOGAFI) {
		this.limiteSuperiorFOGAFI = limiteSuperiorFOGAFI;
	}	
	public void setPorcentajeFOGAFI(String porcentajeFOGAFI) {
		this.porcentajeFOGAFI = porcentajeFOGAFI;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getEsquemaGarantiaLiqID() {
		return esquemaGarantiaLiqID;
	}
	public void setEsquemaGarantiaLiqID(String esquemaGarantiaLiqID) {
		this.esquemaGarantiaLiqID = esquemaGarantiaLiqID;
	}
	public List getlEsquemaGarantiaLiqID() {
		return lEsquemaGarantiaLiqID;
	}
	public List getlProducCreditoID() {
		return lProducCreditoID;
	}
	public List getlClasificacion() {
		return lClasificacion;
	}
	public List getlLimiteInferior() {
		return lLimiteInferior;
	}
	public List getlLimiteSuperior() {
		return lLimiteSuperior;
	}
	public List getlPorcentaje() {
		return lPorcentaje;
	}
	public List getlBonificaFOGA() {
		return lBonificaFOGA;
	}
	public List getlEsqGarFOGAFIID() {
		return lEsqGarFOGAFIID;
	}
	public List getlClasificacionFOGAFI() {
		return lClasificacionFOGAFI;
	}
	public List getlLimiteInferiorFOGAFI() {
		return lLimiteInferiorFOGAFI;
	}
	public List getlLimiteSuperiorFOGAFI() {
		return lLimiteSuperiorFOGAFI;
	}
	public List getlPorcentajeFOGAFI() {
		return lPorcentajeFOGAFI;
	}
	public List getlBonificaFOGAFI() {
		return lBonificaFOGAFI;
	}
	public void setlEsquemaGarantiaLiqID(List lEsquemaGarantiaLiqID) {
		this.lEsquemaGarantiaLiqID = lEsquemaGarantiaLiqID;
	}
	public void setlProducCreditoID(List lProducCreditoID) {
		this.lProducCreditoID = lProducCreditoID;
	}
	public void setlClasificacion(List lClasificacion) {
		this.lClasificacion = lClasificacion;
	}
	public void setlLimiteInferior(List lLimiteInferior) {
		this.lLimiteInferior = lLimiteInferior;
	}
	public void setlLimiteSuperior(List lLimiteSuperior) {
		this.lLimiteSuperior = lLimiteSuperior;
	}
	public void setlPorcentaje(List lPorcentaje) {
		this.lPorcentaje = lPorcentaje;
	}
	public void setlBonificaFOGA(List lBonificaFOGA) {
		this.lBonificaFOGA = lBonificaFOGA;
	}	
	public void setlEsqGarFOGAFIID(List lEsqGarFOGAFIID) {
		this.lEsqGarFOGAFIID = lEsqGarFOGAFIID;	}
	
	public void setlClasificacionFOGAFI(List lClasificacionFOGAFI) {
		this.lClasificacionFOGAFI = lClasificacionFOGAFI;
	}	
	public void setlLimiteInferiorFOGAFI(List lLimiteInferiorFOGAFI) {
		this.lLimiteInferiorFOGAFI = lLimiteInferiorFOGAFI;
	}	
	public void setlLimiteSuperiorFOGAFI(List lLimiteSuperiorFOGAFI) {
		this.lLimiteSuperiorFOGAFI = lLimiteSuperiorFOGAFI;
	}	
	public void setlPorcentajeFOGAFI(List lPorcentajeFOGAFI) {
		this.lPorcentajeFOGAFI = lPorcentajeFOGAFI;
	}
	public void setlBonificaFOGAFI(List lBonificaFOGAFI) {
		this.lBonificaFOGAFI = lBonificaFOGAFI;
	}
	public String getGarantiaLiquida() {
		return garantiaLiquida;
	}
	public String getLiberarGaranLiq() {
		return liberarGaranLiq;
	}
	public void setGarantiaLiquida(String garantiaLiquida) {
		this.garantiaLiquida = garantiaLiquida;
	}
	public void setLiberarGaranLiq(String liberarGaranLiq) {
		this.liberarGaranLiq = liberarGaranLiq;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCalificacion() {
		return calificacion;
	}
	public void setCalificacion(String calificacion) {
		this.calificacion = calificacion;
	}
	public String getMontoSolici() {
		return montoSolici;
	}
	public void setMontoSolici(String montoSolici) {
		this.montoSolici = montoSolici;
	}
	public String getBonificacionFOGA() {
		return bonificacionFOGA;
	}
	public void setBonificacionFOGA(String bonificacionFOGA) {
		this.bonificacionFOGA = bonificacionFOGA;
	}
	public String getDesbloqAutFOGA() {
		return desbloqAutFOGA;
	}
	public void setDesbloqAutFOGA(String desbloqAutFOGA) {
		this.desbloqAutFOGA = desbloqAutFOGA;
	}
	public String getGarantiaFOGAFI() {
		return garantiaFOGAFI;
	}
	public void setGarantiaFOGAFI(String garantiaFOGAFI) {
		this.garantiaFOGAFI = garantiaFOGAFI;
	}
	public String getModalidadFOGAFI() {
		return modalidadFOGAFI;
	}
	public void setModalidadFOGAFI(String modalidadFOGAFI) {
		this.modalidadFOGAFI = modalidadFOGAFI;
	}
	public String getBonificacionFOGAFI() {
		return bonificacionFOGAFI;
	}
	public void setBonificacionFOGAFI(String bonificacionFOGAFI) {
		this.bonificacionFOGAFI = bonificacionFOGAFI;
	}
	public String getDesbloqAutFOGAFI() {
		return desbloqAutFOGAFI;
	}
	public void setDesbloqAutFOGAFI(String desbloqAutFOGAFI) {
		this.desbloqAutFOGAFI = desbloqAutFOGAFI;
	}
	
	
	public String getPorcBonificacionFOGAFI() {
		return porcBonificacionFOGAFI;
	}
	public void setPorcBonificacionFOGAFI(String porcBonificacionFOGAFI) {
		this.porcBonificacionFOGAFI = porcBonificacionFOGAFI;
	}
	
	
}
