package tesoreria.bean;

import general.bean.BaseBean;

public class ReporteChequesEmitidosBean extends BaseBean{

	private String fechaInicioEmision;
	private String fechaFinalEmision;
	private String institucionBancaria;
	private String numeroCuentaBancaria;
	private String numeroCheque;
	private String estatus;
	private String sucursalEmision;
	private String nombreInstitucion;
	private String fechaSistema;
	private String nombreInstitucionBancaria;
	private String nombreSucursalEmision;
	private String tipoChequera;
	
	public String getFechaInicioEmision() {
		return fechaInicioEmision;
	}
	public void setFechaInicioEmision(String fechaInicioEmision) {
		this.fechaInicioEmision = fechaInicioEmision;
	}
	public String getFechaFinalEmision() {
		return fechaFinalEmision;
	}
	public void setFechaFinalEmision(String fechaFinalEmision) {
		this.fechaFinalEmision = fechaFinalEmision;
	}
	public String getInstitucionBancaria() {
		return institucionBancaria;
	}
	public void setInstitucionBancaria(String institucionBancaria) {
		this.institucionBancaria = institucionBancaria;
	}
	public String getNumeroCuentaBancaria() {
		return numeroCuentaBancaria;
	}
	public void setNumeroCuentaBancaria(String numeroCuentaBancaria) {
		this.numeroCuentaBancaria = numeroCuentaBancaria;
	}
	public String getNumeroCheque() {
		return numeroCheque;
	}
	public void setNumeroCheque(String numeroCheque) {
		this.numeroCheque = numeroCheque;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getSucursalEmision() {
		return sucursalEmision;
	}
	public void setSucursalEmision(String sucursalEmision) {
		this.sucursalEmision = sucursalEmision;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getNombreInstitucionBancaria() {
		return nombreInstitucionBancaria;
	}
	public void setNombreInstitucionBancaria(String nombreInstitucionBancaria) {
		this.nombreInstitucionBancaria = nombreInstitucionBancaria;
	}
	public String getNombreSucursalEmision() {
		return nombreSucursalEmision;
	}
	public void setNombreSucursalEmision(String nombreSucursalEmision) {
		this.nombreSucursalEmision = nombreSucursalEmision;
	}
	public String getTipoChequera() {
		return tipoChequera;
	}
	public void setTipoChequera(String tipoChequera) {
		this.tipoChequera = tipoChequera;
	}

}
