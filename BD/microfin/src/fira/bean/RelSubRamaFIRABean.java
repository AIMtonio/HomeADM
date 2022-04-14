package fira.bean;

import general.bean.BaseBean;

public class RelSubRamaFIRABean extends BaseBean {
	
	private String	cveCadena;
	private String	nomCadenaProdSCIAN;
	private String	cveRamaFIRA;
	private String	descripcionRamaFIRA;
	private String	cveSubramaFIRA;
	private String	descSubramaFIRA;

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

	/**
	 * @return the cveSubramaFIRA
	 */
	public String getCveSubramaFIRA() {
		return cveSubramaFIRA;
	}

	/**
	 * @param cveSubramaFIRA the cveSubramaFIRA to set
	 */
	public void setCveSubramaFIRA(String cveSubramaFIRA) {
		this.cveSubramaFIRA = cveSubramaFIRA;
	}

	/**
	 * @return the descSubramaFIRA
	 */
	public String getDescSubramaFIRA() {
		return descSubramaFIRA;
	}

	/**
	 * @param descSubramaFIRA the descSubramaFIRA to set
	 */
	public void setDescSubramaFIRA(String descSubramaFIRA) {
		this.descSubramaFIRA = descSubramaFIRA;
	}

}