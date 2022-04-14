package tesoreria.bean;

import general.bean.BaseBean;

public class CuentaMayorCajasBean  extends BaseBean{
	private String ConceptoCajaID; 
	private String Cuenta;
	private String Nomenclatura;
	private String NomenclaturaCR;
	private String empresaID; 
	private String usuario; 
	private String fechaActual; 
	private String direccionIP; 
	private String programaID; 
	private String sucursal;
	private String numTransaccion;
	
	public String getConceptoCajaID() {
		return ConceptoCajaID;
	}
	public void setConceptoCajaID(String conceptoCajaID) {
		ConceptoCajaID = conceptoCajaID;
	}
	public String getCuenta() {
		return Cuenta;
	}
	public void setCuenta(String cuenta) {
		this.Cuenta = cuenta;
	}
	public String getNomenclatura() {
		return Nomenclatura;
	}
	public void setNomenclatura(String nomenclatura) {
		Nomenclatura = nomenclatura;
	}
	public String getNomenclaturaCR() {
		return NomenclaturaCR;
	}
	public void setNomenclaturaCR(String nomenclaturaCR) {
		NomenclaturaCR = nomenclaturaCR;
	}

	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
}