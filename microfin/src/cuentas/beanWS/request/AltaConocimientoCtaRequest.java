package cuentas.beanWS.request;

import general.bean.BaseBeanWS;

public class AltaConocimientoCtaRequest extends BaseBeanWS{
	private String cuentaAhoID;	
	private String depositoCred;
	private String retirosCargo;
	private String procRecursos;		
	private String concentFondo;
	
	private String admonGtosIng;
	private String pagoNomina;			
	private String ctaInversion;	
	private String pagoCreditos;
	private String otroUso;		
	
	private String defineUso;
	private String recursoProv;
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getDepositoCred() {
		return depositoCred;
	}
	public void setDepositoCred(String depositoCred) {
		this.depositoCred = depositoCred;
	}
	public String getRetirosCargo() {
		return retirosCargo;
	}
	public void setRetirosCargo(String retirosCargo) {
		this.retirosCargo = retirosCargo;
	}
	public String getProcRecursos() {
		return procRecursos;
	}
	public void setProcRecursos(String procRecursos) {
		this.procRecursos = procRecursos;
	}
	public String getConcentFondo() {
		return concentFondo;
	}
	public void setConcentFondo(String concentFondo) {
		this.concentFondo = concentFondo;
	}
	public String getAdmonGtosIng() {
		return admonGtosIng;
	}
	public void setAdmonGtosIng(String admonGtosIng) {
		this.admonGtosIng = admonGtosIng;
	}
	public String getPagoNomina() {
		return pagoNomina;
	}
	public void setPagoNomina(String pagoNomina) {
		this.pagoNomina = pagoNomina;
	}
	public String getCtaInversion() {
		return ctaInversion;
	}
	public void setCtaInversion(String ctaInversion) {
		this.ctaInversion = ctaInversion;
	}
	public String getPagoCreditos() {
		return pagoCreditos;
	}
	public void setPagoCreditos(String pagoCreditos) {
		this.pagoCreditos = pagoCreditos;
	}
	public String getOtroUso() {
		return otroUso;
	}
	public void setOtroUso(String otroUso) {
		this.otroUso = otroUso;
	}
	public String getDefineUso() {
		return defineUso;
	}
	public void setDefineUso(String defineUso) {
		this.defineUso = defineUso;
	}
	public String getRecursoProv() {
		return recursoProv;
	}
	public void setRecursoProv(String recursoProv) {
		this.recursoProv = recursoProv;
	}
	
	
}
