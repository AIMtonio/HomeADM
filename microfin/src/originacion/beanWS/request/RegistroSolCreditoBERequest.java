package originacion.beanWS.request;

import general.bean.BaseBeanWS;

public class RegistroSolCreditoBERequest extends BaseBeanWS {
	private String solicitudCreditoID;
	private String prospectoID;
	private String clienteID;
	private String produCredID;
	private String fechaReg;
	private String promotor;
	private String destinoCre;
	private String proyecto ;
	private String sucursalID;

	private String montoSolic ; 
	private String plazoID;
	private String factorMora;
	private String formaComApertura;
	private String comApertura;
	private String IVAComAper;
	private String tasaFija;
	private String frecuencia;
	private String periodicidad;
	private String numAmorti;
	
	private String numTransacSim;
	private String CAT;
	private String cuentaClabe;
	private String montoCuota;
	private String fechaVencim;
	private String fechaInicio;
	private String clasiDestinCred;
	
	private String institucionNominaID;
	private String negocioAfiliadoID;
	private String numCreditos;
	
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getProduCredID() {
		return produCredID;
	}
	public void setProduCredID(String produCredID) {
		this.produCredID = produCredID;
	}
	public String getFechaReg() {
		return fechaReg;
	}
	public void setFechaReg(String fechaReg) {
		this.fechaReg = fechaReg;
	}
	public String getPromotor() {
		return promotor;
	}
	public void setPromotor(String promotor) {
		this.promotor = promotor;
	}
	public String getDestinoCre() {
		return destinoCre;
	}
	public void setDestinoCre(String destinoCre) {
		this.destinoCre = destinoCre;
	}
	public String getProyecto() {
		return proyecto;
	}
	public void setProyecto(String proyecto) {
		this.proyecto = proyecto;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getMontoSolic() {
		return montoSolic;
	}
	public void setMontoSolic(String montoSolic) {
		this.montoSolic = montoSolic;
	}
	public String getPlazoID() {
		return plazoID;
	}
	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
	}
	public String getFactorMora() {
		return factorMora;
	}
	public void setFactorMora(String factorMora) {
		this.factorMora = factorMora;
	}
	public String getComApertura() {
		return comApertura;
	}
	public void setComApertura(String comApertura) {
		this.comApertura = comApertura;
	}
	public String getIVAComAper() {
		return IVAComAper;
	}
	public void setIVAComAper(String iVAComAper) {
		IVAComAper = iVAComAper;
	}
	public String getTasaFija() {
		return tasaFija;
	}
	public void setTasaFija(String tasaFija) {
		this.tasaFija = tasaFija;
	}
	public String getFrecuencia() {
		return frecuencia;
	}
	public void setFrecuencia(String frecuencia) {
		this.frecuencia = frecuencia;
	}
	public String getPeriodicidad() {
		return periodicidad;
	}
	public void setPeriodicidad(String periodicidad) {
		this.periodicidad = periodicidad;
	}
	public String getNumAmorti() {
		return numAmorti;
	}
	public void setNumAmorti(String numAmorti) {
		this.numAmorti = numAmorti;
	}
	public String getNumTransacSim() {
		return numTransacSim;
	}
	public void setNumTransacSim(String numTransacSim) {
		this.numTransacSim = numTransacSim;
	}
	public String getCAT() {
		return CAT;
	}
	public void setCAT(String cAT) {
		CAT = cAT;
	}
	public String getCuentaClabe() {
		return cuentaClabe;
	}
	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}
	public String getMontoCuota() {
		return montoCuota;
	}
	public void setMontoCuota(String montoCuota) {
		this.montoCuota = montoCuota;
	}
	public String getFechaVencim() {
		return fechaVencim;
	}
	public void setFechaVencim(String fechaVencim) {
		this.fechaVencim = fechaVencim;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getClasiDestinCred() {
		return clasiDestinCred;
	}
	public void setClasiDestinCred(String clasiDestinCred) {
		this.clasiDestinCred = clasiDestinCred;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getInstitucionNominaID() {
		return institucionNominaID;
	}
	public void setInstitucionNominaID(String institucionNominaID) {
		this.institucionNominaID = institucionNominaID;
	}
	public String getNegocioAfiliadoID() {
		return negocioAfiliadoID;
	}
	public void setNegocioAfiliadoID(String negocioAfiliadoID) {
		this.negocioAfiliadoID = negocioAfiliadoID;
	}
	public String getFormaComApertura() {
		return formaComApertura;
	}
	public void setFormaComApertura(String formaComApertura) {
		this.formaComApertura = formaComApertura;
	}
	public String getNumCreditos() {
		return numCreditos;
	}
	public void setNumCreditos(String numCreditos) {
		this.numCreditos = numCreditos;
	}

}
