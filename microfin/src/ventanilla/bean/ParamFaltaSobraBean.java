package ventanilla.bean;

import general.bean.BaseBean;

public class ParamFaltaSobraBean extends BaseBean{
	
	private String paramFaltaSobraID;
	private String sucursalID;
	private String montoMaximoSobra;
	private String montoMaximoFalta;
	private String empresaID;
	
	
	public String getParamFaltaSobraID() {
		return paramFaltaSobraID;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public String getMontoMaximoSobra() {
		return montoMaximoSobra;
	}
	public String getMontoMaximoFalta() {
		return montoMaximoFalta;
	}
	public void setParamFaltaSobraID(String paramFaltaSobraID) {
		this.paramFaltaSobraID = paramFaltaSobraID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public void setMontoMaximoSobra(String montoMaximoSobra) {
		this.montoMaximoSobra = montoMaximoSobra;
	}
	public void setMontoMaximoFalta(String montoMaximoFalta) {
		this.montoMaximoFalta = montoMaximoFalta;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	
	
	
	

}
