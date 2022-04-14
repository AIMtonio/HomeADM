package pld.bean;

import general.bean.BaseBean;

public class IdentidadClienteBean extends BaseBean{
	private String clienteID;
	private String aplicaCuest;
	private String otroAplDetalle;
	private String realizadoOp;
	private String fuenteRecursos;
	private String fuenteOtraDet;	
	private String observacionesEjec;
	
	// parametros de Personas Fisicas con Actividad Empresarial
	private String negocioPersona;
	private String tipoNegocio;
	private String tipoOtroNegocio;
	private String giroNegocio;
	private String aniosAntig;
	private String mesesAntig;
	private String ubicacNegocio;
	private String esNegocioPropio;
	private String especificarNegocio;
	private String tipoProducto;
	private String mercadoDeProducto;
	private String ingresosMensuales;
	private String dependientesEcon;
	private String dependienteHijo;
	private String dependienteOtro;
	private String tipoNuevoNegocio;
	private String tipoOtroNuevoNegocio;
	private String tipoProdTipoNeg;
	private String mercadoDeProdTipoNeg;
	private String ingresosMensTipoNeg;
	private String dependientesEconTipoNeg;
	private String dependienteHijoTipoNeg;
	private String dependienteOtroTipoNeg;
	
	//Parametros de Personas Sin Actividad Empresarial
	private String fteNuevosIngresos;
	private String tiempoNuevoNeg;
	private String parentescoApert;
	private String parentesOtroDet;
	private String tiempoEnvio;
	private String cuantoEnvio;
	private String trabajoActual;
	private String lugarTrabajoAct;
	private String cargoTrabajo;
	private String periodoDePago;
	private String montoPeriodoPago;
	private String tiempoLaborado;
	private String dependientesEconSA;
	private String dependienteHijoSA;
	private String dependienteOtroSA;
	
	//Parametros de Proveedores de Recursos
	private String proveedRecursos;
	private String tipoProvRecursos;
	private String nombreCompProv;
	private String domicilioProv;
	private String fechaNacProv;
	private String nacionalidProv;
	private String rfcProv;
	private String razonSocialProvB;
	private String nacionalidProvB;
	private String rfcProvB;
	private String domicilioProvB;
	
	//Parametros de Propietario Real
	private String propietarioDinero;
	private String propietarioOtroDet;
	private String propietarioNombreCom;
	private String propietarioDomici; 
	private String propietarioNacio;
	private String propietarioCurp;
	private String propietarioRfc;
	private String propietarioGener;
	private String propietarioOcupac;
	private String propietarioFecha;
	private String propietarioLugarNac;
	private String propietarioEntid;
	private String propietarioPais;
	
	//Parametros de Personas Politicamente Expuestas 
	private String cargoPubPEP;
	private String cargoPubPEPDet;
	private String nivelCargoPEP;
	private String periodo1PEP;
	private String periodo2PEP;
	private String ingresosMenPEP;
	private String famEnCargoPEP;
	private String parentescoPEP;
	private String nombreCompletoPEP;
	private String parentescoPEPDet;
	private String relacionPEP;
	private String nombreRelacionPEP;
	private String cargoPubPEPDetFam;
	private String nivelCargoPEPFam;
	private String periodo1PEPFam;
	private String periodo2PEPFam;
	private String parentescoPEPFam;
	private String nombreCtoPEPFam;
	
	//Parametros de Otros Servicios
	private String ingresoAdici;
	private String fuenteIngreOS;
	private String UbicFteIngreOS;
	private String esPropioFteIng;
	private String esPropioFteDet;
	private String ingMensualesOS;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getAplicaCuest() {
		return aplicaCuest;
	}
	public void setAplicaCuest(String aplicaCuest) {
		this.aplicaCuest = aplicaCuest;
	}
	public String getOtroAplDetalle() {
		return otroAplDetalle;
	}
	public void setOtroAplDetalle(String otroAplDetalle) {
		this.otroAplDetalle = otroAplDetalle;
	}
	public String getRealizadoOp() {
		return realizadoOp;
	}
	public void setRealizadoOp(String realizadoOp) {
		this.realizadoOp = realizadoOp;
	}
	public String getFuenteRecursos() {
		return fuenteRecursos;
	}
	public void setFuenteRecursos(String fuenteRecursos) {
		this.fuenteRecursos = fuenteRecursos;
	}
	public String getFuenteOtraDet() {
		return fuenteOtraDet;
	}
	public void setFuenteOtraDet(String fuenteOtraDet) {
		this.fuenteOtraDet = fuenteOtraDet;
	}
	public String getObservacionesEjec() {
		return observacionesEjec;
	}
	public void setObservacionesEjec(String observacionesEjec) {
		this.observacionesEjec = observacionesEjec;
	}
	public String getNegocioPersona() {
		return negocioPersona;
	}
	public void setNegocioPersona(String negocioPersona) {
		this.negocioPersona = negocioPersona;
	}
	public String getTipoNegocio() {
		return tipoNegocio;
	}
	public void setTipoNegocio(String tipoNegocio) {
		this.tipoNegocio = tipoNegocio;
	}
	public String getTipoOtroNegocio() {
		return tipoOtroNegocio;
	}
	public void setTipoOtroNegocio(String tipoOtroNegocio) {
		this.tipoOtroNegocio = tipoOtroNegocio;
	}
	public String getGiroNegocio() {
		return giroNegocio;
	}
	public void setGiroNegocio(String giroNegocio) {
		this.giroNegocio = giroNegocio;
	}
	public String getAniosAntig() {
		return aniosAntig;
	}
	public void setAniosAntig(String aniosAntig) {
		this.aniosAntig = aniosAntig;
	}
	public String getMesesAntig() {
		return mesesAntig;
	}
	public void setMesesAntig(String mesesAntig) {
		this.mesesAntig = mesesAntig;
	}
	public String getUbicacNegocio() {
		return ubicacNegocio;
	}
	public void setUbicacNegocio(String ubicacNegocio) {
		this.ubicacNegocio = ubicacNegocio;
	}
	public String getEsNegocioPropio() {
		return esNegocioPropio;
	}
	public void setEsNegocioPropio(String esNegocioPropio) {
		this.esNegocioPropio = esNegocioPropio;
	}
	public String getEspecificarNegocio() {
		return especificarNegocio;
	}
	public void setEspecificarNegocio(String especificarNegocio) {
		this.especificarNegocio = especificarNegocio;
	}
	public String getTipoProducto() {
		return tipoProducto;
	}
	public void setTipoProducto(String tipoProducto) {
		this.tipoProducto = tipoProducto;
	}
	public String getMercadoDeProducto() {
		return mercadoDeProducto;
	}
	public void setMercadoDeProducto(String mercadoDeProducto) {
		this.mercadoDeProducto = mercadoDeProducto;
	}
	public String getIngresosMensuales() {
		return ingresosMensuales;
	}
	public void setIngresosMensuales(String ingresosMensuales) {
		this.ingresosMensuales = ingresosMensuales;
	}
	public String getDependientesEcon() {
		return dependientesEcon;
	}
	public void setDependientesEcon(String dependientesEcon) {
		this.dependientesEcon = dependientesEcon;
	}
	public String getDependienteHijo() {
		return dependienteHijo;
	}
	public void setDependienteHijo(String dependienteHijo) {
		this.dependienteHijo = dependienteHijo;
	}
	public String getDependienteOtro() {
		return dependienteOtro;
	}
	public void setDependienteOtro(String dependienteOtro) {
		this.dependienteOtro = dependienteOtro;
	}
	public String getTipoNuevoNegocio() {
		return tipoNuevoNegocio;
	}
	public void setTipoNuevoNegocio(String tipoNuevoNegocio) {
		this.tipoNuevoNegocio = tipoNuevoNegocio;
	}
	public String getTipoOtroNuevoNegocio() {
		return tipoOtroNuevoNegocio;
	}
	public void setTipoOtroNuevoNegocio(String tipoOtroNuevoNegocio) {
		this.tipoOtroNuevoNegocio = tipoOtroNuevoNegocio;
	}
	public String getFteNuevosIngresos() {
		return fteNuevosIngresos;
	}
	public void setFteNuevosIngresos(String fteNuevosIngresos) {
		this.fteNuevosIngresos = fteNuevosIngresos;
	}
	public String getTiempoNuevoNeg() {
		return tiempoNuevoNeg;
	}
	public void setTiempoNuevoNeg(String tiempoNuevoNeg) {
		this.tiempoNuevoNeg = tiempoNuevoNeg;
	}
	public String getParentescoApert() {
		return parentescoApert;
	}
	public void setParentescoApert(String parentescoApert) {
		this.parentescoApert = parentescoApert;
	}
	public String getParentesOtroDet() {
		return parentesOtroDet;
	}
	public void setParentesOtroDet(String parentesOtroDet) {
		this.parentesOtroDet = parentesOtroDet;
	}
	public String getTiempoEnvio() {
		return tiempoEnvio;
	}
	public void setTiempoEnvio(String tiempoEnvio) {
		this.tiempoEnvio = tiempoEnvio;
	}
	public String getCuantoEnvio() {
		return cuantoEnvio;
	}
	public void setCuantoEnvio(String cuantoEnvio) {
		this.cuantoEnvio = cuantoEnvio;
	}
	public String getTrabajoActual() {
		return trabajoActual;
	}
	public void setTrabajoActual(String trabajoActual) {
		this.trabajoActual = trabajoActual;
	}
	public String getLugarTrabajoAct() {
		return lugarTrabajoAct;
	}
	public void setLugarTrabajoAct(String lugarTrabajoAct) {
		this.lugarTrabajoAct = lugarTrabajoAct;
	}
	public String getCargoTrabajo() {
		return cargoTrabajo;
	}
	public void setCargoTrabajo(String cargoTrabajo) {
		this.cargoTrabajo = cargoTrabajo;
	}
	public String getPeriodoDePago() {
		return periodoDePago;
	}
	public void setPeriodoDePago(String periodoDePago) {
		this.periodoDePago = periodoDePago;
	}
	public String getMontoPeriodoPago() {
		return montoPeriodoPago;
	}
	public void setMontoPeriodoPago(String montoPeriodoPago) {
		this.montoPeriodoPago = montoPeriodoPago;
	}
	public String getTiempoLaborado() {
		return tiempoLaborado;
	}
	public void setTiempoLaborado(String tiempoLaborado) {
		this.tiempoLaborado = tiempoLaborado;
	}
	public String getDependientesEconSA() {
		return dependientesEconSA;
	}
	public void setDependientesEconSA(String dependientesEconSA) {
		this.dependientesEconSA = dependientesEconSA;
	}
	public String getDependienteHijoSA() {
		return dependienteHijoSA;
	}
	public void setDependienteHijoSA(String dependienteHijoSA) {
		this.dependienteHijoSA = dependienteHijoSA;
	}
	public String getDependienteOtroSA() {
		return dependienteOtroSA;
	}
	public void setDependienteOtroSA(String dependienteOtroSA) {
		this.dependienteOtroSA = dependienteOtroSA;
	}
	public String getProveedRecursos() {
		return proveedRecursos;
	}
	public void setProveedRecursos(String proveedRecursos) {
		this.proveedRecursos = proveedRecursos;
	}
	public String getTipoProvRecursos() {
		return tipoProvRecursos;
	}
	public void setTipoProvRecursos(String tipoProvRecursos) {
		this.tipoProvRecursos = tipoProvRecursos;
	}
	public String getNombreCompProv() {
		return nombreCompProv;
	}
	public void setNombreCompProv(String nombreCompProv) {
		this.nombreCompProv = nombreCompProv;
	}
	public String getDomicilioProv() {
		return domicilioProv;
	}
	public void setDomicilioProv(String domicilioProv) {
		this.domicilioProv = domicilioProv;
	}
	public String getFechaNacProv() {
		return fechaNacProv;
	}
	public void setFechaNacProv(String fechaNacProv) {
		this.fechaNacProv = fechaNacProv;
	}
	public String getNacionalidProv() {
		return nacionalidProv;
	}
	public void setNacionalidProv(String nacionalidProv) {
		this.nacionalidProv = nacionalidProv;
	}
	public String getRfcProv() {
		return rfcProv;
	}
	public void setRfcProv(String rfcProv) {
		this.rfcProv = rfcProv;
	}
	public String getPropietarioDinero() {
		return propietarioDinero;
	}
	public void setPropietarioDinero(String propietarioDinero) {
		this.propietarioDinero = propietarioDinero;
	}
	public String getPropietarioOtroDet() {
		return propietarioOtroDet;
	}
	public void setPropietarioOtroDet(String propietarioOtroDet) {
		this.propietarioOtroDet = propietarioOtroDet;
	}
	public String getPropietarioNombreCom() {
		return propietarioNombreCom;
	}
	public void setPropietarioNombreCom(String propietarioNombreCom) {
		this.propietarioNombreCom = propietarioNombreCom;
	}
	public String getPropietarioDomici() {
		return propietarioDomici;
	}
	public void setPropietarioDomici(String propietarioDomici) {
		this.propietarioDomici = propietarioDomici;
	}
	public String getPropietarioNacio() {
		return propietarioNacio;
	}
	public void setPropietarioNacio(String propietarioNacio) {
		this.propietarioNacio = propietarioNacio;
	}
	public String getPropietarioCurp() {
		return propietarioCurp;
	}
	public void setPropietarioCurp(String propietarioCurp) {
		this.propietarioCurp = propietarioCurp;
	}
	public String getPropietarioRfc() {
		return propietarioRfc;
	}
	public void setPropietarioRfc(String propietarioRfc) {
		this.propietarioRfc = propietarioRfc;
	}
	public String getPropietarioGener() {
		return propietarioGener;
	}
	public void setPropietarioGener(String propietarioGener) {
		this.propietarioGener = propietarioGener;
	}
	public String getPropietarioOcupac() {
		return propietarioOcupac;
	}
	public void setPropietarioOcupac(String propietarioOcupac) {
		this.propietarioOcupac = propietarioOcupac;
	}
	public String getPropietarioFecha() {
		return propietarioFecha;
	}
	public void setPropietarioFecha(String propietarioFecha) {
		this.propietarioFecha = propietarioFecha;
	}
	public String getPropietarioLugarNac() {
		return propietarioLugarNac;
	}
	public void setPropietarioLugarNac(String propietarioLugarNac) {
		this.propietarioLugarNac = propietarioLugarNac;
	}
	public String getPropietarioEntid() {
		return propietarioEntid;
	}
	public void setPropietarioEntid(String propietarioEntid) {
		this.propietarioEntid = propietarioEntid;
	}
	public String getPropietarioPais() {
		return propietarioPais;
	}
	public void setPropietarioPais(String propietarioPais) {
		this.propietarioPais = propietarioPais;
	}
	public String getCargoPubPEP() {
		return cargoPubPEP;
	}
	public void setCargoPubPEP(String cargoPubPEP) {
		this.cargoPubPEP = cargoPubPEP;
	}
	public String getCargoPubPEPDet() {
		return cargoPubPEPDet;
	}
	public void setCargoPubPEPDet(String cargoPubPEPDet) {
		this.cargoPubPEPDet = cargoPubPEPDet;
	}
	public String getNivelCargoPEP() {
		return nivelCargoPEP;
	}
	public void setNivelCargoPEP(String nivelCargoPEP) {
		this.nivelCargoPEP = nivelCargoPEP;
	}
	public String getPeriodo1PEP() {
		return periodo1PEP;
	}
	public void setPeriodo1PEP(String periodo1pep) {
		periodo1PEP = periodo1pep;
	}
	public String getPeriodo2PEP() {
		return periodo2PEP;
	}
	public void setPeriodo2PEP(String periodo2pep) {
		periodo2PEP = periodo2pep;
	}
	public String getIngresosMenPEP() {
		return ingresosMenPEP;
	}
	public void setIngresosMenPEP(String ingresosMenPEP) {
		this.ingresosMenPEP = ingresosMenPEP;
	}
	public String getFamEnCargoPEP() {
		return famEnCargoPEP;
	}
	public void setFamEnCargoPEP(String famEnCargoPEP) {
		this.famEnCargoPEP = famEnCargoPEP;
	}
	public String getParentescoPEP() {
		return parentescoPEP;
	}
	public void setParentescoPEP(String parentescoPEP) {
		this.parentescoPEP = parentescoPEP;
	}
	public String getNombreCompletoPEP() {
		return nombreCompletoPEP;
	}
	public void setNombreCompletoPEP(String nombreCompletoPEP) {
		this.nombreCompletoPEP = nombreCompletoPEP;
	}
	public String getParentescoPEPDet() {
		return parentescoPEPDet;
	}
	public void setParentescoPEPDet(String parentescoPEPDet) {
		this.parentescoPEPDet = parentescoPEPDet;
	}
	public String getRelacionPEP() {
		return relacionPEP;
	}
	public void setRelacionPEP(String relacionPEP) {
		this.relacionPEP = relacionPEP;
	}
	public String getNombreRelacionPEP() {
		return nombreRelacionPEP;
	}
	public void setNombreRelacionPEP(String nombreRelacionPEP) {
		this.nombreRelacionPEP = nombreRelacionPEP;
	}
	public String getIngresoAdici() {
		return ingresoAdici;
	}
	public void setIngresoAdici(String ingresoAdici) {
		this.ingresoAdici = ingresoAdici;
	}
	public String getFuenteIngreOS() {
		return fuenteIngreOS;
	}
	public void setFuenteIngreOS(String fuenteIngreOS) {
		this.fuenteIngreOS = fuenteIngreOS;
	}
	public String getUbicFteIngreOS() {
		return UbicFteIngreOS;
	}
	public void setUbicFteIngreOS(String ubicFteIngreOS) {
		UbicFteIngreOS = ubicFteIngreOS;
	}
	public String getEsPropioFteIng() {
		return esPropioFteIng;
	}
	public void setEsPropioFteIng(String esPropioFteIng) {
		this.esPropioFteIng = esPropioFteIng;
	}
	public String getEsPropioFteDet() {
		return esPropioFteDet;
	}
	public void setEsPropioFteDet(String esPropioFteDet) {
		this.esPropioFteDet = esPropioFteDet;
	}
	public String getIngMensualesOS() {
		return ingMensualesOS;
	}
	public void setIngMensualesOS(String ingMensualesOS) {
		this.ingMensualesOS = ingMensualesOS;
	}
	public String getTipoProdTipoNeg() {
		return tipoProdTipoNeg;
	}
	public void setTipoProdTipoNeg(String tipoProdTipoNeg) {
		this.tipoProdTipoNeg = tipoProdTipoNeg;
	}
	public String getMercadoDeProdTipoNeg() {
		return mercadoDeProdTipoNeg;
	}
	public void setMercadoDeProdTipoNeg(String mercadoDeProdTipoNeg) {
		this.mercadoDeProdTipoNeg = mercadoDeProdTipoNeg;
	}
	public String getIngresosMensTipoNeg() {
		return ingresosMensTipoNeg;
	}
	public void setIngresosMensTipoNeg(String ingresosMensTipoNeg) {
		this.ingresosMensTipoNeg = ingresosMensTipoNeg;
	}
	public String getDependientesEconTipoNeg() {
		return dependientesEconTipoNeg;
	}
	public void setDependientesEconTipoNeg(String dependientesEconTipoNeg) {
		this.dependientesEconTipoNeg = dependientesEconTipoNeg;
	}
	public String getDependienteHijoTipoNeg() {
		return dependienteHijoTipoNeg;
	}
	public void setDependienteHijoTipoNeg(String dependienteHijoTipoNeg) {
		this.dependienteHijoTipoNeg = dependienteHijoTipoNeg;
	}
	public String getDependienteOtroTipoNeg() {
		return dependienteOtroTipoNeg;
	}
	public void setDependienteOtroTipoNeg(String dependienteOtroTipoNeg) {
		this.dependienteOtroTipoNeg = dependienteOtroTipoNeg;
	}
	public String getRazonSocialProvB() {
		return razonSocialProvB;
	}
	public void setRazonSocialProvB(String razonSocialProvB) {
		this.razonSocialProvB = razonSocialProvB;
	}
	public String getNacionalidProvB() {
		return nacionalidProvB;
	}
	public void setNacionalidProvB(String nacionalidProvB) {
		this.nacionalidProvB = nacionalidProvB;
	}
	public String getRfcProvB() {
		return rfcProvB;
	}
	public void setRfcProvB(String rfcProvB) {
		this.rfcProvB = rfcProvB;
	}
	public String getDomicilioProvB() {
		return domicilioProvB;
	}
	public void setDomicilioProvB(String domicilioProvB) {
		this.domicilioProvB = domicilioProvB;
	}
	public String getCargoPubPEPDetFam() {
		return cargoPubPEPDetFam;
	}
	public void setCargoPubPEPDetFam(String cargoPubPEPDetFam) {
		this.cargoPubPEPDetFam = cargoPubPEPDetFam;
	}
	public String getNivelCargoPEPFam() {
		return nivelCargoPEPFam;
	}
	public void setNivelCargoPEPFam(String nivelCargoPEPFam) {
		this.nivelCargoPEPFam = nivelCargoPEPFam;
	}
	public String getPeriodo1PEPFam() {
		return periodo1PEPFam;
	}
	public void setPeriodo1PEPFam(String periodo1pepFam) {
		periodo1PEPFam = periodo1pepFam;
	}
	public String getPeriodo2PEPFam() {
		return periodo2PEPFam;
	}
	public void setPeriodo2PEPFam(String periodo2pepFam) {
		periodo2PEPFam = periodo2pepFam;
	}
	public String getParentescoPEPFam() {
		return parentescoPEPFam;
	}
	public void setParentescoPEPFam(String parentescoPEPFam) {
		this.parentescoPEPFam = parentescoPEPFam;
	}
	public String getNombreCtoPEPFam() {
		return nombreCtoPEPFam;
	}
	public void setNombreCtoPEPFam(String nombreCtoPEPFam) {
		this.nombreCtoPEPFam = nombreCtoPEPFam;
	}
	
	
}
