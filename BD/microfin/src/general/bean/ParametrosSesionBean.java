package general.bean;

import java.sql.Date;
 
public class ParametrosSesionBean extends BaseBean  implements ParametrosAuditoriaInterfaz {

	private Date fechaAplicacion;
	private int numeroSucursalMatriz;
    private String nombreSucursalMatriz;
    private String telefonoLocal;
    private String telefonoInterior;	
    private int numeroInstitucion;
    private String nombreInstitucion;
    private String nomCortoInstitucion;
    private String representanteLegal;
    private String rfcRepresentante;
    private String nombreJefeCobranza;
    private String nomJefeOperayPromo;
    
    private int numeroMonedaBase;
    private String nombreMonedaBase;	
    private String desCortaMonedaBase;
    private String simboloMonedaBase;
	
    private int numeroUsuario;
    private String claveUsuario;
    private int perfilUsuario;
    private String nombreUsuario;
    private String correoUsuario;
	
    private int sucursal;
    private Date fechaSucursal;
    private String nombreSucursal;
    private String gerenteSucursal;
	
    private String numeroCaja;
    private int loginsFallidos;
    private String mensajeLogin;
    private float tasaISR;
	
    private int empresaID;
    private int diasBaseInversion;
    private int diasCambioPass;
    private String cambioPassword;
    private String estatusSesion;
    private String IPsesion;
    private int clienteInstitucion;
    private long CuentaInstitucion;
    private String direccionInstitucion;		//Direccion de la institucion
    
    private String rutaArchivos;	
    private int promotorID;
    	
    private String cajaID;
    private String tipoCaja;
    private String estatusCaja;
    private String saldoEfecMN;
    private String saldoEfecME;
    private String limiteEfectivoMN;
    private String clavePuestoID;
    private String rutaArchivosPLD;
    private float ivaSucursal;
    
    private String impTicket;			// Nombre de la impresara de tickets
    private String edoMunSucursal;		// Estado y Municipio de la Sucursal
    private String tipoImpTicket;		//tipo de impresion del ticket
    private double montoAportacion;		// monto de aportacion de los socios de la caja de Ahorro
    
    private double	montoPolizaSegA;	// Monto de la póliza de ayuda en caso de siniestro
    private double  montoSegAyuda;		// Monto a pagar del seguro de ayuda
    private String  dirFiscal;
    private String  rfcInst;
    private String impSaldoCred;
    private String impSaldoCta;
    private String nombreCortoInst;
    private String recursoTicketVent;
    

	private String tipoCajaDes;
   // private String nomCortoInstitucion;
    
    private double salMinDF;			// Salario Minimo DF 
    
    private String gerenteGeneral;
    private String presidenteConsejo;
    private String jefeContabilidad;
    private String rolTesoreria; //Rol Tesoreria
    private String rolAdminTeso; //Rol Admin Tesoreria
    private String mostrarSaldDisCtaYSbc; // Valor S o N para mostrar el saldo dispobible de la cta
    private String funcionHuella; 		//Indica si requiere huella o no 
    private String origenDatos;
    private String rutaReportes;
    private String rutaImgReportes;
    private String logoCtePantalla;
    private String mostrarPrefijo;
    private String cambiaPromotor;
    private String desFechaPeriodo;
    private String tipoImpresoraTicket;
    
    private String directorFinanzas;
    private String mostrarBtnResumen;
	private String lookAndFeel;
    
	public String getIPsesion() {
		return IPsesion;
	}
	public void setIPsesion(String iPsesion) {
		IPsesion = iPsesion;
	}
	public int getDiasCambioPass() {
		return diasCambioPass;
	}
	public void setDiasCambioPass(int diasCambioPass) {
		this.diasCambioPass = diasCambioPass;
	}
	Date fechUltimAcces;
	Date fechUltPass;
	
	public Date getFechUltimAcces() {
		return fechUltimAcces;
	}
	public void setFechUltimAcces(Date fechUltimAcces) {
		this.fechUltimAcces = fechUltimAcces;
	}
	public Date getFechUltPass() {
		return fechUltPass;
	}
	public void setFechUltPass(Date fechUltPass) {
		this.fechUltPass = fechUltPass;
	}
	public Date getFechaAplicacion() {
		return fechaAplicacion;
	}
	public void setFechaAplicacion(Date fechaAplicacion) {
		this.fechaAplicacion = fechaAplicacion;
	}
	public int getNumeroSucursalMatriz() {
		return numeroSucursalMatriz;
	}
	public void setNumeroSucursalMatriz(int numeroSucursalMatriz) {
		this.numeroSucursalMatriz = numeroSucursalMatriz;
	}
	public String getNombreSucursalMatriz() {
		return nombreSucursalMatriz;
	}
	public void setNombreSucursalMatriz(String nombreSucursalMatriz) {
		this.nombreSucursalMatriz = nombreSucursalMatriz;
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
	public int getNumeroInstitucion() {
		return numeroInstitucion;
	}
	public void setNumeroInstitucion(int numeroInstitucion) {
		this.numeroInstitucion = numeroInstitucion;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}	
	public String getNomCortoInstitucion() {
		return nomCortoInstitucion;
	}
	public void setNomCortoInstitucion(String nomCortoInstitucion) {
		this.nomCortoInstitucion = nomCortoInstitucion;
	}
	public String getRepresentanteLegal() {
		return representanteLegal;
	}
	public void setRepresentanteLegal(String representanteLegal) {
		this.representanteLegal = representanteLegal;
	}
	public String getRfcRepresentante() {
		return rfcRepresentante;
	}
	public void setRfcRepresentante(String rfcRepresentante) {
		this.rfcRepresentante = rfcRepresentante;
	}
	public int getNumeroMonedaBase() {
		return numeroMonedaBase;
	}
	public void setNumeroMonedaBase(int numeroMonedaBase) {
		this.numeroMonedaBase = numeroMonedaBase;
	}
	public String getNombreMonedaBase() {
		return nombreMonedaBase;
	}
	public void setNombreMonedaBase(String nombreMonedaBase) {
		this.nombreMonedaBase = nombreMonedaBase;
	}
	public String getDesCortaMonedaBase() {
		return desCortaMonedaBase;
	}
	public void setDesCortaMonedaBase(String desCortaMonedaBase) {
		this.desCortaMonedaBase = desCortaMonedaBase;
	}
	public String getSimboloMonedaBase() {
		return simboloMonedaBase;
	}
	public void setSimboloMonedaBase(String simboloMonedaBase) {
		this.simboloMonedaBase = simboloMonedaBase;
	}
	public int getNumeroUsuario() {
		return numeroUsuario;
	}
	public void setNumeroUsuario(int numeroUsuario) {
		this.numeroUsuario = numeroUsuario;
	}
	public String getClaveUsuario() {
		return claveUsuario;
	}
	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}
	public int getPerfilUsuario() {
		return perfilUsuario;
	}
	public void setPerfilUsuario(int perfilUsuario) {
		this.perfilUsuario = perfilUsuario;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getCorreoUsuario() {
		return correoUsuario;
	}
	public void setCorreoUsuario(String correoUsuario) {
		this.correoUsuario = correoUsuario;
	}
	public int getSucursal() {
		return sucursal;
	}
	public void setSucursal(int sucursal) {
		this.sucursal = sucursal;
	}
	public Date getFechaSucursal() {
		return fechaSucursal;
	}
	public void setFechaSucursal(Date fechaSucursal) {
		this.fechaSucursal = fechaSucursal;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getGerenteSucursal() {
		return gerenteSucursal;
	}
	public void setGerenteSucursal(String gerenteSucursal) {
		this.gerenteSucursal = gerenteSucursal;
	}
	public String getNumeroCaja() {
		return numeroCaja;
	}
	public void setNumeroCaja(String numeroCaja) {
		this.numeroCaja = numeroCaja;
	}
	public int getLoginsFallidos() {
		return loginsFallidos;
	}
	public void setLoginsFallidos(int loginsFallidos) {
		this.loginsFallidos = loginsFallidos;
	}
	public String getMensajeLogin() {
		return mensajeLogin;
	}
	public void setMensajeLogin(String mensajeLogin) {
		this.mensajeLogin = mensajeLogin;
	}
	public float getTasaISR() {
		return tasaISR;
	}
	public void setTasaISR(float tasaISR) {
		this.tasaISR = tasaISR;
	}
	public int getClienteInstitucion() {
		return clienteInstitucion;
	}
	public void setClienteInstitucion(int clienteInstitucion) {
		this.clienteInstitucion = clienteInstitucion;
	}
	public long getCuentaInstitucion() {
		return CuentaInstitucion;
	}
	public void setCuentaInstitucion(long cuentaInstitucion) {
		CuentaInstitucion = cuentaInstitucion;
	}
	public int getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(int empresaID) {
		this.empresaID = empresaID;
	}
	public int getDiasBaseInversion() {
		return diasBaseInversion;
	}
	public void setDiasBaseInversion(int diasBaseInversion) {
		this.diasBaseInversion = diasBaseInversion;
	}
	public String getCambioPassword() {
		return cambioPassword;
	}
	public void setCambioPassword(String cambioPassword) {
		this.cambioPassword = cambioPassword;
	}
	public String getEstatusSesion() {
		return estatusSesion;
	}
	public void setEstatusSesion(String estatusSesion) {
		this.estatusSesion = estatusSesion;
	}
	public int getPromotorID() {
		return promotorID;
	}
	public void setPromotorID(int promotorID) {
		this.promotorID = promotorID;
	}
	public String getRutaArchivos() {
		return rutaArchivos;
	}
	public void setRutaArchivos(String rutaArchivos) {
		this.rutaArchivos = rutaArchivos;
	}
	public String getCajaID() {
		return cajaID;
	}
	public void setCajaID(String cajaID) {
		this.cajaID = cajaID;
	}
	public String getTipoCaja() {
		return tipoCaja;
	}
	public void setTipoCaja(String tipoCaja) {
		this.tipoCaja = tipoCaja;
	}
	public String getSaldoEfecMN() {
		return saldoEfecMN;
	}
	public void setSaldoEfecMN(String saldoEfecMN) {
		this.saldoEfecMN = saldoEfecMN;
	}
	public String getSaldoEfecME() {
		return saldoEfecME;
	}
	public void setSaldoEfecME(String saldoEfecME) {
		this.saldoEfecME = saldoEfecME;
	}
	public String getLimiteEfectivoMN() {
		return limiteEfectivoMN;
	}
	public void setLimiteEfectivoMN(String limiteEfectivoMN) {
		this.limiteEfectivoMN = limiteEfectivoMN;
	}
	public String getTipoCajaDes() {
		return tipoCajaDes;
	}
	public void setTipoCajaDes(String tipoCajaDes) {
		this.tipoCajaDes = tipoCajaDes;
	}
	public String getClavePuestoID() {
		return clavePuestoID;
	}
	public void setClavePuestoID(String clavePuestoID) {
		this.clavePuestoID = clavePuestoID;
	}
	public String getRutaArchivosPLD() {
		return rutaArchivosPLD;
	}
	public void setRutaArchivosPLD(String rutaArchivosPLD) {
		this.rutaArchivosPLD = rutaArchivosPLD;
	}
	public float getIvaSucursal() {
		return ivaSucursal;
	}
	public void setIvaSucursal(float ivaSucursal) {
		this.ivaSucursal = ivaSucursal;
	}
	public String getDireccionInstitucion() {
		return direccionInstitucion;
	}
	public void setDireccionInstitucion(String direccionInstitucion) {
		this.direccionInstitucion = direccionInstitucion;
	}
	public String getImpTicket() {
		return impTicket;
	}
	public void setImpTicket(String impTicket) {
		this.impTicket = impTicket;
	}
	public String getEdoMunSucursal() {
		return edoMunSucursal;
	}
	public void setEdoMunSucursal(String edoMunSucursal) {
		this.edoMunSucursal = edoMunSucursal;
	}
	public String getTipoImpTicket() {
		return tipoImpTicket;
	}
	public void setTipoImpTicket(String tipoImpTicket) {
		this.tipoImpTicket = tipoImpTicket;
	}
	public String getEstatusCaja() {
		return estatusCaja;
	}
	public void setEstatusCaja(String estatusCaja) {
		this.estatusCaja = estatusCaja;
	}
	public double getMontoAportacion() {
		return montoAportacion;
	}
	public void setMontoAportacion(double montoAportacion) {
		this.montoAportacion = montoAportacion;
	}
	public double getMontoPolizaSegA() {
		return montoPolizaSegA;
	}
	public void setMontoPolizaSegA(double montoPolizaSegA) {
		this.montoPolizaSegA = montoPolizaSegA;
	}
	public double getMontoSegAyuda() {
		return montoSegAyuda;
	}
	public void setMontoSegAyuda(double montoSegAyuda) {
		this.montoSegAyuda = montoSegAyuda;
	}
	/*public String getNomCortoInstitucion() {
		return nomCortoInstitucion;
	}
	public void setNomCortoInstitucion(String nomCortoInstitucion) {
		this.nomCortoInstitucion = nomCortoInstitucion;
	}

	*/
	public double getSalMinDF() {
		return salMinDF;
	}
	public void setSalMinDF(double salMinDF) {
		this.salMinDF = salMinDF;
	}
    public String getDirFiscal() {
		return dirFiscal;
	}
	public void setDirFiscal(String dirFiscal) {
		this.dirFiscal = dirFiscal;
	}
	public String getRfcInst() {
		return rfcInst;
	}
	public void setRfcInst(String rfcInst) {
		this.rfcInst = rfcInst;
	}
	public String getNombreJefeCobranza() {
		return nombreJefeCobranza;
	}
	public String getImpSaldoCred() {
		return impSaldoCred;
	}
	public String getNomJefeOperayPromo() {
		return nomJefeOperayPromo;
	}
	public void setNombreJefeCobranza(String nombreJefeCobranza) {
		this.nombreJefeCobranza = nombreJefeCobranza;
	}
	public void setNomJefeOperayPromo(String nomJefeOperayPromo) {
		this.nomJefeOperayPromo = nomJefeOperayPromo;
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

	public String getRecursoTicketVent() {
		return recursoTicketVent;
	}
	public void setRecursoTicketVent(String recursoTicketVent) {
		this.recursoTicketVent = recursoTicketVent;
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
	public String getMostrarSaldDisCtaYSbc() {
		return mostrarSaldDisCtaYSbc;
	}
	public void setMostrarSaldDisCtaYSbc(String mostrarSaldDisCtaYSbc) {
		this.mostrarSaldDisCtaYSbc = mostrarSaldDisCtaYSbc;
	}
	public String getFuncionHuella() {
		return funcionHuella;
	}
	public void setFuncionHuella(String funcionHuella) {
		this.funcionHuella = funcionHuella;

	}
	
	public String getCambiaPromotor() {
		return cambiaPromotor;
	}
	public void setCambiaPromotor(String cambiaPromotor) {
		this.cambiaPromotor = cambiaPromotor;
	}
	

	public String getOrigenDatos() {
		return origenDatos;
	}
	public void setOrigenDatos(String origenDatos) {
		this.origenDatos = origenDatos;
	}

	public String getRutaReportes() {
		return rutaReportes;
	}
	public void setRutaReportes(String rutaReportes) {
		this.rutaReportes = rutaReportes;
	}
	
	public String getRutaImgReportes() {
		return rutaImgReportes;
	}
	public void setRutaImgReportes(String rutaImgReportes) {
		this.rutaImgReportes = rutaImgReportes;
	}
	
	public String getLogoCtePantalla() {
		return logoCtePantalla;
	}
	public void setLogoCtePantalla(String logoCtePantalla) {
		this.logoCtePantalla = logoCtePantalla;
	}

	public String getMostrarPrefijo() {
		return mostrarPrefijo;
	}
	public void setMostrarPrefijo(String mostrarPrefijo) {
		this.mostrarPrefijo = mostrarPrefijo;
	}
	public String getTipoImpresoraTicket() {
		return tipoImpresoraTicket;
	}
	public void setTipoImpresoraTicket(String tipoImpresoraTicket) {
		this.tipoImpresoraTicket = tipoImpresoraTicket;
	}
	public String getDirectorFinanzas() {
		return directorFinanzas;
	}
	public void setDirectorFinanzas(String directorFinanzas) {
		this.directorFinanzas = directorFinanzas;
	}
	public String getDesFechaPeriodo() {
		return desFechaPeriodo;
	}
	public void setDesFechaPeriodo(String desFechaPeriodo) {
		this.desFechaPeriodo = desFechaPeriodo;
	}	
	public String getMostrarBtnResumen() {
		return mostrarBtnResumen;
	}
	public void setMostrarBtnResumen(String mostrarBtnResumen) {
		this.mostrarBtnResumen = mostrarBtnResumen;
	}
	public String getLookAndFeel() {
		return lookAndFeel;
	}
	public void setLookAndFeel(String lookAndFeel) {
		this.lookAndFeel = lookAndFeel;
	}
}