package inversiones.bean;

public class TipoInversionBean {

	private String tipoInvercionID;
	private String descripcion;
	private String reinversion;
	private int monedaId;
	private String reinvertir;
	//Auxiliar
	private String descripcionMoneda;
	private String claveCNBV;
	private String claveCNBVAmpCred;
	//Variables para el RECA
	private String numRegistroRECA;
	private String fechaInscripcion;
	private String nombreComercial;
	private String estatus;
	
	private String pagoPeriodico;
	
	public String getTipoInvercionID() {
		return tipoInvercionID;
	}
	public void setTipoInvercionID(String tipoInvercionID) {
		this.tipoInvercionID = tipoInvercionID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getReinversion() {
		return reinversion;
	}
	public void setReinversion(String reinversion) {
		this.reinversion = reinversion;
	}
	public int getMonedaId() {
		return monedaId;
	}
	public void setMonedaId(int monedaId) {
		this.monedaId = monedaId;
	}
	public String getReinvertir() {
		return reinvertir;
	}
	public void setReinvertir(String reinvertir) {
		this.reinvertir = reinvertir;
	}
	public String getDescripcionMoneda() {
		return descripcionMoneda;
	}
	public void setDescripcionMoneda(String descripcionMoneda) {
		this.descripcionMoneda = descripcionMoneda;
	}
	public String getClaveCNBV() {
		return claveCNBV;
	}
	public void setClaveCNBV(String claveCNBV) {
		this.claveCNBV = claveCNBV;
	}
	public String getClaveCNBVAmpCred() {
		return claveCNBVAmpCred;
	}
	public void setClaveCNBVAmpCred(String claveCNBVAmpCred) {
		this.claveCNBVAmpCred = claveCNBVAmpCred;
	}
	public String getNumRegistroRECA() {
		return numRegistroRECA;
	}
	public void setNumRegistroRECA(String numRegistroRECA) {
		this.numRegistroRECA = numRegistroRECA;
	}
	public String getFechaInscripcion() {
		return fechaInscripcion;
	}
	public void setFechaInscripcion(String fechaInscripcion) {
		this.fechaInscripcion = fechaInscripcion;
	}
	public String getNombreComercial() {
		return nombreComercial;
	}
	public void setNombreComercial(String nombreComercial) {
		this.nombreComercial = nombreComercial;
	}
	public String getPagoPeriodico() {
		return pagoPeriodico;
	}
	public void setPagoPeriodico(String pagoPeriodico) {
		this.pagoPeriodico = pagoPeriodico;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
		
}
