package soporte.bean;

import general.bean.BaseBean;

public class UsuarioBean extends BaseBean {
	 
	public static int LONGITUD_ID = 7;	
	public static String STATUS_ACTIVO = "A";
	public static int act_statusSesion = 5;
	public static int calcFechaPass= 1;
	public static String STAT_SES_INACT = "I";

	//Declaracion de Constantes
	private String usuarioID;
	private String clavePuestoID;
	private String nombre;
	private String apPaterno;
	private String apMaterno;
	private String nombreCompleto;
	private String estatusSesion;
	private String fechaAlta;
	private String fechUltAcces;
	private String fechUltPass;
	private String clave;
	private String contrasenia;
	private String estatus;
	private String rolID;
	private String sucursalUsuario;
	private String nombreRol;
	private String ipSesion;
	private String correo;
	private int    loginsFallidos;
	private String motivoBloqueo;
	private String fechaBloqueo;
	private String motivoCancel;
	private String fechaCancel;
	private String salt;
	private String descripGestor;
	private String esGestor;
	private String realizaConsultasCC;
	private String usuarioCirculo;
	private String contrasenaCirculo;
	private String realizaConsultasBC;
	private String usuarioBuroCredito;
	private String contrasenaBuroCredito;
	private String origenDatos;
	private String rutaReportes;
	private String rutaImgReportes;
	private String logoCtePantalla;
	private String prefijo;
	private String razonSocial;
	private String subdominio;
	private String outNumErr;
	private String outErrMen;
	private String salida;

	/* Auxiliares para WS */
	private String codigoResp;
	private String codigoDesc;
	private String esValido;
	private String dispositivo;
	private String nombreSucurs;
	
	private String EmpresaID;
	private String Usuario;
	private String FechaActual;
	private String DireccionIP;
	private String ProgramaID;
	private long NumTransaccion;
	
	// fecha del sistema, usuada en WS 
	private String fechaSistema;
	
	// Campos para reactivacion de usuarios cancelado
	private String fechaReactiva;
	private String usuarioIDRespon;
	private String nombreUsuarioRespon;
	private String claveUsuarioRespon;
	private String motivoReactiva;
	private String motivoNuevo;
	private String usuarioIDCancel;
	private String usuarioIDReactiva;
	private String esNuevoComenCance;
	
	private String accesoMonitor;
	/*PLD*/
	private String notificacion;
	/*Fin PLD*/
	/*HUELLA*/
	private String rfc;
	private String accederAutorizar;
	private String accedeHuella;
	/*FIN HUELLA*/
	
	private String curp;
	private String direccionCompleta;
	private String folioIdentificacion;
	private String fechaExpedicion;
	private String fechaVencimiento;
	
	private String empleadoID;
	private String imei;
	private String usaAplicacion;
	private String  estatusAnalisis;
	
	private String notificaCierre;
	private String confirmarContra;
	
	
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getClavePuestoID() {
		return clavePuestoID;
	}
	public void setClavePuestoID(String clavePuestoID) {
		this.clavePuestoID = clavePuestoID;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getApPaterno() {
		return apPaterno;
	}
	public void setApPaterno(String apPaterno) {
		this.apPaterno = apPaterno;
	}
	public String getApMaterno() {
		return apMaterno;
	}
	public void setApMaterno(String apMaterno) {
		this.apMaterno = apMaterno;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getEstatusSesion() {
		return estatusSesion;
	}
	public void setEstatusSesion(String estatusSesion) {
		this.estatusSesion = estatusSesion;
	}
	public String getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(String fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public String getFechUltAcces() {
		return fechUltAcces;
	}
	public void setFechUltAcces(String fechUltAcces) {
		this.fechUltAcces = fechUltAcces;
	}
	public String getFechUltPass() {
		return fechUltPass;
	}
	public void setFechUltPass(String fechUltPass) {
		this.fechUltPass = fechUltPass;
	}
	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
	}
	public String getContrasenia() {
		return contrasenia;
	}
	public void setContrasenia(String contrasenia) {
		this.contrasenia = contrasenia;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getRolID() {
		return rolID;
	}
	public void setRolID(String rolID) {
		this.rolID = rolID;
	}
	public String getSucursalUsuario() {
		return sucursalUsuario;
	}
	public void setSucursalUsuario(String sucursalUsuario) {
		this.sucursalUsuario = sucursalUsuario;
	}
	public String getNombreRol() {
		return nombreRol;
	}
	public void setNombreRol(String nombreRol) {
		this.nombreRol = nombreRol;
	}
	public String getIpSesion() {
		return ipSesion;
	}
	public void setIpSesion(String ipSesion) {
		this.ipSesion = ipSesion;
	}
	public String getCorreo() {
		return correo;
	}
	public void setCorreo(String correo) {
		this.correo = correo;
	}
	public int getLoginsFallidos() {
		return loginsFallidos;
	}
	public void setLoginsFallidos(int loginsFallidos) {
		this.loginsFallidos = loginsFallidos;
	}
	public String getMotivoBloqueo() {
		return motivoBloqueo;
	}
	public void setMotivoBloqueo(String motivoBloqueo) {
		this.motivoBloqueo = motivoBloqueo;
	}
	public String getFechaBloqueo() {
		return fechaBloqueo;
	}
	public void setFechaBloqueo(String fechaBloqueo) {
		this.fechaBloqueo = fechaBloqueo;
	}
	public String getMotivoCancel() {
		return motivoCancel;
	}
	public void setMotivoCancel(String motivoCancel) {
		this.motivoCancel = motivoCancel;
	}
	public String getFechaCancel() {
		return fechaCancel;
	}
	public void setFechaCancel(String fechaCancel) {
		this.fechaCancel = fechaCancel;
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
	public String getEmpresaID() {
		return EmpresaID;
	}
	public void setEmpresaID(String empresaID) {
		EmpresaID = empresaID;
	}
	public String getUsuario() {
		return Usuario;
	}
	public void setUsuario(String usuario) {
		Usuario = usuario;
	}
	public String getFechaActual() {
		return FechaActual;
	}
	public void setFechaActual(String fechaActual) {
		FechaActual = fechaActual;
	}
	public String getDireccionIP() {
		return DireccionIP;
	}
	public void setDireccionIP(String direccionIP) {
		DireccionIP = direccionIP;
	}
	public String getProgramaID() {
		return ProgramaID;
	}
	public void setProgramaID(String programaID) {
		ProgramaID = programaID;
	}
	public long getNumTransaccion() {
		return NumTransaccion;
	}
	public void setNumTransaccion(long numTransaccion) {
		NumTransaccion = numTransaccion;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getSalt() {
		return salt;
	}
	public void setSalt(String salt) {
		this.salt = salt;
	}
	public String getDescripGestor() {
		return descripGestor;
	}
	public void setDescripGestor(String descripGestor) {
		this.descripGestor = descripGestor;
	}
	public String getCodigoResp() {
		return codigoResp;
	}
	public String getCodigoDesc() {
		return codigoDesc;
	}
	public String getEsValido() {
		return esValido;
	}
	public void setCodigoResp(String codigoResp) {
		this.codigoResp = codigoResp;
	}
	public void setCodigoDesc(String codigoDesc) {
		this.codigoDesc = codigoDesc;
	}
	public void setEsValido(String esValido) {
		this.esValido = esValido;
	}
	public String getDispositivo() {
		return dispositivo;
	}
	public void setDispositivo(String dispositivo) {
		this.dispositivo = dispositivo;
	}
	public String getEsGestor() {
		return esGestor;
	}
	public void setEsGestor(String esGestor) {
		this.esGestor = esGestor;
	}
	public String getRealizaConsultasCC() {
		return realizaConsultasCC;
	}
	public void setRealizaConsultasCC(String realizaConsultasCC) {
		this.realizaConsultasCC = realizaConsultasCC;
	}
	public String getUsuarioCirculo() {
		return usuarioCirculo;
	}
	public void setUsuarioCirculo(String usuarioCirculo) {
		this.usuarioCirculo = usuarioCirculo;
	}

	public String getContrasenaCirculo() {
		return contrasenaCirculo;
	}
	public void setContrasenaCirculo(String contrasenaCirculo) {
		this.contrasenaCirculo = contrasenaCirculo;
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
	public String getPrefijo() {
		return prefijo;
	}
	public void setPrefijo(String prefijo) {
		this.prefijo = prefijo;
	}

	public String getNombreSucurs() {
		return nombreSucurs;
	}
	public void setNombreSucurs(String nombreSucurs) {
		this.nombreSucurs = nombreSucurs;
	}
	public String getRazonSocial() {
		return razonSocial;
	}
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}
	public String getSubdominio() {
		return subdominio;
	}
	public void setSubdominio(String subdominio) {
		this.subdominio = subdominio;
	}

	public String getFechaReactiva() {
		return fechaReactiva;
	}
	public void setFechaReactiva(String fechaReactiva) {
		this.fechaReactiva = fechaReactiva;
	}
	public String getUsuarioIDRespon() {
		return usuarioIDRespon;
	}
	public void setUsuarioIDRespon(String usuarioIDRespon) {
		this.usuarioIDRespon = usuarioIDRespon;
	}
	public String getNombreUsuarioRespon() {
		return nombreUsuarioRespon;
	}
	public void setNombreUsuarioRespon(String nombreUsuarioRespon) {
		this.nombreUsuarioRespon = nombreUsuarioRespon;
	}
	public String getClaveUsuarioRespon() {
		return claveUsuarioRespon;
	}
	public void setClaveUsuarioRespon(String claveUsuarioRespon) {
		this.claveUsuarioRespon = claveUsuarioRespon;
	}
	public String getMotivoReactiva() {
		return motivoReactiva;
	}
	public void setMotivoReactiva(String motivoReactiva) {
		this.motivoReactiva = motivoReactiva;
	}
	public String getMotivoNuevo() {
		return motivoNuevo;
	}
	public void setMotivoNuevo(String motivoNuevo) {
		this.motivoNuevo = motivoNuevo;
	}
	public String getUsuarioIDCancel() {
		return usuarioIDCancel;
	}
	public void setUsuarioIDCancel(String usuarioIDCancel) {
		this.usuarioIDCancel = usuarioIDCancel;
	}
	public String getUsuarioIDReactiva() {
		return usuarioIDReactiva;
	}
	public void setUsuarioIDReactiva(String usuarioIDReactiva) {
		this.usuarioIDReactiva = usuarioIDReactiva;
	}
	public String getEsNuevoComenCance() {
		return esNuevoComenCance;
	}
	public void setEsNuevoComenCance(String esNuevoComenCance) {
		this.esNuevoComenCance = esNuevoComenCance;
	}
	public String getAccesoMonitor() {
		return accesoMonitor;
	}
	public void setAccesoMonitor(String accesoMonitor) {
		this.accesoMonitor = accesoMonitor;
	}
	public String getNotificacion() {
		return notificacion;
	}
	public void setNotificacion(String notificacion) {
		this.notificacion = notificacion;
	}
	public String getRfc() {
		return rfc;
	}
	public void setRfc(String rfc) {
		this.rfc = rfc;
	}
	public String getAccederAutorizar() {
		return accederAutorizar;
	}
	public void setAccederAutorizar(String accederAutorizar) {
		this.accederAutorizar = accederAutorizar;
	}
	public String getAccedeHuella() {
		return accedeHuella;
	}
	public void setAccedeHuella(String accedeHuella) {
		this.accedeHuella = accedeHuella;
	}
	public String getRealizaConsultasBC() {
		return realizaConsultasBC;
	}
	public void setRealizaConsultasBC(String realizaConsultasBC) {
		this.realizaConsultasBC = realizaConsultasBC;
	}
	public String getUsuarioBuroCredito() {
		return usuarioBuroCredito;
	}
	public void setUsuarioBuroCredito(String usuarioBuroCredito) {
		this.usuarioBuroCredito = usuarioBuroCredito;
	}
	public String getContrasenaBuroCredito() {
		return contrasenaBuroCredito;
	}
	public void setContrasenaBuroCredito(String contrasenaBuroCredito) {
		this.contrasenaBuroCredito = contrasenaBuroCredito;
	}
	public String getCurp() {
		return curp;
	}
	public void setCurp(String curp) {
		this.curp = curp;
	}
	public String getDireccionCompleta() {
		return direccionCompleta;
	}
	public void setDireccionCompleta(String direccionCompleta) {
		this.direccionCompleta = direccionCompleta;
	}
	public String getFolioIdentificacion() {
		return folioIdentificacion;
	}
	public void setFolioIdentificacion(String folioIdentificacion) {
		this.folioIdentificacion = folioIdentificacion;
	}
	public String getFechaExpedicion() {
		return fechaExpedicion;
	}
	public void setFechaExpedicion(String fechaExpedicion) {
		this.fechaExpedicion = fechaExpedicion;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getEmpleadoID() {
		return empleadoID;
	}
	public void setEmpleadoID(String empleadoID) {
		this.empleadoID = empleadoID;
	}
	public String getImei() {
		return imei;
	}
	public void setImei(String imei) {
		this.imei = imei;
	}
	public String getUsaAplicacion() {
		return usaAplicacion;
	}
	public void setUsaAplicacion(String usaAplicacion) {
		this.usaAplicacion = usaAplicacion;
	}
	public String getEstatusAnalisis() {
		return estatusAnalisis;
	}
	public void setEstatusAnalisis(String estatusAnalisis) {
		this.estatusAnalisis = estatusAnalisis;
	}
	public String getNotificaCierre() {
		return notificaCierre;
	}
	public void setNotificaCierre(String notificaCierre) {
		this.notificaCierre = notificaCierre;
	}
	public String getConfirmarContra() {
		return confirmarContra;
	}
	public void setConfirmarContra(String confirmarContra) {
		this.confirmarContra = confirmarContra;
	}
	
	
	
}