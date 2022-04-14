package cliente.bean;

import general.bean.BaseBean;

public class DireccionesClienteBean extends BaseBean{
	//Declaracion de Constantes
	public static int LONGITUD_ID =3;

	private String clienteID;
	private String direccionID;
	private String empresaID;
	private String tipoDireccionID;
	private String estadoID;
	private String municipioID;
	private String localidadID;
	private String calle;
	private String numeroCasa;
	private String numInterior;
	private String piso;
	private String primEntreCalle;
	private String segEntreCalle;
	private String coloniaID;
	private String CP;
	private String direccionCompleta;
	private String descripcion;
	private String latitud;
	private String longitud;
	private String oficial;
	private String fiscal;
	private String lote;
	private String manzana;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	private String nombreLocalidad;
	private String nombreColonia;
	private String Asentamiento;
	private String colonia;

	private String eqBuroCred;
	private String municipioNombre;	 

	private	String esMarginada; 
	private int numeroHabitantes;
	
	private String paisID;
	private String nombrePais;
	private String aniosRes;
	
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

	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
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
	public String getColoniaID() {
		return coloniaID;
	}
	public void setColoniaID(String coloniaID) {
		this.coloniaID = coloniaID;
	}
	
	public String getCP() {
		return CP;
	}
	public void setCP(String cP) {
		CP = cP;
	}
	public String getDireccionCompleta() {
		return direccionCompleta;
	}
	public void setDireccionCompleta(String direccionCompleta) {
		this.direccionCompleta = direccionCompleta;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
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
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
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
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getLocalidadID() {
		return localidadID;
	}
	public void setLocalidadID(String localidadID) {
		this.localidadID = localidadID;
	}
	public String getNombreLocalidad() {
		return nombreLocalidad;
	}
	public void setNombreLocalidad(String nombreLocalidad) {
		this.nombreLocalidad = nombreLocalidad;
	}
	public String getNombreColonia() {
		return nombreColonia;
	}
	public void setNombreColonia(String nombreColonia) {
		this.nombreColonia = nombreColonia;
	}
	public String getAsentamiento() {
		return Asentamiento;
	}
	public void setAsentamiento(String asentamiento) {
		Asentamiento = asentamiento;
	}
	public String getColonia() {
		return colonia;
	}
	public void setColonia(String colonia) {
		this.colonia = colonia;
	}
	public String getEqBuroCred() {
		return eqBuroCred;
	}
	public void setEqBuroCred(String eqBuroCred) {
		this.eqBuroCred = eqBuroCred;
	}
	public String getMunicipioNombre() {
		return municipioNombre;
	}
	public void setMunicipioNombre(String municipioNombre) {
		this.municipioNombre = municipioNombre;
	}
	public String getEsMarginada() {
		return esMarginada;
	}
	public void setEsMarginada(String esMarginada) {
		this.esMarginada = esMarginada;
	}
	public int getNumeroHabitantes() {
		return numeroHabitantes;
	}
	public void setNumeroHabitantes(int numeroHabitantes) {
		this.numeroHabitantes = numeroHabitantes;
	}
	public String getPaisID() {
		return paisID;
	}
	public void setPaisID(String paisID) {
		this.paisID = paisID;
	}
	public String getNombrePais() {
		return nombrePais;
	}
	public void setNombrePais(String nombrePais) {
		this.nombrePais = nombrePais;
	}
	public String getAniosRes() {
		return aniosRes;
	}
	public void setAniosRes(String aniosRes) {
		this.aniosRes = aniosRes;
	}
	

}
