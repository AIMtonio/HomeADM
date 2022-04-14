package tesoreria.bean;

import general.bean.BaseBean;

public class SubCtaRestInvBanBean extends BaseBean {
	private String ConceptoInvBanID;
	private String RestricionCon;
	private String RestricionSin;
	private String EmpresaID;
	private String Usuario;
	private String FechaActual;
	private String DireccionIP;
	private String ProgramaID;
	private String Sucursal;
	private String NumTransaccion;
	public String getConceptoInvBanID() {
		return ConceptoInvBanID;
	}
	public void setConceptoInvBanID(String conceptoInvBanID) {
		ConceptoInvBanID = conceptoInvBanID;
	}
	public String getRestricionCon() {
		return RestricionCon;
	}
	public void setRestricionCon(String restricionCon) {
		RestricionCon = restricionCon;
	}
	public String getRestricionSin() {
		return RestricionSin;
	}
	public void setRestricionSin(String restricionSin) {
		RestricionSin = restricionSin;
	}
	public String getEmpresaID() {
		return EmpresaID;
	}
	public void setEmpresaID(String empresaID) {
		EmpresaID = empresaID;
	}
	public String getUsuario() {
		return Usuario;
	}
	public void setUsuario(String usuario) {
		Usuario = usuario;
	}
	public String getFechaActual() {
		return FechaActual;
	}
	public void setFechaActual(String fechaActual) {
		FechaActual = fechaActual;
	}
	public String getDireccionIP() {
		return DireccionIP;
	}
	public void setDireccionIP(String direccionIP) {
		DireccionIP = direccionIP;
	}
	public String getProgramaID() {
		return ProgramaID;
	}
	public void setProgramaID(String programaID) {
		ProgramaID = programaID;
	}
	public String getSucursal() {
		return Sucursal;
	}
	public void setSucursal(String sucursal) {
		Sucursal = sucursal;
	}
	public String getNumTransaccion() {
		return NumTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		NumTransaccion = numTransaccion;
	}
}