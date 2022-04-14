package nomina.bean;

import general.bean.BaseBean;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

import originacion.bean.EsquemaOtrosAccesoriosBean;

import java.util.List;

public class EsqComAperNominaBean extends BaseBean{
		// Declaración de Atributos
			
		private String esqComApertID ;
		private String institNominaID;
		private String producCreditoID;
		private String manejaEsqConvenio;
	
		private String esqConvComAperID;
		private String convenioNominaID;
		private String formCobroComAper;
		private String tipoComApert;
		private String plazoID;
		private String montoMin;
		private String montoMax;
		private String valor;
		private String fila;
  
  private List<String> lisPlazoID;

	public String getEsqComApertID() {
		return esqComApertID;
	}
	public void setEsqComApertID(String esqComApertID) {
		this.esqComApertID = esqComApertID;
	}
	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	public String getManejaEsqConvenio() {
		return manejaEsqConvenio;
	}
	public void setManejaEsqConvenio(String manejaEsqConvenio) {
		this.manejaEsqConvenio = manejaEsqConvenio;
	}
	public String getEsqConvComAperID() {
		return esqConvComAperID;
	}
	public void setEsqConvComAperID(String esqConvComAperID) {
		this.esqConvComAperID = esqConvComAperID;
	}
	public String getConvenioNominaID() {
		return convenioNominaID;
	}
	public void setConvenioNominaID(String convenioNominaID) {
		this.convenioNominaID = convenioNominaID;
	}
	public String getFormCobroComAper() {
		return formCobroComAper;
	}
	public void setFormCobroComAper(String formCobroComAper) {
		this.formCobroComAper = formCobroComAper;
	}
	public String getTipoComApert() {
		return tipoComApert;
	}
	public void setTipoComApert(String tipoComApert) {
		this.tipoComApert = tipoComApert;
	}
	public String getPlazoID() {
		return plazoID;
	}
	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
	}
	public String getMontoMin() {
		return montoMin;
	}
	public void setMontoMin(String montoMin) {
		this.montoMin = montoMin;
	}
	public String getMontoMax() {
		return montoMax;
	}
	public void setMontoMax(String montoMax) {
		this.montoMax = montoMax;
	}
	public String getValor() {
		return valor;
	}
	public void setValor(String valor) {
		this.valor = valor;
	}
	public List<String> getLisPlazoID() {
		return lisPlazoID;
	}
	public void setLisPlazoID(List<String> lisPlazoID) {
		this.lisPlazoID = lisPlazoID;
	}
	public String getFila() {
		return fila==null ? "":fila;
	}
	public void setFila(String fila) {
		this.fila = fila;
	}
}
