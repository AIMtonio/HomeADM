package cliente.BeanWS.Response;

import general.bean.BaseBeanWS;

public class ConsultaDireccionClientesResponse extends BaseBeanWS{

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
	private String primEntreCalle;
	private String segEntreCalle;
	private String CP;
	private String latitud;
	
	private String longitud;
	private String lote;
	private String manzana;
	private String oficial;
	private String fiscal;
	private String descripcion;
	
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
	public String getPrimEntreCalle() {
		return primEntreCalle;
	}
	public void setPrimEntreCalle(String primEntreCalle) {
		this.primEntreCalle = primEntreCalle;
	}
	public String getSegEntreCalle() {
		return segEntreCalle;
	}
	public void setSegEntreCalle(String segEntreCalle) {
		this.segEntreCalle = segEntreCalle;
	}
	public String getCP() {
		return CP;
	}
	public void setCP(String cP) {
		CP = cP;
	}
	public String getLatitud() {
		return latitud;
	}
	public void setLatitud(String latitud) {
		this.latitud = latitud;
	}
	public String getLongitud() {
		return longitud;
	}
	public void setLongitud(String longitud) {
		this.longitud = longitud;
	}
	public String getLote() {
		return lote;
	}
	public void setLote(String lote) {
		this.lote = lote;
	}
	public String getManzana() {
		return manzana;
	}
	public void setManzana(String manzana) {
		this.manzana = manzana;
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
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
}
