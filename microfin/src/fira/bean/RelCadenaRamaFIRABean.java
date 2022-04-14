package fira.bean;

import general.bean.BaseBean;

public class RelCadenaRamaFIRABean extends BaseBean {
	
	private String	cveCadena;
	private String	nomCadenaProdSCIAN;
	private String	cveRamaFIRA;
	private String	descripcionRamaFIRA;

	public String getCveCadena() {
		return cveCadena;
	}

	public void setCveCadena(String cveCadena) {
		this.cveCadena = cveCadena;
	}

	public String getNomCadenaProdSCIAN() {
		return nomCadenaProdSCIAN;
	}

	public void setNomCadenaProdSCIAN(String nomCadenaProdSCIAN) {
		this.nomCadenaProdSCIAN = nomCadenaProdSCIAN;
	}

	public String getCveRamaFIRA() {
		return cveRamaFIRA;
	}

	public void setCveRamaFIRA(String cveRamaFIRA) {
		this.cveRamaFIRA = cveRamaFIRA;
	}

	public String getDescripcionRamaFIRA() {
		return descripcionRamaFIRA;
	}

	public void setDescripcionRamaFIRA(String descripcionRamaFIRA) {
		this.descripcionRamaFIRA = descripcionRamaFIRA;
	}

}