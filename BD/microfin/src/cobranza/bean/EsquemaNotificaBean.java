package cobranza.bean;

import general.bean.BaseBean;
import java.util.List;


public class EsquemaNotificaBean extends BaseBean{
	private String esquemaID;
	private String diasAtrasoIni;
	private String diasAtrasoFin;
	private String numEtapa;
	private String etiquetaEtapa;
	private String accion;
	private String formatoNoti;	

	private List lisEsquemaID;
	private List lisDiasAtrasoIni;
	private List lisDiasAtrasoFin;
	private List lisNumEtapa;
	private List lisEtiquetaEtapa;
	private List lisAccion;
	private List lisFormatoNoti;
	
	
	public String getEsquemaID() {
		return esquemaID;
	}
	public void setEsquemaID(String esquemaID) {
		this.esquemaID = esquemaID;
	}
	public String getDiasAtrasoIni() {
		return diasAtrasoIni;
	}
	public void setDiasAtrasoIni(String diasAtrasoIni) {
		this.diasAtrasoIni = diasAtrasoIni;
	}
	public String getDiasAtrasoFin() {
		return diasAtrasoFin;
	}
	public void setDiasAtrasoFin(String diasAtrasoFin) {
		this.diasAtrasoFin = diasAtrasoFin;
	}
	public String getNumEtapa() {
		return numEtapa;
	}
	public void setNumEtapa(String numEtapa) {
		this.numEtapa = numEtapa;
	}
	public String getEtiquetaEtapa() {
		return etiquetaEtapa;
	}
	public void setEtiquetaEtapa(String etiquetaEtapa) {
		this.etiquetaEtapa = etiquetaEtapa;
	}
	public String getAccion() {
		return accion;
	}
	public void setAccion(String accion) {
		this.accion = accion;
	}
	public String getFormatoNoti() {
		return formatoNoti;
	}
	public void setFormatoNoti(String formatoNoti) {
		this.formatoNoti = formatoNoti;
	}
	public List getLisEsquemaID() {
		return lisEsquemaID;
	}
	public void setLisEsquemaID(List lisEsquemaID) {
		this.lisEsquemaID = lisEsquemaID;
	}
	public List getLisDiasAtrasoIni() {
		return lisDiasAtrasoIni;
	}
	public void setLisDiasAtrasoIni(List lisDiasAtrasoIni) {
		this.lisDiasAtrasoIni = lisDiasAtrasoIni;
	}
	public List getLisDiasAtrasoFin() {
		return lisDiasAtrasoFin;
	}
	public void setLisDiasAtrasoFin(List lisDiasAtrasoFin) {
		this.lisDiasAtrasoFin = lisDiasAtrasoFin;
	}
	public List getLisNumEtapa() {
		return lisNumEtapa;
	}
	public void setLisNumEtapa(List lisNumEtapa) {
		this.lisNumEtapa = lisNumEtapa;
	}
	public List getLisEtiquetaEtapa() {
		return lisEtiquetaEtapa;
	}
	public void setLisEtiquetaEtapa(List lisEtiquetaEtapa) {
		this.lisEtiquetaEtapa = lisEtiquetaEtapa;
	}
	public List getLisAccion() {
		return lisAccion;
	}
	public void setLisAccion(List lisAccion) {
		this.lisAccion = lisAccion;
	}
	public List getLisFormatoNoti() {
		return lisFormatoNoti;
	}
	public void setLisFormatoNoti(List lisFormatoNoti) {
		this.lisFormatoNoti = lisFormatoNoti;
	}
	

}
