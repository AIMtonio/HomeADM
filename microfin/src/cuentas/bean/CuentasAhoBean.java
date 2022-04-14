package cuentas.bean;

import general.bean.BaseBean;

public class CuentasAhoBean extends BaseBean {
	//Declaracion de Constantes
	public static int LONGITUD_ID = 11;
	
	// Auxiliares del Bean
	private String mes;
	private String anio;
		
	private String cuentaAhoID;
	private String sucursalID;
	private String clienteID;		
	private String clabe;
	private String monedaID;
	
	private String tipoCuentaID;
	private String fechaReg;			
	private String fechaApertura;		
	private String usuarioApeID; 
	private String etiqueta;
	
	private String fechaCan;			
	private String motivoCan;
	private String usuarioCanID; 
	private String motivoBlo;
	private String usuarioBloID;
	
	private String fechaBlo;
	private String motivoDesbloq;
	private String fechaDesbloq;
	private String usuarioDesbID;
	private String saldoDispon;	
	
	private String saldoIniMes;
	private String cargosMes;		
	private String abonosMes;		
	private String comisiones;
	private String saldoProm;	
	
	private String tasaInteres;	
	private String interesesGen;
	private String ISR;			
	private String tasaISR;		
	private String saldoIniDia;
	
	private String cargosDia;		
	private String abonosDia;		
	private String estatus;
	private String estadoCta;
	private String institucionID;
	private String saldo;
	private String saldoSBC;
	private String saldoBloq;
	private String esPrincipal;
	private String descripcionMoneda;
	private String descripcionTipoCta;
	private String tipoPersona;
	private String sumCanPenAct;
	private String gat;
	private String valorGatReal;
	
	private String codigoRespuesta;
	private String mensajeRespuesta;
	private String cuentaOrigen;
	private String cuentaDestino;
	private String monto;
	private String referencia;
	private String nombreCompleto;
	private String telefonoCelular;
	private String montoComision;
	private String comisionCubierta;
	private String ivaComision;
	private String ivaComCubierta;
	
	
	//Auxiliares
	private String lisTipoCuentas;
	private String nombreSucursal;
	
	
	// atributos para WS
	private String saldoMax;
	private String saldoMin;
	private String permiteAbo;
	
	private String fechaNacimiento;

	// Auxiliares para alidaciones de Limite de Depositos y Saldo
	private String montoMovimiento;
	private String fechaMovimento;
	private String numMensaje;
	private String mensaje;
	private String grabaLimite;
	private int motivoLimite;
	private String descripcionLimite;
	private String canal;
	
	private String descripCortaMon;
	private String totalPersonas;
	
	private String tasaRendimiento;
	private String transaccionID;
	private String saldoPendiente;

	private String montoDepositoActiva;
	private String estatusDepositoActiva;
	private String polizaID;
	
	public String getFechaNacimiento() {
		return fechaNacimiento;
	}
	public void setFechaNacimiento(String fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}
	public String getGat() {
		return gat;
	}
	public void setGat(String gat) {
		this.gat = gat;
	}
	public String getSaldoBloq() {
		return saldoBloq;
	}
	public void setSaldoBloq(String saldoBloq) {
		this.saldoBloq = saldoBloq;
	}
	public static int getLONGITUD_ID() {
		return LONGITUD_ID;
	}
	public static void setLONGITUD_ID(int lONGITUD_ID) {
		LONGITUD_ID = lONGITUD_ID;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getClabe() {
		return clabe;
	}
	public void setClabe(String clabe) {
		this.clabe = clabe;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getTipoCuentaID() {
		return tipoCuentaID;
	}
	public void setTipoCuentaID(String tipoCuentaID) {
		this.tipoCuentaID = tipoCuentaID;
	}
	public String getFechaReg() {
		return fechaReg;
	}
	public void setFechaReg(String fechaReg) {
		this.fechaReg = fechaReg;
	}
	public String getFechaApertura() {
		return fechaApertura;
	}
	public void setFechaApertura(String fechaApertura) {
		this.fechaApertura = fechaApertura;
	}
	public String getUsuarioApeID() {
		return usuarioApeID;
	}
	public void setUsuarioApeID(String usuarioApeID) {
		this.usuarioApeID = usuarioApeID;
	}
	public String getEtiqueta() {
		return etiqueta;
	}
	public void setEtiqueta(String etiqueta) {
		this.etiqueta = etiqueta;
	}
	public String getFechaCan() {
		return fechaCan;
	}
	public void setFechaCan(String fechaCan) {
		this.fechaCan = fechaCan;
	}
	public String getMotivoCan() {
		return motivoCan;
	}
	public void setMotivoCan(String motivoCan) {
		this.motivoCan = motivoCan;
	}
	public String getUsuarioCanID() {
		return usuarioCanID;
	}
	public void setUsuarioCanID(String usuarioCanID) {
		this.usuarioCanID = usuarioCanID;
	}
	public String getMotivoBlo() {
		return motivoBlo;
	}
	public void setMotivoBlo(String motivoBlo) {
		this.motivoBlo = motivoBlo;
	}
	public String getUsuarioBloID() {
		return usuarioBloID;
	}
	public void setUsuarioBloID(String usuarioBloID) {
		this.usuarioBloID = usuarioBloID;
	}
	public String getFechaBlo() {
		return fechaBlo;
	}
	public void setFechaBlo(String fechaBlo) {
		this.fechaBlo = fechaBlo;
	}
	public String getMotivoDesbloq() {
		return motivoDesbloq;
	}
	public void setMotivoDesbloq(String motivoDesbloq) {
		this.motivoDesbloq = motivoDesbloq;
	}
	public String getFechaDesbloq() {
		return fechaDesbloq;
	}
	public void setFechaDesbloq(String fechaDesbloq) {
		this.fechaDesbloq = fechaDesbloq;
	}
	public String getUsuarioDesbID() {
		return usuarioDesbID;
	}
	public void setUsuarioDesbID(String usuarioDesbID) {
		this.usuarioDesbID = usuarioDesbID;
	}
	public String getSaldoDispon() {
		return saldoDispon;
	}
	public void setSaldoDispon(String saldoDispon) {
		this.saldoDispon = saldoDispon;
	}
	public String getSaldoIniMes() {
		return saldoIniMes;
	}
	public void setSaldoIniMes(String saldoIniMes) {
		this.saldoIniMes = saldoIniMes;
	}
	public String getCargosMes() {
		return cargosMes;
	}
	public void setCargosMes(String cargosMes) {
		this.cargosMes = cargosMes;
	}
	public String getAbonosMes() {
		return abonosMes;
	}
	public void setAbonosMes(String abonosMes) {
		this.abonosMes = abonosMes;
	}
	public String getComisiones() {
		return comisiones;
	}
	public void setComisiones(String comisiones) {
		this.comisiones = comisiones;
	}
	public String getSaldoProm() {
		return saldoProm;
	}
	public void setSaldoProm(String saldoProm) {
		this.saldoProm = saldoProm;
	}
	public String getTasaInteres() {
		return tasaInteres;
	}
	public void setTasaInteres(String tasaInteres) {
		this.tasaInteres = tasaInteres;
	}
	public String getInteresesGen() {
		return interesesGen;
	}
	public void setInteresesGen(String interesesGen) {
		this.interesesGen = interesesGen;
	}
	public String getISR() {
		return ISR;
	}
	public void setISR(String iSR) {
		ISR = iSR;
	}
	public String getTasaISR() {
		return tasaISR;
	}
	public void setTasaISR(String tasaISR) {
		this.tasaISR = tasaISR;
	}
	public String getSaldoIniDia() {
		return saldoIniDia;
	}
	public void setSaldoIniDia(String saldoIniDia) {
		this.saldoIniDia = saldoIniDia;
	}
	public String getCargosDia() {
		return cargosDia;
	}
	public void setCargosDia(String cargosDia) {
		this.cargosDia = cargosDia;
	}
	public String getAbonosDia() {
		return abonosDia;
	}
	public void setAbonosDia(String abonosDia) {
		this.abonosDia = abonosDia;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getEstadoCta() {
		return estadoCta;
	}
	public void setEstadoCta(String estadoCta) {
		this.estadoCta = estadoCta;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getSaldo() {
		return saldo;
	}
	public void setSaldo(String saldo) {
		this.saldo = saldo;
	}
	public String getSaldoSBC() {
		return saldoSBC;
	}
	public void setSaldoSBC(String saldoSBC) {
		this.saldoSBC = saldoSBC;
	}
	public String getEsPrincipal() {
		return esPrincipal;
	}
	public void setEsPrincipal(String esPrincipal) {
		this.esPrincipal = esPrincipal;
	}
	public String getDescripcionMoneda() {
		return descripcionMoneda;
	}
	public void setDescripcionMoneda(String descripcionMoneda) {
		this.descripcionMoneda = descripcionMoneda;
	}
	public String getDescripcionTipoCta() {
		return descripcionTipoCta;
	}
	public void setDescripcionTipoCta(String descripcionTipoCta) {
		this.descripcionTipoCta = descripcionTipoCta;
	}	
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getMes() {
		return mes;
	}
	public void setMes(String mes) {
		this.mes = mes;
	}
	public String getAnio() {
		return anio;
	}
	public void setAnio(String anio) {
		this.anio = anio;
	}
	public String getSumCanPenAct() {
		return sumCanPenAct;
	}
	public void setSumCanPenAct(String sumCanPenAct) {
		this.sumCanPenAct = sumCanPenAct;
	}
	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}
	public String getMensajeRespuesta() {
		return mensajeRespuesta;
	}
	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}
	public void setMensajeRespuesta(String mensajeRespuesta) {
		this.mensajeRespuesta = mensajeRespuesta;
	}
	public String getCuentaOrigen() {
		return cuentaOrigen;
	}
	public String getCuentaDestino() {
		return cuentaDestino;
	}
	public String getMonto() {
		return monto;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setCuentaOrigen(String cuentaOrigen) {
		this.cuentaOrigen = cuentaOrigen;
	}
	public void setCuentaDestino(String cuentaDestino) {
		this.cuentaDestino = cuentaDestino;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getLisTipoCuentas() {
		return lisTipoCuentas;
	}
	public void setLisTipoCuentas(String lisTipoCuentas) {
		this.lisTipoCuentas = lisTipoCuentas;
	}
	public String getSaldoMax() {
		return saldoMax;
	}
	public String getSaldoMin() {
		return saldoMin;
	}
	public String getPermiteAbo() {
		return permiteAbo;
	}
	public void setSaldoMax(String saldoMax) {
		this.saldoMax = saldoMax;
	}
	public void setSaldoMin(String saldoMin) {
		this.saldoMin = saldoMin;
	}
	public void setPermiteAbo(String permiteAbo) {
		this.permiteAbo = permiteAbo;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getValorGatReal() {
		return valorGatReal;
	}
	public void setValorGatReal(String valorGatReal) {
		this.valorGatReal = valorGatReal;
	}
	public String getTelefonoCelular() {
		return telefonoCelular;
	}
	public void setTelefonoCelular(String telefonoCelular) {
		this.telefonoCelular = telefonoCelular;
	}
	public String getMontoComision() {
		return montoComision;
	}
	public void setMontoComision(String montoComision) {
		this.montoComision = montoComision;
	}
	public String getComisionCubierta() {
		return comisionCubierta;
	}
	public void setComisionCubierta(String comisionCubierta) {
		this.comisionCubierta = comisionCubierta;
	}
	public String getIvaComision() {
		return ivaComision;
	}
	public void setIvaComision(String ivaComision) {
		this.ivaComision = ivaComision;
	}
	public String getIvaComCubierta() {
		return ivaComCubierta;
	}
	public void setIvaComCubierta(String ivaComCubierta) {
		this.ivaComCubierta = ivaComCubierta;
	}
	public String getMontoMovimiento() {
		return montoMovimiento;
	}
	public void setMontoMovimiento(String montoMovimiento) {
		this.montoMovimiento = montoMovimiento;
	}
	public String getFechaMovimento() {
		return fechaMovimento;
	}
	public void setFechaMovimento(String fechaMovimento) {
		this.fechaMovimento = fechaMovimento;
	}
	public String getNumMensaje() {
		return numMensaje;
	}
	public void setNumMensaje(String numMensaje) {
		this.numMensaje = numMensaje;
	}
	public String getMensaje() {
		return mensaje;
	}
	public void setMensaje(String mensaje) {
		this.mensaje = mensaje;
	}
	public String getGrabaLimite() {
		return grabaLimite;
	}
	public void setGrabaLimite(String grabaLimite) {
		this.grabaLimite = grabaLimite;
	}
	public int getMotivoLimite() {
		return motivoLimite;
	}
	public void setMotivoLimite(int motivoLimite) {
		this.motivoLimite = motivoLimite;
	}
	public String getDescripcionLimite() {
		return descripcionLimite;
	}
	public void setDescripcionLimite(String descripcionLimite) {
		this.descripcionLimite = descripcionLimite;
	}
	public String getCanal() {
		return canal;
	}
	public void setCanal(String canal) {
		this.canal = canal;
	}
	public String getDescripCortaMon() {
		return descripCortaMon;
	}
	public void setDescripCortaMon(String descripCortaMon) {
		this.descripCortaMon = descripCortaMon;
	}
	public String getTotalPersonas() {
		return totalPersonas;
	}
	public void setTotalPersonas(String totalPersonas) {
		this.totalPersonas = totalPersonas;
	}
	public String getTasaRendimiento() {
		return tasaRendimiento;
	}
	public void setTasaRendimiento(String tasaRendimiento) {
		this.tasaRendimiento = tasaRendimiento;
	}
	public String getTransaccionID() {
		return transaccionID;
	}
	public void setTransaccionID(String transaccionID) {
		this.transaccionID = transaccionID;
	}
	public String getSaldoPendiente() {
		return saldoPendiente;
	}
	public void setSaldoPendiente(String saldoPendiente) {
		this.saldoPendiente = saldoPendiente;
	}
	public String getMontoDepositoActiva() {
		return montoDepositoActiva;
	}
	public void setMontoDepositoActiva(String montoDepositoActiva) {
		this.montoDepositoActiva = montoDepositoActiva;
	}
	public String getEstatusDepositoActiva() {
		return estatusDepositoActiva;
	}
	public void setEstatusDepositoActiva(String estatusDepositoActiva) {
		this.estatusDepositoActiva = estatusDepositoActiva;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
}