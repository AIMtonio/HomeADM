package originacion.bean;

import general.bean.BaseBean;

public class CasasComercialesBean extends BaseBean{
	
	private String casaID;
	private String nombreCasa;
	private String tipoDispersion;
	private String institucionID;
	private String cuentaClabe;
	private String estatus;
	private String rfc;
	
	public String getCasaID() {
		return casaID;
	}
	public void setCasaID(String casaID) {
		this.casaID = casaID;
	}
	public String getNombreCasa() {
		return nombreCasa;
	}
	public void setNombreCasa(String nombreCasa) {
		this.nombreCasa = nombreCasa;
	}
	public String getTipoDispersion() {
		return tipoDispersion;
	}
	public void setTipoDispersion(String tipoDispersion) {
		this.tipoDispersion = tipoDispersion;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getCuentaClabe() {
		return cuentaClabe;
	}
	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getRfc() {
		return rfc;
	}
	public void setRfc(String rfc) {
		this.rfc = rfc;
	}

}
