package originacion.beanWS.request;

import general.bean.BaseBeanWS;


public class SolicitudCreditoRequest extends BaseBeanWS{

	private String prospectoID;
	private String productoCreditoID;
	private String fechaRegistro;
	private String montoSolici;	
	private String tasaActiva;
	
	private String periodicidad;
	private String plazo;
	private String calificacion;
	private String tipoDispersion;	
	private String cuentaClabe;
	
	private String clienteID;
	private String forCobComApert;
	private String montoComApert;

	
	
	
	public String getForCobComApert() {
		return forCobComApert;
	}

	public void setForCobComApert(String forCobComApert) {
		this.forCobComApert = forCobComApert;
	}

	public String getMontoComApert() {
		return montoComApert;
	}

	public void setMontoComApert(String montoComApert) {
		this.montoComApert = montoComApert;
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

	public String getFechaRegistro() {
		return fechaRegistro;
	}

	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}

	public String getMontoSolici() {
		return montoSolici;
	}

	public void setMontoSolici(String montoSolici) {
		this.montoSolici = montoSolici;
	}

	public String getTasaActiva() {
		return tasaActiva;
	}

	public void setTasaActiva(String tasaActiva) {
		this.tasaActiva = tasaActiva;
	}

	public String getPeriodicidad() {
		return periodicidad;
	}

	public void setPeriodicidad(String periodicidad) {
		this.periodicidad = periodicidad;
	}

	public String getPlazo() {
		return plazo;
	}

	public void setPlazo(String plazo) {
		this.plazo = plazo;
	}

	public String getCalificacion() {
		return calificacion;
	}

	public void setCalificacion(String calificacion) {
		this.calificacion = calificacion;
	}

	public String getTipoDispersion() {
		return tipoDispersion;
	}

	public void setTipoDispersion(String tipoDispersion) {
		this.tipoDispersion = tipoDispersion;
	}

	public String getCuentaClabe() {
		return cuentaClabe;
	}

	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	
}
