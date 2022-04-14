package fira.bean;

import general.bean.BaseBean;

public class CatFIRAProgEspBean extends BaseBean {

	private String claveProgramaID;
	private String cveSubProgramaID;
	private String subPrograma;
	private String frenteTecnologico;
	private String vigente;

	public String getClaveProgramaID() {
		return claveProgramaID;
	}
	public void setClaveProgramaID(String claveProgramaID) {
		this.claveProgramaID = claveProgramaID;
	}
	public String getCveSubProgramaID() {
		return cveSubProgramaID;
	}
	public void setCveSubProgramaID(String cveSubProgramaID) {
		this.cveSubProgramaID = cveSubProgramaID;
	}
	public String getSubPrograma() {
		return subPrograma;
	}
	public void setSubPrograma(String subPrograma) {
		this.subPrograma = subPrograma;
	}
	public String getFrenteTecnologico() {
		return frenteTecnologico;
	}
	public void setFrenteTecnologico(String frenteTecnologico) {
		this.frenteTecnologico = frenteTecnologico;
	}
	public String getVigente() {
		return vigente;
	}
	public void setVigente(String vigente) {
		this.vigente = vigente;
	}
}
