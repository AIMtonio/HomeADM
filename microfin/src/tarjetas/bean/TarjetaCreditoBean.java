package tarjetas.bean;

import general.bean.BaseBean;
public class TarjetaCreditoBean extends BaseBean{

    
    private String tarjetaCredID;
    private String tarjetaID;
	private String lotecreditoID;
	private String fechaRegistro;
	private String fechaVencimiento;
	private String fechaActivacion;
	private String estatus;
	private String clienteID;
	private String lineaTarCredID;
	private String fechaBloqueo;
	private String motivoBloqueo;
	private String fechaCancelacion;
	private String motivoCancelacion;
	private String fechaDesbloqueo;
	private String motivoDesbloqueo;
	private String NIP;
	private String nombreTarjeta;
	private String Relacion;
	private String sucursalID;
	private String tipoTarjetaCredID;
	private String noDispoDiario;
	private String noDispoMes;
	private String montoDispoDiario;
	private String montoDispoMes;
	private String noConsultaSaldoMes;
	private String noCompraDiario;
	private String noCompraMes;
	private String montoCompraDiario;
	private String montoCompraMes;
	private String pagoComAnual;
	private String fPagoComAnual;
	private String tipoCobro;
	private String descripcionProd;
	private String productoID;
	
	// para el bloqueo de  tarjeta

	private String tarjetaHabiente;    //Numero de Cliente asignado a la tarjeta
	private String coorporativo;      // Id del corporativo del cliente
	private String motivoBloqID; 
	private String descripcion;      // Descripcion adicional
	private String nombreComp;
	private String estatusId;
	private String corpRelacionado;
	private String loteDebitoID;
	private String descriBloqueo;
	private String tipo;
	
	
	// PARA LA CONSULTA DE TARJETA
	private String nombreCompleto;    //Numero de Cliente asignado a la tarjeta
	private String lineaCreditoID;      // Id del corporativo del cliente
	private String tipoCuentaID; 
	private String tipoTarjetaID; 
	private String nombre;
	private String clasificacion;
	private String razonSocial;
	private String tipoTarjetaDebID;
	private String clienteCorporativo;
	private String tarjetaDebID;
	
	// PARA MOVIMIENTOS DE LA TARJETA
	private String identificacionSocio;
		
	// PARA REPORTE DE BLOQUEO O DESBLOQUEO
	private String fechaEmision;
	private String nombreUsuario;
	private String montoComision;

	private String fecha;
	private String depositante;
	private String alias;
	private String identificador;
	private String clabe;
	private String cantidad;
	private String correo;
	private String divisa;
	private String numTransaccion;
	
	
	// PARA LA SOLICITUD DE TARJETA DE CREDITO NUEVO O REPOSICION
	private String nombreInstitucion;
	
	public String getTarjetaCredID() {
		return tarjetaCredID;
	}
	public void setTarjetaCredID(String tarjetaCredID) {
		this.tarjetaCredID = tarjetaCredID;
	}
	public String getLotecreditoID() {
		return lotecreditoID;
	}
	public void setLotecreditoID(String lotecreditoID) {
		this.lotecreditoID = lotecreditoID;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getFechaActivacion() {
		return fechaActivacion;
	}
	public void setFechaActivacion(String fechaActivacion) {
		this.fechaActivacion = fechaActivacion;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getLineaTarCredID() {
		return lineaTarCredID;
	}
	public void setLineaTarCredID(String lineaTarCredID) {
		this.lineaTarCredID = lineaTarCredID;
	}
	public String getFechaBloqueo() {
		return fechaBloqueo;
	}
	public void setFechaBloqueo(String fechaBloqueo) {
		this.fechaBloqueo = fechaBloqueo;
	}
	public String getMotivoBloqueo() {
		return motivoBloqueo;
	}
	public void setMotivoBloqueo(String motivoBloqueo) {
		this.motivoBloqueo = motivoBloqueo;
	}
	public String getFechaCancelacion() {
		return fechaCancelacion;
	}
	public void setFechaCancelacion(String fechaCancelacion) {
		this.fechaCancelacion = fechaCancelacion;
	}
	public String getMotivoCancelacion() {
		return motivoCancelacion;
	}
	public void setMotivoCancelacion(String motivoCancelacion) {
		this.motivoCancelacion = motivoCancelacion;
	}
	public String getFechaDesbloqueo() {
		return fechaDesbloqueo;
	}
	public void setFechaDesbloqueo(String fechaDesbloqueo) {
		this.fechaDesbloqueo = fechaDesbloqueo;
	}
	public String getMotivoDesbloqueo() {
		return motivoDesbloqueo;
	}
	public void setMotivoDesbloqueo(String motivoDesbloqueo) {
		this.motivoDesbloqueo = motivoDesbloqueo;
	}
	public String getNIP() {
		return NIP;
	}
	public void setNIP(String nIP) {
		NIP = nIP;
	}
	public String getNombreTarjeta() {
		return nombreTarjeta;
	}
	public void setNombreTarjeta(String nombreTarjeta) {
		this.nombreTarjeta = nombreTarjeta;
	}
	public String getRelacion() {
		return Relacion;
	}
	public void setRelacion(String relacion) {
		Relacion = relacion;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getTipoTarjetaCredID() {
		return tipoTarjetaCredID;
	}
	public void setTipoTarjetaCredID(String tipoTarjetaCredID) {
		this.tipoTarjetaCredID = tipoTarjetaCredID;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getNoDispoDiario() {
		return noDispoDiario;
	}
	public void setNoDispoDiario(String noDispoDiario) {
		this.noDispoDiario = noDispoDiario;
	}
	public String getNoDispoMes() {
		return noDispoMes;
	}
	public void setNoDispoMes(String noDispoMes) {
		this.noDispoMes = noDispoMes;
	}
	public String getMontoDispoDiario() {
		return montoDispoDiario;
	}
	public void setMontoDispoDiario(String montoDispoDiario) {
		this.montoDispoDiario = montoDispoDiario;
	}
	public String getMontoDispoMes() {
		return montoDispoMes;
	}
	public void setMontoDispoMes(String montoDispoMes) {
		this.montoDispoMes = montoDispoMes;
	}
	public String getNoConsultaSaldoMes() {
		return noConsultaSaldoMes;
	}
	public void setNoConsultaSaldoMes(String noConsultaSaldoMes) {
		this.noConsultaSaldoMes = noConsultaSaldoMes;
	}
	public String getNoCompraDiario() {
		return noCompraDiario;
	}
	public void setNoCompraDiario(String noCompraDiario) {
		this.noCompraDiario = noCompraDiario;
	}
	public String getNoCompraMes() {
		return noCompraMes;
	}
	public void setNoCompraMes(String noCompraMes) {
		this.noCompraMes = noCompraMes;
	}
	public String getMontoCompraDiario() {
		return montoCompraDiario;
	}
	public void setMontoCompraDiario(String montoCompraDiario) {
		this.montoCompraDiario = montoCompraDiario;
	}
	public String getMontoCompraMes() {
		return montoCompraMes;
	}
	public void setMontoCompraMes(String montoCompraMes) {
		this.montoCompraMes = montoCompraMes;
	}
	public String getPagoComAnual() {
		return pagoComAnual;
	}
	public void setPagoComAnual(String pagoComAnual) {
		this.pagoComAnual = pagoComAnual;
	}
	public String getfPagoComAnual() {
		return fPagoComAnual;
	}
	public void setfPagoComAnual(String fPagoComAnual) {
		this.fPagoComAnual = fPagoComAnual;
	}
	public String getTipoCobro() {
		return tipoCobro;
	}
	public void setTipoCobro(String tipoCobro) {
		this.tipoCobro = tipoCobro;
	}
	public String getTarjetaHabiente() {
		return tarjetaHabiente;
	}
	public void setTarjetaHabiente(String tarjetaHabiente) {
		this.tarjetaHabiente = tarjetaHabiente;
	}
	public String getCoorporativo() {
		return coorporativo;
	}
	public void setCoorporativo(String coorporativo) {
		this.coorporativo = coorporativo;
	}
	public String getMotivoBloqID() {
		return motivoBloqID;
	}
	public void setMotivoBloqID(String motivoBloqID) {
		this.motivoBloqID = motivoBloqID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getNombreComp() {
		return nombreComp;
	}
	public void setNombreComp(String nombreComp) {
		this.nombreComp = nombreComp;
	}
	public String getEstatusId() {
		return estatusId;
	}
	public void setEstatusId(String estatusId) {
		this.estatusId = estatusId;
	}
	public String getLoteDebitoID() {
		return loteDebitoID;
	}
	public void setLoteDebitoID(String loteDebitoID) {
		this.loteDebitoID = loteDebitoID;
	}
	public String getDescriBloqueo() {
		return descriBloqueo;
	}
	public void setDescriBloqueo(String descriBloqueo) {
		this.descriBloqueo = descriBloqueo;
	}
	public String getTarjetaID() {
		return tarjetaID;
	}
	public void setTarjetaID(String tarjetaID) {
		this.tarjetaID = tarjetaID;
	}
	public String getCorpRelacionado() {
		return corpRelacionado;
	}
	public void setCorpRelacionado(String corpRelacionado) {
		this.corpRelacionado = corpRelacionado;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getLineaCreditoID() {
		return lineaCreditoID;
	}
	public void setLineaCreditoID(String lineaCreditoID) {
		this.lineaCreditoID = lineaCreditoID;
	}
	public String getTipoCuentaID() {
		return tipoCuentaID;
	}
	public void setTipoCuentaID(String tipoCuentaID) {
		this.tipoCuentaID = tipoCuentaID;
	}
	public String getTipoTarjetaID() {
		return tipoTarjetaID;
	}
	public void setTipoTarjetaID(String tipoTarjetaID) {
		this.tipoTarjetaID = tipoTarjetaID;
	}
	public String getIdentificacionSocio() {
		return identificacionSocio;
	}
	public void setIdentificacionSocio(String identificacionSocio) {
		this.identificacionSocio = identificacionSocio;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}

	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getClasificacion() {
		return clasificacion;
	}
	public void setClasificacion(String clasificacion) {
		this.clasificacion = clasificacion;
	}
	public String getRazonSocial() {
		return razonSocial;
	}
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}
	public String getTipoTarjetaDebID() {
		return tipoTarjetaDebID;
	}
	public void setTipoTarjetaDebID(String tipoTarjetaDebID) {
		this.tipoTarjetaDebID = tipoTarjetaDebID;
	}
	public String getClienteCorporativo() {
		return clienteCorporativo;
	}
	public void setClienteCorporativo(String clienteCorporativo) {
		this.clienteCorporativo = clienteCorporativo;
	}
	public String getTarjetaDebID() {
		return tarjetaDebID;
	}
	public void setTarjetaDebID(String tarjetaDebID) {
		this.tarjetaDebID = tarjetaDebID;
	}
	public String getMontoComision() {
		return montoComision;
	}
	public void setMontoComision(String montoComision) {
		this.montoComision = montoComision;
	}
	public String getDescripcionProd() {
		return descripcionProd;
	}
	public void setDescripcionProd(String descripcionProd) {
		this.descripcionProd = descripcionProd;
	}
	public String getProductoID() {
		return productoID;
	}
	public void setProductoID(String productoID) {
		this.productoID = productoID;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getDepositante() {
		return depositante;
	}
	public void setDepositante(String depositante) {
		this.depositante = depositante;
	}
	public String getAlias() {
		return alias;
	}
	public void setAlias(String alias) {
		this.alias = alias;
	}
	public String getIdentificador() {
		return identificador;
	}
	public void setIdentificador(String identificador) {
		this.identificador = identificador;
	}
	public String getClabe() {
		return clabe;
	}
	public void setClabe(String clabe) {
		this.clabe = clabe;
	}
	public String getCantidad() {
		return cantidad;
	}
	public void setCantidad(String cantidad) {
		this.cantidad = cantidad;
	}
	public String getCorreo() {
		return correo;
	}
	public void setCorreo(String correo) {
		this.correo = correo;
	}
	public String getDivisa() {
		return divisa;
	}
	public void setDivisa(String divisa) {
		this.divisa = divisa;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}

	
	
	
}