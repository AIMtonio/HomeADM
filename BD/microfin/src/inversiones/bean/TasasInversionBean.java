package inversiones.bean;

public class TasasInversionBean {

	private String tasaInversionID;
	private String tasaDescripcion;

	private int tipoInvercionID;
	private String tipoInversionDescripcion;

	private int diaInversionID;
	private String diaInversionDescripcion;

	private int montoInversionID;
	private String montoInversionDescripcion;
	private float monto;

	private float conceptoInversion;
	
	private float valorGat;		// Auxiliar para recoger el valor del GAT  en consultaPrincipal
	private float valorGatReal; 
	private String gatInformativo; 

	public String getTasaInversionID() {
		return tasaInversionID;
	}

	public void setTasaInversionID(String tasaInversionID) {
		this.tasaInversionID = tasaInversionID;
	}

	public String getTasaDescripcion() {
		return tasaDescripcion;
	}

	public void setTasaDescripcion(String tasaDescripcion) {
		this.tasaDescripcion = tasaDescripcion;
	}

	public int getTipoInvercionID() {
		return tipoInvercionID;
	}

	public void setTipoInvercionID(int tipoInvercionID) {
		this.tipoInvercionID = tipoInvercionID;
	}

	public String getTipoInversionDescripcion() {
		return tipoInversionDescripcion;
	}

	public void setTipoInversionDescripcion(String tipoInversionDescripcion) {
		this.tipoInversionDescripcion = tipoInversionDescripcion;
	}

	public int getDiaInversionID() {
		return diaInversionID;
	}

	public void setDiaInversionID(int diaInversionID) {
		this.diaInversionID = diaInversionID;
	}

	public String getDiaInversionDescripcion() {
		return diaInversionDescripcion;
	}

	public void setDiaInversionDescripcion(String diaInversionDescripcion) {
		this.diaInversionDescripcion = diaInversionDescripcion;
	}

	public int getMontoInversionID() {
		return montoInversionID;
	}

	public void setMontoInversionID(int montoInversionID) {
		this.montoInversionID = montoInversionID;
	}

	public String getMontoInversionDescripcion() {
		return montoInversionDescripcion;
	}

	public void setMontoInversionDescripcion(String montoInversionDescripcion) {
		this.montoInversionDescripcion = montoInversionDescripcion;
	}

	public float getMonto() {
		return monto;
	}

	public void setMonto(float monto) {
		this.monto = monto;
	}

	public float getConceptoInversion() {
		return conceptoInversion;
	}

	public void setConceptoInversion(float conceptoInversion) {
		this.conceptoInversion = conceptoInversion;
	}

	public float getValorGat() {
		return valorGat;
	}

	public void setValorGat(float valorGat) {
		this.valorGat = valorGat;
	}

	public float getValorGatReal() {
		return valorGatReal;
	}

	public void setValorGatReal(float valorGatReal) {
		this.valorGatReal = valorGatReal;
	}

	public String getGatInformativo() {
		return gatInformativo;
	}

	public void setGatInformativo(String gatInformativo) {
		this.gatInformativo = gatInformativo;
	}
	
	

}
