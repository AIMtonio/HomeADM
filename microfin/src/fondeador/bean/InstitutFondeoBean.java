package fondeador.bean;

import general.bean.BaseBean;

public class InstitutFondeoBean extends BaseBean {
	private String institutFondID;
	private String tipoFondeador;
	private String cobraISR;
	private String razonSocInstFo;
	private String nombreInstitFon;
	private String estatus;
	private String cuentaClabe;
	private String institucionID;
	private String TipoInstitID;
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private long numTransaccion;
	private String descripcion;
	private String clienteID;
	private String nombreCliente;
	private String numCtaInstit;
	private String centroCostos;
	private String descripcionCenCostos;
	
	private String nombreTitular;
	private String nombreInstitucion;
	private String descripcionInstitucion;
	private String institucionBanc;
	private String IDInstitucionBanc;

	//nuevos campos de contrato credito pasivo
	private String RFC;
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
	private String repLegal;
	
	private String capturaIndica;
	
	
	// auxiliares del beans 
	private String descripcionTipoIns;
	private String nacionalidad;
	private String descripNacionalidad;
	
	
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getInstitutFondID() {
		return institutFondID;
	}
	public void setInstitutFondID(String institutFondID) {
		this.institutFondID = institutFondID;
	}
	public String getTipoFondeador() {
		return tipoFondeador;
	}
	public void setTipoFondeador(String tipoFondeador) {
		this.tipoFondeador = tipoFondeador;
	}
	public String getCobraISR() {
		return cobraISR;
	}
	public void setCobraISR(String cobraISR) {
		this.cobraISR = cobraISR;
	}
	public String getRazonSocInstFo() {
		return razonSocInstFo;
	}
	public void setRazonSocInstFo(String razonSocInstFo) {
		this.razonSocInstFo = razonSocInstFo;
	}
	public String getNombreInstitFon() {
		return nombreInstitFon;
	}
	public void setNombreInstitFon(String nombreInstitFon) {
		this.nombreInstitFon = nombreInstitFon;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getCuentaClabe() {
		return cuentaClabe;
	}
	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getTipoInstitID() {
		return TipoInstitID;
	}
	public void setTipoInstitID(String tipoInstitID) {
		TipoInstitID = tipoInstitID;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
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
	public long getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(long numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getDescripcionTipoIns() {
		return descripcionTipoIns;
	}
	public void setDescripcionTipoIns(String descripcionTipoIns) {
		this.descripcionTipoIns = descripcionTipoIns;
	}
	public String getNacionalidad() {
		return nacionalidad;
	}
	public void setNacionalidad(String nacionalidad) {
		this.nacionalidad = nacionalidad;
	}
	public String getDescripNacionalidad() {
		return descripNacionalidad;
	}
	public void setDescripNacionalidad(String descripNacionalidad) {
		this.descripNacionalidad = descripNacionalidad;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getNumCtaInstit() {
		return numCtaInstit;
	}
	public void setNumCtaInstit(String numCtaInstit) {
		this.numCtaInstit = numCtaInstit;
	}
	public String getNombreTitular() {
		return nombreTitular;
	}
	public void setNombreTitular(String nombreTitular) {
		this.nombreTitular = nombreTitular;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getDescripcionInstitucion() {
		return descripcionInstitucion;
	}
	public void setDescripcionInstitucion(String descripcionInstitucion) {
		this.descripcionInstitucion = descripcionInstitucion;
	}
	public String getInstitucionBanc() {
		return institucionBanc;
	}
	public void setInstitucionBanc(String institucionBanc) {
		this.institucionBanc = institucionBanc;
	}
	public String getIDInstitucionBanc() {
		return IDInstitucionBanc;
	}
	public void setIDInstitucionBanc(String iDInstitucionBanc) {
		IDInstitucionBanc = iDInstitucionBanc;
	}
	public String getCentroCostos() {
		return centroCostos;
	}
	public void setCentroCostos(String centroCostos) {
		this.centroCostos = centroCostos;
	}
	public String getDescripcionCenCostos() {
		return descripcionCenCostos;
	}
	public void setDescripcionCenCostos(String descripcionCenCostos) {
		this.descripcionCenCostos = descripcionCenCostos;
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
	public String getRFC() {
		return RFC;
	}
	public void setRFC(String rFC) {
		RFC = rFC;
	}
	public String getRepLegal() {
		return repLegal;
	}
	public void setRepLegal(String repLegal) {
		this.repLegal = repLegal;
	}
	public String getCapturaIndica() {
		return capturaIndica;
	}
	public void setCapturaIndica(String capturaIndica) {
		this.capturaIndica = capturaIndica;
	}
	
}