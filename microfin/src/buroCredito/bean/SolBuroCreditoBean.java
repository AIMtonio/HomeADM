package buroCredito.bean;

import general.bean.BaseBean;

public class SolBuroCreditoBean extends BaseBean{
	
	private String ProspectoID;
	private String RFC;
	private String fechaConsulta;
	private String fechaConsultaC;
	private String primerNombre;
	private String segundoNombre;
	private String tercerNombre;
	private String apellidoPaterno;
	private String apellidoMaterno;
	private String estadoID;
	private String municipioID;
	private String localidadID;
	private String nombreLocalidad;
	private String calle;
	private String numeroExterior;
	private String numeroInterior;
	private String piso;
	private String coloniaID;
	private String nombreColonia;
	private String CP;
	private String lote;
	private String manzana;
	private String fechaNacimiento;
	private String folioConsulta;
	private String diasVigencia;
	private String diasVigenciaC;
	private String folioConsultaC;
	private String solicitudCreditoID;
	private String productoCreditoID;
	private String montoSolici;
	private String fechaRegistro;
	private String estatus;
	private String montoAutorizado;
	private String nombreMuni;
	private String claveEstado;
	private String numErr;
	private String mensajeErr;
	private String consecutivoFol;
	private String claveUsuario;
	private String claveUsuariob;

	// variables para la lista de Consulta a Buro de Credito
	private String relacion;
	private String nombreCompleto;
	private String registroID;
	private String AvalID;
	private String oficial;
	private String telefono;
	private String telefonoCelular;
	private String telTrabajo;
	private String tipoPersona;
	private String oblSolidID;
	
	// consulta a Circulo de Credito  
	private String estadoCivil;
	private String sexo;
	private String usuarioID;
	private String realizaConsultasCC;
	private String tipoContratoCCID;
	private String clienteID;
	private String usuarioCirculo;
	private String contrasenaCirculo;
	private String sucursalID;
	private String fechaSistema;
	
	// variables para la alta de registro
	private String nombreEstado;
	private String importe;
	private String numeroFirma;
	private String tipoCuenta;
	private String claveUM;
	private String tipoAlta;
	private String adeudoTotal;
	private String calificacionMOP;
	
	// Datos para consultas a buro de credito multibase
	private String origenDatos;
	private String realizaConsultasBC;
	private String usuarioBuroCredito;
	private String contraseniaBuroCredito;
	
	private String empresaID;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	private String direccion;
	
	
	
	public String getOblSolidID() {
		return oblSolidID;
	}
	public void setOblSolidID(String oblSolidID) {
		this.oblSolidID = oblSolidID;
	}
	public String getProspectoID() {
		return ProspectoID;
	}
	public void setProspectoID(String prospectoID) {
		ProspectoID = prospectoID;
	}
	public String getRFC() {
		return RFC;
	}
	public void setRFC(String rFC) {
		RFC = rFC;
	}
	public String getFechaConsulta() {
		return fechaConsulta;
	}
	public void setFechaConsulta(String fechaConsulta) {
		this.fechaConsulta = fechaConsulta;
	}
	public String getFechaConsultaC() {
		return fechaConsultaC;
	}
	public void setFechaConsultaC(String fechaConsultaC) {
		this.fechaConsultaC = fechaConsultaC;
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
	public String getEstadoID() {
		return estadoID;
	}
	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
	}
	public String getMunicipioID() {
		return municipioID;
	}
	public void setMunicipioID(String municipioID) {
		this.municipioID = municipioID;
	}
	public String getLocalidadID() {
		return localidadID;
	}
	public void setLocalidadID(String localidadID) {
		this.localidadID = localidadID;
	}
	public String getNombreLocalidad() {
		return nombreLocalidad;
	}
	public void setNombreLocalidad(String nombreLocalidad) {
		this.nombreLocalidad = nombreLocalidad;
	}
	public String getCalle() {
		return calle;
	}
	public void setCalle(String calle) {
		this.calle = calle;
	}
	public String getNumeroExterior() {
		return numeroExterior;
	}
	public void setNumeroExterior(String numeroExterior) {
		this.numeroExterior = numeroExterior;
	}
	public String getNumeroInterior() {
		return numeroInterior;
	}
	public void setNumeroInterior(String numeroInterior) {
		this.numeroInterior = numeroInterior;
	}
	public String getPiso() {
		return piso;
	}
	public void setPiso(String piso) {
		this.piso = piso;
	}
	public String getColoniaID() {
		return coloniaID;
	}
	public void setColoniaID(String coloniaID) {
		this.coloniaID = coloniaID;
	}
	public String getNombreColonia() {
		return nombreColonia;
	}
	public void setNombreColonia(String nombreColonia) {
		this.nombreColonia = nombreColonia;
	}
	public String getCP() {
		return CP;
	}
	public void setCP(String cP) {
		CP = cP;
	}
	public String getLote() {
		return lote;
	}
	public void setLote(String lote) {
		this.lote = lote;
	}
	public String getManzana() {
		return manzana;
	}
	public void setManzana(String manzana) {
		this.manzana = manzana;
	}
	public String getFechaNacimiento() {
		return fechaNacimiento;
	}
	public void setFechaNacimiento(String fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}
	public String getFolioConsulta() {
		return folioConsulta;
	}
	public void setFolioConsulta(String folioConsulta) {
		this.folioConsulta = folioConsulta;
	}
	public String getDiasVigencia() {
		return diasVigencia;
	}
	public void setDiasVigencia(String diasVigencia) {
		this.diasVigencia = diasVigencia;
	}
	public String getDiasVigenciaC() {
		return diasVigenciaC;
	}
	public void setDiasVigenciaC(String diasVigenciaC) {
		this.diasVigenciaC = diasVigenciaC;
	}
	public String getFolioConsultaC() {
		return folioConsultaC;
	}
	public void setFolioConsultaC(String folioConsultaC) {
		this.folioConsultaC = folioConsultaC;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getMontoSolici() {
		return montoSolici;
	}
	public void setMontoSolici(String montoSolici) {
		this.montoSolici = montoSolici;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getMontoAutorizado() {
		return montoAutorizado;
	}
	public void setMontoAutorizado(String montoAutorizado) {
		this.montoAutorizado = montoAutorizado;
	}
	public String getNombreMuni() {
		return nombreMuni;
	}
	public void setNombreMuni(String nombreMuni) {
		this.nombreMuni = nombreMuni;
	}
	public String getClaveEstado() {
		return claveEstado;
	}
	public void setClaveEstado(String claveEstado) {
		this.claveEstado = claveEstado;
	}
	public String getNumErr() {
		return numErr;
	}
	public void setNumErr(String numErr) {
		this.numErr = numErr;
	}
	public String getMensajeErr() {
		return mensajeErr;
	}
	public void setMensajeErr(String mensajeErr) {
		this.mensajeErr = mensajeErr;
	}
	public String getConsecutivoFol() {
		return consecutivoFol;
	}
	public void setConsecutivoFol(String consecutivoFol) {
		this.consecutivoFol = consecutivoFol;
	}
	public String getRelacion() {
		return relacion;
	}
	public void setRelacion(String relacion) {
		this.relacion = relacion;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getRegistroID() {
		return registroID;
	}
	public void setRegistroID(String registroID) {
		this.registroID = registroID;
	}
	public String getAvalID() {
		return AvalID;
	}
	public void setAvalID(String avalID) {
		AvalID = avalID;
	}
	public String getOficial() {
		return oficial;
	}
	public void setOficial(String oficial) {
		this.oficial = oficial;
	}
	public String getEstadoCivil() {
		return estadoCivil;
	}
	public void setEstadoCivil(String estadoCivil) {
		this.estadoCivil = estadoCivil;
	}
	public String getSexo() {
		return sexo;
	}
	public void setSexo(String sexo) {
		this.sexo = sexo;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getRealizaConsultasCC() {
		return realizaConsultasCC;
	}
	public void setRealizaConsultasCC(String realizaConsultasCC) {
		this.realizaConsultasCC = realizaConsultasCC;
	}
	public String getTipoContratoCCID() {
		return tipoContratoCCID;
	}
	public void setTipoContratoCCID(String tipoContratoCCID) {
		this.tipoContratoCCID = tipoContratoCCID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getUsuarioCirculo() {
		return usuarioCirculo;
	}
	public void setUsuarioCirculo(String usuarioCirculo) {
		this.usuarioCirculo = usuarioCirculo;
	}
	public String getNombreEstado() {
		return nombreEstado;
	}
	public void setNombreEstado(String nombreEstado) {
		this.nombreEstado = nombreEstado;
	}
	public String getImporte() {
		return importe;
	}
	public void setImporte(String importe) {
		this.importe = importe;
	}
	public String getNumeroFirma() {
		return numeroFirma;
	}
	public void setNumeroFirma(String numeroFirma) {
		this.numeroFirma = numeroFirma;
	}
	public String getTipoCuenta() {
		return tipoCuenta;
	}
	public void setTipoCuenta(String tipoCuenta) {
		this.tipoCuenta = tipoCuenta;
	}
	public String getClaveUM() {
		return claveUM;
	}
	public void setClaveUM(String claveUM) {
		this.claveUM = claveUM;
	}
	public String getTipoAlta() {
		return tipoAlta;
	}
	public void setTipoAlta(String tipoAlta) {
		this.tipoAlta = tipoAlta;
	}
	public String getAdeudoTotal() {
		return adeudoTotal;
	}
	public void setAdeudoTotal(String adeudoTotal) {
		this.adeudoTotal = adeudoTotal;
	}
	public String getCalificacionMOP() {
		return calificacionMOP;
	}
	public void setCalificacionMOP(String calificacionMOP) {
		this.calificacionMOP = calificacionMOP;
	}
	public String getEmpresaID() {
		return empresaID;
	}
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
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
	public String getClaveUsuario() {
		return claveUsuario;
	}
	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}
	public String getClaveUsuariob() {
		return claveUsuariob;
	}
	public void setClaveUsuariob(String claveUsuariob) {
		this.claveUsuariob = claveUsuariob;
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
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getTelefonoCelular() {
		return telefonoCelular;
	}
	public void setTelefonoCelular(String telefonoCelular) {
		this.telefonoCelular = telefonoCelular;
	}
	public String getTelTrabajo() {
		return telTrabajo;
	}
	public void setTelTrabajo(String telTrabajo) {
		this.telTrabajo = telTrabajo;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getTelefono() {
		return telefono;
	}
	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}
	public String getOrigenDatos() {
		return origenDatos;
	}
	public void setOrigenDatos(String origenDatos) {
		this.origenDatos = origenDatos;
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
	public String getContraseniaBuroCredito() {
		return contraseniaBuroCredito;
	}
	public void setContraseniaBuroCredito(String contraseniaBuroCredito) {
		this.contraseniaBuroCredito = contraseniaBuroCredito;
	}
	public String getContrasenaCirculo() {
		return contrasenaCirculo;
	}
	public void setContrasenaCirculo(String contrasenaCirculo) {
		this.contrasenaCirculo = contrasenaCirculo;
	}
}