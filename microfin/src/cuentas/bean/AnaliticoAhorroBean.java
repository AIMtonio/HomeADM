package cuentas.bean;

import general.bean.BaseBean;

public class AnaliticoAhorroBean extends BaseBean{
	private String  clienteID;
	private String  cuentasAho ;
	private String  sucursal ;
	private String  monedaID ;
	private String  tipoCuentaID;
	private String  usuario;
	private String  promotorID; 
	private String  genero;
	private String  estadoID;
	private String  municipioID;
	private String  fechaEmision ;
	private String  sexo ;
	
	
	//Para la construccion de  DAO a Excel
	private String RFOficial;
	private String Etiqueta;
	private String Estatus;
	private String SaldoInicioMes;
	private String CargoEnMes;
	private String AbonoEnMes;
	private String SaldoAlDia;
	private String SaldoBloqueado;
	private String SaldoDisponible;
	private String Fecha;
	private String Hora;
	
	
	
	/// VALORES TEXTO
	private String  nombreCliente;
	private String  nombreSucursal ;
	private String  nombreMoneda ;
	private String  nombreTipocuenta;
	private String  nombreCuentaAho;
	private String  nombreUsuario; 
	private String  nombrePromotorI;
	private String  nombreGenero;
	private String  nombreEstado;
	private String  nombreMunicipio;	
	private String  nombreInstitucion ;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentasAho() {
		return cuentasAho;
	}
	public void setCuentasAho(String cuentasAho) {
		this.cuentasAho = cuentasAho;
	}
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
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
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getPromotorID() {
		return promotorID;
	}
	public void setPromotorID(String promotorID) {
		this.promotorID = promotorID;
	}
	public String getGenero() {
		return genero;
	}
	public void setGenero(String genero) {
		this.genero = genero;
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
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getNombreMoneda() {
		return nombreMoneda;
	}
	public void setNombreMoneda(String nombreMoneda) {
		this.nombreMoneda = nombreMoneda;
	}
	public String getNombreTipocuenta() {
		return nombreTipocuenta;
	}
	public void setNombreTipocuenta(String nombreTipocuenta) {
		this.nombreTipocuenta = nombreTipocuenta;
	}
	public String getNombreCuentaAho() {
		return nombreCuentaAho;
	}
	public void setNombreCuentaAho(String nombreCuentaAho) {
		this.nombreCuentaAho = nombreCuentaAho;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getNombrePromotorI() {
		return nombrePromotorI;
	}
	public void setNombrePromotorI(String nombrePromotorI) {
		this.nombrePromotorI = nombrePromotorI;
	}
	public String getNombreGenero() {
		return nombreGenero;
	}
	public void setNombreGenero(String nombreGenero) {
		this.nombreGenero = nombreGenero;
	}
	public String getNombreEstado() {
		return nombreEstado;
	}
	public void setNombreEstado(String nombreEstado) {
		this.nombreEstado = nombreEstado;
	}
	public String getNombreMunicipio() {
		return nombreMunicipio;
	}
	public void setNombreMunicipio(String nombreMunicipio) {
		this.nombreMunicipio = nombreMunicipio;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	} 
 ///bean para  DAO de  Analitico Ahorro
	public String getRFOficial() {
		return RFOficial;
	}
	public void setRFOficial(String rFOficial) {
		RFOficial = rFOficial;
	}
	public String getEtiqueta() {
		return Etiqueta;
	}
	public void setEtiqueta(String etiqueta) {
		Etiqueta = etiqueta;
	}
	public String getEstatus() {
		return Estatus;
	}
	public void setEstatus(String estatus) {
		Estatus = estatus;
	}
	public String getSaldoInicioMes() {
		return SaldoInicioMes;
	}
	public void setSaldoInicioMes(String saldoInicioMes) {
		SaldoInicioMes = saldoInicioMes;
	}
	public String getCargoEnMes() {
		return CargoEnMes;
	}
	public void setCargoEnMes(String cargoEnMes) {
		CargoEnMes = cargoEnMes;
	}
	public String getAbonoEnMes() {
		return AbonoEnMes;
	}
	public void setAbonoEnMes(String abonoEnMes) {
		AbonoEnMes = abonoEnMes;
	}
	public String getSaldoAlDia() {
		return SaldoAlDia;
	}
	public void setSaldoAlDia(String saldoAlDia) {
		SaldoAlDia = saldoAlDia;
	}
	public String getSaldoBloqueado() {
		return SaldoBloqueado;
	}
	public void setSaldoBloqueado(String saldoBloqueado) {
		SaldoBloqueado = saldoBloqueado;
	}
	public String getSaldoDisponible() {
		return SaldoDisponible;
	}
	public void setSaldoDisponible(String saldoDisponible) {
		SaldoDisponible = saldoDisponible;
	}
	
	public String getFecha() {
		return Fecha;
	}
	public void setFecha(String fecha) {
		Fecha = fecha;
	}
	public String getHora() {
		return Hora;
	}
	public void setHora(String hora) {
		Hora = hora;
	}
	public String getSexo() {
		return sexo;
	}
	public void setSexo(String sexo) {
		this.sexo = sexo;
	}


	}
