package pld.bean;

import general.bean.BaseBean;

public class ReportesSITIBean extends BaseBean {

	// Reporte Relevantes
	private String fechaGeneracion;
	private	String periodoID;
	private String periodoInicio;
	private String periodoFin;
	private String archivo;
	
	// Reporte de Op. Inusuales
	private String opeInusualID;
	private String estatus;
	private String comentarioOC;
	private String clavePersonaInv;
	private String nomPersonaInv;
	private String folioInterno;
	private String claveCasfimRelacionado;
	
	// Resultado de Reporte
	private String tipoReporte;
	private String periodoReporte;
	private String folio;
	private String claveOrgSupervisor;
	private String claveEntCasFim;
	private String localidadSuc;
	private String sucursalID;
	private String cpSucursal;
	private String tipoOperacionID;
	private String instrumentMonID;
	private String cuentaAhoID;
	private String monto;
	private String claveMoneda;
	private String fechaOpe;
	private String fechaDeteccion;
	private String nacionalidad;
	private String tipoPersona;
	private String razonSocial;
	private String nombre;
	private String apellidoPat;
	private String apellidoMat;
	private String RFC;
	private String CURP;
	private String fechaNac;
	private String domicilio;
	private String colonia;
	private String localidad;
	private String telefono;
	private String actEconomica;
	private String nomApoderado;
	private String apPatApoderado;
	private String apMatApoderado;
	private String RFCApoderado;
	private String CURPApoderado;
	private String ctaRelacionadoID;
	private String cuenAhoRelacionado;
	private String claveSujeto;
	private String nomTitular;
	private String apPatTitular;
	private String apMatTitular;
	private String desOperacion;
	private String razones;
	private String claveCNBV;

	// Encabezado reporte
	private String nombreUsuario;
	private String tituloReporte;
	private String fechaSistema;
	private String nombreInstitucion;
	private String estatusDes;
	private String fechaInicio;
	private String fechaFinal;
	private String usuario;
	private String horaEmision;
	private String tipoOperacion;
	
	private String operaciones;
	private String descOperaciones;
	
	public String getFechaGeneracion() {
		return fechaGeneracion;
	}

	public void setFechaGeneracion(String fechaGeneracion) {
		this.fechaGeneracion = fechaGeneracion;
	}

	public String getPeriodoID() {
		return periodoID;
	}

	public void setPeriodoID(String periodoID) {
		this.periodoID = periodoID;
	}

	public String getPeriodoInicio() {
		return periodoInicio;
	}

	public void setPeriodoInicio(String periodoInicio) {
		this.periodoInicio = periodoInicio;
	}

	public String getPeriodoFin() {
		return periodoFin;
	}

	public void setPeriodoFin(String periodoFin) {
		this.periodoFin = periodoFin;
	}

	public String getArchivo() {
		return archivo;
	}

	public void setArchivo(String archivo) {
		this.archivo = archivo;
	}

	public String getOpeInusualID() {
		return opeInusualID;
	}

	public void setOpeInusualID(String opeInusualID) {
		this.opeInusualID = opeInusualID;
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

	public String getFolioInterno() {
		return folioInterno;
	}

	public void setFolioInterno(String folioInterno) {
		this.folioInterno = folioInterno;
	}

	public String getClaveCasfimRelacionado() {
		return claveCasfimRelacionado;
	}

	public void setClaveCasfimRelacionado(String claveCasfimRelacionado) {
		this.claveCasfimRelacionado = claveCasfimRelacionado;
	}

	public String getTipoReporte() {
		return tipoReporte;
	}

	public void setTipoReporte(String tipoReporte) {
		this.tipoReporte = tipoReporte;
	}

	public String getPeriodoReporte() {
		return periodoReporte;
	}

	public void setPeriodoReporte(String periodoReporte) {
		this.periodoReporte = periodoReporte;
	}

	public String getFolio() {
		return folio;
	}

	public void setFolio(String folio) {
		this.folio = folio;
	}

	public String getClaveOrgSupervisor() {
		return claveOrgSupervisor;
	}

	public void setClaveOrgSupervisor(String claveOrgSupervisor) {
		this.claveOrgSupervisor = claveOrgSupervisor;
	}

	public String getClaveEntCasFim() {
		return claveEntCasFim;
	}

	public void setClaveEntCasFim(String claveEntCasFim) {
		this.claveEntCasFim = claveEntCasFim;
	}

	public String getLocalidadSuc() {
		return localidadSuc;
	}

	public void setLocalidadSuc(String localidadSuc) {
		this.localidadSuc = localidadSuc;
	}

	public String getSucursalID() {
		return sucursalID;
	}

	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}

	public String getCpSucursal() {
		return cpSucursal;
	}

	public void setCpSucursal(String cpSucursal) {
		this.cpSucursal = cpSucursal;
	}

	public String getTipoOperacionID() {
		return tipoOperacionID;
	}

	public void setTipoOperacionID(String tipoOperacionID) {
		this.tipoOperacionID = tipoOperacionID;
	}

	public String getInstrumentMonID() {
		return instrumentMonID;
	}

	public void setInstrumentMonID(String instrumentMonID) {
		this.instrumentMonID = instrumentMonID;
	}

	public String getCuentaAhoID() {
		return cuentaAhoID;
	}

	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}

	public String getMonto() {
		return monto;
	}

	public void setMonto(String monto) {
		this.monto = monto;
	}

	public String getClaveMoneda() {
		return claveMoneda;
	}

	public void setClaveMoneda(String claveMoneda) {
		this.claveMoneda = claveMoneda;
	}

	public String getFechaOpe() {
		return fechaOpe;
	}

	public void setFechaOpe(String fechaOpe) {
		this.fechaOpe = fechaOpe;
	}

	public String getFechaDeteccion() {
		return fechaDeteccion;
	}

	public void setFechaDeteccion(String fechaDeteccion) {
		this.fechaDeteccion = fechaDeteccion;
	}

	public String getNacionalidad() {
		return nacionalidad;
	}

	public void setNacionalidad(String nacionalidad) {
		this.nacionalidad = nacionalidad;
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

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getApellidoPat() {
		return apellidoPat;
	}

	public void setApellidoPat(String apellidoPat) {
		this.apellidoPat = apellidoPat;
	}

	public String getApellidoMat() {
		return apellidoMat;
	}

	public void setApellidoMat(String apellidoMat) {
		this.apellidoMat = apellidoMat;
	}

	public String getRFC() {
		return RFC;
	}

	public void setRFC(String rFC) {
		RFC = rFC;
	}

	public String getCURP() {
		return CURP;
	}

	public void setCURP(String cURP) {
		CURP = cURP;
	}

	public String getFechaNac() {
		return fechaNac;
	}

	public void setFechaNac(String fechaNac) {
		this.fechaNac = fechaNac;
	}

	public String getDomicilio() {
		return domicilio;
	}

	public void setDomicilio(String domicilio) {
		this.domicilio = domicilio;
	}

	public String getColonia() {
		return colonia;
	}

	public void setColonia(String colonia) {
		this.colonia = colonia;
	}

	public String getLocalidad() {
		return localidad;
	}

	public void setLocalidad(String localidad) {
		this.localidad = localidad;
	}

	public String getTelefono() {
		return telefono;
	}

	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

	public String getActEconomica() {
		return actEconomica;
	}

	public void setActEconomica(String actEconomica) {
		this.actEconomica = actEconomica;
	}

	public String getNomApoderado() {
		return nomApoderado;
	}

	public void setNomApoderado(String nomApoderado) {
		this.nomApoderado = nomApoderado;
	}

	public String getApPatApoderado() {
		return apPatApoderado;
	}

	public void setApPatApoderado(String apPatApoderado) {
		this.apPatApoderado = apPatApoderado;
	}

	public String getApMatApoderado() {
		return apMatApoderado;
	}

	public void setApMatApoderado(String apMatApoderado) {
		this.apMatApoderado = apMatApoderado;
	}

	public String getRFCApoderado() {
		return RFCApoderado;
	}

	public void setRFCApoderado(String rFCApoderado) {
		RFCApoderado = rFCApoderado;
	}

	public String getCURPApoderado() {
		return CURPApoderado;
	}

	public void setCURPApoderado(String cURPApoderado) {
		CURPApoderado = cURPApoderado;
	}

	public String getCtaRelacionadoID() {
		return ctaRelacionadoID;
	}

	public void setCtaRelacionadoID(String ctaRelacionadoID) {
		this.ctaRelacionadoID = ctaRelacionadoID;
	}

	public String getCuenAhoRelacionado() {
		return cuenAhoRelacionado;
	}

	public void setCuenAhoRelacionado(String cuenAhoRelacionado) {
		this.cuenAhoRelacionado = cuenAhoRelacionado;
	}

	public String getClaveSujeto() {
		return claveSujeto;
	}

	public void setClaveSujeto(String claveSujeto) {
		this.claveSujeto = claveSujeto;
	}

	public String getNomTitular() {
		return nomTitular;
	}

	public void setNomTitular(String nomTitular) {
		this.nomTitular = nomTitular;
	}

	public String getApPatTitular() {
		return apPatTitular;
	}

	public void setApPatTitular(String apPatTitular) {
		this.apPatTitular = apPatTitular;
	}

	public String getApMatTitular() {
		return apMatTitular;
	}

	public void setApMatTitular(String apMatTitular) {
		this.apMatTitular = apMatTitular;
	}

	public String getDesOperacion() {
		return desOperacion;
	}

	public void setDesOperacion(String desOperacion) {
		this.desOperacion = desOperacion;
	}

	public String getRazones() {
		return razones;
	}

	public void setRazones(String razones) {
		this.razones = razones;
	}

	public String getClaveCNBV() {
		return claveCNBV;
	}

	public void setClaveCNBV(String claveCNBV) {
		this.claveCNBV = claveCNBV;
	}

	public String getNombreUsuario() {
		return nombreUsuario;
	}

	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}

	public String getTituloReporte() {
		return tituloReporte;
	}

	public void setTituloReporte(String tituloReporte) {
		this.tituloReporte = tituloReporte;
	}

	public String getFechaSistema() {
		return fechaSistema;
	}

	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}

	public String getNombreInstitucion() {
		return nombreInstitucion;
	}

	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}

	public String getEstatusDes() {
		return estatusDes;
	}

	public void setEstatusDes(String estatusDes) {
		this.estatusDes = estatusDes;
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

	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}

	public String getHoraEmision() {
		return horaEmision;
	}

	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}

	public String getTipoOperacion() {
		return tipoOperacion;
	}

	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
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
}