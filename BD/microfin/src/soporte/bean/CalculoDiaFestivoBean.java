package soporte.bean;

import general.bean.BaseBean;

public class CalculoDiaFestivoBean extends BaseBean {

	private String fecha;
	private int numeroDias;
	private int numeroDiasSuma;
	private int numeroMesesSuma;
	private String esFechaHabil;
	private String salidaPantalla;
	private String sigAnt;

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public int getNumeroDias() {
		return numeroDias;
	}

	public void setNumeroDias(int numeroDias) {
		this.numeroDias = numeroDias;
	}

	public int getNumeroDiasSuma() {
		return numeroDiasSuma;
	}

	public void setNumeroDiasSuma(int numeroDiasSuma) {
		this.numeroDiasSuma = numeroDiasSuma;
	}

	public String getEsFechaHabil() {
		return esFechaHabil;
	}

	public void setEsFechaHabil(String esFechaHabil) {
		this.esFechaHabil = esFechaHabil;
	}

	public String getSalidaPantalla() {
		return salidaPantalla;
	}

	public void setSalidaPantalla(String salidaPantalla) {
		this.salidaPantalla = salidaPantalla;
	}

	public String getSigAnt() {
		return sigAnt;
	}

	public void setSigAnt(String sigAnt) {
		this.sigAnt = sigAnt;
	}

	public int getNumeroMesesSuma() {
		return numeroMesesSuma;
	}

	public void setNumeroMesesSuma(int numeroMesesSuma) {
		this.numeroMesesSuma = numeroMesesSuma;
	}

}