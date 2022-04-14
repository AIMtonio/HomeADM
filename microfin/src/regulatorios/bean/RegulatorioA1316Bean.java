package regulatorios.bean;

import general.bean.BaseBean;

public class RegulatorioA1316Bean extends BaseBean{
	
	private String valor;
	private String fechaConsultaActual;
	private String fechaConsultaAnterior;
	private String numReporte;
	private String cuentaContable;
	private String descripcionCuenta;
	private String cargos;
	private String negrita;

	/*PARAMETROS DE AUDITORIA */
	private String empresaID;
	private String usuario;
	private String fechaActual;  
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	public String getValor() {
		return valor;
	}
	public void setValor(String valor) {
		this.valor = valor;
	}
	public String getFechaConsultaActual() {
		return fechaConsultaActual;
	}
	public void setFechaConsultaActual(String fechaConsultaActual) {
		this.fechaConsultaActual = fechaConsultaActual;
	}
	public String getFechaConsultaAnterior() {
		return fechaConsultaAnterior;
	}
	public void setFechaConsultaAnterior(String fechaConsultaAnterior) {
		this.fechaConsultaAnterior = fechaConsultaAnterior;
	}
	public String getNumReporte() {
		return numReporte;
	}
	public void setNumReporte(String numReporte) {
		this.numReporte = numReporte;
	}
	public String getCuentaContable() {
		return cuentaContable;
	}
	public void setCuentaContable(String cuentaContable) {
		this.cuentaContable = cuentaContable;
	}
	public String getDescripcionCuenta() {
		return descripcionCuenta;
	}
	public void setDescripcionCuenta(String descripcionCuenta) {
		this.descripcionCuenta = descripcionCuenta;
	}
	public String getCargos() {
		return cargos;
	}
	public void setCargos(String cargos) {
		this.cargos = cargos;
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
	public String getNegrita() {
		return negrita;
	}
	public void setNegrita(String negrita) {
		this.negrita = negrita;
	}
}
