package nomina.bean;

import general.bean.BaseBean;

import java.util.List;

public class ComApertConvenioBean extends BaseBean{
	// Declaración de Atributos
  private String esqConvComAperID;
  private String EsqComApertID;
  private String convenioNominaID;
  private String formCobroComAper;
  private String tipoComApert;
  private String plazoID;
  private String montoMin;
  private String montoMax;
  private String valor;
  private String fila;
  private String monto;
  
  private List<String> lisConvenioId;
  private List<String> lisPlazoID;

	public String getEsqConvComAperID() {
		return esqConvComAperID;
	}
	public void setEsqConvComAperID(String esqConvComAperID) {
		this.esqConvComAperID = esqConvComAperID;
	}
	public String getEsqComApertID() {
		return EsqComApertID;
	}
	public void setEsqComApertID(String esqComApertID) {
		EsqComApertID = esqComApertID;
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
	public String getFila() {
		return fila;
	}
	public void setFila(String fila) {
		this.fila = fila;
	}
	public List<String> getLisConvenioId() {
		return lisConvenioId;
	}
	public void setLisConvenioId(List<String> lisConvenioId) {
		this.lisConvenioId = lisConvenioId;
	}
	public List<String> getLisPlazoID() {
		return lisPlazoID;
	}
	public void setLisPlazoID(List<String> lisPlazoID) {
		this.lisPlazoID = lisPlazoID;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
}
