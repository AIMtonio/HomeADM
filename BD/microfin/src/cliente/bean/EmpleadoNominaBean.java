package cliente.bean;

import general.bean.BaseBean;

public class EmpleadoNominaBean extends BaseBean {
	private String clienteID;
	private String prospectoID;
	private String institNominaID;
	private String nombreCompleto;
	private String estatusEmp;
	private String fechaInicialInca;
	private String fechaFinInca;
	private String fechaBaja;
	private String motivoBaja;
	private String nombreInstNomina;
	private String estatusAnterior;
	private String fechaAct;
	private String fechaInicio;
	private String fechaFin;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
	public String getClienteID() {
		return clienteID;
	}
	public String getInstitNominaID() {
		return institNominaID;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public String getEstatusEmp() {
		return estatusEmp;
	}
	public String getFechaInicialInca() {
		return fechaInicialInca;
	}
	public String getFechaFinInca() {
		return fechaFinInca;
	}
	public String getFechaBaja() {
		return fechaBaja;
	}
	public String getMotivoBaja() {
		return motivoBaja;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public void setEstatusEmp(String estatusEmp) {
		this.estatusEmp = estatusEmp;
	}
	public void setFechaInicialInca(String fechaInicialInca) {
		this.fechaInicialInca = fechaInicialInca;
	}
	public void setFechaFinInca(String fechaFinInca) {
		this.fechaFinInca = fechaFinInca;
	}
	public void setFechaBaja(String fechaBaja) {
		this.fechaBaja = fechaBaja;
	}
	public void setMotivoBaja(String motivoBaja) {
		this.motivoBaja = motivoBaja;
	}
	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}
	public String getMensajeRespuesta() {
		return mensajeRespuesta;
	}
	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}
	public void setMensajeRespuesta(String mensajeRespuesta) {
		this.mensajeRespuesta = mensajeRespuesta;
	}
	public String getNombreInstNomina() {
		return nombreInstNomina;
	}
	public void setNombreInstNomina(String nombreInstNomina) {
		this.nombreInstNomina = nombreInstNomina;
	}
	public String getEstatusAnterior() {
		return estatusAnterior;
	}
	public void setEstatusAnterior(String estatusAnterior) {
		this.estatusAnterior = estatusAnterior;
	}
	public String getFechaAct() {
		return fechaAct;
	}
	public void setFechaAct(String fechaAct) {
		this.fechaAct = fechaAct;
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


}
