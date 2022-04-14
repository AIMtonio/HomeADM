package pld.bean;

import general.bean.BaseBean;

public class PLDCNBVopeInuBean extends BaseBean {
	
	private String tipoReporte;
	private String periodoReporte;
	private String folio;
	private String claveOrgSupervisor;
	private String claveEntCasFim;
	private String localidadSuc;
	private String sucursalID;
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
	private String razones; //motivo
	private String sucursalCP;
	
	
	private String folioInterno;
	private String folioSITI;
	private String periodoCorresponde;
	private String usuarioSITI;
	private String nombreArchivo;
	
	//----------agregados---------
	private String consecutivoCta;
	private String claveCasfimRelacionado;
	private String nombreRelacionado;
	private String apPatRelacionado;
	private String apMatRelacionado;

	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	public String getTipoReporte() {
		return tipoReporte;
	}
	public String getPeriodoReporte() {
		return periodoReporte;
	}
	public String getFolio() {
		return folio;
	}
	public String getClaveOrgSupervisor() {
		return claveOrgSupervisor;
	}
	public String getClaveEntCasFim() {
		return claveEntCasFim;
	}
	public String getLocalidadSuc() {
		return localidadSuc;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public String getTipoOperacionID() {
		return tipoOperacionID;
	}
	public String getInstrumentMonID() {
		return instrumentMonID;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public String getMonto() {
		return monto;
	}
	public String getClaveMoneda() {
		return claveMoneda;
	}
	public String getFechaOpe() {
		return fechaOpe;
	}
	public String getFechaDeteccion() {
		return fechaDeteccion;
	}
	public String getNacionalidad() {
		return nacionalidad;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public String getRazonSocial() {
		return razonSocial;
	}
	public String getNombre() {
		return nombre;
	}
	public String getApellidoPat() {
		return apellidoPat;
	}
	public String getApellidoMat() {
		return apellidoMat;
	}
	public String getRFC() {
		return RFC;
	}
	public String getCURP() {
		return CURP;
	}
	public String getFechaNac() {
		return fechaNac;
	}
	public String getDomicilio() {
		return domicilio;
	}
	public String getColonia() {
		return colonia;
	}
	public String getLocalidad() {
		return localidad;
	}
	public String getTelefono() {
		return telefono;
	}
	public String getActEconomica() {
		return actEconomica;
	}
	public String getNomApoderado() {
		return nomApoderado;
	}
	public String getApPatApoderado() {
		return apPatApoderado;
	}
	public String getApMatApoderado() {
		return apMatApoderado;
	}
	public String getRFCApoderado() {
		return RFCApoderado;
	}
	public String getCURPApoderado() {
		return CURPApoderado;
	}
	public String getCtaRelacionadoID() {
		return ctaRelacionadoID;
	}
	public String getCuenAhoRelacionado() {
		return cuenAhoRelacionado;
	}
	public String getClaveSujeto() {
		return claveSujeto;
	}
	public String getNomTitular() {
		return nomTitular;
	}
	public String getApPatTitular() {
		return apPatTitular;
	}
	public String getApMatTitular() {
		return apMatTitular;
	}
	public String getDesOperacion() {
		return desOperacion;
	}
	public String getRazones() {
		return razones;
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
	public String getSucursal() {
		return sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public String getFolioInterno() {
		return folioInterno;
	}

	public String getPeriodoCorresponde() {
		return periodoCorresponde;
	}
	public String getUsuarioSITI() {
		return usuarioSITI;
	}
	public void setTipoReporte(String tipoReporte) {
		this.tipoReporte = tipoReporte;
	}
	public void setPeriodoReporte(String periodoReporte) {
		this.periodoReporte = periodoReporte;
	}
	public void setFolio(String folio) {
		this.folio = folio;
	}
	public void setClaveOrgSupervisor(String claveOrgSupervisor) {
		this.claveOrgSupervisor = claveOrgSupervisor;
	}
	public void setClaveEntCasFim(String claveEntCasFim) {
		this.claveEntCasFim = claveEntCasFim;
	}
	public void setLocalidadSuc(String localidadSuc) {
		this.localidadSuc = localidadSuc;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public void setTipoOperacionID(String tipoOperacionID) {
		this.tipoOperacionID = tipoOperacionID;
	}
	public void setInstrumentMonID(String instrumentMonID) {
		this.instrumentMonID = instrumentMonID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public void setClaveMoneda(String claveMoneda) {
		this.claveMoneda = claveMoneda;
	}
	public void setFechaOpe(String fechaOpe) {
		this.fechaOpe = fechaOpe;
	}
	public void setFechaDeteccion(String fechaDeteccion) {
		this.fechaDeteccion = fechaDeteccion;
	}
	public void setNacionalidad(String nacionalidad) {
		this.nacionalidad = nacionalidad;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public void setApellidoPat(String apellidoPat) {
		this.apellidoPat = apellidoPat;
	}
	public void setApellidoMat(String apellidoMat) {
		this.apellidoMat = apellidoMat;
	}
	public void setRFC(String rFC) {
		RFC = rFC;
	}
	public void setCURP(String cURP) {
		CURP = cURP;
	}
	public void setFechaNac(String fechaNac) {
		this.fechaNac = fechaNac;
	}
	public void setDomicilio(String domicilio) {
		this.domicilio = domicilio;
	}
	public void setColonia(String colonia) {
		this.colonia = colonia;
	}
	public void setLocalidad(String localidad) {
		this.localidad = localidad;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	public void setActEconomica(String actEconomica) {
		this.actEconomica = actEconomica;
	}
	public void setNomApoderado(String nomApoderado) {
		this.nomApoderado = nomApoderado;
	}
	public void setApPatApoderado(String apPatApoderado) {
		this.apPatApoderado = apPatApoderado;
	}
	public void setApMatApoderado(String apMatApoderado) {
		this.apMatApoderado = apMatApoderado;
	}
	public void setRFCApoderado(String rFCApoderado) {
		RFCApoderado = rFCApoderado;
	}
	public void setCURPApoderado(String cURPApoderado) {
		CURPApoderado = cURPApoderado;
	}
	public void setCtaRelacionadoID(String ctaRelacionadoID) {
		this.ctaRelacionadoID = ctaRelacionadoID;
	}
	public void setCuenAhoRelacionado(String cuenAhoRelacionado) {
		this.cuenAhoRelacionado = cuenAhoRelacionado;
	}
	public void setClaveSujeto(String claveSujeto) {
		this.claveSujeto = claveSujeto;
	}
	public void setNomTitular(String nomTitular) {
		this.nomTitular = nomTitular;
	}
	public void setApPatTitular(String apPatTitular) {
		this.apPatTitular = apPatTitular;
	}
	public void setApMatTitular(String apMatTitular) {
		this.apMatTitular = apMatTitular;
	}
	public void setDesOperacion(String desOperacion) {
		this.desOperacion = desOperacion;
	}
	public void setRazones(String razones) {
		this.razones = razones;
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
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public void setFolioInterno(String folioInterno) {
		this.folioInterno = folioInterno;
	}
	
	public void setPeriodoCorresponde(String periodoCorresponde) {
		this.periodoCorresponde = periodoCorresponde;
	}
	public void setUsuarioSITI(String usuarioSITI) {
		this.usuarioSITI = usuarioSITI;
	}
	public String getClaveCasfimRelacionado() {
		return claveCasfimRelacionado;
	}
	public String getNombreRelacionado() {
		return nombreRelacionado;
	}
	public String getApPatRelacionado() {
		return apPatRelacionado;
	}
	public String getApMatRelacionado() {
		return apMatRelacionado;
	}
	public void setClaveCasfimRelacionado(String claveCasfimRelacionado) {
		this.claveCasfimRelacionado = claveCasfimRelacionado;
	}
	public void setNombreRelacionado(String nombreRelacionado) {
		this.nombreRelacionado = nombreRelacionado;
	}
	public void setApPatRelacionado(String apPatRelacionado) {
		this.apPatRelacionado = apPatRelacionado;
	}
	public void setApMatRelacionado(String apMatRelacionado) {
		this.apMatRelacionado = apMatRelacionado;
	}
	public String getConsecutivoCta() {
		return consecutivoCta;
	}
	public void setConsecutivoCta(String consecutivoCta) {
		this.consecutivoCta = consecutivoCta;
	}
	public String getFolioSITI() {
		return folioSITI;
	}
	public void setFolioSITI(String folioSITI) {
		this.folioSITI = folioSITI;
	}
	public String getNombreArchivo() {
		return nombreArchivo;
	}
	public void setNombreArchivo(String nombreArchivo) {
		this.nombreArchivo = nombreArchivo;
	}
	public String getSucursalCP() {
		return sucursalCP;
	}
	public void setSucursalCP(String sucursalCP) {
		this.sucursalCP = sucursalCP;
	}
	
	
	
	
}
