package cliente.bean;

import general.bean.BaseBean;

public class CicloCreditoBean extends BaseBean{	
	private String clienteID;
	private String prospectoID;
	private String productoCreditoID;
	private String grupoID;
	private String cicloCliente;
	private String cicloPondGrupo;
	private String calificaCredito;
	private String calificaCliente;
	private String plazoID;
	private String empresaNomina;
	private String convenioNominaID;


	// variables para la tasafija
	private String sucursal;
	
	private String montoCredito;
	private int numCreditos;
	private String valorTasa;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getGrupoID() {
		return grupoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public String getCicloCliente() {
		return cicloCliente;
	}
	public void setCicloCliente(String cicloCliente) {
		this.cicloCliente = cicloCliente;
	}
	public String getCicloPondGrupo() {
		return cicloPondGrupo;
	}
	public void setCicloPondGrupo(String cicloPondGrupo) {
		this.cicloPondGrupo = cicloPondGrupo;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getMontoCredito() {
		return montoCredito;
	}
	public void setMontoCredito(String montoCredito) {
		this.montoCredito = montoCredito;
	}
	
	public int getNumCreditos() {
		return numCreditos;
	}
	public void setNumCreditos(int numCreditos) {
		this.numCreditos = numCreditos;
	}
	public String getValorTasa() {
		return valorTasa;
	}
	public void setValorTasa(String valorTasa) {
		this.valorTasa = valorTasa;
	}

	public String getCalificaCredito() {
		return calificaCredito;
	}
	public void setCalificaCredito(String calificaCredito) {
		this.calificaCredito = calificaCredito;
	}
	public String getCalificaCliente() {
		return calificaCliente;
	}
	public void setCalificaCliente(String calificaCliente) {
		this.calificaCliente = calificaCliente;
	}
	public String getPlazoID() {
		return plazoID;
	}
	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
	}
	public String getEmpresaNomina() {
		return empresaNomina;
	}
	public void setEmpresaNomina(String empresaNomina) {
		this.empresaNomina = empresaNomina;
	}
	public String getConvenioNominaID() {
		return convenioNominaID;
	}
	public void setConvenioNominaID(String convenioNominaID) {
		this.convenioNominaID = convenioNominaID;
	}
	
	
	
}
