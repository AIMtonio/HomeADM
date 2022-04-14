package soporte.bean;

import general.bean.BaseBean;

public class ParametrosSisBean extends BaseBean {
	public  String TimbraEdoCtaSI = "S";
	private String empresaID;
	private String fechaSistema;
	private String sucursalMatrizID;
	private String telefonoLocal;

	private String telefonoInterior;
	private String institucionID;
	private String empresaDefault;
	private String nombreRepresentante;
	private String RFCRepresentante	;

	private String monedaBaseID;
	private String monedaExtrangeraID;
	private String tasaISR;
	private String tasaIDE;
	private String montoExcIDE;

	private String ejercicioVigente	;
	private String periodoVigente;
	private String diasInversion;
	private String diasCredito;
	private String diasCambioPass;

	private String lonMinCaracPass;
	private String clienteInstitucion;
	private String cuentaInstituc;
	private String manejaCaptacion;
	private String bancoCaptacion;

	private String tipoCuenta;
	private String rutaArchivos	;
	private String rolTesoreria;
	private String rolAdminTeso	;
	private String oficialCumID	;

	private String dirGeneralID;
	private String dirOperID	;
	private String nombreJefeCobranza	;
	private String nomJefeOperayPromo	;
	private String rutaArchivosPLD;

	private String califAutoCliente;
	private String remitente;
	private String servidorCorreo;
	private String puerto;
	private String usuarioCorreo;

	private String contrasenia;
	private String tipoCtaGLAdi;
	private String ctaIniGastoEmp;
	private String ctaFinGastoEmp;
	private String impTicket;

	private String tipoImpTicket;
	private String montoAportacion;
	private String reqAportacionSo;
	private String montoPolizaSegA;
	private String montoSegAyuda;

	private String cuentasCapConta;
	private String lonMinPagRemesa;
	private String lonMaxPagRemesa;
	private String lonMinPagOport;
	private String lonMaxPagOport;

	private String salMinDF;
	private String vencimAutoSeg;
	private String aplCobPenCieDia;
	private String servReactivaCliID;  // Servicio reactivacion de cliente
	private String ctaContaSobrante;

	private String ctaContaFaltante;
	private String ctaContaDocSBCD;
	private String ctaContaDocSBCA;
	private String afectaContaRecSBC;
	private String diasVigenciaBC;
	private String cenCostosChequesSBC;

	private String mostrarSaldDispCta;
	private String mostrarSaldDisCtaYSbc;

	private String extTelefonoLocal;
	private String extTelefonoInt;

	private String tipoContaMora;
	private String divideIngresoInteres;
	private String estCreAltInvGar;
	private String conBuroCreDefaut;
	private String abreviaturaCirculo;
	private String cancelaAutMenor;
	private String tarjetaIdentiSocio;
	private String perfilWsVbc;

//	tarjetas débito
	private String tipoTarjetaHN1;
	private String maxAbonosCteN1;
	private String promotorID;

	private String impSaldoCred;
	private String impSaldoCta;
	private String nombreCortoInst;

	private String gerenteGeneral;
	private String presidenteConsejo;
	private String jefeContabilidad;
	private String foliosAutActaComite;
	private String fechaUltimoComite;


	//Parametros Facturacion electronica
	private String calleEmpresa;
	private String numIntEmpresa;
	private String numExtEmpresa;
	private String municipioEmpresa;
	private String coloniaEmpresa;
	private String localidadEmpresa;
	private String estadoEmpresa;
	private String CPEmpresa;
	private String dirFiscal;
	private String rfcEmpresa;
	private String timbraEdoCta;
	private String generaCFDINoReg;
	private String generaEdoCtaAuto;
	private String usuarioFactElect;
	private String passFactElec;
	private String urlWSDLFactElec;
	private String validaAutComite;
	private String validaClaveKey;
	private String zonaHoraria;
	
	private String usuario;
	private String fechaActual;
	private String direccionIP	;
	private String programaID;
	private String sucursal	;
	private String numTransaccion;
	private String contabilidadGL;
	private String funcionHuella;
	private String horaSistema;
	private String reqhuellaProductos;
	private String activaPromotorCapta;
	private String mostrarPrefijo;
	private String tesoMovsCieMes;

	private String cambiaPromotor;
	private String checListCte;
	private String claveNivInstitucion;
	private String cuentaEprc;
	private String claveEntidad;
	private String timbraConsRet;
	private String capitalCubiertoReac;
	private String invPagoPeriodico;
	private String validaCapitalConta;
	private String porMaximoDeposito;
	
	// auxiliares del Bean
	 private String nombreInstitucion;

	//aux seguro dias de vigencia del seguro
	 private String vigDiasSeguro;

	 // auxiliares Pantalla Firma Representante Legal
	 private String razonSocial;
	 private String rfcInstitucion;

	 //auxiliares cancelacion solicitudes de credito
	 private String cancelaAutSolCre;
	 private String diasCancelaAutSolCre;
	 private String numTratamienCre; //Renovaciones
	 private String numTratamienCreRees; //Reestructuras
	 private String capitalCubierto;
	 private String pagoIntVertical;
	 private String numMaxDiasMora;

	 private String impFomatosInd;
	 private String tipoInstitID;
	 private String sistemasID;
	 private String reqValidaCred;
	 private String cobraSeguroCuota;

	//Cobranza
	 private String rutaNotifiCobranza;

	 //Tipo documento firma
	 private String tipoDocumentoID;
	 private String descripcionDoc;
	 private String reestCalendarioVen;
	private String validaEstatusRees;

	//Tipo presentacion detalle recursos reporte bitacora de acceso
	private String tipoDetRecursos;

	//Calcular CURP y RFC
	private String calculaCURPyRFC;

	//cartera Agro
	private String manejaCarAgro;

	private String salMinDFReal;
	//PLD
	private String evaluacionMatriz;
	private String fechaEvaluacionMatriz;
	private String frecuenciaMensual;
	private String actPerfilTransOpe;
	private String frecuenciaMensPerf;
	private String fechaActPerfil;
	private String porcCoincidencias;
	private String validarVigDomi;
	private String fecVigenDomicilio;
	private String modNivelRiesgo;
	private String tipoDocDomID;
	private String actPerfilTransOpeMas;
	private String numEvalPerfilTrans;
	//Riesgo Comun
	private String evaluaRiesgoComun;
	private String capitalContNeto;

	// Créditos Automáticos
	private String cobranzaAutCie;
	private String cobroCompletoAut;
	private String cobranzaxReferencia;

	private String porcPersonaFisica;
	private String porcPersonaMoral;
	private String permitirMultDisp;

	//Fecha Consulta Disp
	private String fechaConsDisp;

	//Aportaciones
	private String perfilAutEspAport;
	private String nomPerfilAutEspAport;

	//Cartas Liquidacion
	private String perfilCamCarLiqui;
	private String nomPerfilCamCarLiqui;

	// Circulo de Credito
	private String institucionCirculoCredito;
	private String claveEntidadCirculo;
	private String reportarTotalIntegrantes;

	private String restringeReporte;

	private String directorFinanzas;
	private String camFuenFonGarFira;

	//Validacion Factura
	private String validaFactura;
	private String validaFacturaURL;
	private String tiempoEsperaWS;
	private String personNoDeseadas;
	//FLujo individual de solicitud de credito
	private String ocultaBtnRechazoSol;
	private String restringebtnLiberacionSol;
	private String primerRolFlujoSolID;
	private String segundoRolFlujoSolID;
	private String nombrePrimerRol;
	private String nombreSegundoRol;
	private String vecesSalMinVig;

	// Param de Config Contrasenia
	private String caracterMinimo;
	private String caracterMayus;
	private String caracterMinus;
	private String caracterNumerico;
	private String caracterEspecial;
	private String ultimasContra;
	private String diaMaxCamContra;
	private String diaMaxInterSesion;
	private String numIntentos;
	private String numDiaBloq;
	private String reqCaracterMayus;
	private String reqCaracterMinus;
	private String reqCaracterNumerico;
	private String reqCaracterEspecial;
	private String habilitaConfPass;


	/*PARAMETROS DE NOTIFICACION DE CONVENIO DE NOMINA*/
	private String alerVerificaConvenio;
	private String noDiasAntEnvioCorreo;
	private String correoRemitente;
	private String correoAdiDestino;
	private String remitenteID;
	private String clabeInstitBancaria;

	private String validarEtiqCambFond;

	private String unificaCI;
	private String origenReplica;
	private String replicaAct;
	private String proveedorTimbrado;
	
	// Variables para cierre
	private String cierreAutomatico;

	private String remitenteCierreID;
	private String correoRemitenteCierre;
	private String ejecDepreAmortiAut;

	// Pagos por referencia
	private String validaRef;
	
	private String aplicaGarAdiPagoCre;
	private String mostrarBtnResumen;
	private String validaCicloGrupo;
	private String CargaLayoutXLSDepRef;
	
	public String getPerfilWsVbc() {
		return perfilWsVbc;
	}
	public void setPerfilWsVbc(String perfilWsVbc) {
		this.perfilWsVbc = perfilWsVbc;
	}
	public String getDescripcionDoc() {
		return descripcionDoc;
	}
	public void setDescripcionDoc(String descripcionDoc) {
		this.descripcionDoc = descripcionDoc;
	}
	public String getTipoDocumentoID() {
		return tipoDocumentoID;
	}
	public void setTipoDocumentoID(String tipoDocumentoID) {
		this.tipoDocumentoID = tipoDocumentoID;
	}
	public String getNumTratamienCre() {
		return numTratamienCre;
	}
	public void setNumTratamienCre(String numTratamienCre) {
		this.numTratamienCre = numTratamienCre;
	}
	public String getCapitalCubierto() {
		return capitalCubierto;
	}
	public void setCapitalCubierto(String capitalCubierto) {
		this.capitalCubierto = capitalCubierto;
	}
	public String getNumMaxDiasMora() {
		return numMaxDiasMora;
	}
	public void setNumMaxDiasMora(String numMaxDiasMora) {
		this.numMaxDiasMora = numMaxDiasMora;
	}
	public String getPagoIntVertical() {
		return pagoIntVertical;
	}
	public void setPagoIntVertical(String pagoIntVertical) {
		this.pagoIntVertical = pagoIntVertical;
	}
	public String getEmpresaID() {
		return empresaID;
	}

	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}

	public String getFechaSistema() {
		return fechaSistema;
	}

	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}

	public String getSucursalMatrizID() {
		return sucursalMatrizID;
	}

	public void setSucursalMatrizID(String sucursalMatrizID) {
		this.sucursalMatrizID = sucursalMatrizID;
	}

	public String getTelefonoLocal() {
		return telefonoLocal;
	}

	public void setTelefonoLocal(String telefonoLocal) {
		this.telefonoLocal = telefonoLocal;
	}

	public String getTelefonoInterior() {
		return telefonoInterior;
	}

	public void setTelefonoInterior(String telefonoInterior) {
		this.telefonoInterior = telefonoInterior;
	}

	public String getInstitucionID() {
		return institucionID;
	}

	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}

	public String getEmpresaDefault() {
		return empresaDefault;
	}

	public void setEmpresaDefault(String empresaDefault) {
		this.empresaDefault = empresaDefault;
	}

	public String getNombreRepresentante() {
		return nombreRepresentante;
	}

	public void setNombreRepresentante(String nombreRepresentante) {
		this.nombreRepresentante = nombreRepresentante;
	}

	public String getRFCRepresentante() {
		return RFCRepresentante;
	}

	public void setRFCRepresentante(String rFCRepresentante) {
		RFCRepresentante = rFCRepresentante;
	}

	public String getMonedaBaseID() {
		return monedaBaseID;
	}

	public void setMonedaBaseID(String monedaBaseID) {
		this.monedaBaseID = monedaBaseID;
	}

	public String getMonedaExtrangeraID() {
		return monedaExtrangeraID;
	}

	public void setMonedaExtrangeraID(String monedaExtrangeraID) {
		this.monedaExtrangeraID = monedaExtrangeraID;
	}

	public String getTasaISR() {
		return tasaISR;
	}

	public void setTasaISR(String tasaISR) {
		this.tasaISR = tasaISR;
	}

	public String getTasaIDE() {
		return tasaIDE;
	}

	public void setTasaIDE(String tasaIDE) {
		this.tasaIDE = tasaIDE;
	}

	public String getMontoExcIDE() {
		return montoExcIDE;
	}

	public void setMontoExcIDE(String montoExcIDE) {
		this.montoExcIDE = montoExcIDE;
	}

	public String getEjercicioVigente() {
		return ejercicioVigente;
	}

	public void setEjercicioVigente(String ejercicioVigente) {
		this.ejercicioVigente = ejercicioVigente;
	}

	public String getPeriodoVigente() {
		return periodoVigente;
	}

	public void setPeriodoVigente(String periodoVigente) {
		this.periodoVigente = periodoVigente;
	}

	public String getDiasInversion() {
		return diasInversion;
	}

	public void setDiasInversion(String diasInversion) {
		this.diasInversion = diasInversion;
	}

	public String getDiasCredito() {
		return diasCredito;
	}

	public void setDiasCredito(String diasCredito) {
		this.diasCredito = diasCredito;
	}

	public String getDiasCambioPass() {
		return diasCambioPass;
	}

	public void setDiasCambioPass(String diasCambioPass) {
		this.diasCambioPass = diasCambioPass;
	}

	public String getLonMinCaracPass() {
		return lonMinCaracPass;
	}

	public void setLonMinCaracPass(String lonMinCaracPass) {
		this.lonMinCaracPass = lonMinCaracPass;
	}

	public String getClienteInstitucion() {
		return clienteInstitucion;
	}

	public void setClienteInstitucion(String clienteInstitucion) {
		this.clienteInstitucion = clienteInstitucion;
	}

	public String getCuentaInstituc() {
		return cuentaInstituc;
	}

	public void setCuentaInstituc(String cuentaInstituc) {
		this.cuentaInstituc = cuentaInstituc;
	}

	public String getManejaCaptacion() {
		return manejaCaptacion;
	}

	public void setManejaCaptacion(String manejaCaptacion) {
		this.manejaCaptacion = manejaCaptacion;
	}

	public String getBancoCaptacion() {
		return bancoCaptacion;
	}

	public void setBancoCaptacion(String bancoCaptacion) {
		this.bancoCaptacion = bancoCaptacion;
	}

	public String getTipoCuenta() {
		return tipoCuenta;
	}

	public void setTipoCuenta(String tipoCuenta) {
		this.tipoCuenta = tipoCuenta;
	}

	public String getRutaArchivos() {
		return rutaArchivos;
	}

	public void setRutaArchivos(String rutaArchivos) {
		this.rutaArchivos = rutaArchivos;
	}

	public String getRolTesoreria() {
		return rolTesoreria;
	}

	public void setRolTesoreria(String rolTesoreria) {
		this.rolTesoreria = rolTesoreria;
	}

	public String getRolAdminTeso() {
		return rolAdminTeso;
	}

	public void setRolAdminTeso(String rolAdminTeso) {
		this.rolAdminTeso = rolAdminTeso;
	}

	public String getOficialCumID() {
		return oficialCumID;
	}

	public void setOficialCumID(String oficialCumID) {
		this.oficialCumID = oficialCumID;
	}

	public String getDirGeneralID() {
		return dirGeneralID;
	}

	public void setDirGeneralID(String dirGeneralID) {
		this.dirGeneralID = dirGeneralID;
	}

	public String getDirOperID() {
		return dirOperID;
	}

	public void setDirOperID(String dirOperID) {
		this.dirOperID = dirOperID;
	}

	public String getNombreJefeCobranza() {
		return nombreJefeCobranza;
	}

	public void setNombreJefeCobranza(String nombreJefeCobranza) {
		this.nombreJefeCobranza = nombreJefeCobranza;
	}

	public String getNomJefeOperayPromo() {
		return nomJefeOperayPromo;
	}

	public void setNomJefeOperayPromo(String nomJefeOperayPromo) {
		this.nomJefeOperayPromo = nomJefeOperayPromo;
	}

	public String getRutaArchivosPLD() {
		return rutaArchivosPLD;
	}

	public void setRutaArchivosPLD(String rutaArchivosPLD) {
		this.rutaArchivosPLD = rutaArchivosPLD;
	}

	public String getRemitente() {
		return remitente;
	}

	public void setRemitente(String remitente) {
		this.remitente = remitente;
	}

	public String getServidorCorreo() {
		return servidorCorreo;
	}

	public void setServidorCorreo(String servidorCorreo) {
		this.servidorCorreo = servidorCorreo;
	}

	public String getPuerto() {
		return puerto;
	}

	public void setPuerto(String puerto) {
		this.puerto = puerto;
	}

	public String getUsuarioCorreo() {
		return usuarioCorreo;
	}

	public void setUsuarioCorreo(String usuarioCorreo) {
		this.usuarioCorreo = usuarioCorreo;
	}

	public String getContrasenia() {
		return contrasenia;
	}

	public void setContrasenia(String contrasenia) {
		this.contrasenia = contrasenia;
	}

	public String getTipoCtaGLAdi() {
		return tipoCtaGLAdi;
	}

	public void setTipoCtaGLAdi(String tipoCtaGLAdi) {
		this.tipoCtaGLAdi = tipoCtaGLAdi;
	}

	public String getCtaIniGastoEmp() {
		return ctaIniGastoEmp;
	}

	public void setCtaIniGastoEmp(String ctaIniGastoEmp) {
		this.ctaIniGastoEmp = ctaIniGastoEmp;
	}

	public String getCtaFinGastoEmp() {
		return ctaFinGastoEmp;
	}

	public void setCtaFinGastoEmp(String ctaFinGastoEmp) {
		this.ctaFinGastoEmp = ctaFinGastoEmp;
	}

	public String getImpTicket() {
		return impTicket;
	}

	public void setImpTicket(String impTicket) {
		this.impTicket = impTicket;
	}

	public String getTipoImpTicket() {
		return tipoImpTicket;
	}

	public void setTipoImpTicket(String tipoImpTicket) {
		this.tipoImpTicket = tipoImpTicket;
	}

	public String getMontoAportacion() {
		return montoAportacion;
	}

	public void setMontoAportacion(String montoAportacion) {
		this.montoAportacion = montoAportacion;
	}

	public String getReqAportacionSo() {
		return reqAportacionSo;
	}

	public void setReqAportacionSo(String reqAportacionSo) {
		this.reqAportacionSo = reqAportacionSo;
	}

	public String getMontoPolizaSegA() {
		return montoPolizaSegA;
	}

	public void setMontoPolizaSegA(String montoPolizaSegA) {
		this.montoPolizaSegA = montoPolizaSegA;
	}

	public String getMontoSegAyuda() {
		return montoSegAyuda;
	}

	public void setMontoSegAyuda(String montoSegAyuda) {
		this.montoSegAyuda = montoSegAyuda;
	}

	public String getCuentasCapConta() {
		return cuentasCapConta;
	}

	public void setCuentasCapConta(String cuentasCapConta) {
		this.cuentasCapConta = cuentasCapConta;
	}

	public String getLonMinPagRemesa() {
		return lonMinPagRemesa;
	}

	public void setLonMinPagRemesa(String lonMinPagRemesa) {
		this.lonMinPagRemesa = lonMinPagRemesa;
	}

	public String getLonMaxPagRemesa() {
		return lonMaxPagRemesa;
	}

	public void setLonMaxPagRemesa(String lonMaxPagRemesa) {
		this.lonMaxPagRemesa = lonMaxPagRemesa;
	}

	public String getLonMinPagOport() {
		return lonMinPagOport;
	}

	public void setLonMinPagOport(String lonMinPagOport) {
		this.lonMinPagOport = lonMinPagOport;
	}

	public String getLonMaxPagOport() {
		return lonMaxPagOport;
	}

	public void setLonMaxPagOport(String lonMaxPagOport) {
		this.lonMaxPagOport = lonMaxPagOport;
	}

	public String getSalMinDF() {
		return salMinDF;
	}

	public void setSalMinDF(String salMinDF) {
		this.salMinDF = salMinDF;
	}

	public String getVencimAutoSeg() {
		return vencimAutoSeg;
	}

	public void setVencimAutoSeg(String vencimAutoSeg) {
		this.vencimAutoSeg = vencimAutoSeg;
	}

	public String getTipoTarjetaHN1() {
		return tipoTarjetaHN1;
	}

	public void setTipoTarjetaHN1(String tipoTarjetaHN1) {
		this.tipoTarjetaHN1 = tipoTarjetaHN1;
	}

	public String getMaxAbonosCteN1() {
		return maxAbonosCteN1;
	}

	public void setMaxAbonosCteN1(String maxAbonosCteN1) {
		this.maxAbonosCteN1 = maxAbonosCteN1;
	}

	public String getPromotorID() {
		return promotorID;
	}

	public void setPromotorID(String promotorID) {
		this.promotorID = promotorID;
	}

	public String getImpSaldoCred() {
		return impSaldoCred;
	}

	public void setImpSaldoCred(String impSaldoCred) {
		this.impSaldoCred = impSaldoCred;
	}

	public String getImpSaldoCta() {
		return impSaldoCta;
	}

	public void setImpSaldoCta(String impSaldoCta) {
		this.impSaldoCta = impSaldoCta;
	}

	public String getNombreCortoInst() {
		return nombreCortoInst;
	}

	public void setNombreCortoInst(String nombreCortoInst) {
		this.nombreCortoInst = nombreCortoInst;
	}

	public String getGerenteGeneral() {
		return gerenteGeneral;
	}

	public void setGerenteGeneral(String gerenteGeneral) {
		this.gerenteGeneral = gerenteGeneral;
	}

	public String getPresidenteConsejo() {
		return presidenteConsejo;
	}

	public void setPresidenteConsejo(String presidenteConsejo) {
		this.presidenteConsejo = presidenteConsejo;
	}

	public String getJefeContabilidad() {
		return jefeContabilidad;
	}

	public void setJefeContabilidad(String jefeContabilidad) {
		this.jefeContabilidad = jefeContabilidad;
	}

	public String getCalleEmpresa() {
		return calleEmpresa;
	}

	public void setCalleEmpresa(String calleEmpresa) {
		this.calleEmpresa = calleEmpresa;
	}

	public String getFoliosAutActaComite() {
		return foliosAutActaComite;
	}

	public void setFoliosAutActaComite(String foliosAutActaComite) {
		this.foliosAutActaComite = foliosAutActaComite;
	}

	public String getFechaUltimoComite() {
		return fechaUltimoComite;
	}

	public void setFechaUltimoComite(String fechaUltimoComite) {
		this.fechaUltimoComite = fechaUltimoComite;
	}

	public String getNumIntEmpresa() {
		return numIntEmpresa;
	}

	public void setNumIntEmpresa(String numIntEmpresa) {
		this.numIntEmpresa = numIntEmpresa;
	}

	public String getNumExtEmpresa() {
		return numExtEmpresa;
	}

	public void setNumExtEmpresa(String numExtEmpresa) {
		this.numExtEmpresa = numExtEmpresa;
	}

	public String getMunicipioEmpresa() {
		return municipioEmpresa;
	}

	public void setMunicipioEmpresa(String municipioEmpresa) {
		this.municipioEmpresa = municipioEmpresa;
	}

	public String getColoniaEmpresa() {
		return coloniaEmpresa;
	}

	public void setColoniaEmpresa(String coloniaEmpresa) {
		this.coloniaEmpresa = coloniaEmpresa;
	}

	public String getLocalidadEmpresa() {
		return localidadEmpresa;
	}

	public void setLocalidadEmpresa(String localidadEmpresa) {
		this.localidadEmpresa = localidadEmpresa;
	}

	public String getEstadoEmpresa() {
		return estadoEmpresa;
	}

	public void setEstadoEmpresa(String estadoEmpresa) {
		this.estadoEmpresa = estadoEmpresa;
	}

	public String getCPEmpresa() {
		return CPEmpresa;
	}

	public void setCPEmpresa(String cPEmpresa) {
		CPEmpresa = cPEmpresa;
	}

	public String getTimbraEdoCta() {
		return timbraEdoCta;
	}

	public void setTimbraEdoCta(String timbraEdoCta) {
		this.timbraEdoCta = timbraEdoCta;
	}

	public String getGeneraCFDINoReg() {
		return generaCFDINoReg;
	}

	public void setGeneraCFDINoReg(String generaCFDINoReg) {
		this.generaCFDINoReg = generaCFDINoReg;
	}

	public String getGeneraEdoCtaAuto() {
		return generaEdoCtaAuto;
	}

	public void setGeneraEdoCtaAuto(String generaEdoCtaAuto) {
		this.generaEdoCtaAuto = generaEdoCtaAuto;
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



	public String getCuentaEprc() {
		return cuentaEprc;
	}
	public void setCuentaEprc(String cuentaEprc) {
		this.cuentaEprc = cuentaEprc;
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

	public String getNombreInstitucion() {
		return nombreInstitucion;
	}

	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}

	public String getVigDiasSeguro() {
		return vigDiasSeguro;
	}

	public void setVigDiasSeguro(String vigDiasSeguro) {
		this.vigDiasSeguro = vigDiasSeguro;
	}

	public String getAplCobPenCieDia() {
		return aplCobPenCieDia;
	}

	public void setAplCobPenCieDia(String aplCobPenCieDia) {
		this.aplCobPenCieDia = aplCobPenCieDia;
	}

	public String getDirFiscal() {
		return dirFiscal;
	}
	public void setDirFiscal(String dirFiscal) {
		this.dirFiscal = dirFiscal;
	}
	public String getRfcEmpresa() {
		return rfcEmpresa;
	}
	public void setRfcEmpresa(String rfcEmpresa) {
		this.rfcEmpresa = rfcEmpresa;
	}
	public String getUsuarioFactElect() {
		return usuarioFactElect;
	}
	public void setUsuarioFactElect(String usuarioFactElect) {
		this.usuarioFactElect = usuarioFactElect;
	}
	public String getPassFactElec() {
		return passFactElec;
	}

	public void setPassFactElec(String passFactElec) {
		this.passFactElec = passFactElec;
	}

	public String getServReactivaCliID() {
		return servReactivaCliID;
	}

	public void setServReactivaCliID(String servReactivaCliID) {
		this.servReactivaCliID = servReactivaCliID;
	}

	public String getCalifAutoCliente() {
		return califAutoCliente;
	}

	public void setCalifAutoCliente(String califAutoCliente) {
		this.califAutoCliente = califAutoCliente;
	}


	public String getCtaContaFaltante() {
		return ctaContaFaltante;
	}



	public void setCtaContaFaltante(String ctaContaFaltante) {
		this.ctaContaFaltante = ctaContaFaltante;
	}

	public String getUrlWSDLFactElec() {
		return urlWSDLFactElec;
	}
	public void setUrlWSDLFactElec(String urlWSDLFactElec) {
		this.urlWSDLFactElec = urlWSDLFactElec;
	}

	public String getCtaContaSobrante() {
		return ctaContaSobrante;
	}

	public void setCtaContaSobrante(String ctaContaSobrante) {
		this.ctaContaSobrante = ctaContaSobrante;
	}

	public String getCtaContaDocSBCD() {
		return ctaContaDocSBCD;
	}

	public String getCtaContaDocSBCA() {
		return ctaContaDocSBCA;
	}

	public String getAfectaContaRecSBC() {
		return afectaContaRecSBC;
	}

	public void setCtaContaDocSBCD(String ctaContaDocSBCD) {
		this.ctaContaDocSBCD = ctaContaDocSBCD;
	}

	public void setCtaContaDocSBCA(String ctaContaDocSBCA) {
		this.ctaContaDocSBCA = ctaContaDocSBCA;
	}

	public void setAfectaContaRecSBC(String afectaContaRecSBC) {
		this.afectaContaRecSBC = afectaContaRecSBC;
	}


	public String getContabilidadGL() {
		return contabilidadGL;
	}

	public void setContabilidadGL(String contabilidadGL) {
		this.contabilidadGL = contabilidadGL;
	}

	public String getDiasVigenciaBC() {
		return diasVigenciaBC;
	}

	public void setDiasVigenciaBC(String diasVigenciaBC) {
		this.diasVigenciaBC = diasVigenciaBC;
	}

	public String getCenCostosChequesSBC() {
		return cenCostosChequesSBC;
	}

	public void setCenCostosChequesSBC(String cenCostosChequesSBC) {
		this.cenCostosChequesSBC = cenCostosChequesSBC;
	}

	public String getMostrarSaldDispCta() {
		return mostrarSaldDispCta;
	}

	public void setMostrarSaldDispCta(String mostrarSaldDispCta) {
		this.mostrarSaldDispCta = mostrarSaldDispCta;

	}

	public String getTimbraEdoCtaSI() {
		return TimbraEdoCtaSI;
	}

	public void setTimbraEdoCtaSI(String timbraEdoCtaSI) {
		TimbraEdoCtaSI = timbraEdoCtaSI;
	}

	public String getValidaClaveKey() {
		return validaClaveKey;
	}

	public void setValidaClaveKey(String validaClaveKey) {
		this.validaClaveKey = validaClaveKey;
	}

	public String getMostrarSaldDisCtaYSbc() {
		return mostrarSaldDisCtaYSbc;
	}

	public void setMostrarSaldDisCtaYSbc(String mostrarSaldDisCtaYSbc) {
		this.mostrarSaldDisCtaYSbc = mostrarSaldDisCtaYSbc;
	}

	public String getValidaAutComite() {
		return validaAutComite;
	}

	public void setValidaAutComite(String validaAutComite) {
		this.validaAutComite = validaAutComite;
	}

	public String getExtTelefonoLocal() {
		return extTelefonoLocal;
	}

	public void setExtTelefonoLocal(String extTelefonoLocal) {
		this.extTelefonoLocal = extTelefonoLocal;
	}

	public String getExtTelefonoInt() {
		return extTelefonoInt;
	}

	public void setExtTelefonoInt(String extTelefonoInt) {
		this.extTelefonoInt = extTelefonoInt;
	}

	public String getTipoContaMora() {
		return tipoContaMora;
	}

	public void setTipoContaMora(String tipoContaMora) {
		this.tipoContaMora = tipoContaMora;
	}

	public String getDivideIngresoInteres() {
		return divideIngresoInteres;
	}

	public void setDivideIngresoInteres(String divideIngresoInteres) {
		this.divideIngresoInteres = divideIngresoInteres;
	}

	public String getEstCreAltInvGar() {
		return estCreAltInvGar;
	}

	public void setEstCreAltInvGar(String estCreAltInvGar) {
		this.estCreAltInvGar = estCreAltInvGar;
	}

	public String getFuncionHuella() {
		return funcionHuella;
	}

	public void setFuncionHuella(String funcionHuella) {
		this.funcionHuella = funcionHuella;
	}


	public String getConBuroCreDefaut() {
		return conBuroCreDefaut;
	}

	public void setConBuroCreDefaut(String conBuroCreDefaut) {
		this.conBuroCreDefaut = conBuroCreDefaut;
	}

	public String getAbreviaturaCirculo() {
		return abreviaturaCirculo;
	}

	public void setAbreviaturaCirculo(String abreviaturaCirculo) {
		this.abreviaturaCirculo = abreviaturaCirculo;
	}

	public String getRazonSocial() {
		return razonSocial;
	}

	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}

	public String getRfcInstitucion() {
		return rfcInstitucion;
	}

	public void setRfcInstitucion(String rfcInstitucion) {
		this.rfcInstitucion = rfcInstitucion;
	}

	public String getHoraSistema() {
		return horaSistema;
	}

	public void setHoraSistema(String horaSistema) {
		this.horaSistema = horaSistema;
	}

	public String getReqhuellaProductos() {
		return reqhuellaProductos;
	}

	public void setReqhuellaProductos(String reqhuellaProductos) {
		this.reqhuellaProductos = reqhuellaProductos;
	}

	public String getCancelaAutMenor() {
		return cancelaAutMenor;
	}

	public void setCancelaAutMenor(String cancelaAutMenor) {
		this.cancelaAutMenor = cancelaAutMenor;
	}

	public String getActivaPromotorCapta() {
		return activaPromotorCapta;
	}

	public void setActivaPromotorCapta(String activaPromotorCapta) {
		this.activaPromotorCapta = activaPromotorCapta;
	}


	public String getMostrarPrefijo() {
		return mostrarPrefijo;
	}

	public void setMostrarPrefijo(String mostrarPrefijo) {
		this.mostrarPrefijo = mostrarPrefijo;
	}

	public String getCambiaPromotor() {
		return cambiaPromotor;
	}

	public void setCambiaPromotor(String cambiaPromotor) {
		this.cambiaPromotor = cambiaPromotor;
	}

	public String getTesoMovsCieMes() {
		return tesoMovsCieMes;
	}

	public void setTesoMovsCieMes(String tesoMovsCieMes) {
		this.tesoMovsCieMes = tesoMovsCieMes;
	}

	public String getChecListCte() {
		return checListCte;
	}

	public void setChecListCte(String checListCte) {
		this.checListCte = checListCte;
	}

	public String getTarjetaIdentiSocio() {
		return tarjetaIdentiSocio;
	}

	public void setTarjetaIdentiSocio(String tarjetaIdentiSocio) {
		this.tarjetaIdentiSocio = tarjetaIdentiSocio;
	}

	public String getCancelaAutSolCre() {
		return cancelaAutSolCre;
	}

	public void setCancelaAutSolCre(String cancelaAutSolCre) {
		this.cancelaAutSolCre = cancelaAutSolCre;
	}

	public String getDiasCancelaAutSolCre() {
		return diasCancelaAutSolCre;
	}

	public void setDiasCancelaAutSolCre(String diasCancelaAutSolCre) {
		this.diasCancelaAutSolCre = diasCancelaAutSolCre;
	}
	public String getClaveNivInstitucion() {
		return claveNivInstitucion;
	}
	public void setClaveNivInstitucion(String claveNivInstitucion) {
		this.claveNivInstitucion = claveNivInstitucion;
	}
	public String getClaveEntidad() {
		return claveEntidad;
	}
	public void setClaveEntidad(String claveEntidad) {
		this.claveEntidad = claveEntidad;
	}
	public String getImpFomatosInd() {
		return impFomatosInd;
	}
	public void setImpFomatosInd(String impFomatosInd) {
		this.impFomatosInd = impFomatosInd;
	}
	public String getTipoInstitID() {
		return tipoInstitID;
	}
	public void setTipoInstitID(String tipoInstitID) {
		this.tipoInstitID = tipoInstitID;
	}
	public String getSistemasID() {
		return sistemasID;
	}
	public void setSistemasID(String sistemasID) {
		this.sistemasID = sistemasID;
	}
	public String getRutaNotifiCobranza() {
		return rutaNotifiCobranza;
	}
	public void setRutaNotifiCobranza(String rutaNotifiCobranza) {
		this.rutaNotifiCobranza = rutaNotifiCobranza;
	}
	 public String getReqValidaCred() {
		return reqValidaCred;
	}
	public void setReqValidaCred(String reqValidaCred) {
		this.reqValidaCred = reqValidaCred;
	}
	public String getCobraSeguroCuota() {
		return cobraSeguroCuota;
	}
	public void setCobraSeguroCuota(String cobraSeguroCuota) {
		this.cobraSeguroCuota = cobraSeguroCuota;
	}
	public String getReestCalendarioVen() {
		return reestCalendarioVen;
	}
	public void setReestCalendarioVen(String reestCalendarioVen) {
		this.reestCalendarioVen = reestCalendarioVen;
	}
	public String getValidaEstatusRees() {
		return validaEstatusRees;
	}
	public void setValidaEstatusRees(String validaEstatusRees) {
		this.validaEstatusRees = validaEstatusRees;
	}
	public String getTipoDetRecursos() {
		return tipoDetRecursos;
	}
	public void setTipoDetRecursos(String tipoDetRecursos) {
		this.tipoDetRecursos = tipoDetRecursos;
	}
	public String getCalculaCURPyRFC() {
		return calculaCURPyRFC;
	}
	public void setCalculaCURPyRFC(String calculaCURPyRFC) {
		this.calculaCURPyRFC = calculaCURPyRFC;
	}
	public String getManejaCarAgro() {
		return manejaCarAgro;
	}
	public void setManejaCarAgro(String manejaCarAgro) {
		this.manejaCarAgro = manejaCarAgro;
	}
	public String getSalMinDFReal() {
		return salMinDFReal;
	}
	public void setSalMinDFReal(String salMinDFReal) {
		this.salMinDFReal = salMinDFReal;
	}
	public String getEvaluacionMatriz() {
		return evaluacionMatriz;
	}
	public void setEvaluacionMatriz(String evaluacionMatriz) {
		this.evaluacionMatriz = evaluacionMatriz;
	}
	public String getFechaEvaluacionMatriz() {
		return fechaEvaluacionMatriz;
	}
	public void setFechaEvaluacionMatriz(String fechaEvaluacionMatriz) {
		this.fechaEvaluacionMatriz = fechaEvaluacionMatriz;
	}
	public String getFrecuenciaMensual() {
		return frecuenciaMensual;
	}
	public void setFrecuenciaMensual(String frecuenciaMensual) {
		this.frecuenciaMensual = frecuenciaMensual;
	}
	public String getTimbraConsRet() {
		return timbraConsRet;
	}

	public void setTimbraConsRet(String timbraConsRet) {
		this.timbraConsRet = timbraConsRet;
	}

	public String getEvaluaRiesgoComun() {
		return evaluaRiesgoComun;
	}
	public void setEvaluaRiesgoComun(String evaluaRiesgoComun) {
		this.evaluaRiesgoComun = evaluaRiesgoComun;
	}
	public String getPermitirMultDisp(){
		return permitirMultDisp;
	}
	public void setPermitirMultDisp(String permitirMultDisp){
		this.permitirMultDisp=permitirMultDisp;
	}
	public String getCapitalContNeto() {
		return capitalContNeto;
	}
	public void setCapitalContNeto(String capitalContNeto) {
		this.capitalContNeto = capitalContNeto;
	}
		public String getActPerfilTransOpe() {
		return actPerfilTransOpe;
	}
	public void setActPerfilTransOpe(String actPerfilTransOpe) {
		this.actPerfilTransOpe = actPerfilTransOpe;
	}
	public String getFrecuenciaMensPerf() {
		return frecuenciaMensPerf;
	}
	public void setFrecuenciaMensPerf(String frecuenciaMensPerf) {
		this.frecuenciaMensPerf = frecuenciaMensPerf;
	}
	public String getFechaActPerfil() {
		return fechaActPerfil;
	}
	public void setFechaActPerfil(String fechaActPerfil) {
		this.fechaActPerfil = fechaActPerfil;
	}
	public String getPorcCoincidencias() {
		return porcCoincidencias;
	}
	public void setPorcCoincidencias(String porcCoincidencias) {
		this.porcCoincidencias = porcCoincidencias;
	}
	public String getFecVigenDomicilio() {
		return fecVigenDomicilio;
	}
	public void setFecVigenDomicilio(String fecVigenDomicilio) {
		this.fecVigenDomicilio = fecVigenDomicilio;
	}
	public String getModNivelRiesgo() {
		return modNivelRiesgo;
	}
	public void setModNivelRiesgo(String modNivelRiesgo) {
		this.modNivelRiesgo = modNivelRiesgo;
	}
	public String getValidarVigDomi() {
		return validarVigDomi;
	}
	public void setValidarVigDomi(String validarVigDomi) {
		this.validarVigDomi = validarVigDomi;
	}
	public String getTipoDocDomID() {
		return tipoDocDomID;
	}
	public void setTipoDocDomID(String tipoDocDomID) {
		this.tipoDocDomID = tipoDocDomID;
	}
	public String getCobranzaAutCie() {
		return cobranzaAutCie;
	}
	public void setCobranzaAutCie(String cobranzaAutCie) {
		this.cobranzaAutCie = cobranzaAutCie;
	}
	public String getCobroCompletoAut() {
		return cobroCompletoAut;
	}
	public void setCobroCompletoAut(String cobroCompletoAut) {
		this.cobroCompletoAut = cobroCompletoAut;
	}
	public String getCapitalCubiertoReac() {
		return capitalCubiertoReac;
	}
	public void setCapitalCubiertoReac(String capitalCubiertoReac) {
		this.capitalCubiertoReac = capitalCubiertoReac;
	}
	public String getPorcPersonaFisica() {
		return porcPersonaFisica;
	}
	public void setPorcPersonaFisica(String porcPersonaFisica) {
		this.porcPersonaFisica = porcPersonaFisica;
	}
	public String getPorcPersonaMoral() {
		return porcPersonaMoral;
	}
	public void setPorcPersonaMoral(String porcPersonaMoral) {
		this.porcPersonaMoral = porcPersonaMoral;
	}
	public String getCobranzaxReferencia() {
		return cobranzaxReferencia;
	}
	public void setCobranzaxReferencia(String cobranzaxReferencia) {
		this.cobranzaxReferencia = cobranzaxReferencia;
	}
	public String getFechaConsDisp() {
		return fechaConsDisp;
	}
	public void setFechaConsDisp(String fechaConsDisp) {
		this.fechaConsDisp = fechaConsDisp;
	}
	public String getActPerfilTransOpeMas() {
		return actPerfilTransOpeMas;
	}
	public void setActPerfilTransOpeMas(String actPerfilTransOpeMas) {
		this.actPerfilTransOpeMas = actPerfilTransOpeMas;
	}
	public String getNumEvalPerfilTrans() {
		return numEvalPerfilTrans;
	}
	public void setNumEvalPerfilTrans(String numEvalPerfilTrans) {
		this.numEvalPerfilTrans = numEvalPerfilTrans;
	}
	public String getInvPagoPeriodico() {
		return invPagoPeriodico;
	}
	public void setInvPagoPeriodico(String invPagoPeriodico) {
		this.invPagoPeriodico = invPagoPeriodico;
	}
	public String getPerfilAutEspAport() {
		return perfilAutEspAport;
	}
	public void setPerfilAutEspAport(String perfilAutEspAport) {
		this.perfilAutEspAport = perfilAutEspAport;
	}
	public String getNomPerfilAutEspAport() {
		return nomPerfilAutEspAport;
	}
	public void setNomPerfilAutEspAport(String nomPerfilAutEspAport) {
		this.nomPerfilAutEspAport = nomPerfilAutEspAport;
	}
	public String getPerfilCamCarLiqui(){
		return perfilCamCarLiqui;
	}
	public void setPerfilCamCarLiqui(String perfilCamCarLiqui){
		this.perfilCamCarLiqui=perfilCamCarLiqui;
	}
	public String getNomPerfilCamCarLiqui(){
		return nomPerfilCamCarLiqui;
	}
	public void setNomPerfilCamCarLiqui(String nomPerfilCamCarLiqui){
		this.nomPerfilCamCarLiqui=nomPerfilCamCarLiqui;
	}
	public String getInstitucionCirculoCredito() {
		return institucionCirculoCredito;
	}
	public void setInstitucionCirculoCredito(String institucionCirculoCredito) {
		this.institucionCirculoCredito = institucionCirculoCredito;
	}
	public String getClaveEntidadCirculo() {
		return claveEntidadCirculo;
	}
	public void setClaveEntidadCirculo(String claveEntidadCirculo) {
		this.claveEntidadCirculo = claveEntidadCirculo;
	}
	public String getReportarTotalIntegrantes() {
		return reportarTotalIntegrantes;
	}
	public void setReportarTotalIntegrantes(String reportarTotalIntegrantes) {
		this.reportarTotalIntegrantes = reportarTotalIntegrantes;
	}
	public String getDirectorFinanzas() {
		return directorFinanzas;
	}
	public void setDirectorFinanzas(String directorFinanzas) {
		this.directorFinanzas = directorFinanzas;
	}
	public String getRestringeReporte() {
		return restringeReporte;
	}
	public void setRestringeReporte(String restringeReporte) {
		this.restringeReporte = restringeReporte;
	}
	public String getValidaFactura() {
		return validaFactura;
	}
	public void setValidaFactura(String validaFactura) {
		this.validaFactura = validaFactura;
	}
	public String getValidaFacturaURL() {
		return validaFacturaURL;
	}
	public void setValidaFacturaURL(String validaFacturaURL) {
		this.validaFacturaURL = validaFacturaURL;
	}
	public String getTiempoEsperaWS() {
		return tiempoEsperaWS;
	}
	public void setTiempoEsperaWS(String tiempoEsperaWS) {
		this.tiempoEsperaWS = tiempoEsperaWS;
	}
	public String getNumTratamienCreRees() {
		return numTratamienCreRees;
	}
	public void setNumTratamienCreRees(String numTratamienCreRees) {
		this.numTratamienCreRees = numTratamienCreRees;
	}
	public String getCamFuenFonGarFira() {
		return camFuenFonGarFira;
	}
	public void setCamFuenFonGarFira(String camFuenFonGarFira) {
		this.camFuenFonGarFira = camFuenFonGarFira;
	}
	public String getPersonNoDeseadas() {
		return personNoDeseadas;
	}
	public void setPersonNoDeseadas(String personNoDeseadas) {
		this.personNoDeseadas = personNoDeseadas;
	}
	public String getOcultaBtnRechazoSol() {
		return ocultaBtnRechazoSol;
	}
	public void setOcultaBtnRechazoSol(String ocultaBtnRechazoSol) {
		this.ocultaBtnRechazoSol = ocultaBtnRechazoSol;
	}
	public String getRestringebtnLiberacionSol() {
		return restringebtnLiberacionSol;
	}
	public void setRestringebtnLiberacionSol(String restringebtnLiberacionSol) {
		this.restringebtnLiberacionSol = restringebtnLiberacionSol;
	}
	public String getPrimerRolFlujoSolID() {
		return primerRolFlujoSolID;
	}
	public void setPrimerRolFlujoSolID(String primerRolFlujoSolID) {
		this.primerRolFlujoSolID = primerRolFlujoSolID;
	}
	public String getSegundoRolFlujoSolID() {
		return segundoRolFlujoSolID;
	}
	public void setSegundoRolFlujoSolID(String segundoRolFlujoSolID) {
		this.segundoRolFlujoSolID = segundoRolFlujoSolID;
	}
	public String getNombrePrimerRol() {
		return nombrePrimerRol;
	}
	public void setNombrePrimerRol(String nombrePrimerRol) {
		this.nombrePrimerRol = nombrePrimerRol;
	}
	public String getNombreSegundoRol() {
		return nombreSegundoRol;
	}
	public void setNombreSegundoRol(String nombreSegundoRol) {
		this.nombreSegundoRol = nombreSegundoRol;
	}
	public String getVecesSalMinVig() {
		return vecesSalMinVig;
	}
	public void setVecesSalMinVig(String vecesSalMinVig) {
		this.vecesSalMinVig = vecesSalMinVig;
	}
	public String getCaracterMinimo() {
		return caracterMinimo;
	}
	public void setCaracterMinimo(String caracterMinimo) {
		this.caracterMinimo = caracterMinimo;
	}
	public String getCaracterMayus() {
		return caracterMayus;
	}
	public void setCaracterMayus(String caracterMayus) {
		this.caracterMayus = caracterMayus;
	}
	public String getCaracterMinus() {
		return caracterMinus;
	}
	public void setCaracterMinus(String caracterMinus) {
		this.caracterMinus = caracterMinus;
	}
	public String getCaracterNumerico() {
		return caracterNumerico;
	}
	public void setCaracterNumerico(String caracterNumerico) {
		this.caracterNumerico = caracterNumerico;
	}
	public String getCaracterEspecial() {
		return caracterEspecial;
	}
	public void setCaracterEspecial(String caracterEspecial) {
		this.caracterEspecial = caracterEspecial;
	}
	public String getUltimasContra() {
		return ultimasContra;
	}
	public void setUltimasContra(String ultimasContra) {
		this.ultimasContra = ultimasContra;
	}
	public String getDiaMaxCamContra() {
		return diaMaxCamContra;
	}
	public void setDiaMaxCamContra(String diaMaxCamContra) {
		this.diaMaxCamContra = diaMaxCamContra;
	}
	public String getDiaMaxInterSesion() {
		return diaMaxInterSesion;
	}
	public void setDiaMaxInterSesion(String diaMaxInterSesion) {
		this.diaMaxInterSesion = diaMaxInterSesion;
	}
	public String getNumIntentos() {
		return numIntentos;
	}
	public void setNumIntentos(String numIntentos) {
		this.numIntentos = numIntentos;
	}
	public String getNumDiaBloq() {
		return numDiaBloq;
	}
	public void setNumDiaBloq(String numDiaBloq) {
		this.numDiaBloq = numDiaBloq;
	}
	public String getReqCaracterMayus() {
		return reqCaracterMayus;
	}
	public void setReqCaracterMayus(String reqCaracterMayus) {
		this.reqCaracterMayus = reqCaracterMayus;
	}
	public String getReqCaracterMinus() {
		return reqCaracterMinus;
	}
	public void setReqCaracterMinus(String reqCaracterMinus) {
		this.reqCaracterMinus = reqCaracterMinus;
	}
	public String getReqCaracterNumerico() {
		return reqCaracterNumerico;
	}
	public void setReqCaracterNumerico(String reqCaracterNumerico) {
		this.reqCaracterNumerico = reqCaracterNumerico;
	}
	public String getReqCaracterEspecial() {
		return reqCaracterEspecial;
	}
	public void setReqCaracterEspecial(String reqCaracterEspecial) {
		this.reqCaracterEspecial = reqCaracterEspecial;
	}
	public String getHabilitaConfPass() {
		return habilitaConfPass;
	}
	public void setHabilitaConfPass(String habilitaConfPass) {
		this.habilitaConfPass = habilitaConfPass;
	}
	public String getAlerVerificaConvenio() {
		return alerVerificaConvenio;
	}
	public void setAlerVerificaConvenio(String alerVerificaConvenio) {
		this.alerVerificaConvenio = alerVerificaConvenio;
	}
	public String getNoDiasAntEnvioCorreo() {
		return noDiasAntEnvioCorreo;
	}
	public void setNoDiasAntEnvioCorreo(String noDiasAntEnvioCorreo) {
		this.noDiasAntEnvioCorreo = noDiasAntEnvioCorreo;
	}
	public String getCorreoRemitente() {
		return correoRemitente;
	}
	public void setCorreoRemitente(String correoRemitente) {
		this.correoRemitente = correoRemitente;
	}
	public String getCorreoAdiDestino() {
		return correoAdiDestino;
	}
	public void setCorreoAdiDestino(String correoAdiDestino) {
		this.correoAdiDestino = correoAdiDestino;
	}
	public String getRemitenteID() {
		return remitenteID;
	}
	public void setRemitenteID(String remitenteID) {
		this.remitenteID = remitenteID;
	}
	public String getClabeInstitBancaria() {
		return clabeInstitBancaria;
	}
	public void setClabeInstitBancaria(String clabeInstitBancaria) {
		this.clabeInstitBancaria = clabeInstitBancaria;
	}
	public String getValidarEtiqCambFond() {
		return validarEtiqCambFond;
	}
	public void setValidarEtiqCambFond(String validarEtiqCambFond) {
		this.validarEtiqCambFond = validarEtiqCambFond;
	}
	public String getUnificaCI() {
		return unificaCI;
	}
	public void setUnificaCI(String unificaCI) {
		this.unificaCI = unificaCI;
	}
	public String getOrigenReplica() {
		return origenReplica;
	}
	public void setOrigenReplica(String origenReplica) {
		this.origenReplica = origenReplica;
	}
	public String getReplicaAct() {
		return replicaAct;
	}
	public void setReplicaAct(String replicaAct) {
		this.replicaAct = replicaAct;
	}
	public String getCierreAutomatico() {
		return cierreAutomatico;
	}
	public void setCierreAutomatico(String cierreAutomatico) {
		this.cierreAutomatico = cierreAutomatico;
	}
	public String getRemitenteCierreID() {
		return remitenteCierreID;
	}
	public void setRemitenteCierreID(String remitenteCierreID) {
		this.remitenteCierreID = remitenteCierreID;
	}
	public String getCorreoRemitenteCierre() {
		return correoRemitenteCierre;
	}
	public void setCorreoRemitenteCierre(String correoRemitenteCierre) {
		this.correoRemitenteCierre = correoRemitenteCierre;
	}
	public String getEjecDepreAmortiAut() {
		return ejecDepreAmortiAut;
	}
	public void setEjecDepreAmortiAut(String ejecDepreAmortiAut) {
		this.ejecDepreAmortiAut = ejecDepreAmortiAut;
	}
	public String getZonaHoraria() {
		return zonaHoraria;
	}
	public void setZonaHoraria(String zonaHoraria) {
		this.zonaHoraria = zonaHoraria;
	}
	public String getProveedorTimbrado() {
		return proveedorTimbrado;
	}
	public void setProveedorTimbrado(String proveedorTimbrado) {
		this.proveedorTimbrado = proveedorTimbrado;
	}
	public String getValidaRef() {
		return validaRef;
	}
	public void setValidaRef(String validaRef) {
		this.validaRef = validaRef;
	}
	public String getAplicaGarAdiPagoCre() {
		return aplicaGarAdiPagoCre;
	}
	public void setAplicaGarAdiPagoCre(String aplicaGarAdiPagoCre) {
		this.aplicaGarAdiPagoCre = aplicaGarAdiPagoCre;
	}
	public String getValidaCapitalConta() {
		return validaCapitalConta;
	}
	public void setValidaCapitalConta(String validaCapitalConta) {
		this.validaCapitalConta = validaCapitalConta;
	}
	public String getPorMaximoDeposito() {
		return porMaximoDeposito;
	}
	public void setPorMaximoDeposito(String porMaximoDeposito) {
		this.porMaximoDeposito = porMaximoDeposito;
	}
	public String getMostrarBtnResumen() {
		return mostrarBtnResumen;
	}
	public void setMostrarBtnResumen(String mostrarBtnResumen) {
		this.mostrarBtnResumen = mostrarBtnResumen;
	}
	public String getValidaCicloGrupo() {
		return validaCicloGrupo;
	}
	public void setValidaCicloGrupo(String validaCicloGrupo) {
		this.validaCicloGrupo = validaCicloGrupo;
	}
	public String getCargaLayoutXLSDepRef() {
		return CargaLayoutXLSDepRef;
	}
	public void setCargaLayoutXLSDepRef(String cargaLayoutXLSDepRef) {
		CargaLayoutXLSDepRef = cargaLayoutXLSDepRef;
	}
}