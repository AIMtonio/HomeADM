package cliente.bean;

import general.bean.BaseBean;

public class AdicionalPersonaMoralBean extends BaseBean {

	private String numCliente;
	private String directivoID;
	private String numeroCte;
	private String nomCliente;
	private String cargoID;
	private String descCargo;
	private String nombreDirectivo;
	private String cuentaAhoID;			
	private String personaID; 	  
	private String esApoderado;
	private String consejoAdmon;
	private String esTitular;
	private String esCotitular;
	private String esBeneficiario;
	private String esProvRecurso;
	private String esPropReal;
	private String esFirmante;
	private String empresaID;
	
	private String titulo; 				
	private String primerNombre; 
	private String segundoNombre; 		
	private String tercerNombre; 		
	private String apellidoPaterno; 
	private String apellidoMaterno; 	
	private String nombreCompleto; 		
	private String fechaNacimiento; 
	private String paisNacimiento;
	private String edoNacimiento;
	private String estadoCivil; 		
	
	private String sexo; 			
	private String nacion; 
	private String CURP; 				
	private String RFC; 	
	private String OcupacionID;
	private String puestoA;
	private String sectorGeneral; 
	private String actividadBancoMX; 	
	private String actividadINEGI; 		
	private String sectorEconomico; 
	private String tipoIdentiID; 		
	
	private String otraIdentifi; 		
	private String numIdentific; 
	private String fecExIden; 			
	private String fecVenIden; 		
	private String domicilio; 
	private String telefonoCasa; 		
	private String telefonoCelular; 	
	private String correo; 
	private String paisResidencia; 		
	private String docEstanciaLegal; 	
	
	private String docExisLegal; 
	private String fechaVenEst; 		
	private String numEscPub; 			
	private String fechaEscPub; 
	private String estadoID; 			
	private String municipioID; 		
	private String notariaID; 
	private String titularNotaria; 		
	private String razonSocial; 		
	private String fax; 
	private String parentescoID; 		
	
	private String descripParentesco;
	private String porcentaje;
	private String clienteID;
	private String nombreInstitucion ; 
	private String extTelefonoPart;
	private String fechaEmision;
	private String dirInst;
	private String RFCInst;
	private String telInst;
	private String representanteLegal;
	private String sucursalID;
	private String nombreSucursal;
	private String ingreRealoRecursos;
	private String tipoPersona;
	private String desOcupacion;
	
	private String FEA;
	private String paisFea;
	private String paisRFC;
	
//Datos Adicionales Personas Morales
	private String tipoSociedadID;
	private String RFCpm;
	private String grupoEmpresarial;
	
    private String nacionalidadPM;
    private String paisConstitucionID;
    private String correoPM;
    private String correoAlterPM;
    private String telefonoPM;
    private String extTelefonoPM;
    private String fechaRegistroPM;
    private String nombreNotario;
    private String numNotario;
    private String inscripcionReg;
    private String domicilioOfiPM;
    private String escrituraPubPM;
    
    private String EsAccionista;
    private String tipoPersonaP;
    private String porcentajeAccionM;
    private String porcentajeAccion;
    private String porcentajeAccionista;
    private String razonSocialPM;
    private String feaPM;
	private String paisFeaPM;
	private String valorAcciones;	
	private String folioMercantil;
	private String garanteID;
	private String avalID;
	private String avalRelacion;
	private String garanteRelacion;
	
	private String tipoAccionista;
	private String compania;
	private String direccion1;
	private String direccion2;
	private String munNacimiento;
	private String locNacimiento;
	private String coloniaID;
	private String nombreCiudad;
	private String codigoPostal;
	private String edoExtranjero;
	
	private String esSolicitante;
	private String esAutorizador;
	private String esAdministrador;
	private String paisIDDom;
	private String estadoIDDom;
	
	private String municipioIDDom;
	private String localidadIDDom;
	private String coloniaIDDom;
	private String nombreColoniaDom;
	private String nombreCiudadDom;
	
	private String calleDom;
	private String numExteriorDom;
	private String numInteriorDom;
	private String pisoDom;
	private String primeraEntreDom;
	
	private String segundaEntreDom;
	private String codigoPostalDom;
	
	public String getConsejoAdmon() {
		return consejoAdmon;
	}
	public void setConsejoAdmon(String consejoAdmon) {
		this.consejoAdmon = consejoAdmon;
	}
	public String getAvalID() {
		return avalID;
	}

	public String getAvalRelacion() {
		return avalRelacion;
	}
	public void setAvalRelacion(String avalRelacion) {
		this.avalRelacion = avalRelacion;
	}
	public String getGaranteRelacion() {
		return garanteRelacion;
	}
	public void setGaranteRelacion(String garanteRelacion) {
		this.garanteRelacion = garanteRelacion;
	}
	public void setAvalID(String avalID) {
		this.avalID = avalID;
	}
	public String getGaranteID() {
		return garanteID;
	}
	public void setGaranteID(String garanteID) {
		this.garanteID = garanteID;
	}
	public String getNumCliente() {
		return numCliente;
	}
	public void setNumCliente(String numCliente) {
		this.numCliente = numCliente;
	}
	public String getDirectivoID() {
		return directivoID;
	}
	public void setDirectivoID(String directivoID) {
		this.directivoID = directivoID;
	}
	
	public String getNombreDirectivo() {
		return nombreDirectivo;
	}
	public void setNombreDirectivo(String nombreDirectivo) {
		this.nombreDirectivo = nombreDirectivo;
	}
	
	public String getNumeroCte() {
		return numeroCte;
	}
	public void setNumeroCte(String numeroCte) {
		this.numeroCte = numeroCte;
	}
	public String getNomCliente() {
		return nomCliente;
	}
	public void setNomCliente(String nomCliente) {
		this.nomCliente = nomCliente;
	}
	public String getCargoID() {
		return cargoID;
	}
	public void setCargoID(String cargoID) {
		this.cargoID = cargoID;
	}
	public String getDescCargo() {
		return descCargo;
	}
	public void setDescCargo(String descCargo) {
		this.descCargo = descCargo;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getDescripParentesco() {
		return descripParentesco;
	}
	public void setDescripParentesco(String descripParentesco) {
		this.descripParentesco = descripParentesco;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getPersonaID() {
		return personaID;
	}
	public void setPersonaID(String personaID) {
		this.personaID = personaID;
	}
	public String getEsApoderado() {
		return esApoderado;
	}
	public void setEsApoderado(String esApoderado) {
		this.esApoderado = esApoderado;
	}
	public String getEsTitular() {
		return esTitular;
	}
	public void setEsTitular(String esTitular) {
		this.esTitular = esTitular;
	}
	public String getEsCotitular() {
		return esCotitular;
	}
	public void setEsCotitular(String esCotitular) {
		this.esCotitular = esCotitular;
	}
	public String getEsBeneficiario() {
		return esBeneficiario;
	}
	public void setEsBeneficiario(String esBeneficiario) {
		this.esBeneficiario = esBeneficiario;
	}
	public String getEsProvRecurso() {
		return esProvRecurso;
	}
	public void setEsProvRecurso(String esProvRecurso) {
		this.esProvRecurso = esProvRecurso;
	}
	public String getEsPropReal() {
		return esPropReal;
	}
	public void setEsPropReal(String esPropReal) {
		this.esPropReal = esPropReal;
	}
	public String getEsFirmante() {
		return esFirmante;
	}
	public void setEsFirmante(String esFirmante) {
		this.esFirmante = esFirmante;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getTitulo() {
		return titulo;
	}
	public void setTitulo(String titulo) {
		this.titulo = titulo;
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
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getFechaNacimiento() {
		return fechaNacimiento;
	}
	public void setFechaNacimiento(String fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}
	public String getPaisNacimiento() {
		return paisNacimiento;
	}
	public void setPaisNacimiento(String paisNacimiento) {
		this.paisNacimiento = paisNacimiento;
	}
	public String getEstadoCivil() {
		return estadoCivil;
	}
	public void setEstadoCivil(String estadoCivil) {
		this.estadoCivil = estadoCivil;
	}
	public String getSexo() {
		return sexo;
	}
	public void setSexo(String sexo) {
		this.sexo = sexo;
	}
	public String getNacion() {
		return nacion;
	}
	public void setNacion(String nacion) {
		this.nacion = nacion;
	}
	public String getCURP() {
		return CURP;
	}
	public void setCURP(String cURP) {
		CURP = cURP;
	}
	public String getRFC() {
		return RFC;
	}
	public void setRFC(String rFC) {
		RFC = rFC;
	}
	public String getOcupacionID() {
		return OcupacionID;
	}
	public void setOcupacionID(String ocupacionID) {
		OcupacionID = ocupacionID;
	}
	public String getPuestoA() {
		return puestoA;
	}
	public void setPuestoA(String puestoA) {
		this.puestoA = puestoA;
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
	public String getActividadINEGI() {
		return actividadINEGI;
	}
	public void setActividadINEGI(String actividadINEGI) {
		this.actividadINEGI = actividadINEGI;
	}
	public String getSectorEconomico() {
		return sectorEconomico;
	}
	public void setSectorEconomico(String sectorEconomico) {
		this.sectorEconomico = sectorEconomico;
	}
	public String getTipoIdentiID() {
		return tipoIdentiID;
	}
	public void setTipoIdentiID(String tipoIdentiID) {
		this.tipoIdentiID = tipoIdentiID;
	}
	public String getOtraIdentifi() {
		return otraIdentifi;
	}
	public void setOtraIdentifi(String otraIdentifi) {
		this.otraIdentifi = otraIdentifi;
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
	public String getDomicilio() {
		return domicilio;
	}
	public void setDomicilio(String domicilio) {
		this.domicilio = domicilio;
	}
	public String getTelefonoCasa() {
		return telefonoCasa;
	}
	public void setTelefonoCasa(String telefonoCasa) {
		this.telefonoCasa = telefonoCasa;
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
	public String getPaisResidencia() {
		return paisResidencia;
	}
	public void setPaisResidencia(String paisResidencia) {
		this.paisResidencia = paisResidencia;
	}
	public String getDocEstanciaLegal() {
		return docEstanciaLegal;
	}
	public void setDocEstanciaLegal(String docEstanciaLegal) {
		this.docEstanciaLegal = docEstanciaLegal;
	}
	public String getDocExisLegal() {
		return docExisLegal;
	}
	public void setDocExisLegal(String docExisLegal) {
		this.docExisLegal = docExisLegal;
	}
	public String getFechaVenEst() {
		return fechaVenEst;
	}
	public void setFechaVenEst(String fechaVenEst) {
		this.fechaVenEst = fechaVenEst;
	}
	public String getNumEscPub() {
		return numEscPub;
	}
	public void setNumEscPub(String numEscPub) {
		this.numEscPub = numEscPub;
	}
	public String getFechaEscPub() {
		return fechaEscPub;
	}
	public void setFechaEscPub(String fechaEscPub) {
		this.fechaEscPub = fechaEscPub;
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
	public String getNotariaID() {
		return notariaID;
	}
	public void setNotariaID(String notariaID) {
		this.notariaID = notariaID;
	}
	public String getTitularNotaria() {
		return titularNotaria;
	}
	public void setTitularNotaria(String titularNotaria) {
		this.titularNotaria = titularNotaria;
	}
	public String getRazonSocial() {
		return razonSocial;
	}
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}
	public String getFax() {
		return fax;
	}
	public void setFax(String fax) {
		this.fax = fax;
	}
	public String getParentescoID() {
		return parentescoID;
	}
	public void setParentescoID(String parentescoID) {
		this.parentescoID = parentescoID;
	}
	public String getPorcentaje() {
		return porcentaje;
	}
	public void setPorcentaje(String porcentaje) {
		this.porcentaje = porcentaje;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getEdoNacimiento() {
		return edoNacimiento;
	}
	public void setEdoNacimiento(String edoNacimiento) {
		this.edoNacimiento = edoNacimiento;
	}
	public String getExtTelefonoPart() {
		return extTelefonoPart;
	}
	public void setExtTelefonoPart(String extTelefonoPart) {
		this.extTelefonoPart = extTelefonoPart;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getDirInst() {
		return dirInst;
	}
	public void setDirInst(String dirInst) {
		this.dirInst = dirInst;
	}
	public String getRFCInst() {
		return RFCInst;
	}
	public void setRFCInst(String rFCInst) {
		RFCInst = rFCInst;
	}
	public String getTelInst() {
		return telInst;
	}
	public void setTelInst(String telInst) {
		this.telInst = telInst;
	}
	public String getRepresentanteLegal() {
		return representanteLegal;
	}
	public void setRepresentanteLegal(String representanteLegal) {
		this.representanteLegal = representanteLegal;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getIngreRealoRecursos() {
		return ingreRealoRecursos;
	}
	public void setIngreRealoRecursos(String ingreRealoRecursos) {
		this.ingreRealoRecursos = ingreRealoRecursos;
	}
	public String getDesOcupacion() {
		return desOcupacion;
	}
	public void setDesOcupacion(String desOcupacion) {
		this.desOcupacion = desOcupacion;
	}
	public String getFEA() {
		return FEA;
	}
	public String getPaisRFC() {
		return paisRFC;
	}
	public void setFEA(String fEA) {
		FEA = fEA;
	}
	public void setPaisRFC(String paisRFC) {
		this.paisRFC = paisRFC;
	}
	public String getPaisFea() {
		return paisFea;
	}
	public void setPaisFea(String paisFea) {
		this.paisFea = paisFea;
	}
	public String getTipoSociedadID() {
		return tipoSociedadID;
	}
	public void setTipoSociedadID(String tipoSociedadID) {
		this.tipoSociedadID = tipoSociedadID;
	}
	public String getRFCpm() {
		return RFCpm;
	}
	public void setRFCpm(String rFCpm) {
		RFCpm = rFCpm;
	}
	public String getGrupoEmpresarial() {
		return grupoEmpresarial;
	}
	public void setGrupoEmpresarial(String grupoEmpresarial) {
		this.grupoEmpresarial = grupoEmpresarial;
	}
	public String getNacionalidadPM() {
		return nacionalidadPM;
	}
	public void setNacionalidadPM(String nacionalidadPM) {
		this.nacionalidadPM = nacionalidadPM;
	}
	public String getPaisConstitucionID() {
		return paisConstitucionID;
	}
	public void setPaisConstitucionID(String paisConstitucionID) {
		this.paisConstitucionID = paisConstitucionID;
	}
	public String getCorreoPM() {
		return correoPM;
	}
	public void setCorreoPM(String correoPM) {
		this.correoPM = correoPM;
	}
	public String getCorreoAlterPM() {
		return correoAlterPM;
	}
	public void setCorreoAlterPM(String correoAlterPM) {
		this.correoAlterPM = correoAlterPM;
	}
	public String getTelefonoPM() {
		return telefonoPM;
	}
	public void setTelefonoPM(String telefonoPM) {
		this.telefonoPM = telefonoPM;
	}
	public String getExtTelefonoPM() {
		return extTelefonoPM;
	}
	public void setExtTelefonoPM(String extTelefonoPM) {
		this.extTelefonoPM = extTelefonoPM;
	}
	public String getFechaRegistroPM() {
		return fechaRegistroPM;
	}
	public void setFechaRegistroPM(String fechaRegistroPM) {
		this.fechaRegistroPM = fechaRegistroPM;
	}
	public String getNombreNotario() {
		return nombreNotario;
	}
	public void setNombreNotario(String nombreNotario) {
		this.nombreNotario = nombreNotario;
	}
	public String getNumNotario() {
		return numNotario;
	}
	public void setNumNotario(String numNotario) {
		this.numNotario = numNotario;
	}
	public String getInscripcionReg() {
		return inscripcionReg;
	}
	public void setInscripcionReg(String inscripcionReg) {
		this.inscripcionReg = inscripcionReg;
	}
	public String getDomicilioOfiPM() {
		return domicilioOfiPM;
	}
	public void setDomicilioOfiPM(String domicilioOfiPM) {
		this.domicilioOfiPM = domicilioOfiPM;
	}
	public String getEscrituraPubPM() {
		return escrituraPubPM;
	}
	public void setEscrituraPubPM(String escrituraPubPM) {
		this.escrituraPubPM = escrituraPubPM;
	}
	public String getTipoPersonaP() {
		return tipoPersonaP;
	}
	public void setTipoPersonaP(String tipoPersonaP) {
		this.tipoPersonaP = tipoPersonaP;
	}
	public String getPorcentajeAccionM() {
		return porcentajeAccionM;
	}
	public void setPorcentajeAccionM(String porcentajeAccionM) {
		this.porcentajeAccionM = porcentajeAccionM;
	}
	public String getPorcentajeAccion() {
		return porcentajeAccion;
	}
	public void setPorcentajeAccion(String porcentajeAccion) {
		this.porcentajeAccion = porcentajeAccion;
	}
	public String getPorcentajeAccionista() {
		return porcentajeAccionista;
	}
	public void setPorcentajeAccionista(String porcentajeAccionista) {
		this.porcentajeAccionista = porcentajeAccionista;
	}
	public String getEsAccionista() {
		return EsAccionista;
	}
	public void setEsAccionista(String esAccionista) {
		EsAccionista = esAccionista;
	}
	public String getRazonSocialPM() {
		return razonSocialPM;
	}
	public void setRazonSocialPM(String razonSocialPM) {
		this.razonSocialPM = razonSocialPM;
	}
	public String getFeaPM() {
		return feaPM;
	}
	public void setFeaPM(String feaPM) {
		this.feaPM = feaPM;
	}
	public String getPaisFeaPM() {
		return paisFeaPM;
	}
	public void setPaisFeaPM(String paisFeaPM) {
		this.paisFeaPM = paisFeaPM;
	}
	public String getValorAcciones() {
		return valorAcciones;
	}
	public void setValorAcciones(String valorAcciones) {
		this.valorAcciones = valorAcciones;
	}
	public String getFolioMercantil() {
		return folioMercantil;
	}
	public void setFolioMercantil(String folioMercantil) {
		this.folioMercantil = folioMercantil;
	}
	public String getTipoAccionista() {
		return tipoAccionista;
	}
	public void setTipoAccionista(String tipoAccionista) {
		this.tipoAccionista = tipoAccionista;
	}
	public String getCompania() {
		return compania;
	}
	public void setCompania(String compania) {
		this.compania = compania;
	}
	public String getDireccion1() {
		return direccion1;
	}
	public void setDireccion1(String direccion1) {
		this.direccion1 = direccion1;
	}
	public String getDireccion2() {
		return direccion2;
	}
	public void setDireccion2(String direccion2) {
		this.direccion2 = direccion2;
	}
	public String getMunNacimiento() {
		return munNacimiento;
	}
	public void setMunNacimiento(String munNacimiento) {
		this.munNacimiento = munNacimiento;
	}
	public String getLocNacimiento() {
		return locNacimiento;
	}
	public void setLocNacimiento(String locNacimiento) {
		this.locNacimiento = locNacimiento;
	}
	public String getColoniaID() {
		return coloniaID;
	}
	public void setColoniaID(String coloniaID) {
		this.coloniaID = coloniaID;
	}
	public String getNombreCiudad() {
		return nombreCiudad;
	}
	public void setNombreCiudad(String nombreCiudad) {
		this.nombreCiudad = nombreCiudad;
	}
	public String getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public String getEdoExtranjero() {
		return edoExtranjero;
	}
	public void setEdoExtranjero(String edoExtranjero) {
		this.edoExtranjero = edoExtranjero;
	}
	public String getEsSolicitante() {
		return esSolicitante;
	}
	public void setEsSolicitante(String esSolicitante) {
		this.esSolicitante = esSolicitante;
	}
	public String getEsAutorizador() {
		return esAutorizador;
	}
	public void setEsAutorizador(String esAutorizador) {
		this.esAutorizador = esAutorizador;
	}
	public String getEsAdministrador() {
		return esAdministrador;
	}
	public void setEsAdministrador(String esAdministrador) {
		this.esAdministrador = esAdministrador;
	}
	public String getPaisIDDom() {
		return paisIDDom;
	}
	public void setPaisIDDom(String paisIDDom) {
		this.paisIDDom = paisIDDom;
	}
	public String getEstadoIDDom() {
		return estadoIDDom;
	}
	public void setEstadoIDDom(String estadoIDDom) {
		this.estadoIDDom = estadoIDDom;
	}
	public String getMunicipioIDDom() {
		return municipioIDDom;
	}
	public void setMunicipioIDDom(String municipioIDDom) {
		this.municipioIDDom = municipioIDDom;
	}
	public String getLocalidadIDDom() {
		return localidadIDDom;
	}
	public void setLocalidadIDDom(String localidadIDDom) {
		this.localidadIDDom = localidadIDDom;
	}
	public String getColoniaIDDom() {
		return coloniaIDDom;
	}
	public void setColoniaIDDom(String coloniaIDDom) {
		this.coloniaIDDom = coloniaIDDom;
	}
	public String getNombreColoniaDom() {
		return nombreColoniaDom;
	}
	public void setNombreColoniaDom(String nombreColoniaDom) {
		this.nombreColoniaDom = nombreColoniaDom;
	}
	public String getNombreCiudadDom() {
		return nombreCiudadDom;
	}
	public void setNombreCiudadDom(String nombreCiudadDom) {
		this.nombreCiudadDom = nombreCiudadDom;
	}
	public String getCalleDom() {
		return calleDom;
	}
	public void setCalleDom(String calleDom) {
		this.calleDom = calleDom;
	}
	public String getNumExteriorDom() {
		return numExteriorDom;
	}
	public void setNumExteriorDom(String numExteriorDom) {
		this.numExteriorDom = numExteriorDom;
	}
	public String getNumInteriorDom() {
		return numInteriorDom;
	}
	public void setNumInteriorDom(String numInteriorDom) {
		this.numInteriorDom = numInteriorDom;
	}
	public String getPisoDom() {
		return pisoDom;
	}
	public void setPisoDom(String pisoDom) {
		this.pisoDom = pisoDom;
	}
	public String getPrimeraEntreDom() {
		return primeraEntreDom;
	}
	public void setPrimeraEntreDom(String primeraEntreDom) {
		this.primeraEntreDom = primeraEntreDom;
	}
	public String getSegundaEntreDom() {
		return segundaEntreDom;
	}
	public void setSegundaEntreDom(String segundaEntreDom) {
		this.segundaEntreDom = segundaEntreDom;
	}
	public String getCodigoPostalDom() {
		return codigoPostalDom;
	}
	public void setCodigoPostalDom(String codigoPostalDom) {
		this.codigoPostalDom = codigoPostalDom;
	}
}