
package cliente.bean;

import general.bean.BaseBean;
public class ClienteBean extends BaseBean{
	//Declaracion de Constantes
	public static int LONGITUD_ID = 10;
	public static String  PER_FISICA="F" ;
	public static String  PER_MORAL="M" ;
	public static String  PER_FISACTEMP="A";
	public static String  NO_PAGA_IVA="N" ;
	public static String  SI_PAGA_IVA="S" ;
	public static String  SI_ALT_HACIENDA="S"; //CONSTANTE QUE SI ESTA REGISTRADO EN HACIENDA
	public static String  NO_ALT_HACIENDA="N"; //CONSTANTE QUE NO ESTA REGISTRADO EN HACIENDA
	public static String  MENOR_EDAD="E";	//CONSTANTE PARA IDENTIFICAR QUE EL CLIENTE ES MENOR DE EDAD
	
	private String empresaID;
	private String numero;
	private String tipoPersona;
	private String titulo;
	private String primerNombre;
	private String segundoNombre;
	private String tercerNombre;
	private String apellidoPaterno;
	private String apellidoMaterno;
	private String fechaNacimiento;
	private String CURP;
	private String nacion;
	private String paisResidencia;
	private String representanteLegal;
	private String razonSocial;
	private String tipoSociedadID;
	private String RFCpm;
	private String grupoEmpresarial;
	private String fax; 
	private String correo;
	private String RFC;
	private String sectorGeneral;
	private String actividadBancoMX;
	private String actividadINEGI;
	private String actividadFR;
	private String actividadFOMUR;
	private String sectorEconomico;
	private String sexo;
	private String estadoCivil;
	private String lugarNacimiento;
	private String direccion;
	private String estadoID;
	private String ocupacionID;
	private String lugarTrabajo;
	private String puesto;
	private String domicilioTrabajo;
	private String telTrabajo;
	private String antiguedadTra;
	private String telefonoCelular;
	private String telefonoCasa;
	private String clasificacion;
	private String motivoApertura;
	private String pagaISR;
	private String pagaIVA;
	private String pagaIDE;
	private String nivelRiesgo;
	private String promotorInicial;
	private String promotorActual;
	private String fechaAlta;
	private String estatus;
	private String nombreCompleto;
	private String sucursalOrigen;
	private String RFCOficial;
	private String tipoInactiva;
	private String motivoInactiva;
	private String outclienteID;
	private String outNumErr;
	private String outErrMen;
	private String salida;
	private String claveUsuAuto;
	private String contraseniaUsu;
	private String esMenorEdad;
	private String registroHacienda; //variable para cachar valor de jradiobutton
	private String edad;
	private String noEmpleado;
	private String tipoEmpleado;
	private String aporteSocio;		
	
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	private String clienteID;
	private String calificaCredito;
	private String calificacion;
	private String estatusCred;

	//auxiliares
	private String prospectoID;	
	private String productocCreditoID;
	private String institNominaID;
	private String institucionNominaID;
	private String negocioAfiliadoID;
	private String numCon;
	private	String observaciones;
	private String descripcionCURP;
	private String descripcionRFC;
	private String extTelefonoPart;
	private String extTelefonoTrab;
	private String fechaCorte;
	private String horaEmision;
	private String tipoAportacion;
	private String totalAhorro;
	private String totalInversion;
	private String totalCreditos;
	private String moroso;
	private String maximoMora;
	private String sucursalID;
	private String ejecutivoCap;
	private String promotorExtInv;
	
	private String nombSucursal;
	private String promotorAct;
	private String nombPromotor;
	private String promotorNue;
	
	private String tipoPuestoID;
	private String origenDatos;
	
	private String fechaIniTrabajo;
	private String ubicaNegocioID;

	// Auxiliares para Asociacion de Tarjetas con WS Entura
	private String tipoDocumento;
	private String codigoMoneda;
	private String tipoDireccion;
	private String tipoTelefono;
	private String codCooperativa;
	private String codMoneda;
	private String codUsuario;
	private String tipoCuenta;

	// Nueva disposición articulo 4to 
	private String fea;
	private String fechaConstitucion;
	private String paisFea;
	
	 //Datos Adicionales Personas Morales
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
    private String escrituraPubPM;
    private String feaPM;
    private String paisFeaPM;
    private String tasaISR;
    private String validaTasa;
    private String observacionesPM;
    private String paisNacionalidad;
	
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}
	//corporativo relacionado a cliente
	private String corpRelacionado; 
	
	public String getRFCOficial() {
		return RFCOficial;
	}
	public void setRFCOficial(String rFCOficial) {
		RFCOficial = rFCOficial;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public String getNumero() {
		return numero;
	}
	public void setNumero(String numero) {
		this.numero = numero;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
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
	public String getFechaNacimiento() {
		return fechaNacimiento;
	}
	public void setFechaNacimiento(String fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}
	public String getCURP() {
		return CURP;
	}
	public void setCURP(String cURP) {
		CURP = cURP;
	}
	
	
	
	public String getRegistroHacienda(){
		return registroHacienda;
	}
	public void setRegistroHacienda(String registroHacienda){
		this.registroHacienda = registroHacienda;
	}
	
	
	
	public String getNacion() {
		return nacion;
	}
	public void setNacion(String nacion) {
		this.nacion = nacion;
	}
	public String getPaisResidencia() {
		return paisResidencia;
	}
	public void setPaisResidencia(String paisResidencia) {
		this.paisResidencia = paisResidencia;
	}
	public String getRepresentanteLegal() {
		return representanteLegal;
	}
	public void setRepresentanteLegal(String representanteLegal) {
		this.representanteLegal = representanteLegal;
	}
	public String getRazonSocial() {
		return razonSocial;
	}
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
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
	public String getFax() {
		return fax;
	}
	public void setFax(String fax) {
		this.fax = fax;
	}
	public String getCorreo() {
		return correo;
	}
	public void setCorreo(String correo) {
		this.correo = correo;
	}
	public String getRFC() {
		return RFC;
	}
	public void setRFC(String rFC) {
		RFC = rFC;
	}	
	public String getTipoInactiva() {
		return tipoInactiva;
	}
	public void setTipoInactiva(String tipoInactiva) {
		this.tipoInactiva = tipoInactiva;
	}
	public String getMotivoInactiva() {
		return motivoInactiva;
	}
	public void setMotivoInactiva(String motivoInactiva) {
		this.motivoInactiva = motivoInactiva;
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
	public String getActividadFR() {
		return actividadFR;
	}
	public void setActividadFR(String actividadFR) {
		this.actividadFR = actividadFR;
	}	
	public String getActividadFOMUR() {
		return actividadFOMUR;
	}
	public void setActividadFOMUR(String actividadFOMUR) {
		this.actividadFOMUR = actividadFOMUR;
	}
	public String getSectorEconomico() {
		return sectorEconomico;
	}
	public void setSectorEconomico(String sectorEconomico) {
		this.sectorEconomico = sectorEconomico;
	}
	public String getSexo() {
		return sexo;
	}
	public void setSexo(String sexo) {
		this.sexo = sexo;
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
	public String getEstadoID() {
		return estadoID;
	}
	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
	}
	public String getOcupacionID() {
		return ocupacionID;
	}
	public void setOcupacionID(String ocupacionID) {
		this.ocupacionID = ocupacionID;
	}
	public String getLugarTrabajo() {
		return lugarTrabajo;
	}
	public void setLugarTrabajo(String lugarTrabajo) {
		this.lugarTrabajo = lugarTrabajo;
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
	public String getTelTrabajo() {
		return telTrabajo;
	}
	public void setTelTrabajo(String telTrabajo) {
		this.telTrabajo = telTrabajo;
	}
	public String getAntiguedadTra() {
		return antiguedadTra;
	}
	public void setAntiguedadTra(String antiguedadTra) {
		this.antiguedadTra = antiguedadTra;
	}
	public String getTelefonoCelular() {
		return telefonoCelular;
	}
	public void setTelefonoCelular(String telefonoCelular) {
		this.telefonoCelular = telefonoCelular;
	}
	public String getTelefonoCasa() {
		return telefonoCasa;
	}
	public void setTelefonoCasa(String telefonoCasa) {
		this.telefonoCasa = telefonoCasa;
	}
	public String getClasificacion() {
		return clasificacion;
	}
	public void setClasificacion(String clasificacion) {
		this.clasificacion = clasificacion;
	}
	public String getMotivoApertura() {
		return motivoApertura;
	}
	public void setMotivoApertura(String motivoApertura) {
		this.motivoApertura = motivoApertura;
	}
	public String getPagaISR() {
		return pagaISR;
	}
	public void setPagaISR(String pagaISR) {
		this.pagaISR = pagaISR;
	}
	public String getPagaIVA() {
		return pagaIVA;
	}
	public void setPagaIVA(String pagaIVA) {
		this.pagaIVA = pagaIVA;
	}
	public String getPagaIDE() {
		return pagaIDE;
	}
	public void setPagaIDE(String pagaIDE) {
		this.pagaIDE = pagaIDE;
	}
	public String getNivelRiesgo() {
		return nivelRiesgo;
	}
	public void setNivelRiesgo(String nivelRiesgo) {
		this.nivelRiesgo = nivelRiesgo;
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
	public String getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(String fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	
	public String getClaveUsuAuto() {
		return claveUsuAuto;
	}
	public void setClaveUsuAuto(String claveUsuAuto) {
		this.claveUsuAuto = claveUsuAuto;
	}
	public String getContraseniaUsu() {
		return contraseniaUsu;
	}
	public void setContraseniaUsu(String contraseniaUsu) {
		this.contraseniaUsu = contraseniaUsu;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getSucursalOrigen() {
		return sucursalOrigen;
	}
	public void setSucursalOrigen(String sucursalOrigen) {
		this.sucursalOrigen = sucursalOrigen;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
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
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getOutclienteID() {
		return outclienteID;
	}
	public void setOutclienteID(String outclienteID) {
		this.outclienteID = outclienteID;
	}
	public String getOutNumErr() {
		return outNumErr;
	}
	public void setOutNumErr(String outNumErr) {
		this.outNumErr = outNumErr;
	}
	public String getOutErrMen() {
		return outErrMen;
	}
	public void setOutErrMen(String outErrMen) {
		this.outErrMen = outErrMen;
	}
	public String getSalida() {
		return salida;
	}
	public void setSalida(String salida) {
		this.salida = salida;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}	
	public String getEsMenorEdad() {
		return esMenorEdad;
	}
	public void setEsMenorEdad(String esMenorEdad) {
		this.esMenorEdad = esMenorEdad;
	}
	/**
	 * @return the productocCreditoID
	 */
	public String getProductocCreditoID() {
		return productocCreditoID;
	}
	/**
	 * @param productocCreditoID the productocCreditoID to set
	 */
	public void setProductocCreditoID(String productocCreditoID) {
		this.productocCreditoID = productocCreditoID;
	}

	public String getCorpRelacionado() {
		return corpRelacionado;
	}
	public void setCorpRelacionado(String corpRelacionado) {
		this.corpRelacionado = corpRelacionado;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCalificaCredito() {
		return calificaCredito;
	}
	public void setCalificaCredito(String calificaCredito) {
		this.calificaCredito = calificaCredito;
	}

	public String getEstatusCred() {
		return estatusCred;
	}
	public void setEstatusCred(String estatusCred) {
		this.estatusCred = estatusCred;
	}
	public String getEdad() {
		return edad;
	}
	public void setEdad(String edad) {
		this.edad = edad;
	}
	public String getInstitucionNominaID() {
		return institucionNominaID;
	}
	public void setInstitucionNominaID(String institucionNominaID) {
		this.institucionNominaID = institucionNominaID;
	}
	public String getNegocioAfiliadoID() {
		return negocioAfiliadoID;
	}
	public void setNegocioAfiliadoID(String negocioAfiliadoID) {
		this.negocioAfiliadoID = negocioAfiliadoID;
	}
	public String getNumCon() {
		return numCon;
	}
	public void setNumCon(String numCon) {
		this.numCon = numCon;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public String getCalificacion() {
		return calificacion;
	}
	public void setCalificacion(String calificacion) {
		this.calificacion = calificacion;
	}

	public String getNoEmpleado() {
		return noEmpleado;
	}
	public void setNoEmpleado(String noEmpleado) {
		this.noEmpleado = noEmpleado;
	}
	public String getTipoEmpleado() {
		return tipoEmpleado;
	}
	public void setTipoEmpleado(String tipoEmpleado) {
		this.tipoEmpleado = tipoEmpleado;
	}
	public String getDescripcionCURP() {
		return descripcionCURP;
	}
	public void setDescripcionCURP(String descripcionCURP) {
		this.descripcionCURP = descripcionCURP;
	}
	public String getDescripcionRFC() {
		return descripcionRFC;
	}
	public void setDescripcionRFC(String descripcionRFC) {
		this.descripcionRFC = descripcionRFC;
	}
	
	public String getExtTelefonoPart() {
		return extTelefonoPart;
	}
	public void setExtTelefonoPart(String extTelefonoPart) {
		this.extTelefonoPart = extTelefonoPart;
	}
	public String getExtTelefonoTrab() {
		return extTelefonoTrab;
	}
	public void setExtTelefonoTrab(String extTelefonoTrab) {
		this.extTelefonoTrab = extTelefonoTrab;
	}
	public String getAporteSocio() {
		return aporteSocio;
	}
	public void setAporteSocio(String aporteSocio) {
		this.aporteSocio = aporteSocio;
	}
	public String getFechaCorte() {
		return fechaCorte;
	}
	public void setFechaCorte(String fechaCorte) {
		this.fechaCorte = fechaCorte;
	}
	public String getTipoAportacion() {
		return tipoAportacion;
	}
	public void setTipoAportacion(String tipoAportacion) {
		this.tipoAportacion = tipoAportacion;
	}
	public String getTotalAhorro() {
		return totalAhorro;
	}
	public String getTotalInversion() {
		return totalInversion;
	}
	public String getTotalCreditos() {
		return totalCreditos;
	}
	public String getMoroso() {
		return moroso;
	}
	public String getMaximoMora() {
		return maximoMora;
	}
	public void setTotalAhorro(String totalAhorro) {
		this.totalAhorro = totalAhorro;
	}
	public void setTotalInversion(String totalInversion) {
		this.totalInversion = totalInversion;
	}
	public void setTotalCreditos(String totalCreditos) {
		this.totalCreditos = totalCreditos;
	}
	public void setMoroso(String moroso) {
		this.moroso = moroso;
	}
	public void setMaximoMora(String maximoMora) {
		this.maximoMora = maximoMora;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getEjecutivoCap() {
		return ejecutivoCap;
	}
	public void setEjecutivoCap(String ejecutivoCap) {
		this.ejecutivoCap = ejecutivoCap;
	}
	public String getPromotorExtInv() {
		return promotorExtInv;
	}
	public void setPromotorExtInv(String promotorExtInv) {
		this.promotorExtInv = promotorExtInv;
	}
	public String getNombSucursal() {
		return nombSucursal;
	}
	public void setNombSucursal(String nombSucursal) {
		this.nombSucursal = nombSucursal;
	}
	public String getNombPromotor() {
		return nombPromotor;
	}
	public void setNombPromotor(String nombPromotor) {
		this.nombPromotor = nombPromotor;
	}
	public String getPromotorAct() {
		return promotorAct;
	}
	public void setPromotorAct(String promotorAct) {
		this.promotorAct = promotorAct;
	}
	public String getPromotorNue() {
		return promotorNue;
	}
	public void setPromotorNue(String promotorNue) {
		this.promotorNue = promotorNue;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getTipoPuestoID() {
		return tipoPuestoID;
	}
	public void setTipoPuestoID(String tipoPuestoID) {
		this.tipoPuestoID = tipoPuestoID;
	}
	public String getOrigenDatos() {
		return origenDatos;
	}
	public void setOrigenDatos(String origenDatos) {
		this.origenDatos = origenDatos;
	}
	public String getFechaIniTrabajo() {
		return fechaIniTrabajo;
	}
	public void setFechaIniTrabajo(String fechaIniTrabajo) {
		this.fechaIniTrabajo = fechaIniTrabajo;
	}
	public String getUbicaNegocioID() {
		return ubicaNegocioID;
	}
	public void setUbicaNegocioID(String ubicaNegocioID) {
		this.ubicaNegocioID = ubicaNegocioID;
	}	
	public String getTipoDocumento() {
		return tipoDocumento;
	}
	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}
	public String getCodigoMoneda() {
		return codigoMoneda;
	}
	public void setCodigoMoneda(String codigoMoneda) {
		this.codigoMoneda = codigoMoneda;
	}
	public String getTipoDireccion() {
		return tipoDireccion;
	}
	public void setTipoDireccion(String tipoDireccion) {
		this.tipoDireccion = tipoDireccion;
	}
	public String getTipoTelefono() {
		return tipoTelefono;
	}
	public void setTipoTelefono(String tipoTelefono) {
		this.tipoTelefono = tipoTelefono;
	}
	public String getCodCooperativa() {
		return codCooperativa;
	}
	public void setCodCooperativa(String codCooperativa) {
		this.codCooperativa = codCooperativa;
	}
	public String getCodMoneda() {
		return codMoneda;
	}
	public void setCodMoneda(String codMoneda) {
		this.codMoneda = codMoneda;
	}
	public String getCodUsuario() {
		return codUsuario;
	}
	public void setCodUsuario(String codUsuario) {
		this.codUsuario = codUsuario;
	}
	public String getTipoCuenta() {
		return tipoCuenta;
	}
	public void setTipoCuenta(String tipoCuenta) {
		this.tipoCuenta = tipoCuenta;
	}
	public String getFea() {
		return fea;
	}
	public void setFea(String fea) {
		this.fea = fea;
	}
	public String getFechaConstitucion() {
		return fechaConstitucion;
	}
	public void setFechaConstitucion(String fechaConstitucion) {
		this.fechaConstitucion = fechaConstitucion;
	}
	public String getPaisFea() {
		return paisFea;
	}
	public void setPaisFea(String paisFea) {
		this.paisFea = paisFea;
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
	public String getEscrituraPubPM() {
		return escrituraPubPM;
	}
	public void setEscrituraPubPM(String escrituraPubPM) {
		this.escrituraPubPM = escrituraPubPM;
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
	public String getTasaISR() {
		return tasaISR;
	}
	public void setTasaISR(String tasaISR) {
		this.tasaISR = tasaISR;
	}
	public String getValidaTasa() {
		return validaTasa;
	}
	public void setValidaTasa(String validaTasa) {
		this.validaTasa = validaTasa;
	}
	public String getObservacionesPM() {
		return observacionesPM;
	}
	public void setObservacionesPM(String observacionesPM) {
		this.observacionesPM = observacionesPM;
	}
	public String getPaisNacionalidad() {
		return paisNacionalidad;
	}
	public void setPaisNacionalidad(String paisNacionalidad) {
		this.paisNacionalidad = paisNacionalidad;
	}
	
}