package soporte.bean;

import general.bean.BaseBean;

public class SucursalesBean extends BaseBean{
	//Declaracion de Constantes
	public static int LONGITUD_ID = 3;

	private String sucursalID;
	private	String empresaID;
	private	String nombreSucurs;
	private	String tipoSucursal;
	private	String fechaSucursal;
	private	String estadoID;
	private	String municipioID;
	private	String CP;
	private	String colonia;
	private	String calle;
	private	String numero;
	private	String direcCompleta;
	private	String plazaID;
	private	String IVA;
	private	String centroCostoID;
	private	String telefono;
	private	String nombreGerente;
	private	String subGerente;
	private	String tasaISR;
	private	String difHorarMatriz;
	private	String estatus;
	private	String usuario;
	private	String fechaActual;
	private	String direccionIP;
	private	String programaID;
	private	String sucursal;
	private	String numTransaccion;
	private String poderNotarial;
	private	String poder;
	private String tituloGte;
	private String tituloSubGte;
	private String extTelefonoPart;
	private String promotorCaptaID;
	private String claveSucCNBV;
	private String claveSucOpeCred;
	private String horaInicioOper;
	private String horaFinOper;
	
	// auxiliares del bean
	private String nombreMunicipio;
	private String nombreEstado;
	
	private String localidadID;
	private String coloniaID;
	
	private String latitud;
	private String longitud;
	
	public String getNombreEstado() {
		return nombreEstado;
	}
	public void setNombreEstado(String nombreEstado) {
		this.nombreEstado = nombreEstado;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getNombreSucurs() {
		return nombreSucurs;
	}
	public void setNombreSucurs(String nombreSucurs) {
		this.nombreSucurs = nombreSucurs;
	}
	public String getTipoSucursal() {
		return tipoSucursal;
	}
	public void setTipoSucursal(String tipoSucursal) {
		this.tipoSucursal = tipoSucursal;
	}
	public String getFechaSucursal() {
		return fechaSucursal;
	}
	public void setFechaSucursal(String fechaSucursal) {
		this.fechaSucursal = fechaSucursal;
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
	public String getCP() {
		return CP;
	}
	public void setCP(String cP) {
		CP = cP;
	}
	public String getColonia() {
		return colonia;
	}
	public void setColonia(String colonia) {
		this.colonia = colonia;
	}
	public String getCalle() {
		return calle;
	}
	public void setCalle(String calle) {
		this.calle = calle;
	}
	public String getNumero() {
		return numero;
	}
	public void setNumero(String numero) {
		this.numero = numero;
	}
	public String getDirecCompleta() {
		return direcCompleta;
	}
	public void setDirecCompleta(String direcCompleta) {
		this.direcCompleta = direcCompleta;
	}
	public String getPlazaID() {
		return plazaID;
	}
	public void setPlazaID(String plazaID) {
		this.plazaID = plazaID;
	}
	public String getIVA() {
		return IVA;
	}
	public void setIVA(String iVA) {
		IVA = iVA;
	}
	public String getCentroCostoID() {
		return centroCostoID;
	}
	public void setCentroCostoID(String centroCostoID) {
		this.centroCostoID = centroCostoID;
	}
	public String getTelefono() {
		return telefono;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	public String getNombreGerente() {
		return nombreGerente;
	}
	public void setNombreGerente(String nombreGerente) {
		this.nombreGerente = nombreGerente;
	}
	public String getSubGerente() {
		return subGerente;
	}
	public void setSubGerente(String subGerente) {
		this.subGerente = subGerente;
	}
	public String getTasaISR() {
		return tasaISR;
	}
	public void setTasaISR(String tasaISR) {
		this.tasaISR = tasaISR;
	}
	public String getDifHorarMatriz() {
		return difHorarMatriz;
	}
	public void setDifHorarMatriz(String difHorarMatriz) {
		this.difHorarMatriz = difHorarMatriz;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
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
	public String getNombreMunicipio() {
		return nombreMunicipio;
	}
	public void setNombreMunicipio(String nombreMunicipio) {
		this.nombreMunicipio = nombreMunicipio;
	}
	public String getPoderNotarial() {
		return poderNotarial;
	}
	public void setPoderNotarial(String poderNotarial) {
		this.poderNotarial = poderNotarial;
	}
	public String getPoder() {
		return poder;
	}
	public void setPoder(String poder) {
		this.poder = poder;
	}
	public String getTituloGte() {
		return tituloGte;
	}
	public void setTituloGte(String tituloGte) {
		this.tituloGte = tituloGte;
	}
	public String getTituloSubGte() {
		return tituloSubGte;
	}
	public void setTituloSubGte(String tituloSubGte) {
		this.tituloSubGte = tituloSubGte;
	}
	public String getExtTelefonoPart() {
		return extTelefonoPart;
	}
	public void setExtTelefonoPart(String extTelefonoPart) {
		this.extTelefonoPart = extTelefonoPart;
	}
	public String getPromotorCaptaID() {
		return promotorCaptaID;
	}
	public void setPromotorCaptaID(String promotorCaptaID) {
		this.promotorCaptaID = promotorCaptaID;
	}
	public String getClaveSucCNBV() {
		return claveSucCNBV;
	}
	public void setClaveSucCNBV(String claveSucCNBV) {
		this.claveSucCNBV = claveSucCNBV;
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
	public String getClaveSucOpeCred() {
		return claveSucOpeCred;
	}
	public void setClaveSucOpeCred(String claveSucOpeCred) {
		this.claveSucOpeCred = claveSucOpeCred;
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
	public String getHoraInicioOper() {
		return horaInicioOper;
	}
	public void setHoraInicioOper(String horaInicioOper) {
		this.horaInicioOper = horaInicioOper;
	}
	public String getHoraFinOper() {
		return horaFinOper;
	}
	public void setHoraFinOper(String horaFinOper) {
		this.horaFinOper = horaFinOper;
	}
	
	
	
	
}