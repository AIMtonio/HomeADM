package cliente.BeanWS.Request;

import general.bean.BaseBeanWS;

public class ActualizaEstatusEmpRequest extends BaseBeanWS{
	private String institNominaID;
	private String clienteID;
	private String estatus;
	private String fechaInicialInca;
	private String fechaFinInca;
	private String fechaBaja;
	private String motivoBaja;
	
	public String getFechaInicialInca() {
		return fechaInicialInca;
	}
	public void setFechaInicialInca(String fechaInicialInca) {
		this.fechaInicialInca = fechaInicialInca;
	}
	public String getFechaFinInca() {
		return fechaFinInca;
	}
	public void setFechaFinInca(String fechaFinInca) {
		this.fechaFinInca = fechaFinInca;
	}
	public String getFechaBaja() {
		return fechaBaja;
	}
	public void setFechaBaja(String fechaBaja) {
		this.fechaBaja = fechaBaja;
	}
	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public String getMotivoBaja() {
		return motivoBaja;
	}
	public void setMotivoBaja(String motivoBaja) {
		this.motivoBaja = motivoBaja;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	

}
