package credito.bean;

public class RepEstimacionesCredPrevBean {
	
	private String		creditoID;
	private String		clienteID;
	private String		nombreCompleto;
	private String		productoCreditoID;
	private String		descripcion;
	private String		fechaInicio;
	private String		fechaVencim;
	private String		capital;
	private String		interes;
	private String		diasAtraso;
	private String		calificacion;
	private String		porcReserva;
	private String		montoGarantia;
	private String		reserva;
	private String		reservaInteres;
	private String		totalReserva;
	private String 		subClasificacion;
	
	private String		sucursalID;
	private String		nombreSucursal;
	private String		promotorID;
	private String		NombrePromotor;
	private String		grupoID;
	private String		nombreGrupo;
	private String		monedaID;
	private String		sexo;
	private String		hora;

	private String 		reservaTotCubierto;
	private String 		reservaTotExpuesto;
	
	
	private String estatus;
	private String saldoInteresVencido;
	private String saldoInteresAnterior;
	private String esHipotecado;
	private String clasificacion;
	private String tipoCredito;
	
	// EPRC	
	private String PorcReservaCub;
	private String ZonaMarginada;
	private String MontoBaseEstCub; 
	private String MontoBaseEstExp;
	
	
	public String getSubClasificacion() {
		return subClasificacion;
	}
	public void setSubClasificacion(String subClasificacion) {
		this.subClasificacion = subClasificacion;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public String getProductoCreditoID() {
		return productoCreditoID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public String getFechaVencim() {
		return fechaVencim;
	}
	public String getCapital() {
		return capital;
	}
	public String getInteres() {
		return interes;
	}
	public String getDiasAtraso() {
		return diasAtraso;
	}
	public String getCalificacion() {
		return calificacion;
	}
	public String getPorcReserva() {
		return porcReserva;
	}
	public String getMontoGarantia() {
		return montoGarantia;
	}
	public String getReserva() {
		return reserva;
	}
	public String getReservaInteres() {
		return reservaInteres;
	}
	public String getTotalReserva() {
		return totalReserva;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public void setFechaVencim(String fechaVencim) {
		this.fechaVencim = fechaVencim;
	}
	public void setCapital(String capital) {
		this.capital = capital;
	}
	public void setInteres(String interes) {
		this.interes = interes;
	}
	public void setDiasAtraso(String diasAtraso) {
		this.diasAtraso = diasAtraso;
	}
	public void setCalificacion(String calificacion) {
		this.calificacion = calificacion;
	}
	public void setPorcReserva(String porcReserva) {
		this.porcReserva = porcReserva;
	}
	public void setMontoGarantia(String montoGarantia) {
		this.montoGarantia = montoGarantia;
	}
	public void setReserva(String reserva) {
		this.reserva = reserva;
	}
	public void setReservaInteres(String reservaInteres) {
		this.reservaInteres = reservaInteres;
	}
	public void setTotalReserva(String totalReserva) {
		this.totalReserva = totalReserva;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public String getPromotorID() {
		return promotorID;
	}
	public String getNombrePromotor() {
		return NombrePromotor;
	}
	public String getGrupoID() {
		return grupoID;
	}
	public String getNombreGrupo() {
		return nombreGrupo;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public String getSexo() {
		return sexo;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public void setPromotorID(String promotorID) {
		this.promotorID = promotorID;
	}
	public void setNombrePromotor(String nombrePromotor) {
		NombrePromotor = nombrePromotor;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public void setNombreGrupo(String nombreGrupo) {
		this.nombreGrupo = nombreGrupo;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public void setSexo(String sexo) {
		this.sexo = sexo;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getReservaTotCubierto() {
		return reservaTotCubierto;
	}
	public void setReservaTotCubierto(String reservaTotCubierto) {
		this.reservaTotCubierto = reservaTotCubierto;
	}
	public String getReservaTotExpuesto() {
		return reservaTotExpuesto;
	}
	public void setReservaTotExpuesto(String reservaTotExpuesto) {
		this.reservaTotExpuesto = reservaTotExpuesto;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getSaldoInteresVencido() {
		return saldoInteresVencido;
	}
	public void setSaldoInteresVencido(String saldoInteresVencido) {
		this.saldoInteresVencido = saldoInteresVencido;
	}
	public String getSaldoInteresAnterior() {
		return saldoInteresAnterior;
	}
	public void setSaldoInteresAnterior(String saldoInteresAnterior) {
		this.saldoInteresAnterior = saldoInteresAnterior;
	}
	public String getEsHipotecado() {
		return esHipotecado;
	}
	public void setEsHipotecado(String esHipotecado) {
		this.esHipotecado = esHipotecado;
	}
	public String getClasificacion() {
		return clasificacion;
	}
	public void setClasificacion(String clasificacion) {
		this.clasificacion = clasificacion;
	}
	public String getTipoCredito() {
		return tipoCredito;
	}
	public void setTipoCredito(String tipoCredito) {
		this.tipoCredito = tipoCredito;
	}
	public String getPorcReservaCub() {
		return PorcReservaCub;
	}
	public void setPorcReservaCub(String porcReservaCub) {
		PorcReservaCub = porcReservaCub;
	}
	public String getZonaMarginada() {
		return ZonaMarginada;
	}
	public void setZonaMarginada(String zonaMarginada) {
		ZonaMarginada = zonaMarginada;
	}
	public String getMontoBaseEstCub() {
		return MontoBaseEstCub;
	}
	public void setMontoBaseEstCub(String montoBaseEstCub) {
		MontoBaseEstCub = montoBaseEstCub;
	}
	public String getMontoBaseEstExp() {
		return MontoBaseEstExp;
	}
	public void setMontoBaseEstExp(String montoBaseEstExp) {
		MontoBaseEstExp = montoBaseEstExp;
	}
	
}
