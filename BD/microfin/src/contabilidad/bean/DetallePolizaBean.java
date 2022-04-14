package contabilidad.bean;

import general.bean.BaseBean;

public class DetallePolizaBean extends BaseBean{
	private String empresaID; 
	private String polizaID; 
	private String fecha; 
	private String centroCostoID; 
	private String cuentaCompleta;
	private String instrumento; 
	private String monedaID; 
	private String cargos;
	private String abonos;
	private String descripcion;
	private String referencia; 
	private String procedimientoCont; 
	private String RFC;
	private String totalFactura;	
	private String folioUUID;
	
	private String usuario; 
	private String fechaActual;
	private String direccionIP; 
	private String programaID;
	private String sucursal; 
	private String numTransaccion;
	
	
	//axuliar para la carga masiva de Polizas	
	private String desCuentaCompleta;
	private String desPertenece;
	
	
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getCentroCostoID() {
		return centroCostoID;
	}
	public void setCentroCostoID(String centroCostoID) {
		this.centroCostoID = centroCostoID;
	}
	public String getCuentaCompleta() {
		return cuentaCompleta;
	}
	public void setCuentaCompleta(String cuentaCompleta) {
		this.cuentaCompleta = cuentaCompleta;
	}
	public String getInstrumento() {
		return instrumento;
	}
	public void setInstrumento(String instrumento) {
		this.instrumento = instrumento;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getCargos() {
		return cargos;
	}
	public void setCargos(String cargos) {
		this.cargos = cargos;
	}
	public String getAbonos() {
		return abonos;
	}
	public void setAbonos(String abonos) {
		this.abonos = abonos;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getProcedimientoCont() {
		return procedimientoCont;
	}
	public void setProcedimientoCont(String procedimientoCont) {
		this.procedimientoCont = procedimientoCont;
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
	public String getRFC() {
		return RFC;
	}
	public void setRFC(String rFC) {
		RFC = rFC;
	}
	public String getTotalFactura() {
		return totalFactura;
	}
	public void setTotalFactura(String totalFactura) {
		this.totalFactura = totalFactura;
	}
	public String getFolioUUID() {
		return folioUUID;
	}
	public void setFolioUUID(String folioUUID) {
		this.folioUUID = folioUUID;
	}
	public String getDesCuentaCompleta() {
		return desCuentaCompleta;
	}
	public void setDesCuentaCompleta(String desCuentaCompleta) {
		this.desCuentaCompleta = desCuentaCompleta;
	}
	public String getDesPertenece() {
		return desPertenece;
	}
	public void setDesPertenece(String desPertenece) {
		this.desPertenece = desPertenece;
	}
	
	
}
