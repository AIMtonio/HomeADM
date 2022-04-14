package pld.bean;

import general.bean.BaseBean;

public class OpeInusualesBean extends BaseBean{
	
	private String 	fecha;
	private String	opeInusualID;
	private String	claveRegistra;
	private String	nombreReg;
	private String	catProcedIntID;
	private String	catMotivInuID;
	private String	fechaDeteccion;
	private String	sucursalID;
	private String	clavePersonaInv;
	private String	nomPersonaInv;
	private String	empInvolucrado;
	private String	frecuencia;
	private String	desFrecuencia;
	private String	desOperacion;
	private String	estatus;
	private String	comentarioOC;
	private String	fechaCierre;
	private String folioInterno;
	private String formaPago;
	private String edad;
	private String ocupacionCli;
	private String clasificacionCli;
	private String sucursalIDCli;
	private String nombreSucursalCli;
	private String nivelEstudios;
	private String ingresoMensual;	
	private String fechaNacimiento;
	private String estadoCivil;
	private String localidad;
	private String numCredito;
	private String productoCredito;
	private String grupoNoSolidadario;	
	private Double ingMenSocie1;
		
	//Deteccion automatica	
	private String	creditoID;
	private String	cuentaAhoID;
	private String	transaccionOpe;
	
	private String	naturaOperacion;
	private String	montoOperacion;
	private String	monedaID;
	
	//beans Auxiliares
	private String	auxClavePersonaInv;
	private String	auxNomPersonaInv;
	
	// auxiliares para la pantalla de Generacion de Reportes
	private String nombreArchivo;	// nombre del archivo 
	private String diasRestantes;// dias restantes para reportar (60 dias maximo para reportar)
	private String desCorta;    // descripcion corta del motivo 
	private String claveRegistraDescri; // descripcion (de la clave) de quien registra "PERSONAL INTERNO, PERSONAL EXTERNO, SISTEMA AUTOMATICO"
	private String folioSITI;
	private String usuarioSITI;
	private String rutaArchivosPLD;
	private String origenDatos;
	
	private String tipoPerSAFI;
	private String nombresPersonaInv;
	private String apPaternoPersonaInv;
	private String apMaternoPersonaInv;
	
	private String desc_CatProcedInt;
	private String desc_CatMotivInu;
	private String descripcionEstatus;
	private String eqCNBVUIF;
	private String tipoOpeCNBV;
	private String tipoPersonaSAFI;
	private String fechaAlta;
	private String actividadBancoMX;
	private String actividadBMXDesc;
	private String nivelRiesgo;
	
	private String tipoReporteOpe;
	private String clienteID;
	private String periodo;
	private String periodoDes;
	private String descripcionMov;
	private String totalMonto;
	private String listaID;
	private String tipoLista;
	private String tipoListaID;
	private String rFC;
	private String nombreCompleto;
	private String primerNombre;
	private String segundoNombre;
	private String tercerNombre;
	private String paisID;
	private String estadoID;
	private String tipoPersona;

	/*Parametros del Reporte*/
	private String estatusDes;
	private String fechaInicio;
	private String fechaFinal;
	private String nombreInstitucion;
	private String usuario;
	private String fechaSistema;
	private String horaEmision;
	private String tipoReporte;
	private String tipoOperacion;
	
	private String operaciones;
	private String descOperaciones;
	private String usuarioServicioID;
	private String nombreUsuario;

	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getOpeInusualID() {
		return opeInusualID;
	}
	public void setOpeInusualID(String opeInusualID) {
		this.opeInusualID = opeInusualID;
	}
	public String getClaveRegistra() {
		return claveRegistra;
	}
	public void setClaveRegistra(String claveRegistra) {
		this.claveRegistra = claveRegistra;
	}
	public String getNombreReg() {
		return nombreReg;
	}
	public void setNombreReg(String nombreReg) {
		this.nombreReg = nombreReg;
	}
	public String getCatProcedIntID() {
		return catProcedIntID;
	}
	public void setCatProcedIntID(String catProcedIntID) {
		this.catProcedIntID = catProcedIntID;
	}
	public String getCatMotivInuID() {
		return catMotivInuID;
	}
	public void setCatMotivInuID(String catMotivInuID) {
		this.catMotivInuID = catMotivInuID;
	}
	public String getFechaDeteccion() {
		return fechaDeteccion;
	}
	public void setFechaDeteccion(String fechaDeteccion) {
		this.fechaDeteccion = fechaDeteccion;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getClavePersonaInv() {
		return clavePersonaInv;
	}
	public void setClavePersonaInv(String clavePersonaInv) {
		this.clavePersonaInv = clavePersonaInv;
	}
	public String getNomPersonaInv() {
		return nomPersonaInv;
	}
	public void setNomPersonaInv(String nomPersonaInv) {
		this.nomPersonaInv = nomPersonaInv;
	}
	public String getEmpInvolucrado() {
		return empInvolucrado;
	}
	public void setEmpInvolucrado(String empInvolucrado) {
		this.empInvolucrado = empInvolucrado;
	}
	public String getFrecuencia() {
		return frecuencia;
	}
	public void setFrecuencia(String frecuencia) {
		this.frecuencia = frecuencia;
	}
	public String getDesFrecuencia() {
		return desFrecuencia;
	}
	public void setDesFrecuencia(String desFrecuencia) {
		this.desFrecuencia = desFrecuencia;
	}
	public String getDesOperacion() {
		return desOperacion;
	}
	public void setDesOperacion(String desOperacion) {
		this.desOperacion = desOperacion;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getComentarioOC() {
		return comentarioOC;
	}
	public void setComentarioOC(String comentarioOC) {
		this.comentarioOC = comentarioOC;
	}
	public String getFechaCierre() {
		return fechaCierre;
	}
	public void setFechaCierre(String fechaCierre) {
		this.fechaCierre = fechaCierre;
	}
	public String getAuxClavePersonaInv() {
		return auxClavePersonaInv;
	}
	public void setAuxClavePersonaInv(String auxClavePersonaInv) {
		this.auxClavePersonaInv = auxClavePersonaInv;
	}
	public String getAuxNomPersonaInv() {
		return auxNomPersonaInv;
	}
	public void setAuxNomPersonaInv(String auxNomPersonaInv) {
		this.auxNomPersonaInv = auxNomPersonaInv;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getTransaccionOpe() {
		return transaccionOpe;
	}
	public void setTransaccionOpe(String transaccionOpe) {
		this.transaccionOpe = transaccionOpe;
	}
	public String getNaturaOperacion() {
		return naturaOperacion;
	}
	public void setNaturaOperacion(String naturaOperacion) {
		this.naturaOperacion = naturaOperacion;
	}
	public String getMontoOperacion() {
		return montoOperacion;
	}
	public void setMontoOperacion(String montoOperacion) {
		this.montoOperacion = montoOperacion;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getNombreArchivo() {
		return nombreArchivo;
	}
	public void setNombreArchivo(String nombreArchivo) {
		this.nombreArchivo = nombreArchivo;
	}
	public String getFolioInterno() {
		return folioInterno;
	}
	public void setFolioInterno(String folioInterno) {
		this.folioInterno = folioInterno;
	}
	public String getDiasRestantes() {
		return diasRestantes;
	}
	public void setDiasRestantes(String diasRestantes) {
		this.diasRestantes = diasRestantes;
	}
	public String getFolioSITI() {
		return folioSITI;
	}
	public String getUsuarioSITI() {
		return usuarioSITI;
	}
	public void setFolioSITI(String folioSITI) {
		this.folioSITI = folioSITI;
	}
	public void setUsuarioSITI(String usuarioSITI) {
		this.usuarioSITI = usuarioSITI;
	}
	public String getDesCorta() {
		return desCorta;
	}
	public void setDesCorta(String desCorta) {
		this.desCorta = desCorta;
	}
	public String getClaveRegistraDescri() {
		return claveRegistraDescri;
	}
	public void setClaveRegistraDescri(String claveRegistraDescri) {
		this.claveRegistraDescri = claveRegistraDescri;
	}
	public String getRutaArchivosPLD() {
		return rutaArchivosPLD;
	}
	public void setRutaArchivosPLD(String rutaArchivosPLD) {
		this.rutaArchivosPLD = rutaArchivosPLD;
	}
	public String getOrigenDatos() {
		return origenDatos;
	}
	public void setOrigenDatos(String origenDatos) {
		this.origenDatos = origenDatos;
	}
	public String getFormaPago() {
		return formaPago;
	}
	public void setFormaPago(String formaPago) {
		this.formaPago = formaPago;
	}
	public String getEdad() {
		return edad;
	}
	public void setEdad(String edad) {
		this.edad = edad;
	}
	public String getOcupacionCli() {
		return ocupacionCli;
	}
	public void setOcupacionCli(String ocupacionCli) {
		this.ocupacionCli = ocupacionCli;
	}
	public String getClasificacionCli() {
		return clasificacionCli;
	}
	public void setClasificacionCli(String clasificacionCli) {
		this.clasificacionCli = clasificacionCli;
	}
	public String getSucursalIDCli() {
		return sucursalIDCli;
	}
	public void setSucursalIDCli(String sucursalIDCli) {
		this.sucursalIDCli = sucursalIDCli;
	}
	public String getNombreSucursalCli() {
		return nombreSucursalCli;
	}
	public void setNombreSucursalCli(String nombreSucursalCli) {
		this.nombreSucursalCli = nombreSucursalCli;
	}
	public String getNivelEstudios() {
		return nivelEstudios;
	}
	public void setNivelEstudios(String nivelEstudios) {
		this.nivelEstudios = nivelEstudios;
	}
	public String getIngresoMensual() {
		return ingresoMensual;
	}
	public void setIngresoMensual(String ingresoMensual) {
		this.ingresoMensual = ingresoMensual;
	}
	public String getFechaNacimiento() {
		return fechaNacimiento;
	}
	public void setFechaNacimiento(String fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}
	public String getEstadoCivil() {
		return estadoCivil;
	}
	public void setEstadoCivil(String estadoCivil) {
		this.estadoCivil = estadoCivil;
	}
	public String getLocalidad() {
		return localidad;
	}
	public void setLocalidad(String localidad) {
		this.localidad = localidad;
	}
	public String getNumCredito() {
		return numCredito;
	}
	public void setNumCredito(String numCredito) {
		this.numCredito = numCredito;
	}
	public String getProductoCredito() {
		return productoCredito;
	}
	public void setProductoCredito(String productoCredito) {
		this.productoCredito = productoCredito;
	}
	public String getGrupoNoSolidadario() {
		return grupoNoSolidadario;
	}
	public void setGrupoNoSolidadario(String grupoNoSolidadario) {
		this.grupoNoSolidadario = grupoNoSolidadario;
	}
	public Double getIngMenSocie1() {
		return ingMenSocie1;
	}
	public void setIngMenSocie1(Double ingMenSocie1) {
		this.ingMenSocie1 = ingMenSocie1;
	}
	public String getTipoPerSAFI() {
		return tipoPerSAFI;
	}
	public void setTipoPerSAFI(String tipoPerSAFI) {
		this.tipoPerSAFI = tipoPerSAFI;
	}
	public String getNombresPersonaInv() {
		return nombresPersonaInv;
	}
	public void setNombresPersonaInv(String nombresPersonaInv) {
		this.nombresPersonaInv = nombresPersonaInv;
	}
	public String getApPaternoPersonaInv() {
		return apPaternoPersonaInv;
	}
	public void setApPaternoPersonaInv(String apPaternoPersonaInv) {
		this.apPaternoPersonaInv = apPaternoPersonaInv;
	}
	public String getApMaternoPersonaInv() {
		return apMaternoPersonaInv;
	}
	public void setApMaternoPersonaInv(String apMaternoPersonaInv) {
		this.apMaternoPersonaInv = apMaternoPersonaInv;
	}
	public String getDesc_CatProcedInt() {
		return desc_CatProcedInt;
	}
	public void setDesc_CatProcedInt(String desc_CatProcedInt) {
		this.desc_CatProcedInt = desc_CatProcedInt;
	}
	public String getDesc_CatMotivInu() {
		return desc_CatMotivInu;
	}
	public void setDesc_CatMotivInu(String desc_CatMotivInu) {
		this.desc_CatMotivInu = desc_CatMotivInu;
	}
	public String getDescripcionEstatus() {
		return descripcionEstatus;
	}
	public void setDescripcionEstatus(String descripcionEstatus) {
		this.descripcionEstatus = descripcionEstatus;
	}
	public String getEqCNBVUIF() {
		return eqCNBVUIF;
	}
	public void setEqCNBVUIF(String eqCNBVUIF) {
		this.eqCNBVUIF = eqCNBVUIF;
	}
	public String getTipoOpeCNBV() {
		return tipoOpeCNBV;
	}
	public void setTipoOpeCNBV(String tipoOpeCNBV) {
		this.tipoOpeCNBV = tipoOpeCNBV;
	}
	public String getTipoPersonaSAFI() {
		return tipoPersonaSAFI;
	}
	public void setTipoPersonaSAFI(String tipoPersonaSAFI) {
		this.tipoPersonaSAFI = tipoPersonaSAFI;
	}
	public String getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(String fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	public String getActividadBancoMX() {
		return actividadBancoMX;
	}
	public void setActividadBancoMX(String actividadBancoMX) {
		this.actividadBancoMX = actividadBancoMX;
	}
	public String getActividadBMXDesc() {
		return actividadBMXDesc;
	}
	public void setActividadBMXDesc(String actividadBMXDesc) {
		this.actividadBMXDesc = actividadBMXDesc;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaFinal() {
		return fechaFinal;
	}
	public void setFechaFinal(String fechaFinal) {
		this.fechaFinal = fechaFinal;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}
	public String getEstatusDes() {
		return estatusDes;
	}
	public void setEstatusDes(String estatusDes) {
		this.estatusDes = estatusDes;
	}
	public String getNivelRiesgo() {
		return nivelRiesgo;
	}
	public void setNivelRiesgo(String nivelRiesgo) {
		this.nivelRiesgo = nivelRiesgo;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getPeriodo() {
		return periodo;
	}
	public void setPeriodo(String periodo) {
		this.periodo = periodo;
	}
	public String getPeriodoDes() {
		return periodoDes;
	}
	public void setPeriodoDes(String periodoDes) {
		this.periodoDes = periodoDes;
	}
	public String getTipoReporteOpe() {
		return tipoReporteOpe;
	}
	public void setTipoReporteOpe(String tipoReporteOpe) {
		this.tipoReporteOpe = tipoReporteOpe;
	}
	public String getDescripcionMov() {
		return descripcionMov;
	}
	public void setDescripcionMov(String descripcionMov) {
		this.descripcionMov = descripcionMov;
	}
	public String getTotalMonto() {
		return totalMonto;
	}
	public void setTotalMonto(String totalMonto) {
		this.totalMonto = totalMonto;
	}
	public String getTipoReporte() {
		return tipoReporte;
	}
	public void setTipoReporte(String tipoReporte) {
		this.tipoReporte = tipoReporte;
	}
	public String getTipoOperacion() {
		return tipoOperacion;
	}
	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
	}
	public String getListaID() {
		return listaID;
	}
	public void setListaID(String listaID) {
		this.listaID = listaID;
	}
	public String getTipoLista() {
		return tipoLista;
	}
	public void setTipoLista(String tipoLista) {
		this.tipoLista = tipoLista;
	}
	public String getTipoListaID() {
		return tipoListaID;
	}
	public void setTipoListaID(String tipoListaID) {
		this.tipoListaID = tipoListaID;
	}
	public String getrFC() {
		return rFC;
	}
	public void setrFC(String rFC) {
		this.rFC = rFC;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
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
	public String getPaisID() {
		return paisID;
	}
	public void setPaisID(String paisID) {
		this.paisID = paisID;
	}
	public String getEstadoID() {
		return estadoID;
	}
	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getOperaciones() {
		return operaciones;
	}
	public void setOperaciones(String operaciones) {
		this.operaciones = operaciones;
	}
	public String getDescOperaciones() {
		return descOperaciones;
	}
	public void setDescOperaciones(String descOperaciones) {
		this.descOperaciones = descOperaciones;
	}
	public String getUsuarioServicioID() {
		return usuarioServicioID;
	}
	public void setUsuarioServicioID(String usuarioServicioID) {
		this.usuarioServicioID = usuarioServicioID;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
}