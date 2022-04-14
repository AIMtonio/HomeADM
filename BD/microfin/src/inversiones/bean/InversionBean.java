package inversiones.bean;

import general.bean.BaseBean;

public class InversionBean extends BaseBean {
	
	private String inversionID;
	private String clienteID;
	private String cuentaAhoID;
	private String tipoInversionID;
	
	
	private String fechaInicio;
	private String fechaVencimiento;

	private Double monto;
	private String monedaID;
	private int	plazo;
	private Double tasa;
	private Double tasaISR;
	private Double tasaNeta;
	private Double interesGenerado;
	private Double interesRecibir;
	private Double interesRetener;

	private String estatus;
	private String usuarioID;
	private String reinvertir;
	private String estatusImpresion;
	private String inversionRenovada;
	private String etiqueta;
	private String valorGat; //para nuevo campo en la pantalla donde se calcula el Gasto Anual Total para pantalla aperturaInversion.jsp
	private String beneficiario; // atributo para tomar el tipo de beneficiario: Cuenta Socio o Propio de la inversion.
	private String valorGatReal;
	private String polizaID;
		
	//Campos de Apoyo para Consultas y Reportes
	private String nombreCliente;

	
	private String promotorID;
	private String sucursalID;
	private String nombreUsuario;
	private String nombreInstitucion;
	private String nombrePromotor;
	private String descripcionTipoInv;
	private String nombreMoneda;
	private String nombreSucursal;
	private String anio;
	private String mes;
	private String fechaActual;
	private String reinvertirDes;
	
	private String motivoInversion;
	private String usuarioAutorizaID;
	private String contraseniaUsuarioAutoriza;
	private String diasTrans;
	private String saldoProvision;
	private String nombreCompleto;
	private String tipoInversion;
	private String descripcion;
	private String fecha;
	private String hora;
	
	/* Se crearon las sig variables para hacer posible ponerle formato moneda y poder usar sus valores en la pantalla de resulmen de cliente */
	private String tasaNetaString;
	private String interesGeneradoString;
	private String interesRecibirString;
	private String interesRetenerString;
	private String montoString;
	private String tasaISRString;
	private String direccionInstit;
	private String RFCInstit;
	private String telefonoInst;
	private String nombreGerente;
	private String nombrePresidente;
	private double tipoModena;
	private double totalRecibir;
	
	public final String concCanInver = "12";
	public final String descCanInver = "CANCELACION INVERSION";
	
	public final String concApeInver = "10";
	public final String descApeInver = "APERTURA INVERSION";
	
	public final String concVenAntInv = "16";
	public final String descVenAntInv = "VENCIMIENTO ANTICIPADO INVERSION";
	
	public final String concReInvInd = "11";
	public final String descReInvInd = "REINVERSION INDIVIDUAL";
	public final String concCanReInver = "12";
	public final String descCanReInver = "CANCELACION REINVERSION";
	private String estatusISR;

	
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getInversionID() {
		return inversionID;
	}
	public void setInversionID(String inversionID) {
		this.inversionID = inversionID;
	}
	
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getTipoInversionID() {
		return tipoInversionID;
	}
	public void setTipoInversionID(String tipoInversionID) {
		this.tipoInversionID = tipoInversionID;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getTipoInversion() {
		return tipoInversion;
	}
	public void setTipoInversion(String tipoInversion) {
		this.tipoInversion = tipoInversion;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public Double getMonto() {
		return monto;
	}
	public void setMonto(Double monto) {
		this.monto = monto;
	}
	public int getPlazo() {
		return plazo;
	}
	public void setPlazo(int plazo) {
		this.plazo = plazo;
	}
	public Double getTasa() {
		return tasa;
	}
	public void setTasa(Double tasa) {
		this.tasa = tasa;
	}
	public Double getTasaISR() {
		return tasaISR;
	}
	public void setTasaISR(Double tasaISR) {
		this.tasaISR = tasaISR;
	}
	public Double getTasaNeta() {
		return tasaNeta;
	}
	public void setTasaNeta(Double tasaNeta) {
		this.tasaNeta = tasaNeta;
	}
	public Double getInteresGenerado() {
		return interesGenerado;
	}
	public void setInteresGenerado(Double interesGenerado) {
		this.interesGenerado = interesGenerado;
	}
	public Double getInteresRecibir() {
		return interesRecibir;
	}
	public void setInteresRecibir(Double interesRecibir) {
		this.interesRecibir = interesRecibir;
	}
	public Double getInteresRetener() {
		return interesRetener;
	}
	public void setInteresRetener(Double interesRetener) {
		this.interesRetener = interesRetener;
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
	public String getReinvertir() {
		return reinvertir;
	}
	public void setReinvertir(String reinvertir) {
		this.reinvertir = reinvertir;
	}
	public String getEstatusImpresion() {
		return estatusImpresion;
	}
	public void setEstatusImpresion(String estatusImpresion) {
		this.estatusImpresion = estatusImpresion;
	}
	public String getInversionRenovada() {
		return inversionRenovada;
	}
	public void setInversionRenovada(String inversionRenovada) {
		this.inversionRenovada = inversionRenovada;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getMonedaID() {
		return monedaID;
	}
	public void setMonedaID(String monedaID) {
		this.monedaID = monedaID;
	}
	public String getEtiqueta() {
		return etiqueta;
	}
	public void setEtiqueta(String etiqueta) {
		this.etiqueta = etiqueta;
	}
	public String getValorGat() {
		return valorGat;
	}
	public void setValorGat(String valorGat) {
		this.valorGat = valorGat;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getMontoString() {
		return montoString;
	}
	public void setMontoString(String montoString) {
		this.montoString = montoString;
	}
	public String getPromotorID() {
		return promotorID;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setPromotorID(String promotorID) {
		this.promotorID = promotorID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getDescripcionTipoInv() {
		return descripcionTipoInv;
	}
	public void setDescripcionTipoInv(String descripcionTipoInv) {
		this.descripcionTipoInv = descripcionTipoInv;
	}
	public String getNombrePromotor() {
		return nombrePromotor;
	}
	public void setNombrePromotor(String nombrePromotor) {
		this.nombrePromotor = nombrePromotor;
	}
	public String getNombreMoneda() {
		return nombreMoneda;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreMoneda(String nombreMoneda) {
		this.nombreMoneda = nombreMoneda;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getAnio() {
		return anio;
	}
	public String getMes() {
		return mes;
	}
	public void setAnio(String anio) {
		this.anio = anio;
	}
	public void setMes(String mes) {
		this.mes = mes;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public String getMotivoInversion() {
		return motivoInversion;
	}
	public void setMotivoInversion(String motivoInversion) {
		this.motivoInversion = motivoInversion;
	}
	public String getUsuarioAutorizaID() {
		return usuarioAutorizaID;
	}
	public void setUsuarioAutorizaID(String usuarioAutorizaID) {
		this.usuarioAutorizaID = usuarioAutorizaID;
	}
	public String getContraseniaUsuarioAutoriza() {
		return contraseniaUsuarioAutoriza;
	}
	public void setContraseniaUsuarioAutoriza(String contraseniaUsuarioAutoriza) {
		this.contraseniaUsuarioAutoriza = contraseniaUsuarioAutoriza;
	}
	public String getDiasTrans() {
		return diasTrans;
	}
	public void setDiasTrans(String diasTrans) {
		this.diasTrans = diasTrans;
	}
	public String getSaldoProvision() {
		return saldoProvision;
	}
	public void setSaldoProvision(String saldoProvision) {
		this.saldoProvision = saldoProvision;
	}
	public String getBeneficiario() {
		return beneficiario;
	}
	public void setBeneficiario(String beneficiario) {
		this.beneficiario = beneficiario;
	}

	public String getTasaNetaString() {
		return tasaNetaString;
	}
	public String getInteresGeneradoString() {
		return interesGeneradoString;
	}
	public String getInteresRecibirString() {
		return interesRecibirString;
	}
	public String getInteresRetenerString() {
		return interesRetenerString;
	}
	public void setTasaNetaString(String tasaNetaString) {
		this.tasaNetaString = tasaNetaString;
	}
	public void setInteresGeneradoString(String interesGeneradoString) {
		this.interesGeneradoString = interesGeneradoString;
	}
	public void setInteresRecibirString(String interesRecibirString) {
		this.interesRecibirString = interesRecibirString;
	}
	public void setInteresRetenerString(String interesRetenerString) {
		this.interesRetenerString = interesRetenerString;
	}
	public String getTasaISRString() {
		return tasaISRString;
	}
	public void setTasaISRString(String tasaISRString) {
		this.tasaISRString = tasaISRString;
	}
	public String getReinvertirDes() {
		return reinvertirDes;
	}
	public void setReinvertirDes(String reinvertirDes) {
		this.reinvertirDes = reinvertirDes;
	}
	public String getDireccionInstit() {
		return direccionInstit;
	}
	public void setDireccionInstit(String direccionInstit) {
		this.direccionInstit = direccionInstit;
	}
	public String getRFCInstit() {
		return RFCInstit;
	}
	public void setRFCInstit(String rFCInstit) {
		RFCInstit = rFCInstit;
	}
	public String getTelefonoInst() {
		return telefonoInst;
	}
	public void setTelefonoInst(String telefonoInst) {
		this.telefonoInst = telefonoInst;
	}
	public String getNombreGerente() {
		return nombreGerente;
	}
	public void setNombreGerente(String nombreGerente) {
		this.nombreGerente = nombreGerente;
	}
	public String getNombrePresidente() {
		return nombrePresidente;
	}
	public void setNombrePresidente(String nombrePresidente) {
		this.nombrePresidente = nombrePresidente;
	}
	public String getValorGatReal() {
		return valorGatReal;
	}
	public void setValorGatReal(String valorGatReal) {
		this.valorGatReal = valorGatReal;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getConcCanInver() {
		return concCanInver;
	}
	public String getDescCanInver() {
		return descCanInver;
	}
	public String getConcApeInver() {
		return concApeInver;
	}
	public String getDescApeInver() {
		return descApeInver;
	}
	public String getConcVenAntInv() {
		return concVenAntInv;
	}
	public String getDescVenAntInv() {
		return descVenAntInv;
	}
	public String getConcReInvInd() {
		return concReInvInd;
	}
	public String getDescReInvInd() {
		return descReInvInd;
	}
	public double getTipoModena() {
		return tipoModena;
	}
	public void setTipoModena(double tipoModena) {
		this.tipoModena = tipoModena;
	}
	public double getTotalRecibir() {
		return totalRecibir;
	}
	public void setTotalRecibir(double totalRecibir) {
		this.totalRecibir = totalRecibir;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getHora() {
		return hora;
	}
	public void setHora(String hora) {
		this.hora = hora;
	}
	public String getEstatusISR() {
		return estatusISR;
	}
	public void setEstatusISR(String estatusISR) {
		this.estatusISR = estatusISR;
	}	

}