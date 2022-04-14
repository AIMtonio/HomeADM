package cedes.bean;

import general.bean.BaseBean;

public class CedesAnclajeBean extends BaseBean{

	private String cedeAnclajeID;
	private String cedeOriID;
	private String cedeAncID;
	private Double montoTotal;
	private Double tasa;
	private String tasaBruta;
	private String fechaAnclaje;
	private String usuarioAncID;
	private String sucursalAncID;
	private Double tasaFija;
	private Double tasaCedeOr;
	
	private String cedeID;
	private String clienteID;
	private String cuentaAhoID;
	private String tipoCedeID;

	private String fechaInicio;
	private String fechaVencimiento;

	private String monto;
	private String montoAnclar;
	private String montOriginal;
	private String monedaID;
	private int	plazo;
	private String tasaOriginal;
	private String tasaISR;
	private String tasaNeta;
	private String interesGenerado;
	private String interesRecibir;
	private String interesRetener;
	private String nombreCliente;
	private String estatus;
	private String usuarioID;
	private String valorGat; //para nuevo campo en la pantalla donde se calcula el Gasto Anual Total para pantalla aperturaInversion.jsp
	private String valorGatReal;
	private String nombreCompleto;
	private String saldoProvision;
	private String descripcion;
	
	private String tasaBase;
	private String sobreTasa;
	private String techoTasa;
	private String pisoTasa;
	private String plazoInvOr;
	
	private String calculoInteresMa;
	private String sobreTasaOr;
	private String pisoTasaOr;
	private String techoTasaOr;
	private String calculoInteres;
	private String relaciones;
	private String plazoOriginal;
	
	private String nuevoInteresGen;
	private String nuevoInteresRec;
	private String granTotal;
	
	private String interesGeneradoOriginal;
	private String interesRecibirOriginal;
	private String interesRetenerOriginal;
	private String tasaBaseOriginal;
	private String nuevaTasa;
	
	public String getCedeAnclajeID() {
		return cedeAnclajeID;
	}
	public void setCedeAnclajeID(String cedeAnclajeID) {
		this.cedeAnclajeID = cedeAnclajeID;
	}
	public String getCedeOriID() {
		return cedeOriID;
	}
	public void setCedeOriID(String cedeOriID) {
		this.cedeOriID = cedeOriID;
	}
	public String getCedeAncID() {
		return cedeAncID;
	}
	public void setCedeAncID(String cedeAncID) {
		this.cedeAncID = cedeAncID;
	}
	public Double getMontoTotal() {
		return montoTotal;
	}
	public void setMontoTotal(Double montoTotal) {
		this.montoTotal = montoTotal;
	}
	public Double getTasa() {
		return tasa;
	}
	public void setTasa(Double tasa) {
		this.tasa = tasa;
	}
	public String getTasaBruta() {
		return tasaBruta;
	}
	public void setTasaBruta(String tasaBruta) {
		this.tasaBruta = tasaBruta;
	}
	public String getFechaAnclaje() {
		return fechaAnclaje;
	}
	public void setFechaAnclaje(String fechaAnclaje) {
		this.fechaAnclaje = fechaAnclaje;
	}
	public String getUsuarioAncID() {
		return usuarioAncID;
	}
	public void setUsuarioAncID(String usuarioAncID) {
		this.usuarioAncID = usuarioAncID;
	}
	public String getSucursalAncID() {
		return sucursalAncID;
	}
	public void setSucursalAncID(String sucursalAncID) {
		this.sucursalAncID = sucursalAncID;
	}
	public String getCedeID() {
		return cedeID;
	}
	public void setCedeID(String cedeID) {
		this.cedeID = cedeID;
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
	public String getTipoCedeID() {
		return tipoCedeID;
	}
	public void setTipoCedeID(String tipoCedeID) {
		this.tipoCedeID = tipoCedeID;
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
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getMontoAnclar() {
		return montoAnclar;
	}
	public void setMontoAnclar(String montoAnclar) {
		this.montoAnclar = montoAnclar;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public int getPlazo() {
		return plazo;
	}
	public void setPlazo(int plazo) {
		this.plazo = plazo;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getValorGat() {
		return valorGat;
	}
	public void setValorGat(String valorGat) {
		this.valorGat = valorGat;
	}
	public String getValorGatReal() {
		return valorGatReal;
	}
	public void setValorGatReal(String valorGatReal) {
		this.valorGatReal = valorGatReal;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getSaldoProvision() {
		return saldoProvision;
	}
	public void setSaldoProvision(String saldoProvision) {
		this.saldoProvision = saldoProvision;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public Double getTasaFija() {
		return tasaFija;
	}
	public void setTasaFija(Double tasaFija) {
		this.tasaFija = tasaFija;
	}
	public Double getTasaCedeOr() {
		return tasaCedeOr;
	}
	public void setTasaCedeOr(Double tasaCedeOr) {
		this.tasaCedeOr = tasaCedeOr;
	}
	public String getMontOriginal() {
		return montOriginal;
	}
	public void setMontOriginal(String montOriginal) {
		this.montOriginal = montOriginal;
	}
	public String getCalculoInteresMa() {
		return calculoInteresMa;
	}
	public void setCalculoInteresMa(String calculoInteresMa) {
		this.calculoInteresMa = calculoInteresMa;
	}
	public String getSobreTasaOr() {
		return sobreTasaOr;
	}
	public void setSobreTasaOr(String sobreTasaOr) {
		this.sobreTasaOr = sobreTasaOr;
	}
	public String getPisoTasaOr() {
		return pisoTasaOr;
	}
	public void setPisoTasaOr(String pisoTasaOr) {
		this.pisoTasaOr = pisoTasaOr;
	}
	public String getTechoTasaOr() {
		return techoTasaOr;
	}
	public void setTechoTasaOr(String techoTasaOr) {
		this.techoTasaOr = techoTasaOr;
	}
	public void setCalculoInteres(String calculoInteres) {
		this.calculoInteres = calculoInteres;
	}
	public String getCalculoInteres() {
		return calculoInteres;
	}
	public String getTasaOriginal() {
		return tasaOriginal;
	}
	public void setTasaOriginal(String tasaOriginal) {
		this.tasaOriginal = tasaOriginal;
	}
	public String getTasaISR() {
		return tasaISR;
	}
	public void setTasaISR(String tasaISR) {
		this.tasaISR = tasaISR;
	}
	public String getTasaNeta() {
		return tasaNeta;
	}
	public void setTasaNeta(String tasaNeta) {
		this.tasaNeta = tasaNeta;
	}
	public String getInteresGenerado() {
		return interesGenerado;
	}
	public void setInteresGenerado(String interesGenerado) {
		this.interesGenerado = interesGenerado;
	}
	public String getInteresRecibir() {
		return interesRecibir;
	}
	public void setInteresRecibir(String interesRecibir) {
		this.interesRecibir = interesRecibir;
	}
	public String getInteresRetener() {
		return interesRetener;
	}
	public void setInteresRetener(String interesRetener) {
		this.interesRetener = interesRetener;
	}
	public String getTasaBase() {
		return tasaBase;
	}
	public void setTasaBase(String tasaBase) {
		this.tasaBase = tasaBase;
	}
	public String getSobreTasa() {
		return sobreTasa;
	}
	public void setSobreTasa(String sobreTasa) {
		this.sobreTasa = sobreTasa;
	}
	public String getTechoTasa() {
		return techoTasa;
	}
	public void setTechoTasa(String techoTasa) {
		this.techoTasa = techoTasa;
	}
	public String getPisoTasa() {
		return pisoTasa;
	}
	public void setPisoTasa(String pisoTasa) {
		this.pisoTasa = pisoTasa;
	}
	public String getPlazoInvOr() {
		return plazoInvOr;
	}
	public void setPlazoInvOr(String plazoInvOr) {
		this.plazoInvOr = plazoInvOr;
	}
	public String getRelaciones() {
		return relaciones;
	}
	public void setRelaciones(String relaciones) {
		this.relaciones = relaciones;
	}
	public String getPlazoOriginal() {
		return plazoOriginal;
	}
	public void setPlazoOriginal(String plazoOriginal) {
		this.plazoOriginal = plazoOriginal;
	}
	public String getNuevoInteresGen() {
		return nuevoInteresGen;
	}
	public void setNuevoInteresGen(String nuevoInteresGen) {
		this.nuevoInteresGen = nuevoInteresGen;
	}
	public String getNuevoInteresRec() {
		return nuevoInteresRec;
	}
	public void setNuevoInteresRec(String nuevoInteresRec) {
		this.nuevoInteresRec = nuevoInteresRec;
	}
	public String getGranTotal() {
		return granTotal;
	}
	public void setGranTotal(String granTotal) {
		this.granTotal = granTotal;
	}
	public String getInteresGeneradoOriginal() {
		return interesGeneradoOriginal;
	}
	public void setInteresGeneradoOriginal(String interesGeneradoOriginal) {
		this.interesGeneradoOriginal = interesGeneradoOriginal;
	}
	public String getInteresRecibirOriginal() {
		return interesRecibirOriginal;
	}
	public void setInteresRecibirOriginal(String interesRecibirOriginal) {
		this.interesRecibirOriginal = interesRecibirOriginal;
	}
	public String getTasaBaseOriginal() {
		return tasaBaseOriginal;
	}
	public void setTasaBaseOriginal(String tasaBaseOriginal) {
		this.tasaBaseOriginal = tasaBaseOriginal;
	}
	public String getNuevaTasa() {
		return nuevaTasa;
	}
	public void setNuevaTasa(String nuevaTasa) {
		this.nuevaTasa = nuevaTasa;
	}
	public String getInteresRetenerOriginal() {
		return interesRetenerOriginal;
	}
	public void setInteresRetenerOriginal(String interesRetenerOriginal) {
		this.interesRetenerOriginal = interesRetenerOriginal;
	}
	 
}
