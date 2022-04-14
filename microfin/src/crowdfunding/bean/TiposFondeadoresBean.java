package crowdfunding.bean;

import general.bean.BaseBean;

public class TiposFondeadoresBean extends BaseBean {

	private String tipoFondeadorID;
	private String descripcion;
	private String esObligadoSol;
	private String pagoEnIncumple;
	private String porcentajeMora;
	private String porcentajeComisi;
	private String estatus;
	private String empresaID;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;

	public String getTipoFondeadorID() {
		return tipoFondeadorID;
	}

	public void setTipoFondeadorID(String tipoFondeadorID) {
		this.tipoFondeadorID = tipoFondeadorID;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getEsObligadoSol() {
		return esObligadoSol;
	}

	public void setEsObligadoSol(String esObligadoSol) {
		this.esObligadoSol = esObligadoSol;
	}

	public String getPagoEnIncumple() {
		return pagoEnIncumple;
	}

	public void setPagoEnIncumple(String pagoEnIncumple) {
		this.pagoEnIncumple = pagoEnIncumple;
	}

	public String getPorcentajeMora() {
		return porcentajeMora;
	}

	public void setPorcentajeMora(String porcentajeMora) {
		this.porcentajeMora = porcentajeMora;
	}

	public String getPorcentajeComisi() {
		return porcentajeComisi;
	}

	public void setPorcentajeComisi(String porcentajeComisi) {
		this.porcentajeComisi = porcentajeComisi;
	}

	public String getEstatus() {
		return estatus;
	}

	public void setEstatus(String estatus) {
		this.estatus = estatus;
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

	public String getSucursal() {
		return sucursal;
	}

	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
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

	public String getNumTransaccion() {
		return numTransaccion;
	}

	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}

}