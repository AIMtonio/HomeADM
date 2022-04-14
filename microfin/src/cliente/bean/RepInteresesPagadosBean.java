package cliente.bean;

import general.bean.BaseBean;

public class RepInteresesPagadosBean extends BaseBean{
	// datos de la pantalla
	private String fechaInicio;
	private String fechaFin;
	private String nombreInstitucion;
	private String fechaSistema;
	private String nombreUsuario;
	private String horaEmision;
	private String nomUsuario;
	
	// datos del reporte
	private String clienteID;
	private String nombreCompleto;
	private String instrumentoID;
	private String fechaApertura;
	private String fechaVencimiento;
	private String numDias;
	private String monto;
	private String tasaInteres;	
	private String interesesGen;
	private String ISR;
	private String interesReal;
	

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
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}
	public String getNomUsuario() {
		return nomUsuario;
	}
	public void setNomUsuario(String nomUsuario) {
		this.nomUsuario = nomUsuario;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getInstrumentoID() {
		return instrumentoID;
	}
	public void setInstrumentoID(String instrumentoID) {
		this.instrumentoID = instrumentoID;
	}
	public String getFechaApertura() {
		return fechaApertura;
	}
	public void setFechaApertura(String fechaApertura) {
		this.fechaApertura = fechaApertura;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getNumDias() {
		return numDias;
	}
	public void setNumDias(String numDias) {
		this.numDias = numDias;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getTasaInteres() {
		return tasaInteres;
	}
	public void setTasaInteres(String tasaInteres) {
		this.tasaInteres = tasaInteres;
	}
	public String getInteresesGen() {
		return interesesGen;
	}
	public void setInteresesGen(String interesesGen) {
		this.interesesGen = interesesGen;
	}
	public String getISR() {
		return ISR;
	}
	public void setISR(String iSR) {
		ISR = iSR;
	}
	public String getInteresReal() {
		return interesReal;
	}
	public void setInteresReal(String interesReal) {
		this.interesReal = interesReal;
	}
	
}
