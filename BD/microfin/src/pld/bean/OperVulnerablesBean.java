package pld.bean;

import general.bean.BaseBean;

public class OperVulnerablesBean extends BaseBean{
	private String anio;
	private String mes;
	private String rfc;
	private String fechaActual;
	private String nombreCliente;
/*DATOS DEL SP*/
	private String fechaReporto;
	private String claveEntidadColegiada;
	private String claveSujetoObligado;
	private String claveActividad;
	private String exento;
	private String dominioPlataforma;
	private String referenciaAviso;
	private String prioridad;
	private String folioModificacion;
	private String descripcionModificacion;
	private String tipoAlerta;
	private String descripcionAlerta;
	private String clienteID;
	private String cuentaRelacionada;
	private String clabeInterbancaria;
	private String monedaCuenta;
	private String nombrePF;
	private String apellidoPaternoPF;
	private String apellidoMaternoPF;
	private String fechaNacimientoPF;
	private String rFCPF;
	private String cURPPF;
	private String paisNacionalidadPF;
	private String actividadEconomicaPF;
	private String tipoIdentificacionPF;
	private String numeroIdentificacionPF;
	private String denominacionRazonPM;
	private String fechaConstitucionPM;
	private String rFCPM;
	private String paisNacionalidadPM;
	private String giroMercantilPM;
	private String nombreRL;
	private String apellidoPaternoRL;
	private String apellidoMaternoRL;
	private String fechaNacimientoRL;
	private String rFCRL;
	private String cURPRL;
	private String tipoIdentificacionRL;
	private String numeroIdentificacionRL;
	private String denominacionRazonFedi;
	private String rFCFedi;
	private String fideicomisoIDFedi;
	private String nombreApo;
	private String apellidoPaternoApo;
	private String apellidoMaternoApo;
	private String fechaNacimientoApo;
	private String rFCApo;
	private String cURPApo;
	private String tipoIdentificacionApo;
	private String numeroIdentificacionApo;
	private String coloniaN;
	private String calleN;
	private String numeroExteriorN;
	private String numeroInteriorN;
	private String codigoPostalN;
	private String paisE;
	private String estadoProvinciaE;
	private String ciudadPoblacionE;
	private String coloniaE;
	private String calleE;
	private String numeroExteriorE;
	private String numeroInteriorE;
	private String codigoPostalE;
	private String clavePaisPer;
	private String numeroTelefonoPer;
	private String correoElectronicoPer;
	private String nombreDuePF;
	private String apellidoPaternoDuePF;
	private String apellidoMaternoDuePF;
	private String fechaNacimientoDuePF;
	private String rFCDuePF;
	private String cURPDuePF;
	private String paisNacionalidadDuePF;
	private String denominacionRazonDuePM;
	private String fechaConstitucionDuePM;
	private String rFCDuePM;
	private String paisNacionalidadDuePM;
	private String denominacionRazonDueFid;
	private String rFCDueFid;
	private String fideicomisoIDDueFid; 
	//PARTE DOS
	private String fechaHoraOperacionCom;
	private String monedaOperacionCom;
	private String montoOperacionCom;
	private String activoVirtualOperadoAV;
	private String descripcionActivoVirtualAV;
	private String tipoCambioMnAV;
	private String cantidadActivoVirtualAV;
	private String hashOperacionAV;
	private String fechaHoraOperacionV;
	private String monedaOperacionV;
	private String montoOperacionV;
	private String activoVirtualOperadoVAV;
	private String descripcionActivoVirtualVAV;
	private String tipoCambioMnVAV;
	private String cantidadActivoVirtualVAV;
	private String hashOperacionVAV;
	private String fechaHoraOperacionOI;
	private String activoVirtualOperadoOIAV;
	private String descripcionActivoVirtualOIAV;
	private String tipoCambioMnOIAV;
	private String cantidadActivoVirtualOIAV;
	private String montoOperacionMnOIAV;
	private String activoVirtualOperadoOIAR;
	private String descripcionActivoVirtualOIAR;
	private String tipoCambioMnOIAR;
	private String cantidadActivoVirtualOIAR;
	private String montoOperacionMnOIAR;
	private String hashOperacionOIAR;
	private String fechaHoraOperacionOTE;
	private String montoOperacionMnOTE;
	private String activoVirtualOperadoOTAV;
	private String descripcionActivoVirtualOTAV;
	private String tipoCambioMnOTAV;
	private String cantidadActivoVirtualOTAV;
	private String hashOperacionOTAV;
	private String fechaHoraOperacionTR;
	private String montoOperacionMnTR;
	private String activoVirtualOperadoTRA;
	private String descripcionActivoVirtualTRA;
	private String tipoCambioMnTRA;
	private String cantidadActivoVirtualTRA;
	private String hashOperacionTRA;
	private String fechaHoraOperacionFR;
	private String instrumentoMonetarioFR;
	private String monedaOperacionFR;
	private String montoOperacionFR;
	private String nombreFRPF;
	private String apellidoPaternoFRPF;
	private String apellidoMaternoFRPF;
	private String denominacionRazonFRPF;
	private String clabeDestinoFRN;
	private String claveInstitucionFinancieraFRN;
	private String numeroCuentaFRE;
	private String nombreBancoFRE;
	private String fechaHoraOperacionFD;
	private String instrumentoMonetarioFD;
	private String monedaOperacionFD;
	private String montoOperacionFD;
	private String nombreFDPF;
	private String apellidoPaternoFDPF;
	private String apellidoMaternoFDPF;
	private String denominacionRazonFDPM;
	private String clabeDestinoFDN;
	private String claveInstitucionFinancieraFDN;
	private String numeroCuentaFDE;
	private String nombreBancoFDE;
	private String clienteInstitucion;
	private String rutaArchivo;
	
	
	
	public String getAnio() {
		return anio;
	}
	public void setAnio(String anio) {
		this.anio = anio;
	}
	public String getMes() {
		return mes;
	}
	public void setMes(String mes) {
		this.mes = mes;
	}
	public String getRfc() {
		return rfc;
	}
	public void setRfc(String rfc) {
		this.rfc = rfc;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getFechaReporto() {
		return fechaReporto;
	}
	public void setFechaReporto(String fechaReporto) {
		this.fechaReporto = fechaReporto;
	}
	public String getClaveEntidadColegiada() {
		return claveEntidadColegiada;
	}
	public void setClaveEntidadColegiada(String claveEntidadColegiada) {
		this.claveEntidadColegiada = claveEntidadColegiada;
	}
	public String getClaveSujetoObligado() {
		return claveSujetoObligado;
	}
	public void setClaveSujetoObligado(String claveSujetoObligado) {
		this.claveSujetoObligado = claveSujetoObligado;
	}
	public String getClaveActividad() {
		return claveActividad;
	}
	public void setClaveActividad(String claveActividad) {
		this.claveActividad = claveActividad;
	}
	public String getExento() {
		return exento;
	}
	public void setExento(String exento) {
		this.exento = exento;
	}
	public String getDominioPlataforma() {
		return dominioPlataforma;
	}
	public void setDominioPlataforma(String dominioPlataforma) {
		this.dominioPlataforma = dominioPlataforma;
	}
	public String getReferenciaAviso() {
		return referenciaAviso;
	}
	public void setReferenciaAviso(String referenciaAviso) {
		this.referenciaAviso = referenciaAviso;
	}
	public String getPrioridad() {
		return prioridad;
	}
	public void setPrioridad(String prioridad) {
		this.prioridad = prioridad;
	}
	public String getFolioModificacion() {
		return folioModificacion;
	}
	public void setFolioModificacion(String folioModificacion) {
		this.folioModificacion = folioModificacion;
	}
	public String getDescripcionModificacion() {
		return descripcionModificacion;
	}
	public void setDescripcionModificacion(String descripcionModificacion) {
		this.descripcionModificacion = descripcionModificacion;
	}
	public String getTipoAlerta() {
		return tipoAlerta;
	}
	public void setTipoAlerta(String tipoAlerta) {
		this.tipoAlerta = tipoAlerta;
	}
	public String getDescripcionAlerta() {
		return descripcionAlerta;
	}
	public void setDescripcionAlerta(String descripcionAlerta) {
		this.descripcionAlerta = descripcionAlerta;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentaRelacionada() {
		return cuentaRelacionada;
	}
	public void setCuentaRelacionada(String cuentaRelacionada) {
		this.cuentaRelacionada = cuentaRelacionada;
	}
	public String getClabeInterbancaria() {
		return clabeInterbancaria;
	}
	public void setClabeInterbancaria(String clabeInterbancaria) {
		this.clabeInterbancaria = clabeInterbancaria;
	}
	public String getMonedaCuenta() {
		return monedaCuenta;
	}
	public void setMonedaCuenta(String monedaCuenta) {
		this.monedaCuenta = monedaCuenta;
	}
	public String getNombrePF() {
		return nombrePF;
	}
	public void setNombrePF(String nombrePF) {
		this.nombrePF = nombrePF;
	}
	public String getApellidoPaternoPF() {
		return apellidoPaternoPF;
	}
	public void setApellidoPaternoPF(String apellidoPaternoPF) {
		this.apellidoPaternoPF = apellidoPaternoPF;
	}
	
	public String getApellidoMaternoPF() {
		return apellidoMaternoPF;
	}
	public void setApellidoMaternoPF(String apellidoMaternoPF) {
		this.apellidoMaternoPF = apellidoMaternoPF;
	}
	public String getFechaNacimientoPF() {
		return fechaNacimientoPF;
	}
	public void setFechaNacimientoPF(String fechaNacimientoPF) {
		this.fechaNacimientoPF = fechaNacimientoPF;
	}
	public String getrFCPF() {
		return rFCPF;
	}
	public void setrFCPF(String rFCPF) {
		this.rFCPF = rFCPF;
	}
	public String getcURPPF() {
		return cURPPF;
	}
	public void setcURPPF(String cURPPF) {
		this.cURPPF = cURPPF;
	}
	public String getPaisNacionalidadPF() {
		return paisNacionalidadPF;
	}
	public void setPaisNacionalidadPF(String paisNacionalidadPF) {
		this.paisNacionalidadPF = paisNacionalidadPF;
	}
	public String getActividadEconomicaPF() {
		return actividadEconomicaPF;
	}
	public void setActividadEconomicaPF(String actividadEconomicaPF) {
		this.actividadEconomicaPF = actividadEconomicaPF;
	}
	public String getTipoIdentificacionPF() {
		return tipoIdentificacionPF;
	}
	public void setTipoIdentificacionPF(String tipoIdentificacionPF) {
		this.tipoIdentificacionPF = tipoIdentificacionPF;
	}
	public String getNumeroIdentificacionPF() {
		return numeroIdentificacionPF;
	}
	public void setNumeroIdentificacionPF(String numeroIdentificacionPF) {
		this.numeroIdentificacionPF = numeroIdentificacionPF;
	}
	public String getDenominacionRazonPM() {
		return denominacionRazonPM;
	}
	public void setDenominacionRazonPM(String denominacionRazonPM) {
		this.denominacionRazonPM = denominacionRazonPM;
	}
	public String getFechaConstitucionPM() {
		return fechaConstitucionPM;
	}
	public void setFechaConstitucionPM(String fechaConstitucionPM) {
		this.fechaConstitucionPM = fechaConstitucionPM;
	}
	public String getrFCPM() {
		return rFCPM;
	}
	public void setrFCPM(String rFCPM) {
		this.rFCPM = rFCPM;
	}
	public String getPaisNacionalidadPM() {
		return paisNacionalidadPM;
	}
	public void setPaisNacionalidadPM(String paisNacionalidadPM) {
		this.paisNacionalidadPM = paisNacionalidadPM;
	}
	public String getGiroMercantilPM() {
		return giroMercantilPM;
	}
	public void setGiroMercantilPM(String giroMercantilPM) {
		this.giroMercantilPM = giroMercantilPM;
	}
	public String getNombreRL() {
		return nombreRL;
	}
	public void setNombreRL(String nombreRL) {
		this.nombreRL = nombreRL;
	}
	public String getApellidoPaternoRL() {
		return apellidoPaternoRL;
	}
	public void setApellidoPaternoRL(String apellidoPaternoRL) {
		this.apellidoPaternoRL = apellidoPaternoRL;
	}
	public String getApellidoMaternoRL() {
		return apellidoMaternoRL;
	}
	public void setApellidoMaternoRL(String apellidoMaternoRL) {
		this.apellidoMaternoRL = apellidoMaternoRL;
	}
	public String getFechaNacimientoRL() {
		return fechaNacimientoRL;
	}
	public void setFechaNacimientoRL(String fechaNacimientoRL) {
		this.fechaNacimientoRL = fechaNacimientoRL;
	}
	public String getrFCRL() {
		return rFCRL;
	}
	public void setrFCRL(String rFCRL) {
		this.rFCRL = rFCRL;
	}
	public String getcURPRL() {
		return cURPRL;
	}
	public void setcURPRL(String cURPRL) {
		this.cURPRL = cURPRL;
	}
	public String getTipoIdentificacionRL() {
		return tipoIdentificacionRL;
	}
	public void setTipoIdentificacionRL(String tipoIdentificacionRL) {
		this.tipoIdentificacionRL = tipoIdentificacionRL;
	}
	public String getNumeroIdentificacionRL() {
		return numeroIdentificacionRL;
	}
	public void setNumeroIdentificacionRL(String numeroIdentificacionRL) {
		this.numeroIdentificacionRL = numeroIdentificacionRL;
	}
	public String getDenominacionRazonFedi() {
		return denominacionRazonFedi;
	}
	public void setDenominacionRazonFedi(String denominacionRazonFedi) {
		this.denominacionRazonFedi = denominacionRazonFedi;
	}
	public String getrFCFedi() {
		return rFCFedi;
	}
	public void setrFCFedi(String rFCFedi) {
		this.rFCFedi = rFCFedi;
	}
	public String getFideicomisoIDFedi() {
		return fideicomisoIDFedi;
	}
	public void setFideicomisoIDFedi(String fideicomisoIDFedi) {
		this.fideicomisoIDFedi = fideicomisoIDFedi;
	}
	public String getNombreApo() {
		return nombreApo;
	}
	public void setNombreApo(String nombreApo) {
		this.nombreApo = nombreApo;
	}
	public String getApellidoPaternoApo() {
		return apellidoPaternoApo;
	}
	public void setApellidoPaternoApo(String apellidoPaternoApo) {
		this.apellidoPaternoApo = apellidoPaternoApo;
	}
	public String getApellidoMaternoApo() {
		return apellidoMaternoApo;
	}
	public void setApellidoMaternoApo(String apellidoMaternoApo) {
		this.apellidoMaternoApo = apellidoMaternoApo;
	}
	public String getFechaNacimientoApo() {
		return fechaNacimientoApo;
	}
	public void setFechaNacimientoApo(String fechaNacimientoApo) {
		this.fechaNacimientoApo = fechaNacimientoApo;
	}
	public String getrFCApo() {
		return rFCApo;
	}
	public void setrFCApo(String rFCApo) {
		this.rFCApo = rFCApo;
	}
	public String getcURPApo() {
		return cURPApo;
	}
	public void setcURPApo(String cURPApo) {
		this.cURPApo = cURPApo;
	}
	public String getTipoIdentificacionApo() {
		return tipoIdentificacionApo;
	}
	public void setTipoIdentificacionApo(String tipoIdentificacionApo) {
		this.tipoIdentificacionApo = tipoIdentificacionApo;
	}
	public String getNumeroIdentificacionApo() {
		return numeroIdentificacionApo;
	}
	public void setNumeroIdentificacionApo(String numeroIdentificacionApo) {
		this.numeroIdentificacionApo = numeroIdentificacionApo;
	}
	public String getColoniaN() {
		return coloniaN;
	}
	public void setColoniaN(String coloniaN) {
		this.coloniaN = coloniaN;
	}
	public String getCalleN() {
		return calleN;
	}
	public void setCalleN(String calleN) {
		this.calleN = calleN;
	}
	public String getNumeroExteriorN() {
		return numeroExteriorN;
	}
	public void setNumeroExteriorN(String numeroExteriorN) {
		this.numeroExteriorN = numeroExteriorN;
	}
	public String getNumeroInteriorN() {
		return numeroInteriorN;
	}
	public void setNumeroInteriorN(String numeroInteriorN) {
		this.numeroInteriorN = numeroInteriorN;
	}
	public String getCodigoPostalN() {
		return codigoPostalN;
	}
	public void setCodigoPostalN(String codigoPostalN) {
		this.codigoPostalN = codigoPostalN;
	}
	public String getPaisE() {
		return paisE;
	}
	public void setPaisE(String paisE) {
		this.paisE = paisE;
	}
	public String getEstadoProvinciaE() {
		return estadoProvinciaE;
	}
	public void setEstadoProvinciaE(String estadoProvinciaE) {
		this.estadoProvinciaE = estadoProvinciaE;
	}
	public String getCiudadPoblacionE() {
		return ciudadPoblacionE;
	}
	public void setCiudadPoblacionE(String ciudadPoblacionE) {
		this.ciudadPoblacionE = ciudadPoblacionE;
	}
	public String getColoniaE() {
		return coloniaE;
	}
	public void setColoniaE(String coloniaE) {
		this.coloniaE = coloniaE;
	}
	public String getCalleE() {
		return calleE;
	}
	public void setCalleE(String calleE) {
		this.calleE = calleE;
	}
	public String getNumeroExteriorE() {
		return numeroExteriorE;
	}
	public void setNumeroExteriorE(String numeroExteriorE) {
		this.numeroExteriorE = numeroExteriorE;
	}
	public String getNumeroInteriorE() {
		return numeroInteriorE;
	}
	public void setNumeroInteriorE(String numeroInteriorE) {
		this.numeroInteriorE = numeroInteriorE;
	}
	public String getCodigoPostalE() {
		return codigoPostalE;
	}
	public void setCodigoPostalE(String codigoPostalE) {
		this.codigoPostalE = codigoPostalE;
	}
	public String getClavePaisPer() {
		return clavePaisPer;
	}
	public void setClavePaisPer(String clavePaisPer) {
		this.clavePaisPer = clavePaisPer;
	}
	public String getNumeroTelefonoPer() {
		return numeroTelefonoPer;
	}
	public void setNumeroTelefonoPer(String numeroTelefonoPer) {
		this.numeroTelefonoPer = numeroTelefonoPer;
	}
	public String getCorreoElectronicoPer() {
		return correoElectronicoPer;
	}
	public void setCorreoElectronicoPer(String correoElectronicoPer) {
		this.correoElectronicoPer = correoElectronicoPer;
	}
	public String getNombreDuePF() {
		return nombreDuePF;
	}
	public void setNombreDuePF(String nombreDuePF) {
		this.nombreDuePF = nombreDuePF;
	}
	public String getApellidoPaternoDuePF() {
		return apellidoPaternoDuePF;
	}
	public void setApellidoPaternoDuePF(String apellidoPaternoDuePF) {
		this.apellidoPaternoDuePF = apellidoPaternoDuePF;
	}
	public String getApellidoMaternoDuePF() {
		return apellidoMaternoDuePF;
	}
	public void setApellidoMaternoDuePF(String apellidoMaternoDuePF) {
		this.apellidoMaternoDuePF = apellidoMaternoDuePF;
	}
	public String getFechaNacimientoDuePF() {
		return fechaNacimientoDuePF;
	}
	public void setFechaNacimientoDuePF(String fechaNacimientoDuePF) {
		this.fechaNacimientoDuePF = fechaNacimientoDuePF;
	}
	public String getrFCDuePF() {
		return rFCDuePF;
	}
	public void setrFCDuePF(String rFCDuePF) {
		this.rFCDuePF = rFCDuePF;
	}
	public String getcURPDuePF() {
		return cURPDuePF;
	}
	public void setcURPDuePF(String cURPDuePF) {
		this.cURPDuePF = cURPDuePF;
	}
	public String getPaisNacionalidadDuePF() {
		return paisNacionalidadDuePF;
	}
	public void setPaisNacionalidadDuePF(String paisNacionalidadDuePF) {
		this.paisNacionalidadDuePF = paisNacionalidadDuePF;
	}
	public String getDenominacionRazonDuePM() {
		return denominacionRazonDuePM;
	}
	public void setDenominacionRazonDuePM(String denominacionRazonDuePM) {
		this.denominacionRazonDuePM = denominacionRazonDuePM;
	}
	public String getFechaConstitucionDuePM() {
		return fechaConstitucionDuePM;
	}
	public void setFechaConstitucionDuePM(String fechaConstitucionDuePM) {
		this.fechaConstitucionDuePM = fechaConstitucionDuePM;
	}
	public String getrFCDuePM() {
		return rFCDuePM;
	}
	public void setrFCDuePM(String rFCDuePM) {
		this.rFCDuePM = rFCDuePM;
	}
	public String getPaisNacionalidadDuePM() {
		return paisNacionalidadDuePM;
	}
	public void setPaisNacionalidadDuePM(String paisNacionalidadDuePM) {
		this.paisNacionalidadDuePM = paisNacionalidadDuePM;
	}
	public String getDenominacionRazonDueFid() {
		return denominacionRazonDueFid;
	}
	public void setDenominacionRazonDueFid(String denominacionRazonDueFid) {
		this.denominacionRazonDueFid = denominacionRazonDueFid;
	}
	public String getrFCDueFid() {
		return rFCDueFid;
	}
	public void setrFCDueFid(String rFCDueFid) {
		this.rFCDueFid = rFCDueFid;
	}
	public String getFideicomisoIDDueFid() {
		return fideicomisoIDDueFid;
	}
	public void setFideicomisoIDDueFid(String fideicomisoIDDueFid) {
		this.fideicomisoIDDueFid = fideicomisoIDDueFid;
	}
	public String getFechaHoraOperacionCom() {
		return fechaHoraOperacionCom;
	}
	public void setFechaHoraOperacionCom(String fechaHoraOperacionCom) {
		this.fechaHoraOperacionCom = fechaHoraOperacionCom;
	}
	public String getMonedaOperacionCom() {
		return monedaOperacionCom;
	}
	public void setMonedaOperacionCom(String monedaOperacionCom) {
		this.monedaOperacionCom = monedaOperacionCom;
	}
	public String getMontoOperacionCom() {
		return montoOperacionCom;
	}
	public void setMontoOperacionCom(String montoOperacionCom) {
		this.montoOperacionCom = montoOperacionCom;
	}
	public String getActivoVirtualOperadoAV() {
		return activoVirtualOperadoAV;
	}
	public void setActivoVirtualOperadoAV(String activoVirtualOperadoAV) {
		this.activoVirtualOperadoAV = activoVirtualOperadoAV;
	}
	public String getDescripcionActivoVirtualAV() {
		return descripcionActivoVirtualAV;
	}
	public void setDescripcionActivoVirtualAV(String descripcionActivoVirtualAV) {
		this.descripcionActivoVirtualAV = descripcionActivoVirtualAV;
	}
	public String getTipoCambioMnAV() {
		return tipoCambioMnAV;
	}
	public void setTipoCambioMnAV(String tipoCambioMnAV) {
		this.tipoCambioMnAV = tipoCambioMnAV;
	}
	public String getCantidadActivoVirtualAV() {
		return cantidadActivoVirtualAV;
	}
	public void setCantidadActivoVirtualAV(String cantidadActivoVirtualAV) {
		this.cantidadActivoVirtualAV = cantidadActivoVirtualAV;
	}
	public String getHashOperacionAV() {
		return hashOperacionAV;
	}
	public void setHashOperacionAV(String hashOperacionAV) {
		this.hashOperacionAV = hashOperacionAV;
	}
	public String getFechaHoraOperacionV() {
		return fechaHoraOperacionV;
	}
	public void setFechaHoraOperacionV(String fechaHoraOperacionV) {
		this.fechaHoraOperacionV = fechaHoraOperacionV;
	}
	public String getMonedaOperacionV() {
		return monedaOperacionV;
	}
	public void setMonedaOperacionV(String monedaOperacionV) {
		this.monedaOperacionV = monedaOperacionV;
	}
	public String getMontoOperacionV() {
		return montoOperacionV;
	}
	public void setMontoOperacionV(String montoOperacionV) {
		this.montoOperacionV = montoOperacionV;
	}
	public String getActivoVirtualOperadoVAV() {
		return activoVirtualOperadoVAV;
	}
	public void setActivoVirtualOperadoVAV(String activoVirtualOperadoVAV) {
		this.activoVirtualOperadoVAV = activoVirtualOperadoVAV;
	}
	public String getDescripcionActivoVirtualVAV() {
		return descripcionActivoVirtualVAV;
	}
	public void setDescripcionActivoVirtualVAV(String descripcionActivoVirtualVAV) {
		this.descripcionActivoVirtualVAV = descripcionActivoVirtualVAV;
	}
	public String getTipoCambioMnVAV() {
		return tipoCambioMnVAV;
	}
	public void setTipoCambioMnVAV(String tipoCambioMnVAV) {
		this.tipoCambioMnVAV = tipoCambioMnVAV;
	}
	public String getCantidadActivoVirtualVAV() {
		return cantidadActivoVirtualVAV;
	}
	public void setCantidadActivoVirtualVAV(String cantidadActivoVirtualVAV) {
		this.cantidadActivoVirtualVAV = cantidadActivoVirtualVAV;
	}
	public String getHashOperacionVAV() {
		return hashOperacionVAV;
	}
	public void setHashOperacionVAV(String hashOperacionVAV) {
		this.hashOperacionVAV = hashOperacionVAV;
	}
	public String getFechaHoraOperacionOI() {
		return fechaHoraOperacionOI;
	}
	public void setFechaHoraOperacionOI(String fechaHoraOperacionOI) {
		this.fechaHoraOperacionOI = fechaHoraOperacionOI;
	}
	public String getActivoVirtualOperadoOIAV() {
		return activoVirtualOperadoOIAV;
	}
	public void setActivoVirtualOperadoOIAV(String activoVirtualOperadoOIAV) {
		this.activoVirtualOperadoOIAV = activoVirtualOperadoOIAV;
	}
	public String getDescripcionActivoVirtualOIAV() {
		return descripcionActivoVirtualOIAV;
	}
	public void setDescripcionActivoVirtualOIAV(String descripcionActivoVirtualOIAV) {
		this.descripcionActivoVirtualOIAV = descripcionActivoVirtualOIAV;
	}
	public String getTipoCambioMnOIAV() {
		return tipoCambioMnOIAV;
	}
	public void setTipoCambioMnOIAV(String tipoCambioMnOIAV) {
		this.tipoCambioMnOIAV = tipoCambioMnOIAV;
	}
	public String getCantidadActivoVirtualOIAV() {
		return cantidadActivoVirtualOIAV;
	}
	public void setCantidadActivoVirtualOIAV(String cantidadActivoVirtualOIAV) {
		this.cantidadActivoVirtualOIAV = cantidadActivoVirtualOIAV;
	}
	public String getMontoOperacionMnOIAV() {
		return montoOperacionMnOIAV;
	}
	public void setMontoOperacionMnOIAV(String montoOperacionMnOIAV) {
		this.montoOperacionMnOIAV = montoOperacionMnOIAV;
	}
	public String getActivoVirtualOperadoOIAR() {
		return activoVirtualOperadoOIAR;
	}
	public void setActivoVirtualOperadoOIAR(String activoVirtualOperadoOIAR) {
		this.activoVirtualOperadoOIAR = activoVirtualOperadoOIAR;
	}
	public String getDescripcionActivoVirtualOIAR() {
		return descripcionActivoVirtualOIAR;
	}
	public void setDescripcionActivoVirtualOIAR(String descripcionActivoVirtualOIAR) {
		this.descripcionActivoVirtualOIAR = descripcionActivoVirtualOIAR;
	}
	public String getTipoCambioMnOIAR() {
		return tipoCambioMnOIAR;
	}
	public void setTipoCambioMnOIAR(String tipoCambioMnOIAR) {
		this.tipoCambioMnOIAR = tipoCambioMnOIAR;
	}
	public String getCantidadActivoVirtualOIAR() {
		return cantidadActivoVirtualOIAR;
	}
	public void setCantidadActivoVirtualOIAR(String cantidadActivoVirtualOIAR) {
		this.cantidadActivoVirtualOIAR = cantidadActivoVirtualOIAR;
	}
	public String getMontoOperacionMnOIAR() {
		return montoOperacionMnOIAR;
	}
	public void setMontoOperacionMnOIAR(String montoOperacionMnOIAR) {
		this.montoOperacionMnOIAR = montoOperacionMnOIAR;
	}
	public String getHashOperacionOIAR() {
		return hashOperacionOIAR;
	}
	public void setHashOperacionOIAR(String hashOperacionOIAR) {
		this.hashOperacionOIAR = hashOperacionOIAR;
	}
	public String getFechaHoraOperacionOTE() {
		return fechaHoraOperacionOTE;
	}
	public void setFechaHoraOperacionOTE(String fechaHoraOperacionOTE) {
		this.fechaHoraOperacionOTE = fechaHoraOperacionOTE;
	}
	public String getMontoOperacionMnOTE() {
		return montoOperacionMnOTE;
	}
	public void setMontoOperacionMnOTE(String montoOperacionMnOTE) {
		this.montoOperacionMnOTE = montoOperacionMnOTE;
	}
	public String getActivoVirtualOperadoOTAV() {
		return activoVirtualOperadoOTAV;
	}
	public void setActivoVirtualOperadoOTAV(String activoVirtualOperadoOTAV) {
		this.activoVirtualOperadoOTAV = activoVirtualOperadoOTAV;
	}
	public String getDescripcionActivoVirtualOTAV() {
		return descripcionActivoVirtualOTAV;
	}
	public void setDescripcionActivoVirtualOTAV(String descripcionActivoVirtualOTAV) {
		this.descripcionActivoVirtualOTAV = descripcionActivoVirtualOTAV;
	}
	public String getTipoCambioMnOTAV() {
		return tipoCambioMnOTAV;
	}
	public void setTipoCambioMnOTAV(String tipoCambioMnOTAV) {
		this.tipoCambioMnOTAV = tipoCambioMnOTAV;
	}
	public String getCantidadActivoVirtualOTAV() {
		return cantidadActivoVirtualOTAV;
	}
	public void setCantidadActivoVirtualOTAV(String cantidadActivoVirtualOTAV) {
		this.cantidadActivoVirtualOTAV = cantidadActivoVirtualOTAV;
	}
	public String getHashOperacionOTAV() {
		return hashOperacionOTAV;
	}
	public void setHashOperacionOTAV(String hashOperacionOTAV) {
		this.hashOperacionOTAV = hashOperacionOTAV;
	}
	public String getFechaHoraOperacionTR() {
		return fechaHoraOperacionTR;
	}
	public void setFechaHoraOperacionTR(String fechaHoraOperacionTR) {
		this.fechaHoraOperacionTR = fechaHoraOperacionTR;
	}
	public String getMontoOperacionMnTR() {
		return montoOperacionMnTR;
	}
	public void setMontoOperacionMnTR(String montoOperacionMnTR) {
		this.montoOperacionMnTR = montoOperacionMnTR;
	}
	public String getActivoVirtualOperadoTRA() {
		return activoVirtualOperadoTRA;
	}
	public void setActivoVirtualOperadoTRA(String activoVirtualOperadoTRA) {
		this.activoVirtualOperadoTRA = activoVirtualOperadoTRA;
	}
	public String getDescripcionActivoVirtualTRA() {
		return descripcionActivoVirtualTRA;
	}
	public void setDescripcionActivoVirtualTRA(String descripcionActivoVirtualTRA) {
		this.descripcionActivoVirtualTRA = descripcionActivoVirtualTRA;
	}
	public String getTipoCambioMnTRA() {
		return tipoCambioMnTRA;
	}
	public void setTipoCambioMnTRA(String tipoCambioMnTRA) {
		this.tipoCambioMnTRA = tipoCambioMnTRA;
	}
	public String getCantidadActivoVirtualTRA() {
		return cantidadActivoVirtualTRA;
	}
	public void setCantidadActivoVirtualTRA(String cantidadActivoVirtualTRA) {
		this.cantidadActivoVirtualTRA = cantidadActivoVirtualTRA;
	}
	public String getHashOperacionTRA() {
		return hashOperacionTRA;
	}
	public void setHashOperacionTRA(String hashOperacionTRA) {
		this.hashOperacionTRA = hashOperacionTRA;
	}
	public String getFechaHoraOperacionFR() {
		return fechaHoraOperacionFR;
	}
	public void setFechaHoraOperacionFR(String fechaHoraOperacionFR) {
		this.fechaHoraOperacionFR = fechaHoraOperacionFR;
	}
	public String getInstrumentoMonetarioFR() {
		return instrumentoMonetarioFR;
	}
	public void setInstrumentoMonetarioFR(String instrumentoMonetarioFR) {
		this.instrumentoMonetarioFR = instrumentoMonetarioFR;
	}
	public String getMonedaOperacionFR() {
		return monedaOperacionFR;
	}
	public void setMonedaOperacionFR(String monedaOperacionFR) {
		this.monedaOperacionFR = monedaOperacionFR;
	}
	public String getMontoOperacionFR() {
		return montoOperacionFR;
	}
	public void setMontoOperacionFR(String montoOperacionFR) {
		this.montoOperacionFR = montoOperacionFR;
	}
	public String getNombreFRPF() {
		return nombreFRPF;
	}
	public void setNombreFRPF(String nombreFRPF) {
		this.nombreFRPF = nombreFRPF;
	}
	public String getApellidoPaternoFRPF() {
		return apellidoPaternoFRPF;
	}
	public void setApellidoPaternoFRPF(String apellidoPaternoFRPF) {
		this.apellidoPaternoFRPF = apellidoPaternoFRPF;
	}
	public String getApellidoMaternoFRPF() {
		return apellidoMaternoFRPF;
	}
	public void setApellidoMaternoFRPF(String apellidoMaternoFRPF) {
		this.apellidoMaternoFRPF = apellidoMaternoFRPF;
	}
	public String getDenominacionRazonFRPF() {
		return denominacionRazonFRPF;
	}
	public void setDenominacionRazonFRPF(String denominacionRazonFRPF) {
		this.denominacionRazonFRPF = denominacionRazonFRPF;
	}
	public String getClabeDestinoFRN() {
		return clabeDestinoFRN;
	}
	public void setClabeDestinoFRN(String clabeDestinoFRN) {
		this.clabeDestinoFRN = clabeDestinoFRN;
	}
	public String getClaveInstitucionFinancieraFRN() {
		return claveInstitucionFinancieraFRN;
	}
	public void setClaveInstitucionFinancieraFRN(
			String claveInstitucionFinancieraFRN) {
		this.claveInstitucionFinancieraFRN = claveInstitucionFinancieraFRN;
	}
	public String getNumeroCuentaFRE() {
		return numeroCuentaFRE;
	}
	public void setNumeroCuentaFRE(String numeroCuentaFRE) {
		this.numeroCuentaFRE = numeroCuentaFRE;
	}
	public String getNombreBancoFRE() {
		return nombreBancoFRE;
	}
	public void setNombreBancoFRE(String nombreBancoFRE) {
		this.nombreBancoFRE = nombreBancoFRE;
	}
	public String getFechaHoraOperacionFD() {
		return fechaHoraOperacionFD;
	}
	public void setFechaHoraOperacionFD(String fechaHoraOperacionFD) {
		this.fechaHoraOperacionFD = fechaHoraOperacionFD;
	}
	public String getInstrumentoMonetarioFD() {
		return instrumentoMonetarioFD;
	}
	public void setInstrumentoMonetarioFD(String instrumentoMonetarioFD) {
		this.instrumentoMonetarioFD = instrumentoMonetarioFD;
	}
	public String getMonedaOperacionFD() {
		return monedaOperacionFD;
	}
	public void setMonedaOperacionFD(String monedaOperacionFD) {
		this.monedaOperacionFD = monedaOperacionFD;
	}
	public String getMontoOperacionFD() {
		return montoOperacionFD;
	}
	public void setMontoOperacionFD(String montoOperacionFD) {
		this.montoOperacionFD = montoOperacionFD;
	}
	public String getNombreFDPF() {
		return nombreFDPF;
	}
	public void setNombreFDPF(String nombreFDPF) {
		this.nombreFDPF = nombreFDPF;
	}
	public String getApellidoPaternoFDPF() {
		return apellidoPaternoFDPF;
	}
	public void setApellidoPaternoFDPF(String apellidoPaternoFDPF) {
		this.apellidoPaternoFDPF = apellidoPaternoFDPF;
	}
	public String getApellidoMaternoFDPF() {
		return apellidoMaternoFDPF;
	}
	public void setApellidoMaternoFDPF(String apellidoMaternoFDPF) {
		this.apellidoMaternoFDPF = apellidoMaternoFDPF;
	}
	public String getDenominacionRazonFDPM() {
		return denominacionRazonFDPM;
	}
	public void setDenominacionRazonFDPM(String denominacionRazonFDPM) {
		this.denominacionRazonFDPM = denominacionRazonFDPM;
	}
	public String getClabeDestinoFDN() {
		return clabeDestinoFDN;
	}
	public void setClabeDestinoFDN(String clabeDestinoFDN) {
		this.clabeDestinoFDN = clabeDestinoFDN;
	}
	public String getClaveInstitucionFinancieraFDN() {
		return claveInstitucionFinancieraFDN;
	}
	public void setClaveInstitucionFinancieraFDN(
			String claveInstitucionFinancieraFDN) {
		this.claveInstitucionFinancieraFDN = claveInstitucionFinancieraFDN;
	}
	public String getNumeroCuentaFDE() {
		return numeroCuentaFDE;
	}
	public void setNumeroCuentaFDE(String numeroCuentaFDE) {
		this.numeroCuentaFDE = numeroCuentaFDE;
	}
	public String getNombreBancoFDE() {
		return nombreBancoFDE;
	}
	public void setNombreBancoFDE(String nombreBancoFDE) {
		this.nombreBancoFDE = nombreBancoFDE;
	}
	public String getClienteInstitucion() {
		return clienteInstitucion;
	}
	public void setClienteInstitucion(String clienteInstitucion) {
		this.clienteInstitucion = clienteInstitucion;
	}
	public String getRutaArchivo() {
		return rutaArchivo;
	}
	public void setRutaArchivo(String rutaArchivo) {
		this.rutaArchivo = rutaArchivo;
	}
	
}
