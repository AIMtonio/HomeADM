package soporte.bean;

import general.bean.BaseBean;



public class CalculosyOperacionesBean extends BaseBean {
	private String numeroDecimales;
	private String valorUnoA;
	private String valorDosA;		
	private String valorUnoB;		
	private String valorDosB;

	private String resultadoDosDecimales;
	private String resultadoCuatroDecimales;
	public String getNumeroDecimales() {
		return numeroDecimales;
	}
	public void setNumeroDecimales(String numeroDecimales) {
		this.numeroDecimales = numeroDecimales;
	}
	public String getValorUnoA() {
		return valorUnoA;
	}
	public void setValorUnoA(String valorUnoA) {
		this.valorUnoA = valorUnoA;
	}
	public String getValorDosA() {
		return valorDosA;
	}
	public void setValorDosA(String valorDosA) {
		this.valorDosA = valorDosA;
	}
	public String getValorUnoB() {
		return valorUnoB;
	}
	public void setValorUnoB(String valorUnoB) {
		this.valorUnoB = valorUnoB;
	}
	public String getValorDosB() {
		return valorDosB;
	}
	public void setValorDosB(String valorDosB) {
		this.valorDosB = valorDosB;
	}
	public String getResultadoDosDecimales() {
		return resultadoDosDecimales;
	}
	public void setResultadoDosDecimales(String resultadoDosDecimales) {
		this.resultadoDosDecimales = resultadoDosDecimales;
	}
	public String getResultadoCuatroDecimales() {
		return resultadoCuatroDecimales;
	}
	public void setResultadoCuatroDecimales(String resultadoCuatroDecimales) {
		this.resultadoCuatroDecimales = resultadoCuatroDecimales;
	}			

}