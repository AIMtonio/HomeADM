package credito.bean;

import java.util.List;

public class CreditosOtorgarBean {
	private String fecha;
	private String montoTotal;
	private String tipoConsulta;
	private String productoCredito;
	private String sucursal;
	private String empresaNomina;
	private List creditoID;
	private String   valor;
	private List   estatus;
	private String credito;
	

	
	
	public List getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(List creditoID) {
		this.creditoID = creditoID;
	}
	public String getValor() {
		return valor;
	}
	public void setValor(String valor) {
		this.valor = valor;
	}
	public String getCredito() {
		return credito;
	}
	public void setCredito(String credito) {
		this.credito = credito;
	}	
	public List getEstatus() {
		return estatus;
	}
	public void setEstatus(List estatus) {
		this.estatus = estatus;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	
	public String getMontoTotal() {
		return montoTotal;
	}
	public void setMontoTotal(String montoTotal) {
		this.montoTotal = montoTotal;
	}
	
	public String getProductoCredito() {
		return productoCredito;
	}
	public void setProductoCredito(String productoCredito) {
		this.productoCredito = productoCredito;
	}
	
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getTipoConsulta() {
		return tipoConsulta;
	}
	public void setTipoConsulta(String tipoConsulta) {
		this.tipoConsulta = tipoConsulta;
	}
	public String getEmpresaNomina() {
		return empresaNomina;
	}
	public void setEmpresaNomina(String empresaNomina) {
		this.empresaNomina = empresaNomina;
	}

	
 
}
