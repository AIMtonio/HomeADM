package tesoreria.bean;

import general.bean.BaseBean;

public class SubCtaTituInvBanBean extends BaseBean {
	private String ConceptoInvBanID;
	private String TituNegocio;
	private String TituDispVenta;
	private String TituConsVenc;
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
	public String getTituNegocio() {
		return TituNegocio;
	}
	public void setTituNegocio(String tituNegocio) {
		TituNegocio = tituNegocio;
	}
	public String getTituDispVenta() {
		return TituDispVenta;
	}
	public void setTituDispVenta(String tituDispVenta) {
		TituDispVenta = tituDispVenta;
	}
	public String getTituConsVenc() {
		return TituConsVenc;
	}
	public void setTituConsVenc(String tituConsVenc) {
		TituConsVenc = tituConsVenc;
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