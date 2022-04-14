package soporte.bean;

public class ValidaCajasTransferBean {
	private String valCajaParamID;
	private String horaInicio;
	private String numEjecuciones;
	private String intervalo;
	private String expresionCron;
	
	private String remitenteID;
	private String descripcion;
	private String destinatarioID;
	private String destinatarioNombre;
	private String conCopiaID;
	private String conCopiaNombre;
	private String tipo;
	private String detalle;
	
	public String getValCajaParamID() {
		return valCajaParamID;
	}
	public void setValCajaParamID(String valCajaParamID) {
		this.valCajaParamID = valCajaParamID;
	}
	public String getHoraInicio() {
		return horaInicio;
	}
	public void setHoraInicio(String horaInicio) {
		this.horaInicio = horaInicio;
	}
	public String getNumEjecuciones() {
		return numEjecuciones;
	}
	public void setNumEjecuciones(String numEjecuciones) {
		this.numEjecuciones = numEjecuciones;
	}
	public String getIntervalo() {
		return intervalo;
	}
	public void setIntervalo(String intervalo) {
		this.intervalo = intervalo;
	}
	public String getRemitenteID() {
		return remitenteID;
	}
	public void setRemitenteID(String remitenteID) {
		this.remitenteID = remitenteID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getDestinatarioID() {
		return destinatarioID;
	}
	public void setDestinatarioID(String destinatarioID) {
		this.destinatarioID = destinatarioID;
	}
	public String getDestinatarioNombre() {
		return destinatarioNombre;
	}
	public void setDestinatarioNombre(String destinatarioNombre) {
		this.destinatarioNombre = destinatarioNombre;
	}
	public String getConCopiaID() {
		return conCopiaID;
	}
	public void setConCopiaID(String conCopiaID) {
		this.conCopiaID = conCopiaID;
	}
	public String getConCopiaNombre() {
		return conCopiaNombre;
	}
	public void setConCopiaNombre(String conCopiaNombre) {
		this.conCopiaNombre = conCopiaNombre;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getDetalle() {
		return detalle;
	}
	public void setDetalle(String detalle) {
		this.detalle = detalle;
	}
	public String getExpresionCron() {
		return expresionCron;
	}
	public void setExpresionCron(String expresionCron) {
		this.expresionCron = expresionCron;
	}
}