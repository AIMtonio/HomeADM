package nomina.bean;

import java.util.List;

import general.bean.BaseBean;

public class CondicionProductoNominaBean extends BaseBean {
	private String institNominaID;
	private String convenioNominaID;
	private List<String> lisProducCreditoID;
	private List<String> lisTipoTasaCred;
	private List<String> lisValorTasaCred;
	private List<String> lisCondicionCredID;
	private List<String> lisSucursalID;
	private List<String> lisTipoEmpleadoIDEsqTasa;
	private List<String> lisPlazoIDEsqTasa;
	private List<String> lisMaxCredEsqTasa;
	private List<String> lisMinCredEsqTasa;
	private List<String> lisMontoMinEsqTasa;
	private List<String> lisMontoMaxEsqTasa;
	private List<String> LisTasaEsqTasa;
	private List<String> lisTipoCobMora;
	private List<String> lisValorMora;
	private String CondicionCredID;
	private String valorTasa;
	private String cantidad;
	private String nCoincidencias;
	private String tipoCobMora;
	private String valorMora;
	private String producCreditoID;
	
	
	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public String getConvenioNominaID() {
		return convenioNominaID;
	}
	public void setConvenioNominaID(String convenioNominaID) {
		this.convenioNominaID = convenioNominaID;
	}
	public List<String> getLisProducCreditoID() {
		return lisProducCreditoID;
	}
	public void setLisProducCreditoID(List<String> lisProducCreditoID) {
		this.lisProducCreditoID = lisProducCreditoID;
	}
	public List<String> getLisTipoTasaCred() {
		return lisTipoTasaCred;
	}
	public void setLisTipoTasaCred(List<String> lisTipoTasaCred) {
		this.lisTipoTasaCred = lisTipoTasaCred;
	}
	public List<String> getLisValorTasaCred() {
		return lisValorTasaCred;
	}
	public void setLisValorTasaCred(List<String> lisValorTasaCred) {
		this.lisValorTasaCred = lisValorTasaCred;
	}
	public List<String> getLisCondicionCredID() {
		return lisCondicionCredID;
	}
	public void setLisCondicionCredID(List<String> lisCondicionCredID) {
		this.lisCondicionCredID = lisCondicionCredID;
	}
	public String getCondicionCredID() {
		return CondicionCredID;
	}
	public void setCondicionCredID(String condicionCredID) {
		CondicionCredID = condicionCredID;
	}
	public List<String> getLisSucursalID() {
		return lisSucursalID;
	}
	public void setLisSucursalID(List<String> lisSucursalID) {
		this.lisSucursalID = lisSucursalID;
	}
	public List<String> getLisTipoEmpleadoIDEsqTasa() {
		return lisTipoEmpleadoIDEsqTasa;
	}
	public void setLisTipoEmpleadoIDEsqTasa(List<String> lisTipoEmpleadoIDEsqTasa) {
		this.lisTipoEmpleadoIDEsqTasa = lisTipoEmpleadoIDEsqTasa;
	}
	public List<String> getLisPlazoIDEsqTasa() {
		return lisPlazoIDEsqTasa;
	}
	public void setLisPlazoIDEsqTasa(List<String> lisPlazoIDEsqTasa) {
		this.lisPlazoIDEsqTasa = lisPlazoIDEsqTasa;
	}
	public List<String> getLisMaxCredEsqTasa() {
		return lisMaxCredEsqTasa;
	}
	public void setLisMaxCredEsqTasa(List<String> lisMaxCredEsqTasa) {
		this.lisMaxCredEsqTasa = lisMaxCredEsqTasa;
	}
	public List<String> getLisMinCredEsqTasa() {
		return lisMinCredEsqTasa;
	}
	public void setLisMinCredEsqTasa(List<String> lisMinCredEsqTasa) {
		this.lisMinCredEsqTasa = lisMinCredEsqTasa;
	}
	public List<String> getLisMontoMinEsqTasa() {
		return lisMontoMinEsqTasa;
	}
	public void setLisMontoMinEsqTasa(List<String> lisMontoMinEsqTasa) {
		this.lisMontoMinEsqTasa = lisMontoMinEsqTasa;
	}
	public List<String> getLisMontoMaxEsqTasa() {
		return lisMontoMaxEsqTasa;
	}
	public void setLisMontoMaxEsqTasa(List<String> lisMontoMaxEsqTasa) {
		this.lisMontoMaxEsqTasa = lisMontoMaxEsqTasa;
	}
	public List<String> getLisTasaEsqTasa() {
		return LisTasaEsqTasa;
	}
	public void setLisTasaEsqTasa(List<String> lisTasaEsqTasa) {
		LisTasaEsqTasa = lisTasaEsqTasa;
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
	public String getnCoincidencias() {
		return nCoincidencias;
	}
	public void setnCoincidencias(String nCoincidencias) {
		this.nCoincidencias = nCoincidencias;
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
	public List<String> getLisTipoCobMora() {
		return lisTipoCobMora;
	}
	public void setLisTipoCobMora(List<String> lisTipoCobMora) {
		this.lisTipoCobMora = lisTipoCobMora;
	}
	public List<String> getLisValorMora() {
		return lisValorMora;
	}
	public void setLisValorMora(List<String> lisValorMora) {
		this.lisValorMora = lisValorMora;
	}
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
}
