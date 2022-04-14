package credito.bean;

import general.bean.BaseBean;

public class AvalesBean extends BaseBean {

	private String avalID;
	private String tipoPersona;
	private String razonSocial;
	private String primerNombre;
	private String segundoNombre;
	private String tercerNombre;
	private String apellidoPaterno;
	private String apellidoMaterno;
	private String rFC;
	private String rFCpm;
	private String telefono;
	private String nombreCompleto;
	private String calle;
	private String numExterior;
	private String numInterior;
	private String manzana;
	private String lote;
	private String colonia;
	private String coloniaID;
	private String localidadID;
	private String municipioID;
	private String estadoID;
	private String cP;
	private String clienteID;
	private String prospectoID;
	private String latitud;
	private String longitud;
	private String sexo;
	private String estadoCivil;
	private String extTelefonoPart;
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	private String fechaNac;
	private String telefonoCel;
	private String direccionCompleta;
	private String creditoID;
	private String montoCredito;
	
	private String solicitudCreditoID;
	private String estatus;
	private String creditosAvalados;
	private String estatusCliente;
	
	// Escritura Publica
	private String esc_Tipo;
	private String nomApoderado;
	private String RFC_Apoderado;
	private String escrituraPub;
	private String libroEscritura;
	private String volumenEsc;
	private String fechaEsc;
	private String estadoIDEsc;
	private String localidadEsc;
	private String notaria;
	private String direcNotaria;
	private String nomNotario;
	private String registroPub;
	private String folioRegPub;
	private String volumenRegPub;
	private String libroRegPub;
	private String auxiliarRegPub;
	private String fechaRegPub;
	private String localidadRegPub;
	private String estadoIDReg;
	private String estatusEP;
	private String observaciones;
	private String nacion;
	private String lugarNacimiento;

	private String ocupacionID;
	private String ocupacion;
	private String puesto;
	private String domicilioTrabajo;
	private String telefonoTrabajo;
	private String extTelTrabajo;
	
	private String numIdentific;
	private String fecExIden;
	private String fecVenIden;

	public String getEstatusCliente() {
		return estatusCliente;
	}
	public void setEstatusCliente(String estatusCliente) {
		this.estatusCliente = estatusCliente;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getCreditosAvalados() {
		return creditosAvalados;
	}
	public void setCreditosAvalados(String creditosAvalados) {
		this.creditosAvalados = creditosAvalados;
	}
	public String getAvalID() {
		return avalID;
	}
	public void setAvalID(String avalID) {
		this.avalID = avalID;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getRazonSocial() {
		return razonSocial;
	}
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
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
	public String getrFC() {
		return rFC;
	}
	public void setrFC(String rFC) {
		this.rFC = rFC;
	}
	public String getrFCpm() {
		return rFCpm;
	}
	public void setrFCpm(String rFCpm) {
		this.rFCpm = rFCpm;
	}
	public String getTelefono() {
		return telefono;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getCalle() {
		return calle;
	}
	public void setCalle(String calle) {
		this.calle = calle;
	}
	public String getNumExterior() {
		return numExterior;
	}
	public void setNumExterior(String numExterior) {
		this.numExterior = numExterior;
	}
	public String getNumInterior() {
		return numInterior;
	}
	public void setNumInterior(String numInterior) {
		this.numInterior = numInterior;
	}
	public String getManzana() {
		return manzana;
	}
	public void setManzana(String manzana) {
		this.manzana = manzana;
	}
	public String getLote() {
		return lote;
	}
	public void setLote(String lote) {
		this.lote = lote;
	}
	public String getColonia() {
		return colonia;
	}
	public void setColonia(String colonia) {
		this.colonia = colonia;
	}
	public String getMunicipioID() {
		return municipioID;
	}
	public void setMunicipioID(String municipioID) {
		this.municipioID = municipioID;
	}
	public String getEstadoID() {
		return estadoID;
	}
	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
	}
	public String getcP() {
		return cP;
	}
	public void setcP(String cP) {
		this.cP = cP;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
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
	public String getFechaNac() {
		return fechaNac;
	}
	public void setFechaNac(String fechaNac) {
		this.fechaNac = fechaNac;
	}
	public String getTelefonoCel() {
		return telefonoCel;
	}
	public void setTelefonoCel(String telefonoCel) {
		this.telefonoCel = telefonoCel;
	}
	/**
	 * @return the sexo
	 */
	public String getSexo() {
		return sexo;
	}
	/**
	 * @param sexo the sexo to set
	 */
	public void setSexo(String sexo) {
		this.sexo = sexo;
	}
	/**
	 * @return the estadoCivil
	 */
	public String getEstadoCivil() {
		return estadoCivil;
	}
	/**
	 * @param estadoCivil the estadoCivil to set
	 */
	public void setEstadoCivil(String estadoCivil) {
		this.estadoCivil = estadoCivil;
	}
	/**
	 * @return the coloniaID
	 */
	public String getColoniaID() {
		return coloniaID;
	}
	/**
	 * @param coloniaID the coloniaID to set
	 */
	public void setColoniaID(String coloniaID) {
		this.coloniaID = coloniaID;
	}
	/**
	 * @return the localidadID
	 */
	public String getLocalidadID() {
		return localidadID;
	}
	/**
	 * @param localidadID the localidadID to set
	 */
	public void setLocalidadID(String localidadID) {
		this.localidadID = localidadID;
	}
	
	public String getDireccionCompleta() {
		return direccionCompleta;
	}
	public void setDireccionCompleta(String direccionCompleta) {
		this.direccionCompleta = direccionCompleta;
	}
	public String getExtTelefonoPart() {
		return extTelefonoPart;
	}
	public void setExtTelefonoPart(String extTelefonoPart) {
		this.extTelefonoPart = extTelefonoPart;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getMontoCredito() {
		return montoCredito;
	}
	public void setMontoCredito(String montoCredito) {
		this.montoCredito = montoCredito;
	}
	
	/* Datos Escritura Publica */
	public String getesc_Tipo() {
		return esc_Tipo;
	}
	public void setesc_Tipo(String esc_Tipo) {
		this.esc_Tipo = esc_Tipo;
	}
	public String getnomApoderado() {
		return nomApoderado;
	}
	public void setnomApoderado(String nomApoderado) {
		this.nomApoderado = nomApoderado;
	}

	public String getRFC_Apoderado() {
		return RFC_Apoderado;
	}
	public void setRFC_Apoderado(String RFC_Apoderado) {
		this.RFC_Apoderado = RFC_Apoderado;
	}

	public String getescrituraPub() {
		return escrituraPub;
	}
	public void setescrituraPub(String escrituraPub) {
		this.escrituraPub = escrituraPub;
	}

	public String getlibroEscritura() {
		return libroEscritura;
	}
	public void setlibroEscritura(String libroEscritura) {
		this.libroEscritura = libroEscritura;
	}

	public String getvolumenEsc() {
		return volumenEsc;
	}
	public void setvolumenEsc(String volumenEsc) {
		this.volumenEsc = volumenEsc;
	}

	public String getfechaEsc() {
		return fechaEsc;
	}
	public void setfechaEsc(String fechaEsc) {
		this.fechaEsc = fechaEsc;
	}

	public String getestadoIDEsc() {
		return estadoIDEsc;
	}
	public void setestadoIDEsc(String estadoIDEsc) {
		this.estadoIDEsc = estadoIDEsc;
	}

	public String getlocalidadEsc() {
		return localidadEsc;
	}
	public void setlocalidadEsc(String localidadEsc) {
		this.localidadEsc = localidadEsc;
	}

	public String getnotaria() {
		return notaria;
	}
	public void setnotaria(String notaria) {
		this.notaria = notaria;
	}
	public String getdirecNotaria() {
		return direcNotaria;
	}
	public void setdirecNotaria(String direcNotaria) {
		this.direcNotaria = direcNotaria;
	}
	public String getnomNotario() {
		return nomNotario;
	}
	public void setnomNotario(String nomNotario) {
		this.nomNotario = nomNotario;
	}

	public String getregistroPub() {
		return registroPub;
	}
	public void setregistroPub(String registroPub) {
		this.registroPub = registroPub;
	}

	public String getfolioRegPub() {
		return folioRegPub;
	}
	public void setfolioRegPub(String folioRegPub) {
		this.folioRegPub = folioRegPub;
	}

	public String getvolumenRegPub() {
		return volumenRegPub;
	}
	public void setvolumenRegPub(String volumenRegPub) {
		this.volumenRegPub = volumenRegPub;
	}

	public String getlibroRegPub() {
		return libroRegPub;
	}
	public void setlibroRegPub(String libroRegPub) {
		this.libroRegPub = libroRegPub;
	}

	public String getauxiliarRegPub() {
		return auxiliarRegPub;
	}
	public void setauxiliarRegPub(String auxiliarRegPub) {
		this.auxiliarRegPub = auxiliarRegPub;
	}

	public String getfechaRegPub() {
		return fechaRegPub;
	}
	public void setfechaRegPub(String fechaRegPub) {
		this.fechaRegPub = fechaRegPub;
	}

	public String getlocalidadRegPub() {
		return localidadRegPub;
	}
	public void setlocalidadRegPub(String localidadRegPub) {
		this.localidadRegPub = localidadRegPub;
	}

	public String getestadoIDReg() {
		return estadoIDReg;
	}
	public void setestadoIDReg(String estadoIDReg) {
		this.estadoIDReg = estadoIDReg;
	}
	public String getestatusEP() {
		return estatusEP;
	}
	public void setestatusEP(String estatusEP) {
		this.estatusEP = estatusEP;
	}

	public String getobservaciones() {
		return observaciones;
	}
	public void setobservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getNacion() {
		return nacion;
	}
	public void setNacion(String nacion) {
		this.nacion = nacion;
	}
	public String getLugarNacimiento() {
		return lugarNacimiento;
	}
	public void setLugarNacimiento(String lugarNacimiento) {
		this.lugarNacimiento = lugarNacimiento;
	}
	public String getOcupacionID() {
		return ocupacionID;
	}
	public void setOcupacionID(String ocupacionID) {
		this.ocupacionID = ocupacionID;
	}
	public String getOcupacion() {
		return ocupacion;
	}
	public void setOcupacion(String ocupacion) {
		this.ocupacion = ocupacion;
	}
	public String getPuesto() {
		return puesto;
	}
	public void setPuesto(String puesto) {
		this.puesto = puesto;
	}
	public String getDomicilioTrabajo() {
		return domicilioTrabajo;
	}
	public void setDomicilioTrabajo(String domicilioTrabajo) {
		this.domicilioTrabajo = domicilioTrabajo;
	}
	public String getTelefonoTrabajo() {
		return telefonoTrabajo;
	}
	public void setTelefonoTrabajo(String telefonoTrabajo) {
		this.telefonoTrabajo = telefonoTrabajo;
	}
	public String getExtTelTrabajo() {
		return extTelTrabajo;
	}
	public void setExtTelTrabajo(String extTelTrabajo) {
		this.extTelTrabajo = extTelTrabajo;
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
	

}