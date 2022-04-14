package operacionesCRCB.beanWS.request;

public class AltaClienteRequest extends BaseRequestBean {
	
	private String primerNombre;
	private String segundoNombre;
	private String tercerNombre;
	private String apellidoPaterno;
	private String apellidoMaterno;
	private String fechaNacimiento;
	private String cURP;
	private String estadoNacimientoID;
	private String sexo;
	private String telefono;
	private String telefonoCelular;
	private String correo;
	private String rFC;
	private String ocupacionID;
	private String lugardeTrabajo;
	private String puesto;
	private String telTrabajo;
	private String noEmpleado;
	private String antiguedadTra;
	private String extTelefonoTrab;
	private String tipoEmpleado;
	private String tipoPuesto;
	private String sucursalOrigen;
	private String tipoPersona;
	private String paisNacionalidad;
	private String ingresosMensuales;
	private String tamanioAcreditado;
	private String niveldeRiesgo;
	private String titulo;
	private String paisResidencia;
	private String sectorGeneral;
	private String actividadBancoMX;
	private String estadoCivil;
	private String lugarNacimiento;
	private String promotorInicial;
	private String promotorActual;
	private String extTelefonoPart;

	private String tipoDireccionID;
	private String estadoID;
	private String municipioID;
	private String localidadID;
	private String coloniaID;
	private String calle;
	private String numero;
	private String cP;
	private String oficial;
	private String fiscal;
	private String numInterior;
	private String lote;
	private String manzana;

	private String tipoIdentiID;

	private String numIdentific;
	private String fecExIden;
	private String fecVenIden;
	private String clienteId;
	
	//Adicional para control de errores de consulta
	private String codigoRespuesta;
	private String mensajeRespuesta;
	private String piso;
	private String PrimeraEntreCalle;
	private String SegundaEntreCalle;
	
	
	
	
	public String getPiso() {
		return piso;
	}
	public void setPiso(String piso) {
		this.piso = piso;
	}
	public String getPrimeraEntreCalle() {
		return PrimeraEntreCalle;
	}
	public void setPrimeraEntreCalle(String primeraEntreCalle) {
		PrimeraEntreCalle = primeraEntreCalle;
	}
	public String getSegundaEntreCalle() {
		return SegundaEntreCalle;
	}
	public void setSegundaEntreCalle(String segundaEntreCalle) {
		SegundaEntreCalle = segundaEntreCalle;
	}
	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}
	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}
	public String getMensajeRespuesta() {
		return mensajeRespuesta;
	}
	public void setMensajeRespuesta(String mensajeRespuesta) {
		this.mensajeRespuesta = mensajeRespuesta;
	}
	public String getPrimerNombre() {
		return primerNombre;
	}
	public void setPrimerNombre(String primerNombre) {
		this.primerNombre = primerNombre;
	}
	public String getSegundoNombre() {
		return segundoNombre;
	}
	public void setSegundoNombre(String segundoNombre) {
		this.segundoNombre = segundoNombre;
	}
	public String getTercerNombre() {
		return tercerNombre;
	}
	public void setTercerNombre(String tercerNombre) {
		this.tercerNombre = tercerNombre;
	}
	public String getApellidoPaterno() {
		return apellidoPaterno;
	}
	public void setApellidoPaterno(String apellidoPaterno) {
		this.apellidoPaterno = apellidoPaterno;
	}
	public String getApellidoMaterno() {
		return apellidoMaterno;
	}
	public void setApellidoMaterno(String apellidoMaterno) {
		this.apellidoMaterno = apellidoMaterno;
	}
	public String getFechaNacimiento() {
		return fechaNacimiento;
	}
	public void setFechaNacimiento(String fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}
	public String getCURP() {
		return cURP;
	}
	public void setCURP(String cURP) {
		this.cURP = cURP;
	}
	public String getEstadoNacimientoID() {
		return estadoNacimientoID;
	}
	public void setEstadoNacimientoID(String estadoNacimientoID) {
		this.estadoNacimientoID = estadoNacimientoID;
	}
	public String getSexo() {
		return sexo;
	}
	public void setSexo(String sexo) {
		this.sexo = sexo;
	}
	public String getTelefono() {
		return telefono;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	public String getTelefonoCelular() {
		return telefonoCelular;
	}
	public void setTelefonoCelular(String telefonoCelular) {
		this.telefonoCelular = telefonoCelular;
	}
	public String getCorreo() {
		return correo;
	}
	public void setCorreo(String correo) {
		this.correo = correo;
	}
	public String getRFC() {
		return rFC;
	}
	public void setRFC(String rFC) {
		this.rFC = rFC;
	}
	public String getOcupacionID() {
		return ocupacionID;
	}
	public void setOcupacionID(String ocupacionID) {
		this.ocupacionID = ocupacionID;
	}
	public String getLugardeTrabajo() {
		return lugardeTrabajo;
	}
	public void setLugardeTrabajo(String lugardeTrabajo) {
		this.lugardeTrabajo = lugardeTrabajo;
	}
	public String getPuesto() {
		return puesto;
	}
	public void setPuesto(String puesto) {
		this.puesto = puesto;
	}
	public String getTelTrabajo() {
		return telTrabajo;
	}
	public void setTelTrabajo(String telTrabajo) {
		this.telTrabajo = telTrabajo;
	}
	public String getNoEmpleado() {
		return noEmpleado;
	}
	public void setNoEmpleado(String noEmpleado) {
		this.noEmpleado = noEmpleado;
	}
	public String getAntiguedadTra() {
		return antiguedadTra;
	}
	public void setAntiguedadTra(String antiguedadTra) {
		this.antiguedadTra = antiguedadTra;
	}
	public String getExtTelefonoTrab() {
		return extTelefonoTrab;
	}
	public void setExtTelefonoTrab(String extTelefonoTrab) {
		this.extTelefonoTrab = extTelefonoTrab;
	}
	public String getTipoEmpleado() {
		return tipoEmpleado;
	}
	public void setTipoEmpleado(String tipoEmpleado) {
		this.tipoEmpleado = tipoEmpleado;
	}
	public String getTipoPuesto() {
		return tipoPuesto;
	}
	public void setTipoPuesto(String tipoPuesto) {
		this.tipoPuesto = tipoPuesto;
	}
	public String getSucursalOrigen() {
		return sucursalOrigen;
	}
	public void setSucursalOrigen(String sucursalOrigen) {
		this.sucursalOrigen = sucursalOrigen;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getPaisNacionalidad() {
		return paisNacionalidad;
	}
	public void setPaisNacionalidad(String paisNacionalidad) {
		this.paisNacionalidad = paisNacionalidad;
	}
	public String getIngresosMensuales() {
		return ingresosMensuales;
	}
	public void setIngresosMensuales(String ingresosMensuales) {
		this.ingresosMensuales = ingresosMensuales;
	}
	public String getTamanioAcreditado() {
		return tamanioAcreditado;
	}
	public void setTamanioAcreditado(String tamanioAcreditado) {
		this.tamanioAcreditado = tamanioAcreditado;
	}
	public String getNiveldeRiesgo() {
		return niveldeRiesgo;
	}
	public void setNiveldeRiesgo(String niveldeRiesgo) {
		this.niveldeRiesgo = niveldeRiesgo;
	}
	public String getTitulo() {
		return titulo;
	}
	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}
	public String getPaisResidencia() {
		return paisResidencia;
	}
	public void setPaisResidencia(String paisResidencia) {
		this.paisResidencia = paisResidencia;
	}
	public String getSectorGeneral() {
		return sectorGeneral;
	}
	public void setSectorGeneral(String sectorGeneral) {
		this.sectorGeneral = sectorGeneral;
	}
	public String getActividadBancoMX() {
		return actividadBancoMX;
	}
	public void setActividadBancoMX(String actividadBancoMX) {
		this.actividadBancoMX = actividadBancoMX;
	}
	public String getEstadoCivil() {
		return estadoCivil;
	}
	public void setEstadoCivil(String estadoCivil) {
		this.estadoCivil = estadoCivil;
	}
	public String getLugarNacimiento() {
		return lugarNacimiento;
	}
	public void setLugarNacimiento(String lugarNacimiento) {
		this.lugarNacimiento = lugarNacimiento;
	}
	public String getPromotorInicial() {
		return promotorInicial;
	}
	public void setPromotorInicial(String promotorInicial) {
		this.promotorInicial = promotorInicial;
	}
	public String getPromotorActual() {
		return promotorActual;
	}
	public void setPromotorActual(String promotorActual) {
		this.promotorActual = promotorActual;
	}
	public String getExtTelefonoPart() {
		return extTelefonoPart;
	}
	public void setExtTelefonoPart(String extTelefonoPart) {
		this.extTelefonoPart = extTelefonoPart;
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
	public String getNumero() {
		return numero;
	}
	public void setNumero(String numero) {
		this.numero = numero;
	}
	public String getCP() {
		return cP;
	}
	public void setCP(String cP) {
		this.cP = cP;
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
	public String getNumInterior() {
		return numInterior;
	}
	public void setNumInterior(String numInterior) {
		this.numInterior = numInterior;
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
	public String getTipoIdentiID() {
		return tipoIdentiID;
	}
	public void setTipoIdentiID(String tipoIdentiID) {
		this.tipoIdentiID = tipoIdentiID;
	}
	public String getNumIdentific() {
		return numIdentific;
	}
	public void setNumIdentific(String numIdentific) {
		this.numIdentific = numIdentific;
	}
	public String getFecExIden() {
		return fecExIden;
	}
	public void setFecExIden(String fecExIden) {
		this.fecExIden = fecExIden;
	}
	public String getFecVenIden() {
		return fecVenIden;
	}
	public void setFecVenIden(String fecVenIden) {
		this.fecVenIden = fecVenIden;
	}
	public String getClienteId() {
		return clienteId;
	}
	public void setClienteId(String clienteId) {
		this.clienteId = clienteId;
	}
	

}
