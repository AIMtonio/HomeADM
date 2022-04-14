package tesoreria.bean;

import general.bean.BaseBean;

public class SubCtaPlazoInvBanBean extends BaseBean {
	private String ConceptoInvBanID;
	private String Plazo;
	private String SubPlazoMayor;
	private String SubPlazoMenor;
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
	public String getPlazo() {
		return Plazo;
	}
	public void setPlazo(String plazo) {
		Plazo = plazo;
	}
	public String getSubPlazoMayor() {
		return SubPlazoMayor;
	}
	public void setSubPlazoMayor(String subPlazoMayor) {
		SubPlazoMayor = subPlazoMayor;
	}
	public String getSubPlazoMenor() {
		return SubPlazoMenor;
	}
	public void setSubPlazoMenor(String subPlazoMenor) {
		SubPlazoMenor = subPlazoMenor;
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
