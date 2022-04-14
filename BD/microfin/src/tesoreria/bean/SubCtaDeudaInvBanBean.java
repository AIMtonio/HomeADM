package tesoreria.bean;

import general.bean.BaseBean;

public class SubCtaDeudaInvBanBean extends BaseBean {
	private String ConceptoInvBanID;
	private String TipoDeuGuber;
	private String TipoDeuBanca;
	private String TipoDeuOtros;
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
	public String getTipoDeuGuber() {
		return TipoDeuGuber;
	}
	public void setTipoDeuGuber(String tipoDeuGuber) {
		TipoDeuGuber = tipoDeuGuber;
	}
	public String getTipoDeuBanca() {
		return TipoDeuBanca;
	}
	public void setTipoDeuBanca(String tipoDeuBanca) {
		TipoDeuBanca = tipoDeuBanca;
	}
	public String getTipoDeuOtros() {
		return TipoDeuOtros;
	}
	public void setTipoDeuOtros(String tipoDeuOtros) {
		TipoDeuOtros = tipoDeuOtros;
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