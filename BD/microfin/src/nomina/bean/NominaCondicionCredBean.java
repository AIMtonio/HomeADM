package nomina.bean;

import general.bean.BaseBean;

public class NominaCondicionCredBean extends BaseBean {
	private String condicionCredID;
	private String convenioNominaID;
	private String institNominaID;
	private String producCreditoID;
	private String tipoTasa;
	private String valorTasa;
	private String cantidad;
	private String nCoincidencias;
	private String tipoCobMora;
	private String valorMora;
	
	public String getnCoincidencias() {
		return nCoincidencias;
	}
	public void setnCoincidencias(String nCoincidencias) {
		this.nCoincidencias = nCoincidencias;
	}
	public String getCondicionCredID() {
		return condicionCredID;
	}
	public void setCondicionCredID(String condicionCredID) {
		this.condicionCredID = condicionCredID;
	}
	public String getConvenioNominaID() {
		return convenioNominaID;
	}
	public void setConvenioNominaID(String convenioNominaID) {
		this.convenioNominaID = convenioNominaID;
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
	public String getTipoTasa() {
		return tipoTasa;
	}
	public void setTipoTasa(String tipoTasa) {
		this.tipoTasa = tipoTasa;
	}
	public String getValorTasa() {
		return valorTasa;
	}
	public void setValorTasa(String valorTasa) {
		this.valorTasa = valorTasa;
	}
	public String getCantidad() {
		return cantidad;
	}
	public void setCantidad(String cantidad) {
		this.cantidad = cantidad;
	}
	public String getTipoCobMora() {
		return tipoCobMora;
	}
	public void setTipoCobMora(String tipoCobMora) {
		this.tipoCobMora = tipoCobMora;
	}
	public String getValorMora() {
		return valorMora;
	}
	public void setValorMora(String valorMora) {
		this.valorMora = valorMora;
	}
}
