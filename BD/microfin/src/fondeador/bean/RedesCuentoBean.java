package fondeador.bean;

import java.util.List;

import general.bean.BaseBean;

public class RedesCuentoBean extends BaseBean {
	private String institutFondeoID;
	private String nombreInstitFon;
	private String lineaFondeoID;
	private String descripLinFon;
	private String creditoFondeoID;
	private String saldoCreditoFon;
	private String fechaIniCredFon;
	private String saldoCapFon;
	private String creditoID;
	private String montoCredito;
	private String saldoCapCre;
	private String fechaAsignacion;
	private String usuarioAsigna;
	private String formaSeleccion;
	private String condicionesCum;
	private String cantidadIntegrar;
	private String porcentajeExtraCob;
	
	// auxiliares del reporte
	private String previoReporte;
	private String clienteID;
	private String tipoPersona;
	private String titulo;
	private String nombres;
	private String apellidoPat;
	private String apellidoMat;
	private String nombreCompleto;
	private String sexo;
	private String estadoCivil;
	private String rfc;
	private String curp;
	private String telefonoCasa;
	private String telefonoCel;
	private String correo;
	private String gradoEscolar;
	private String tipoIdenti;
	private String numeroIdenti;
	private String fechaNacimiento;
	private String entidadFedNacim;
	private String ocupacionID;
	private String desOcupacion;
	private String lugarTrabajo;
	private String antiguedadTrab;
	private String puestoTrabajo;
	private String actividadFR;
	private String desActividadFR;
	private String actividadFomurID;
	private String desActividadFomur;
	private String tipoDirOficial;
	private String estadoDirOficial;
	private String municipioDirOficial;
	private String localidadDirOficial;
	private String asentamientoColoniaDir;
	private String coloniaDirOficial;
	private String calleDirOficial;
	private String numeroIntDirOf;
	private String numeroExtDirOf;
	private String codigoPostalDir;
	private String direccionCompleta;
	private String estadoDirNegocio;
	private String municipioDirNegocio;
	private String localidadDirNegocio;
	private String asentamientoColoniaNeg;
	private String coloniaDirNegocio;
	private String calleDirNegocio;
	private String numeroIntDirNeg;
	private String numeroExtDirNeg;
	private String codigoPostalDirNeg;
	private String direccionCompletaNeg;
	private String numeroEmpleados;
	private String sucursalID;
	private String nombreSucursal;
	private String nombrePromotor;
	private String productoCreditoID;
	private String descripcion;
	private String diasAtraso;
	private String rangoDias;
	private String destinoCreID;
	private String destino;
	private String destinoFomurID;
	private String destinoFomur;
	private String destinoFRID;
	private String destinoFR;
	private String tipoCredito;
	private String tasaAnual;
	private String tasaMensual;
	private String fechaDesembolso;
	private String fechaVencimien;
	private String numeroCuotas;
	private String grupoID;
	private String nombreGrupo;
	private String estatus;
	private String frecuencia;
	private String modalidadPago;
	private String garantiaExhibida;
	private String garantiaAdicional;
	private String montoDesembolsado;
	private String saldo;
	private String capitalExigible;
	private String interesVigente;
	private String interesProvisionado;
	private String interesVencido;
	private String interesOrdinario;
	private String saldoMora;
	private String comisiones;
	private String capital;
	private String columnasSaldoSafi;
	private String saldoCapitalVigente;
	private String saldoCapitalAtrasado;
	private String saldoCapitalVencido;
	private String saldoCapitalVencidonoExi;
	private String saldoInteresAtrasado;
	private String saldoInteresVencido;
	private String saldoInteresDevengado;
	private String saldIntDevengadoCtaOrden;
	private String saldoMoratorio;
	private String saldoComFaltaPago;
	private String saldoOtrasComisiones;
	private String ingresos;
	private String egresos;	
	
	
	private String fechaInicio;
	private String saldoCapital;
	private String actividadBancoMx;
	private String actDescrip;
	

	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private long numTransaccion;
	
	private List listaSeleccion;
	private List listaCreditoID;
	private List listaMontoCredito;
	private List listaSaldoCapCre;
	
	private String nombreUsuario;
	private String ParFechaEmision;
	private String hora;
	
	
	public String getInstitutFondeoID() {
		return institutFondeoID;
	}
	public String getLineaFondeoID() {
		return lineaFondeoID;
	}
	public String getCreditoFondeoID() {
		return creditoFondeoID;
	}
	public String getSaldoCapFon() {
		return saldoCapFon;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public String getMontoCredito() {
		return montoCredito;
	}
	public String getSaldoCapCre() {
		return saldoCapCre;
	}
	public String getFechaAsignacion() {
		return fechaAsignacion;
	}
	public String getUsuarioAsigna() {
		return usuarioAsigna;
	}
	public String getFormaSeleccion() {
		return formaSeleccion;
	}
	public String getCondicionesCum() {
		return condicionesCum;
	}
	
	public String getEmpresaID() {
		return empresaID;
	}
	public String getUsuario() {
		return usuario;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public long getNumTransaccion() {
		return numTransaccion;
	}
	public void setInstitutFondeoID(String institutFondeoID) {
		this.institutFondeoID = institutFondeoID;
	}
	public void setLineaFondeoID(String lineaFondeoID) {
		this.lineaFondeoID = lineaFondeoID;
	}
	public void setCreditoFondeoID(String creditoFondeoID) {
		this.creditoFondeoID = creditoFondeoID;
	}
	public void setSaldoCapFon(String saldoCapFon) {
		this.saldoCapFon = saldoCapFon;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public void setMontoCredito(String montoCredito) {
		this.montoCredito = montoCredito;
	}
	public void setSaldoCapCre(String saldoCapCre) {
		this.saldoCapCre = saldoCapCre;
	}
	public void setFechaAsignacion(String fechaAsignacion) {
		this.fechaAsignacion = fechaAsignacion;
	}
	public void setUsuarioAsigna(String usuarioAsigna) {
		this.usuarioAsigna = usuarioAsigna;
	}
	public void setFormaSeleccion(String formaSeleccion) {
		this.formaSeleccion = formaSeleccion;
	}
	public void setCodicionesCum(String condicionesCum) {
		this.condicionesCum = condicionesCum;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public void setNumTransaccion(long numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public String getFechaVencimien() {
		return fechaVencimien;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public String getDireccionCompleta() {
		return direccionCompleta;
	}
	public void setCondicionesCum(String condicionesCum) {
		this.condicionesCum = condicionesCum;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public void setFechaVencimien(String fechaVencimien) {
		this.fechaVencimien = fechaVencimien;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public void setDireccionCompleta(String direccionCompleta) {
		this.direccionCompleta = direccionCompleta;
	}
	public String getSaldoCapital() {
		return saldoCapital;
	}
	public void setSaldoCapital(String saldoCapital) {
		this.saldoCapital = saldoCapital;
	}
	public List getListaSeleccion() {
		return listaSeleccion;
	}
	public List getListaCreditoID() {
		return listaCreditoID;
	}
	public List getListaMontoCredito() {
		return listaMontoCredito;
	}
	public List getListaSaldoCapCre() {
		return listaSaldoCapCre;
	}
	public void setListaSeleccion(List listaSeleccion) {
		this.listaSeleccion = listaSeleccion;
	}
	public void setListaCreditoID(List listaCreditoID) {
		this.listaCreditoID = listaCreditoID;
	}
	public void setListaMontoCredito(List listaMontoCredito) {
		this.listaMontoCredito = listaMontoCredito;
	}
	public void setListaSaldoCapCre(List listaSaldoCapCre) {
		this.listaSaldoCapCre = listaSaldoCapCre;
	}
	public String getNombreInstitFon() {
		return nombreInstitFon;
	}
	public String getDescripLinFon() {
		return descripLinFon;
	}
	public String getSaldoCreditoFon() {
		return saldoCreditoFon;
	}
	public String getFechaIniCredFon() {
		return fechaIniCredFon;
	}
	public void setNombreInstitFon(String nombreInstitFon) {
		this.nombreInstitFon = nombreInstitFon;
	}
	public void setDescripLinFon(String descripLinFon) {
		this.descripLinFon = descripLinFon;
	}
	public void setSaldoCreditoFon(String saldoCreditoFon) {
		this.saldoCreditoFon = saldoCreditoFon;
	}
	public void setFechaIniCredFon(String fechaIniCredFon) {
		this.fechaIniCredFon = fechaIniCredFon;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public String getParFechaEmision() {
		return ParFechaEmision;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public void setParFechaEmision(String parFechaEmision) {
		ParFechaEmision = parFechaEmision;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getSexo() {
		return sexo;
	}
	public String getClienteID() {
		return clienteID;
	}
	public String getActividadBancoMx() {
		return actividadBancoMx;
	}
	public String getActDescrip() {
		return actDescrip;
	}
	public String getEstadoCivil() {
		return estadoCivil;
	}
	public String getDestinoCreID() {
		return destinoCreID;
	}
	public String getDestino() {
		return destino;
	}
	public void setSexo(String sexo) {
		this.sexo = sexo;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public void setActividadBancoMx(String actividadBancoMx) {
		this.actividadBancoMx = actividadBancoMx;
	}
	public void setActDescrip(String actDescrip) {
		this.actDescrip = actDescrip;
	}
	public void setEstadoCivil(String estadoCivil) {
		this.estadoCivil = estadoCivil;
	}
	public void setDestinoCreID(String destinoCreID) {
		this.destinoCreID = destinoCreID;
	}
	public void setDestino(String destino) {
		this.destino = destino;
	}
	public String getTitulo() {
		return titulo;
	}
	public String getNombres() {
		return nombres;
	}
	public String getApellidoPat() {
		return apellidoPat;
	}
	public String getApellidoMat() {
		return apellidoMat;
	}
	public String getRfc() {
		return rfc;
	}
	public String getCurp() {
		return curp;
	}
	public String getTelefonoCasa() {
		return telefonoCasa;
	}
	public String getTelefonoCel() {
		return telefonoCel;
	}
	public String getCorreo() {
		return correo;
	}
	public String getGradoEscolar() {
		return gradoEscolar;
	}
	public String getTipoIdenti() {
		return tipoIdenti;
	}
	public String getNumeroIdenti() {
		return numeroIdenti;
	}
	public String getFechaNacimiento() {
		return fechaNacimiento;
	}
	public String getEntidadFedNacim() {
		return entidadFedNacim;
	}
	public String getOcupacionID() {
		return ocupacionID;
	}
	public String getDesOcupacion() {
		return desOcupacion;
	}
	public String getLugarTrabajo() {
		return lugarTrabajo;
	}
	public String getAntiguedadTrab() {
		return antiguedadTrab;
	}
	public String getPuestoTrabajo() {
		return puestoTrabajo;
	}
	public String getActividadFR() {
		return actividadFR;
	}
	public String getDesActividadFR() {
		return desActividadFR;
	}
	public String getActividadFomurID() {
		return actividadFomurID;
	}
	public String getDesActividadFomur() {
		return desActividadFomur;
	}
	public String getTipoDirOficial() {
		return tipoDirOficial;
	}
	public String getEstadoDirOficial() {
		return estadoDirOficial;
	}
	public String getMunicipioDirOficial() {
		return municipioDirOficial;
	}
	public String getLocalidadDirOficial() {
		return localidadDirOficial;
	}
	public String getAsentamientoColoniaDir() {
		return asentamientoColoniaDir;
	}
	public String getColoniaDirOficial() {
		return coloniaDirOficial;
	}
	public String getCalleDirOficial() {
		return calleDirOficial;
	}
	public String getNumeroIntDirOf() {
		return numeroIntDirOf;
	}
	public String getNumeroExtDirOf() {
		return numeroExtDirOf;
	}
	public String getCodigoPostalDir() {
		return codigoPostalDir;
	}
	public String getEstadoDirNegocio() {
		return estadoDirNegocio;
	}
	public String getMunicipioDirNegocio() {
		return municipioDirNegocio;
	}
	public String getLocalidadDirNegocio() {
		return localidadDirNegocio;
	}
	public String getAsentamientoColoniaNeg() {
		return asentamientoColoniaNeg;
	}
	public String getColoniaDirNegocio() {
		return coloniaDirNegocio;
	}
	public String getCalleDirNegocio() {
		return calleDirNegocio;
	}
	public String getNumeroIntDirNeg() {
		return numeroIntDirNeg;
	}
	public String getNumeroExtDirNeg() {
		return numeroExtDirNeg;
	}
	public String getCodigoPostalDirNeg() {
		return codigoPostalDirNeg;
	}
	public String getDireccionCompletaNeg() {
		return direccionCompletaNeg;
	}
	public String getNumeroEmpleados() {
		return numeroEmpleados;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public String getNombrePromotor() {
		return nombrePromotor;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public String getDiasAtraso() {
		return diasAtraso;
	}
	public String getRangoDias() {
		return rangoDias;
	}
	public String getDestinoFomurID() {
		return destinoFomurID;
	}
	public String getDestinoFomur() {
		return destinoFomur;
	}
	public String getDestinoFRID() {
		return destinoFRID;
	}
	public String getDestinoFR() {
		return destinoFR;
	}
	public String getTipoCredito() {
		return tipoCredito;
	}
	public String getTasaAnual() {
		return tasaAnual;
	}
	public String getTasaMensual() {
		return tasaMensual;
	}
	public String getFechaDesembolso() {
		return fechaDesembolso;
	}
	public String getNumeroCuotas() {
		return numeroCuotas;
	}
	public String getGrupoID() {
		return grupoID;
	}
	public String getNombreGrupo() {
		return nombreGrupo;
	}
	public String getEstatus() {
		return estatus;
	}
	public String getFrecuencia() {
		return frecuencia;
	}
	public String getModalidadPago() {
		return modalidadPago;
	}
	public String getGarantiaExhibida() {
		return garantiaExhibida;
	}
	public String getGarantiaAdicional() {
		return garantiaAdicional;
	}
	public String getMontoDesembolsado() {
		return montoDesembolsado;
	}
	public String getSaldo() {
		return saldo;
	}
	public String getCapitalExigible() {
		return capitalExigible;
	}
	public String getInteresVigente() {
		return interesVigente;
	}
	public String getInteresProvisionado() {
		return interesProvisionado;
	}
	public String getInteresVencido() {
		return interesVencido;
	}
	public String getInteresOrdinario() {
		return interesOrdinario;
	}
	public String getSaldoMora() {
		return saldoMora;
	}
	public String getComisiones() {
		return comisiones;
	}
	public String getCapital() {
		return capital;
	}
	public String getColumnasSaldoSafi() {
		return columnasSaldoSafi;
	}
	public String getSaldoCapitalVigente() {
		return saldoCapitalVigente;
	}
	public String getSaldoCapitalAtrasado() {
		return saldoCapitalAtrasado;
	}
	public String getSaldoCapitalVencido() {
		return saldoCapitalVencido;
	}
	public String getSaldoCapitalVencidonoExi() {
		return saldoCapitalVencidonoExi;
	}
	public String getSaldoInteresAtrasado() {
		return saldoInteresAtrasado;
	}
	public String getSaldoInteresVencido() {
		return saldoInteresVencido;
	}
	public String getSaldoInteresDevengado() {
		return saldoInteresDevengado;
	}
	public String getSaldIntDevengadoCtaOrden() {
		return saldIntDevengadoCtaOrden;
	}
	public String getSaldoMoratorio() {
		return saldoMoratorio;
	}
	public String getSaldoComFaltaPago() {
		return saldoComFaltaPago;
	}
	public String getSaldoOtrasComisiones() {
		return saldoOtrasComisiones;
	}
	public String getIngresos() {
		return ingresos;
	}
	public String getEgresos() {
		return egresos;
	}
	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}
	public void setNombres(String nombres) {
		this.nombres = nombres;
	}
	public void setApellidoPat(String apellidoPat) {
		this.apellidoPat = apellidoPat;
	}
	public void setApellidoMat(String apellidoMat) {
		this.apellidoMat = apellidoMat;
	}
	public void setRfc(String rfc) {
		this.rfc = rfc;
	}
	public void setCurp(String curp) {
		this.curp = curp;
	}
	public void setTelefonoCasa(String telefonoCasa) {
		this.telefonoCasa = telefonoCasa;
	}
	public void setTelefonoCel(String telefonoCel) {
		this.telefonoCel = telefonoCel;
	}
	public void setCorreo(String correo) {
		this.correo = correo;
	}
	public void setGradoEscolar(String gradoEscolar) {
		this.gradoEscolar = gradoEscolar;
	}
	public void setTipoIdenti(String tipoIdenti) {
		this.tipoIdenti = tipoIdenti;
	}
	public void setNumeroIdenti(String numeroIdenti) {
		this.numeroIdenti = numeroIdenti;
	}
	public void setFechaNacimiento(String fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}
	public void setEntidadFedNacim(String entidadFedNacim) {
		this.entidadFedNacim = entidadFedNacim;
	}
	public void setOcupacionID(String ocupacionID) {
		this.ocupacionID = ocupacionID;
	}
	public void setDesOcupacion(String desOcupacion) {
		this.desOcupacion = desOcupacion;
	}
	public void setLugarTrabajo(String lugarTrabajo) {
		this.lugarTrabajo = lugarTrabajo;
	}
	public void setAntiguedadTrab(String antiguedadTrab) {
		this.antiguedadTrab = antiguedadTrab;
	}
	public void setPuestoTrabajo(String puestoTrabajo) {
		this.puestoTrabajo = puestoTrabajo;
	}
	public void setActividadFR(String actividadFR) {
		this.actividadFR = actividadFR;
	}
	public void setDesActividadFR(String desActividadFR) {
		this.desActividadFR = desActividadFR;
	}
	public void setActividadFomurID(String actividadFomurID) {
		this.actividadFomurID = actividadFomurID;
	}
	public void setDesActividadFomur(String desActividadFomur) {
		this.desActividadFomur = desActividadFomur;
	}
	public void setTipoDirOficial(String tipoDirOficial) {
		this.tipoDirOficial = tipoDirOficial;
	}
	public void setEstadoDirOficial(String estadoDirOficial) {
		this.estadoDirOficial = estadoDirOficial;
	}
	public void setMunicipioDirOficial(String municipioDirOficial) {
		this.municipioDirOficial = municipioDirOficial;
	}
	public void setLocalidadDirOficial(String localidadDirOficial) {
		this.localidadDirOficial = localidadDirOficial;
	}
	public void setAsentamientoColoniaDir(String asentamientoColoniaDir) {
		this.asentamientoColoniaDir = asentamientoColoniaDir;
	}
	public void setColoniaDirOficial(String coloniaDirOficial) {
		this.coloniaDirOficial = coloniaDirOficial;
	}
	public void setCalleDirOficial(String calleDirOficial) {
		this.calleDirOficial = calleDirOficial;
	}
	public void setNumeroIntDirOf(String numeroIntDirOf) {
		this.numeroIntDirOf = numeroIntDirOf;
	}
	public void setNumeroExtDirOf(String numeroExtDirOf) {
		this.numeroExtDirOf = numeroExtDirOf;
	}
	public void setCodigoPostalDir(String codigoPostalDir) {
		this.codigoPostalDir = codigoPostalDir;
	}
	public void setEstadoDirNegocio(String estadoDirNegocio) {
		this.estadoDirNegocio = estadoDirNegocio;
	}
	public void setMunicipioDirNegocio(String municipioDirNegocio) {
		this.municipioDirNegocio = municipioDirNegocio;
	}
	public void setLocalidadDirNegocio(String localidadDirNegocio) {
		this.localidadDirNegocio = localidadDirNegocio;
	}
	public void setAsentamientoColoniaNeg(String asentamientoColoniaNeg) {
		this.asentamientoColoniaNeg = asentamientoColoniaNeg;
	}
	public void setColoniaDirNegocio(String coloniaDirNegocio) {
		this.coloniaDirNegocio = coloniaDirNegocio;
	}
	public void setCalleDirNegocio(String calleDirNegocio) {
		this.calleDirNegocio = calleDirNegocio;
	}
	public void setNumeroIntDirNeg(String numeroIntDirNeg) {
		this.numeroIntDirNeg = numeroIntDirNeg;
	}
	public void setNumeroExtDirNeg(String numeroExtDirNeg) {
		this.numeroExtDirNeg = numeroExtDirNeg;
	}
	public void setCodigoPostalDirNeg(String codigoPostalDirNeg) {
		this.codigoPostalDirNeg = codigoPostalDirNeg;
	}
	public void setDireccionCompletaNeg(String direccionCompletaNeg) {
		this.direccionCompletaNeg = direccionCompletaNeg;
	}
	public void setNumeroEmpleados(String numeroEmpleados) {
		this.numeroEmpleados = numeroEmpleados;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public void setNombrePromotor(String nombrePromotor) {
		this.nombrePromotor = nombrePromotor;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public void setDiasAtraso(String diasAtraso) {
		this.diasAtraso = diasAtraso;
	}
	public void setRangoDias(String rangoDias) {
		this.rangoDias = rangoDias;
	}
	public void setDestinoFomurID(String destinoFomurID) {
		this.destinoFomurID = destinoFomurID;
	}
	public void setDestinoFomur(String destinoFomur) {
		this.destinoFomur = destinoFomur;
	}
	public void setDestinoFRID(String destinoFRID) {
		this.destinoFRID = destinoFRID;
	}
	public void setDestinoFR(String destinoFR) {
		this.destinoFR = destinoFR;
	}
	public void setTipoCredito(String tipoCredito) {
		this.tipoCredito = tipoCredito;
	}
	public void setTasaAnual(String tasaAnual) {
		this.tasaAnual = tasaAnual;
	}
	public void setTasaMensual(String tasaMensual) {
		this.tasaMensual = tasaMensual;
	}
	public void setFechaDesembolso(String fechaDesembolso) {
		this.fechaDesembolso = fechaDesembolso;
	}
	public void setNumeroCuotas(String numeroCuotas) {
		this.numeroCuotas = numeroCuotas;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public void setNombreGrupo(String nombreGrupo) {
		this.nombreGrupo = nombreGrupo;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public void setFrecuencia(String frecuencia) {
		this.frecuencia = frecuencia;
	}
	public void setModalidadPago(String modalidadPago) {
		this.modalidadPago = modalidadPago;
	}
	public void setGarantiaExhibida(String garantiaExhibida) {
		this.garantiaExhibida = garantiaExhibida;
	}
	public void setGarantiaAdicional(String garantiaAdicional) {
		this.garantiaAdicional = garantiaAdicional;
	}
	public void setMontoDesembolsado(String montoDesembolsado) {
		this.montoDesembolsado = montoDesembolsado;
	}
	public void setSaldo(String saldo) {
		this.saldo = saldo;
	}
	public void setCapitalExigible(String capitalExigible) {
		this.capitalExigible = capitalExigible;
	}
	public void setInteresVigente(String interesVigente) {
		this.interesVigente = interesVigente;
	}
	public void setInteresProvisionado(String interesProvisionado) {
		this.interesProvisionado = interesProvisionado;
	}
	public void setInteresVencido(String interesVencido) {
		this.interesVencido = interesVencido;
	}
	public void setInteresOrdinario(String interesOrdinario) {
		this.interesOrdinario = interesOrdinario;
	}
	public void setSaldoMora(String saldoMora) {
		this.saldoMora = saldoMora;
	}
	public void setComisiones(String comisiones) {
		this.comisiones = comisiones;
	}
	public void setCapital(String capital) {
		this.capital = capital;
	}
	public void setColumnasSaldoSafi(String columnasSaldoSafi) {
		this.columnasSaldoSafi = columnasSaldoSafi;
	}
	public void setSaldoCapitalVigente(String saldoCapitalVigente) {
		this.saldoCapitalVigente = saldoCapitalVigente;
	}
	public void setSaldoCapitalAtrasado(String saldoCapitalAtrasado) {
		this.saldoCapitalAtrasado = saldoCapitalAtrasado;
	}
	public void setSaldoCapitalVencido(String saldoCapitalVencido) {
		this.saldoCapitalVencido = saldoCapitalVencido;
	}
	public void setSaldoCapitalVencidonoExi(String saldoCapitalVencidonoExi) {
		this.saldoCapitalVencidonoExi = saldoCapitalVencidonoExi;
	}
	public void setSaldoInteresAtrasado(String saldoInteresAtrasado) {
		this.saldoInteresAtrasado = saldoInteresAtrasado;
	}
	public void setSaldoInteresVencido(String saldoInteresVencido) {
		this.saldoInteresVencido = saldoInteresVencido;
	}
	public void setSaldoInteresDevengado(String saldoInteresDevengado) {
		this.saldoInteresDevengado = saldoInteresDevengado;
	}
	public void setSaldIntDevengadoCtaOrden(String saldIntDevengadoCtaOrden) {
		this.saldIntDevengadoCtaOrden = saldIntDevengadoCtaOrden;
	}
	public void setSaldoMoratorio(String saldoMoratorio) {
		this.saldoMoratorio = saldoMoratorio;
	}
	public void setSaldoComFaltaPago(String saldoComFaltaPago) {
		this.saldoComFaltaPago = saldoComFaltaPago;
	}
	public void setSaldoOtrasComisiones(String saldoOtrasComisiones) {
		this.saldoOtrasComisiones = saldoOtrasComisiones;
	}
	public void setIngresos(String ingresos) {
		this.ingresos = ingresos;
	}
	public void setEgresos(String egresos) {
		this.egresos = egresos;
	}
	public String getPrevioReporte() {
		return previoReporte;
	}
	public void setPrevioReporte(String previoReporte) {
		this.previoReporte = previoReporte;
	}
	public String getCantidadIntegrar() {
		return cantidadIntegrar;
	}
	public String getPorcentajeExtraCob() {
		return porcentajeExtraCob;
	}
	public void setCantidadIntegrar(String cantidadIntegrar) {
		this.cantidadIntegrar = cantidadIntegrar;
	}
	public void setPorcentajeExtraCob(String porcentajeExtraCob) {
		this.porcentajeExtraCob = porcentajeExtraCob;
	}
}