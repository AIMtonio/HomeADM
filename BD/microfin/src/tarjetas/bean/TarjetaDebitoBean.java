package tarjetas.bean;

import general.bean.BaseBean;
public class TarjetaDebitoBean extends BaseBean{

	private String tarjetaDebID;
	private String tarjetaID;
	private String nombre;
	private String tipo;
	private String corporativoID;
	private String corporativo;
	private String loteDebitoID;
	private String loteDebitoSAFIID;
	private String fechaRegistro;
	private String fechaVencimiento;
	private String fechaActivacion;
	private String fechaCancelacion;
	private String fechaBloqueo;
	private String fechaDesbloqueo;
	private String motivoCancelacion;
	private String descriCancela;
	private String usuarioCancelaID;
	private String estatus;
	private String clienteID;
	private String cuentaAhoID;
	private String tipoCobro;
	
	private String motivoBloqueo;
	private String motivoDesbloqueo;
	private String descriBloqueo;
	private String usuarioBloqueaID;
	private String nIP;
	private String nombreTarjeta;
	private String relacion;
	private String sucursalID;
	private String fechaUltimaOperacion;
	private String tipoTarjetaDebID;
	private String numero;
	
	private String catServiceCodeID;
	private String numeroServicio;
	private String esPersonalizado;
	private String esVirtual;
	

	private String clasificacion;
	private String corpRelacionado;
	private String clienteCorporativo;	  
	private String razonSocial;
	private String etiqueta;

	private String nombreCompleto;
	private String tipoCuentaID;
	private String identificacionSocio;
	
	
// para el bloqueo de  tarjeta

	private String tarjetaHabiente;    //Numero de Cliente asignado a la tarjeta
	private String coorporativo;              // Id del corporativo del cliente
	private String motivoBloqID;               // Motivo de Bloqueo
	private String descripcion;      // Descripcion adicional	 
	private String nombreComp;
	private String estatusId;
	
	private String fechaEmision;
	private String nombreUsuario;
	private String nombreInstitucion;
	private String montoComision;
	
	// para reporte
	private String fechaSistema;
	
	// Pago Anualidad 
	private String pagoComAnual;
	private String FPagoComAnual;
	private String comisionAnual;
	private String fechaProximoPag;
	private String desTipoCta;
	private String desTipoTarjeta;
	
	//lote
	private String sucursalSolicita;
	private String esAdicional;
	private String folioInicial;
	private String folioFinal;
	private String numTarjetas;
	private String usuarioID;
	private String nomArchiGen;
	private String rutaNomArch;
	private String numBIN;
	private String numSubBin;
	private String aliasSubBIN;
	
	private String urlCore;
	
	// tipo de tarjeta
	private int tipoTarjeta;
	
	
	// Asignacion de tarjeta de credito
	private String tipoCorte;
	private String tipoPago;
	private String diaCorte;
	private String diaPago;
	private String tarjetaCredID;
	private String cuentaClabe;
	
	// Web Service ISOTRX
	private String montoOperacion;
	private String tipoInstrumento;
	private String numeroInstrumento;
	
	public String getTarjetaDebID() {
		return tarjetaDebID;
	}
	public void setTarjetaDebID(String tarjetaDebID) {
		this.tarjetaDebID = tarjetaDebID;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
		public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getEtiqueta() {
		return etiqueta;
	}
	public void setEtiqueta(String etiqueta) {
		this.etiqueta = etiqueta;
	}
	public String getClasificacion() {
		return clasificacion;
	}
	public void setClasificacion(String clasificacion) {
		this.clasificacion = clasificacion;
	}
	public String getClienteCorporativo() {
		return clienteCorporativo;
	}
	public void setClienteCorporativo(String clienteCorporativo) {
		this.clienteCorporativo = clienteCorporativo;
	}
	public String getRazonSocial() {
		return razonSocial;
	}
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getCorporativoID() {
		return corporativoID;
	}
	public void setCorporativoID(String corporativoID) {
		this.corporativoID = corporativoID;
	}
	public String getCorporativo() {
		return corporativo;
	}
	public void setCorporativo(String corporativo) {
		this.corporativo = corporativo;
	}
	public String getLoteDebitoID() {
		return loteDebitoID;
	}
	public void setLoteDebitoID(String loteDebitoID) {
		this.loteDebitoID = loteDebitoID;
	}
	public String getLoteDebitoSAFIID() {
		return loteDebitoSAFIID;
	}
	public void setLoteDebitoSAFIID(String loteDebitoSAFIID) {
		this.loteDebitoSAFIID = loteDebitoSAFIID;
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
	public String getMotivoCancelacion() {
		return motivoCancelacion;
	}
	public void setMotivoCancelacion(String motivoCancelacion) {
		this.motivoCancelacion = motivoCancelacion;
	}
	public String getDescriCancela() {
		return descriCancela;
	}
	public void setDescriCancela(String descriCancela) {
		this.descriCancela = descriCancela;
	}
	public String getUsuarioCancelaID() {
		return usuarioCancelaID;
	}
	public void setUsuarioCancelaID(String usuarioCancelaID) {
		this.usuarioCancelaID = usuarioCancelaID;
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
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getMotivoBloqueo() {
		return motivoBloqueo;
	}
	public void setMotivoBloqueo(String motivoBloqueo) {
		this.motivoBloqueo = motivoBloqueo;
	}
	public String getMotivoDesbloqueo() {
		return motivoDesbloqueo;
	}
	public void setMotivoDesbloqueo(String motivoDesbloqueo) {
		this.motivoDesbloqueo = motivoDesbloqueo;
	}
	public String getDescriBloqueo() {
		return descriBloqueo;
	}
	public void setDescriBloqueo(String descriBloqueo) {
		this.descriBloqueo = descriBloqueo;
	}
	public String getUsuarioBloqueaID() {
		return usuarioBloqueaID;
	}
	public void setUsuarioBloqueaID(String usuarioBloqueaID) {
		this.usuarioBloqueaID = usuarioBloqueaID;
	}
	public String getnIP() {
		return nIP;
	}
	public void setnIP(String nIP) {
		this.nIP = nIP;
	}
	public String getNombreTarjeta() {
		return nombreTarjeta;
	}
	public void setNombreTarjeta(String nombreTarjeta) {
		this.nombreTarjeta = nombreTarjeta;
	}
	public String getRelacion() {
		return relacion;
	}
	public void setRelacion(String relacion) {
		this.relacion = relacion;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getFechaUltimaOperacion() {
		return fechaUltimaOperacion;
	}
	public void setFechaUltimaOperacion(String fechaUltimaOperacion) {
		this.fechaUltimaOperacion = fechaUltimaOperacion;
	}
	public String getTipoTarjetaDebID() {
		return tipoTarjetaDebID;
	}
	public void setTipoTarjetaDebID(String tipoTarjetaDebID) {
		this.tipoTarjetaDebID = tipoTarjetaDebID;
	}

	public String getTipoCuentaID() {
		return tipoCuentaID;
	}
	public void setTipoCuentaID(String tipoCuentaID) {
		this.tipoCuentaID = tipoCuentaID;		
	}

	public String getNumero() {
		return numero;
	}
	public void setNumero(String numero) {
		this.numero = numero;
	}
	public String getCatServiceCodeID() {
		return catServiceCodeID;
	}
	public void setCatServiceCodeID(String catServiceCodeID) {
		this.catServiceCodeID = catServiceCodeID;
	}
	public String getNumeroServicio() {
		return numeroServicio;
	}
	public void setNumeroServicio(String numeroServicio) {
		this.numeroServicio = numeroServicio;
	}
	public String getEsPersonalizado() {
		return esPersonalizado;
	}
	public void setEsPersonalizado(String esPersonalizado) {
		this.esPersonalizado = esPersonalizado;
	}
	public String getEsVirtual() {
		return esVirtual;
	}
	public void setEsVirtual(String esVirtual) {
		this.esVirtual = esVirtual;
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
	public String getEstatusId() {
		return estatusId;
	}
	public void setEstatusId(String estatusId) {
		this.estatusId = estatusId;
	}
	public String getNombreComp() {
		return nombreComp;
	}
	public void setNombreComp(String nombreComp) {
		this.nombreComp = nombreComp;
	}
	public String getCorpRelacionado() {
		return corpRelacionado;
	}
	public void setCorpRelacionado(String corpRelacionado) {
		this.corpRelacionado = corpRelacionado;
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
	public String getMontoComision() {
		return montoComision;
	}
	public void setMontoComision(String montoComision) {
		this.montoComision = montoComision;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getTipoCobro() {
		return tipoCobro;
	}
	public void setTipoCobro(String tipoCobro) {
		this.tipoCobro = tipoCobro;
	}
	public String getFPagoComAnual() {
		return FPagoComAnual;
	}
	public String getComisionAnual() {
		return comisionAnual;
	}
	public String getFechaProximoPag() {
		return fechaProximoPag;
	}
	public String getDesTipoCta() {
		return desTipoCta;
	}
	public String getDesTipoTarjeta() {
		return desTipoTarjeta;
	}
	public void setFPagoComAnual(String fPagoComAnual) {
		FPagoComAnual = fPagoComAnual;
	}
	public void setComisionAnual(String comisionAnual) {
		this.comisionAnual = comisionAnual;
	}
	public void setFechaProximoPag(String fechaProximoPag) {
		this.fechaProximoPag = fechaProximoPag;
	}
	public void setDesTipoCta(String desTipoCta) {
		this.desTipoCta = desTipoCta;
	}
	public void setDesTipoTarjeta(String desTipoTarjeta) {
		this.desTipoTarjeta = desTipoTarjeta;
	}
	public String getPagoComAnual() {
		return pagoComAnual;
	}
	public void setPagoComAnual(String pagoComAnual) {
		this.pagoComAnual = pagoComAnual;
	}
	public String getIdentificacionSocio() {
		return identificacionSocio;
	}
	public void setIdentificacionSocio(String identificacionSocio) {
		this.identificacionSocio = identificacionSocio;
	}
	public String getSucursalSolicita() {
		return sucursalSolicita;
	}
	public void setSucursalSolicita(String sucursalSolicita) {
		this.sucursalSolicita = sucursalSolicita;
	}
	public String getEsAdicional() {
		return esAdicional;
	}
	public void setEsAdicional(String esAdicional) {
		this.esAdicional = esAdicional;
	}
	public String getFolioFinal() {
		return folioFinal;
	}
	public void setFolioFinal(String folioFinal) {
		this.folioFinal = folioFinal;
	}
	public String getFolioInicial() {
		return folioInicial;
	}
	public void setFolioInicial(String folioInicial) {
		this.folioInicial = folioInicial;
	}
	public String getNumTarjetas() {
		return numTarjetas;
	}
	public void setNumTarjetas(String numTarjetas) {
		this.numTarjetas = numTarjetas;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getNomArchiGen() {
		return nomArchiGen;
	}
	public void setNomArchiGen(String nomArchiGen) {
		this.nomArchiGen = nomArchiGen;
	}
	public String getRutaNomArch() {
		return rutaNomArch;
	}
	public void setRutaNomArch(String rutaNomArch) {
		this.rutaNomArch = rutaNomArch;
	}
	public String getNumBIN() {
		return numBIN;
	}
	public void setNumBIN(String numBIN) {
		this.numBIN = numBIN;
	}
	public String getNumSubBin() {
		return numSubBin;
	}
	public void setNumSubBin(String numSubBin) {
		this.numSubBin = numSubBin;
	}
	public String getAliasSubBIN() {
		return aliasSubBIN;
	}
	public void setAliasSubBIN(String aliasSubBIN) {
		this.aliasSubBIN = aliasSubBIN;
	}
	public String getUrlCore() {
		return urlCore;
	}
	public void setUrlCore(String urlCore) {
		this.urlCore = urlCore;
	}
	public int getTipoTarjeta() {
		return tipoTarjeta;
	}
	public void setTipoTarjeta(int tipoTarjeta) {
		this.tipoTarjeta = tipoTarjeta;
	}
	public String getTarjetaID() {
		return tarjetaID;
	}
	public void setTarjetaID(String tarjetaID) {
		this.tarjetaID = tarjetaID;
	}
	public String getTipoCorte() {
		return tipoCorte;
	}
	public String getTipoPago() {
		return tipoPago;
	}
	public String getDiaCorte() {
		return diaCorte;
	}
	public String getDiaPago() {
		return diaPago;
	}
	public void setTipoCorte(String tipoCorte) {
		this.tipoCorte = tipoCorte;
	}
	public void setTipoPago(String tipoPago) {
		this.tipoPago = tipoPago;
	}
	public void setDiaCorte(String diaCorte) {
		this.diaCorte = diaCorte;
	}
	public void setDiaPago(String diaPago) {
		this.diaPago = diaPago;
	}
	public String getTarjetaCredID() {
		return tarjetaCredID;
	}
	public void setTarjetaCredID(String tarjetaCredID) {
		this.tarjetaCredID = tarjetaCredID;
	}
	public String getCuentaClabe() {
		return cuentaClabe;
	}
	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}
	public String getMontoOperacion() {
		return montoOperacion;
	}
	public void setMontoOperacion(String montoOperacion) {
		this.montoOperacion = montoOperacion;
	}
	public String getTipoInstrumento() {
		return tipoInstrumento;
	}
	public void setTipoInstrumento(String tipoInstrumento) {
		this.tipoInstrumento = tipoInstrumento;
	}
	public String getNumeroInstrumento() {
		return numeroInstrumento;
	}
	public void setNumeroInstrumento(String numeroInstrumento) {
		this.numeroInstrumento = numeroInstrumento;
	}
	
}