package operacionesCRCB.beanWS.request;

public class ActualizaDireccionRequest extends BaseRequestBean {
	
	private String clienteID;
	private String direccionID;
	private String tipoDireccionID;
	private String estadoID;
	private String municipioID;
	private String localidadID;
	private String coloniaID;
	private String calle;
	private String numeroCasa;
	private String numInterior;
	private String piso;
	private String primeraEntreCalle;
	private String segundaEntreCalle;
	private String oficial;
	private String fiscal;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getDireccionID() {
		return direccionID;
	}
	public void setDireccionID(String direccionID) {
		this.direccionID = direccionID;
	}
	public String getTipoDireccionID() {
		return tipoDireccionID;
	}
	public void setTipoDireccionID(String tipoDireccionID) {
		this.tipoDireccionID = tipoDireccionID;
	}
	public String getEstadoID() {
		return estadoID;
	}
	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
	}
	public String getMunicipioID() {
		return municipioID;
	}
	public void setMunicipioID(String municipioID) {
		this.municipioID = municipioID;
	}
	public String getLocalidadID() {
		return localidadID;
	}
	public void setLocalidadID(String localidadID) {
		this.localidadID = localidadID;
	}
	public String getColoniaID() {
		return coloniaID;
	}
	public void setColoniaID(String coloniaID) {
		this.coloniaID = coloniaID;
	}
	public String getCalle() {
		return calle;
	}
	public void setCalle(String calle) {
		this.calle = calle;
	}
	public String getNumeroCasa() {
		return numeroCasa;
	}
	public void setNumeroCasa(String numeroCasa) {
		this.numeroCasa = numeroCasa;
	}
	public String getNumInterior() {
		return numInterior;
	}
	public void setNumInterior(String numInterior) {
		this.numInterior = numInterior;
	}
	public String getPiso() {
		return piso;
	}
	public void setPiso(String piso) {
		this.piso = piso;
	}
	public String getPrimeraEntreCalle() {
		return primeraEntreCalle;
	}
	public void setPrimeraEntreCalle(String primeraEntreCalle) {
		this.primeraEntreCalle = primeraEntreCalle;
	}
	public String getSegundaEntreCalle() {
		return segundaEntreCalle;
	}
	public void setSegundaEntreCalle(String segundaEntreCalle) {
		this.segundaEntreCalle = segundaEntreCalle;
	}
	public String getOficial() {
		return oficial;
	}
	public void setOficial(String oficial) {
		this.oficial = oficial;
	}
	public String getFiscal() {
		return fiscal;
	}
	public void setFiscal(String fiscal) {
		this.fiscal = fiscal;
	}

	
}
