package regulatorios.bean;

import general.bean.BaseBean;

public class RegulatorioB1524Bean extends BaseBean{
	
	private String anio;
	private String mes;
	private String periodo;
	private String claveEntidad;
	private String numReporte;
	private String servicios;
	private String persJuridica	;
	private String tipoCliente;	
	private String numClientes;
	private String numFacultadas;
	private String numOperaron;

	private String valor;


	 
	/*PARAMETROS DE AUDITORIA */
	private String empresaID;
	private String usuario;
	private String fechaActual;  
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	public String getAnio() {
		return anio;
	}
	public void setAnio(String anio) {
		this.anio = anio;
	}
	public String getMes() {
		return mes;
	}
	public void setMes(String mes) {
		this.mes = mes;
	}
	public String getPeriodo() {
		return periodo;
	}
	public void setPeriodo(String periodo) {
		this.periodo = periodo;
	}
	public String getClaveEntidad() {
		return claveEntidad;
	}
	public void setClaveEntidad(String claveEntidad) {
		this.claveEntidad = claveEntidad;
	}
	public String getNumReporte() {
		return numReporte;
	}
	public void setNumReporte(String numReporte) {
		this.numReporte = numReporte;
	}
	public String getPersJuridica() {
		return persJuridica;
	}
	public void setPersJuridica(String persJuridica) {
		this.persJuridica = persJuridica;
	}
	public String getTipoCliente() {
		return tipoCliente;
	}
	public void setTipoCliente(String tipoCliente) {
		this.tipoCliente = tipoCliente;
	}
	public String getNumClientes() {
		return numClientes;
	}
	public void setNumClientes(String numClientes) {
		this.numClientes = numClientes;
	}
	public String getNumFacultadas() {
		return numFacultadas;
	}
	public void setNumFacultadas(String numFacultadas) {
		this.numFacultadas = numFacultadas;
	}
	public String getNumOperaron() {
		return numOperaron;
	}
	public void setNumOperaron(String numOperaron) {
		this.numOperaron = numOperaron;
	}
	public String getValor() {
		return valor;
	}
	public void setValor(String valor) {
		this.valor = valor;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
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
	public String getServicios() {
		return servicios;
	}
	public void setServicios(String servicios) {
		this.servicios = servicios;
	}
	
	
	
}
