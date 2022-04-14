package contabilidad.bean;

import general.bean.BaseBean;

public class ReporteAnexoYFapBean extends BaseBean {
	
	private String nombre;
	private String apellidoPat;
	private String apellidoMat;
	private String clienteID;
	private String numeroCuenta;

	private String tipoPersona;
	private String actividadEconomica;
	private String nacionalidad;
	private String fechaNac;
	private String RFC;

	private String CURP;		
	private String calle;
	private String numeroExt;
	private String coloniaID;
	private String codigoPostal;

	private String localidad;               
	private String municipioID;
	private String estadoID;
	private String codigoPais;
	private String direccion;

	private String telefonoCasa;
	private String telefonoOficina;
	private String telefonoCelular;
	private String telefonoLocalizacion;
	private String relacionLocalizacion;

	private String correo;             
	private String claveSucursal;
	private String nombreSucursal;
	private String direccionSucursal;
	private String clasfContable;

	private String tipoCuenta;
	private String numContrato;
	private String fechaContrato;
	private String fechaVencimiento;
	private String plazoDeposito;

	private String periodicidad;
	private String tasaPactada;
	private String fechaUltimoDeposito;
	private String saldoUltimoDepostito;
	private String porcFondoPro;

	private String saldoCapital;
	private String intDevNoPago;
	private String saldoFinal;
	private String fecha;
	
	private String valor;
	
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
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNumeroCuenta() {
		return numeroCuenta;
	}
	public void setNumeroCuenta(String numeroCuenta) {
		this.numeroCuenta = numeroCuenta;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getActividadEconomica() {
		return actividadEconomica;
	}
	public void setActividadEconomica(String actividadEconomica) {
		this.actividadEconomica = actividadEconomica;
	}
	public String getNacionalidad() {
		return nacionalidad;
	}
	public void setNacionalidad(String nacionalidad) {
		this.nacionalidad = nacionalidad;
	}
	public String getFechaNac() {
		return fechaNac;
	}
	public void setFechaNac(String fechaNac) {
		this.fechaNac = fechaNac;
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
	public String getCalle() {
		return calle;
	}
	public void setCalle(String calle) {
		this.calle = calle;
	}
	public String getNumeroExt() {
		return numeroExt;
	}
	public void setNumeroExt(String numeroExt) {
		this.numeroExt = numeroExt;
	}
	public String getColoniaID() {
		return coloniaID;
	}
	public void setColoniaID(String coloniaID) {
		this.coloniaID = coloniaID;
	}
	public String getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public String getLocalidad() {
		return localidad;
	}
	public void setLocalidad(String localidad) {
		this.localidad = localidad;
	}
	public String getMunicipioID() {
		return municipioID;
	}
	public void setMunicipioID(String municipioID) {
		this.municipioID = municipioID;
	}
	public String getEstadoID() {
		return estadoID;
	}
	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
	}
	public String getCodigoPais() {
		return codigoPais;
	}
	public void setCodigoPais(String codigoPais) {
		this.codigoPais = codigoPais;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public String getTelefonoCasa() {
		return telefonoCasa;
	}
	public void setTelefonoCasa(String telefonoCasa) {
		this.telefonoCasa = telefonoCasa;
	}
	public String getTelefonoOficina() {
		return telefonoOficina;
	}
	public void setTelefonoOficina(String telefonoOficina) {
		this.telefonoOficina = telefonoOficina;
	}
	public String getTelefonoCelular() {
		return telefonoCelular;
	}
	public void setTelefonoCelular(String telefonoCelular) {
		this.telefonoCelular = telefonoCelular;
	}
	public String getTelefonoLocalizacion() {
		return telefonoLocalizacion;
	}
	public void setTelefonoLocalizacion(String telefonoLocalizacion) {
		this.telefonoLocalizacion = telefonoLocalizacion;
	}
	public String getRelacionLocalizacion() {
		return relacionLocalizacion;
	}
	public void setRelacionLocalizacion(String relacionLocalizacion) {
		this.relacionLocalizacion = relacionLocalizacion;
	}
	public String getCorreo() {
		return correo;
	}
	public void setCorreo(String correo) {
		this.correo = correo;
	}
	public String getClaveSucursal() {
		return claveSucursal;
	}
	public void setClaveSucursal(String claveSucursal) {
		this.claveSucursal = claveSucursal;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getDireccionSucursal() {
		return direccionSucursal;
	}
	public void setDireccionSucursal(String direccionSucursal) {
		this.direccionSucursal = direccionSucursal;
	}
	public String getClasfContable() {
		return clasfContable;
	}
	public void setClasfContable(String clasfContable) {
		this.clasfContable = clasfContable;
	}
	public String getTipoCuenta() {
		return tipoCuenta;
	}
	public void setTipoCuenta(String tipoCuenta) {
		this.tipoCuenta = tipoCuenta;
	}
	public String getNumContrato() {
		return numContrato;
	}
	public void setNumContrato(String numContrato) {
		this.numContrato = numContrato;
	}
	public String getFechaContrato() {
		return fechaContrato;
	}
	public void setFechaContrato(String fechaContrato) {
		this.fechaContrato = fechaContrato;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getPlazoDeposito() {
		return plazoDeposito;
	}
	public void setPlazoDeposito(String plazoDeposito) {
		this.plazoDeposito = plazoDeposito;
	}
	public String getPeriodicidad() {
		return periodicidad;
	}
	public void setPeriodicidad(String periodicidad) {
		this.periodicidad = periodicidad;
	}
	public String getTasaPactada() {
		return tasaPactada;
	}
	public void setTasaPactada(String tasaPactada) {
		this.tasaPactada = tasaPactada;
	}
	public String getFechaUltimoDeposito() {
		return fechaUltimoDeposito;
	}
	public void setFechaUltimoDeposito(String fechaUltimoDeposito) {
		this.fechaUltimoDeposito = fechaUltimoDeposito;
	}
	public String getSaldoUltimoDepostito() {
		return saldoUltimoDepostito;
	}
	public void setSaldoUltimoDepostito(String saldoUltimoDepostito) {
		this.saldoUltimoDepostito = saldoUltimoDepostito;
	}
	public String getPorcFondoPro() {
		return porcFondoPro;
	}
	public void setPorcFondoPro(String porcFondoPro) {
		this.porcFondoPro = porcFondoPro;
	}
	public String getSaldoCapital() {
		return saldoCapital;
	}
	public void setSaldoCapital(String saldoCapital) {
		this.saldoCapital = saldoCapital;
	}
	public String getIntDevNoPago() {
		return intDevNoPago;
	}
	public void setIntDevNoPago(String intDevNoPago) {
		this.intDevNoPago = intDevNoPago;
	}
	public String getSaldoFinal() {
		return saldoFinal;
	}
	public void setSaldoFinal(String saldoFinal) {
		this.saldoFinal = saldoFinal;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getValor() {
		return valor;
	}
	public void setValor(String valor) {
		this.valor = valor;
	}
	
}
