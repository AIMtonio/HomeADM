package credito.bean;

import general.bean.BaseBean;

public class LineasCreditoBean  extends BaseBean {
	private String lineaCreditoID;
	private String clienteID;
	private String cuentaID;
	private String monedaID;
	private String sucursalID;
	private String folioContrato;
	private String fechaInicio;
	private String fechaVencimiento;
	private String productoCreditoID;
	private String solicitado;
	private String autorizado;
	private String dispuesto;
	private String pagado;
	private String saldoDisponible;
	private String saldoDeudor;
	private String estatus;
	private String numeroCreditos;
	private String fechaCancelacion;
	private String fechaBloqueo;
	private String fechaDesbloqueo;
	private String fechaAutoriza;
	private String usuarioAutoriza;
	private String usuarioBloqueo;
	private String usuarioDesbloquea;
	private String usuarioCancela;
	private String motivoBloquea;
	private String motivoDesbloqueo;
	private String motivoCancela;
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String creditoID;
	private String nombreCliente;
	private String nombreProducto;
	private String nombreSucursal;
	private String nombreEstatus;
	private String nombreInstitucion;
	private String nombreUsuario;
	private String numTransaccion;
	private String aumentado;
	private String excedente;
	private String idenCreditoCNBV;

	private String comisionAnual;
	private String cobraComAnual;
	private String tipoComAnual;
	private String comisionCobrada;
	private String saldoComAnual;
	private String valorComAnual;

	// Segmento Agro
	private String tipoLineaAgroID;
	private String esRevolvente;
	private String manejaComAdmon;
	private String forCobComAdmon;
	private String porcentajeComAdmon;

	private String manejaComGarantia;
	private String forCobComGarantia;
	private String porcentajeComGarantia;
	private String fechaRechazo;
	private String usuarioRechazo;

	private String montoUltimoIncremento;
	private String fechaReactivacion;
	private String usuarioReactivacion;
	private String saldoAtraso;
	private String esAgropecuario;
	
	private String descripcion;
    private String fechaNuevoVenci;
    private String ultFechaDisposicion;
    private String ultMontoDisposicion;
    private String cobraTolPriDisposicion;

    private String fechaCobroComision;
    private String fechaProximoCobro;
    
	private String fechaEmision;
	private String horaEmision;
	private String claveUsuario;
    
	public String getLineaCreditoID() {
		return lineaCreditoID;
	}
	public void setLineaCreditoID(String lineaCreditoID) {
		this.lineaCreditoID = lineaCreditoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentaID() {
		return cuentaID;
	}
	public void setCuentaID(String cuentaID) {
		this.cuentaID = cuentaID;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getFolioContrato() {
		return folioContrato;
	}
	public void setFolioContrato(String folioContrato) {
		this.folioContrato = folioContrato;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public String getSolicitado() {
		return solicitado;
	}
	public void setSolicitado(String solicitado) {
		this.solicitado = solicitado;
	}
	public String getAutorizado() {
		return autorizado;
	}
	public void setAutorizado(String autorizado) {
		this.autorizado = autorizado;
	}
	public String getDispuesto() {
		return dispuesto;
	}
	public void setDispuesto(String dispuesto) {
		this.dispuesto = dispuesto;
	}
	public String getPagado() {
		return pagado;
	}
	public void setPagado(String pagado) {
		this.pagado = pagado;
	}
	public String getSaldoDisponible() {
		return saldoDisponible;
	}
	public void setSaldoDisponible(String saldoDisponible) {
		this.saldoDisponible = saldoDisponible;
	}
	public String getSaldoDeudor() {
		return saldoDeudor;
	}
	public void setSaldoDeudor(String saldoDeudor) {
		this.saldoDeudor = saldoDeudor;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getNumeroCreditos() {
		return numeroCreditos;
	}
	public void setNumeroCreditos(String numeroCreditos) {
		this.numeroCreditos = numeroCreditos;
	}
	public String getFechaCancelacion() {
		return fechaCancelacion;
	}
	public void setFechaCancelacion(String fechaCancelacion) {
		this.fechaCancelacion = fechaCancelacion;
	}
	public String getFechaBloqueo() {
		return fechaBloqueo;
	}
	public void setFechaBloqueo(String fechaBloqueo) {
		this.fechaBloqueo = fechaBloqueo;
	}
	public String getFechaDesbloqueo() {
		return fechaDesbloqueo;
	}
	public void setFechaDesbloqueo(String fechaDesbloqueo) {
		this.fechaDesbloqueo = fechaDesbloqueo;
	}
	public String getFechaAutoriza() {
		return fechaAutoriza;
	}
	public void setFechaAutoriza(String fechaAutoriza) {
		this.fechaAutoriza = fechaAutoriza;
	}
	public String getUsuarioAutoriza() {
		return usuarioAutoriza;
	}
	public void setUsuarioAutoriza(String usuarioAutoriza) {
		this.usuarioAutoriza = usuarioAutoriza;
	}
	public String getUsuarioBloqueo() {
		return usuarioBloqueo;
	}
	public void setUsuarioBloqueo(String usuarioBloqueo) {
		this.usuarioBloqueo = usuarioBloqueo;
	}
	public String getUsuarioDesbloquea() {
		return usuarioDesbloquea;
	}
	public void setUsuarioDesbloquea(String usuarioDesbloquea) {
		this.usuarioDesbloquea = usuarioDesbloquea;
	}
	public String getUsuarioCancela() {
		return usuarioCancela;
	}
	public void setUsuarioCancela(String usuarioCancela) {
		this.usuarioCancela = usuarioCancela;
	}
	public String getMotivoBloquea() {
		return motivoBloquea;
	}
	public void setMotivoBloquea(String motivoBloquea) {
		this.motivoBloquea = motivoBloquea;
	}
	public String getMotivoDesbloqueo() {
		return motivoDesbloqueo;
	}
	public void setMotivoDesbloqueo(String motivoDesbloqueo) {
		this.motivoDesbloqueo = motivoDesbloqueo;
	}
	public String getMotivoCancela() {
		return motivoCancela;
	}
	public void setMotivoCancela(String motivoCancela) {
		this.motivoCancela = motivoCancela;
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
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getAumentado() {
		return aumentado;
	}
	public void setAumentado(String aumentado) {
		this.aumentado = aumentado;
	}

	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getNombreProducto() {
		return nombreProducto;
	}
	public void setNombreProducto(String nombreProducto) {
		this.nombreProducto = nombreProducto;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getNombreEstatus() {
		return nombreEstatus;
	}
	public void setNombreEstatus(String nombreEstatus) {
		this.nombreEstatus = nombreEstatus;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getExcedente() {
		return excedente;
	}
	public void setExcedente(String excedente) {
		this.excedente = excedente;
	}
	public String getIdenCreditoCNBV() {
		return idenCreditoCNBV;
	}
	public void setIdenCreditoCNBV(String idenCreditoCNBV) {
		this.idenCreditoCNBV = idenCreditoCNBV;
	}
	public String getComisionAnual() {
		return comisionAnual;
	}
	public void setComisionAnual(String comisionAnual) {
		this.comisionAnual = comisionAnual;
	}
	public String getCobraComAnual() {
		return cobraComAnual;
	}
	public void setCobraComAnual(String cobraComAnual) {
		this.cobraComAnual = cobraComAnual;
	}
	public String getTipoComAnual() {
		return tipoComAnual;
	}
	public void setTipoComAnual(String tipoComAnual) {
		this.tipoComAnual = tipoComAnual;
	}
	public String getComisionCobrada() {
		return comisionCobrada;
	}
	public void setComisionCobrada(String comisionCobrada) {
		this.comisionCobrada = comisionCobrada;
	}
	public String getTipoLineaAgroID() {
		return tipoLineaAgroID;
	}
	public void setTipoLineaAgroID(String tipoLineaAgroID) {
		this.tipoLineaAgroID = tipoLineaAgroID;
	}
	public String getEsRevolvente() {
		return esRevolvente;
	}
	public void setEsRevolvente(String esRevolvente) {
		this.esRevolvente = esRevolvente;
	}
	public String getManejaComAdmon() {
		return manejaComAdmon;
	}
	public void setManejaComAdmon(String manejaComAdmon) {
		this.manejaComAdmon = manejaComAdmon;
	}
	public String getForCobComAdmon() {
		return forCobComAdmon;
	}
	public void setForCobComAdmon(String forCobComAdmon) {
		this.forCobComAdmon = forCobComAdmon;
	}
	public String getPorcentajeComAdmon() {
		return porcentajeComAdmon;
	}
	public void setPorcentajeComAdmon(String porcentajeComAdmon) {
		this.porcentajeComAdmon = porcentajeComAdmon;
	}
	public String getManejaComGarantia() {
		return manejaComGarantia;
	}
	public void setManejaComGarantia(String manejaComGarantia) {
		this.manejaComGarantia = manejaComGarantia;
	}
	public String getForCobComGarantia() {
		return forCobComGarantia;
	}
	public void setForCobComGarantia(String forCobComGarantia) {
		this.forCobComGarantia = forCobComGarantia;
	}
	public String getPorcentajeComGarantia() {
		return porcentajeComGarantia;
	}
	public void setPorcentajeComGarantia(String porcentajeComGarantia) {
		this.porcentajeComGarantia = porcentajeComGarantia;
	}
	public String getFechaRechazo() {
		return fechaRechazo;
	}
	public void setFechaRechazo(String fechaRechazo) {
		this.fechaRechazo = fechaRechazo;
	}
	public String getUsuarioRechazo() {
		return usuarioRechazo;
	}
	public void setUsuarioRechazo(String usuarioRechazo) {
		this.usuarioRechazo = usuarioRechazo;
	}
	public String getMontoUltimoIncremento() {
		return montoUltimoIncremento;
	}
	public void setMontoUltimoIncremento(String montoUltimoIncremento) {
		this.montoUltimoIncremento = montoUltimoIncremento;
	}
	public String getFechaReactivacion() {
		return fechaReactivacion;
	}
	public void setFechaReactivacion(String fechaReactivacion) {
		this.fechaReactivacion = fechaReactivacion;
	}
	public String getUsuarioReactivacion() {
		return usuarioReactivacion;
	}
	public void setUsuarioReactivacion(String usuarioReactivacion) {
		this.usuarioReactivacion = usuarioReactivacion;
	}
	public String getSaldoAtraso() {
		return saldoAtraso;
	}
	public void setSaldoAtraso(String saldoAtraso) {
		this.saldoAtraso = saldoAtraso;
	}
	public String getEsAgropecuario() {
		return esAgropecuario;
	}
	public void setEsAgropecuario(String esAgropecuario) {
		this.esAgropecuario = esAgropecuario;
	}
	public String getSaldoComAnual() {
		return saldoComAnual;
	}
	public void setSaldoComAnual(String saldoComAnual) {
		this.saldoComAnual = saldoComAnual;
	}
	public String getValorComAnual() {
		return valorComAnual;
	}
	public void setValorComAnual(String valorComAnual) {
		this.valorComAnual = valorComAnual;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getFechaNuevoVenci() {
		return fechaNuevoVenci;
	}
	public void setFechaNuevoVenci(String fechaNuevoVenci) {
		this.fechaNuevoVenci = fechaNuevoVenci;
	}
	public String getUltFechaDisposicion() {
		return ultFechaDisposicion;
	}
	public void setUltFechaDisposicion(String ultFechaDisposicion) {
		this.ultFechaDisposicion = ultFechaDisposicion;
	}
	public String getUltMontoDisposicion() {
		return ultMontoDisposicion;
	}
	public void setUltMontoDisposicion(String ultMontoDisposicion) {
		this.ultMontoDisposicion = ultMontoDisposicion;
	}
	public String getCobraTolPriDisposicion() {
		return cobraTolPriDisposicion;
	}
	public void setCobraTolPriDisposicion(String cobraTolPriDisposicion) {
		this.cobraTolPriDisposicion = cobraTolPriDisposicion;
	}
	public String getFechaCobroComision() {
		return fechaCobroComision;
	}
	public void setFechaCobroComision(String fechaCobroComision) {
		this.fechaCobroComision = fechaCobroComision;
	}
	public String getFechaProximoCobro() {
		return fechaProximoCobro;
	}
	public void setFechaProximoCobro(String fechaProximoCobro) {
		this.fechaProximoCobro = fechaProximoCobro;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}
	public String getClaveUsuario() {
		return claveUsuario;
	}
	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}
	
	
}
