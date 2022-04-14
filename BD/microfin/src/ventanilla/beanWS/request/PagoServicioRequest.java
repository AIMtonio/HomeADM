package ventanilla.beanWS.request;

public class PagoServicioRequest {
	private String	catalogoServID;
	private String	sucursalID;
	private String	referencia;
	private String	segundaRefe;
	private String	montoServicio;
	private String	ivaServicio;
	private String	comision;
	private String	ivaComision;
	private String	total;
	private String	clienteID;
	private String	cuentasAhoID;
	
	
	public String getCatalogoServID() {
		return catalogoServID;
	}
	public void setCatalogoServID(String catalogoServID) {
		this.catalogoServID = catalogoServID;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getSegundaRefe() {
		return segundaRefe;
	}
	public void setSegundaRefe(String segundaRefe) {
		this.segundaRefe = segundaRefe;
	}
	public String getMontoServicio() {
		return montoServicio;
	}
	public void setMontoServicio(String montoServicio) {
		this.montoServicio = montoServicio;
	}
	public String getIvaServicio() {
		return ivaServicio;
	}
	public void setIvaServicio(String ivaServicio) {
		this.ivaServicio = ivaServicio;
	}
	public String getComision() {
		return comision;
	}
	public void setComision(String comision) {
		this.comision = comision;
	}
	public String getIvaComision() {
		return ivaComision;
	}
	public void setIvaComision(String ivaComision) {
		this.ivaComision = ivaComision;
	}
	public String getTotal() {
		return total;
	}
	public void setTotal(String total) {
		this.total = total;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentasAhoID() {
		return cuentasAhoID;
	}
	public void setCuentasAhoID(String cuentasAhoID) {
		this.cuentasAhoID = cuentasAhoID;
	}

}
