package credito.beanWS.request;

import general.bean.BaseBeanWS;

public class ConsultaPagosAplicadosRequest extends BaseBeanWS {
	private String institNominaID;
	private String negocioAfiliadoID;
	private String clienteID;
	private String fechaInicio;
	private String fechaFin;
	private String tipoCon;
	
	
	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public String getNegocioAfiliadoID() {
		return negocioAfiliadoID;
	}
	public void setNegocioAfiliadoID(String negocioAfiliadoID) {
		this.negocioAfiliadoID = negocioAfiliadoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getTipoCon() {
		return tipoCon;
	}
	public void setTipoCon(String tipoCon) {
		this.tipoCon = tipoCon;
	}
	
}
