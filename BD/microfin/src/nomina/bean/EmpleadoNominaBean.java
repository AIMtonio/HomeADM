package nomina.bean;

import general.bean.BaseBean;

public class EmpleadoNominaBean extends BaseBean {
	
	private String folioCtrl;
	private String clienteID;
	private String prospectoID;
	private String institNominaID;
	private String nombreInstNomina;
	private String nombreCompleto;//NommbreCliente en descuentos
	private String estatusAnterior;
	private String estatusEmp;
	private String fechaAct;
	private String fechaInicialInca;
	private String fechaFinInca;
	private String fechaBaja;
	private String motivoBaja;
	private String fechaInicio;
	private String fechaFin;
	private String creditoID;
	private String montoAccesorio;
	private String interesAccesorios;
	private String ivaInteresAccesorios;
	
	private String montoCuota;
	private String montoTotal;
	private String codigoRespuesta;
	private String mensajeRespuesta;
	
	/* -----Auxiliares Reporte descuentos------*/
	private String horaEmision;
	private String fechaEmision;
	private String usuario;
	private String nombreInstitucion;
	private String plazo;
	private String numPago;
	private String fechaPago;
	private String montoExigible;
	private String montoAtraso;
	private String adeudoTotal;
	private String tipoLista;
	
	
	private String nominaEmpleadoID;
	private String convenioNominaID;
	private String descripcionConvenio;
	private String tipoEmpleadoID;
	private String descripcionTipoEmpleado;
	private String noEmpleado;
	private String puestoOcupacionID;
	private String descripcionTipoPuesto;
	private String quinquenioID;
	private String centroAdscripcion;
	private String fechaIngreso;
	private String estatus;
	private String noPension;
	
	/*reporte*/
	private String estatusCuenta;
	private String CURP;
	private String RFC;
	private String desPuestoOcupacion;
	private String desQuinquenio;
	private String desTipoEmpleado;
	private String claveUsuario;
	private String nombreSucursal;
	private String sucursalID;

	
	public String getTipoLista() {
		return tipoLista;
	}
	public void setTipoLista(String tipoLista) {
		this.tipoLista = tipoLista;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getFechaPago() {
		return fechaPago;
	}
	public void setFechaPago(String fechaPago) {
		this.fechaPago = fechaPago;
	}
	public String getMontoExigible() {
		return montoExigible;
	}
	public void setMontoExigible(String montoExigible) {
		this.montoExigible = montoExigible;
	}
	public String getFechaInicio() {
		return fechaInicio;
	}
	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}
	public String getFechaFin() {
		return fechaFin;
	}
	public void setFechaFin(String fechaFin) {
		this.fechaFin = fechaFin;
	}
	public String getNombreInstNomina() {
		return nombreInstNomina;
	}
	public void setNombreInstNomina(String nombreInstNomina) {
		this.nombreInstNomina = nombreInstNomina;
	}
	public String getEstatusAnterior() {
		return estatusAnterior;
	}
	public void setEstatusAnterior(String estatusAnterior) {
		this.estatusAnterior = estatusAnterior;
	}
	public String getFechaAct() {
		return fechaAct;
	}
	public void setFechaAct(String fechaAct) {
		this.fechaAct = fechaAct;
	}
	public String getClienteID() {
		return clienteID;
	}
	public String getInstitNominaID() {
		return institNominaID;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public String getEstatusEmp() {
		return estatusEmp;
	}
	public String getFechaInicialInca() {
		return fechaInicialInca;
	}
	public String getFechaFinInca() {
		return fechaFinInca;
	}
	public String getFechaBaja() {
		return fechaBaja;
	}
	public String getMotivoBaja() {
		return motivoBaja;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public void setEstatusEmp(String estatusEmp) {
		this.estatusEmp = estatusEmp;
	}
	public void setFechaInicialInca(String fechaInicialInca) {
		this.fechaInicialInca = fechaInicialInca;
	}
	public void setFechaFinInca(String fechaFinInca) {
		this.fechaFinInca = fechaFinInca;
	}
	public void setFechaBaja(String fechaBaja) {
		this.fechaBaja = fechaBaja;
	}
	public void setMotivoBaja(String motivoBaja) {
		this.motivoBaja = motivoBaja;
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
	public String getFolioCtrl() {
		return folioCtrl;
	}
	public void setFolioCtrl(String folioCtrl) {
		this.folioCtrl = folioCtrl;
	}
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}
	
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getPlazo() {
		return plazo;
	}
	public void setPlazo(String plazo) {
		this.plazo = plazo;
	}
	public String getNumPago() {
		return numPago;
	}
	public void setNumPago(String numPago) {
		this.numPago = numPago;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getMontoCuota() {
		return montoCuota;
	}
	public void setMontoCuota(String montoCuota) {
		this.montoCuota = montoCuota;
	}
	public String getMontoTotal() {
		return montoTotal;
	}
	public void setMontoTotal(String montoTotal) {
		this.montoTotal = montoTotal;
	}
	public String getMontoAtraso() {
		return montoAtraso;
	}
	public void setMontoAtraso(String montoAtraso) {
		this.montoAtraso = montoAtraso;
	}
	public String getAdeudoTotal() {
		return adeudoTotal;
	}
	public void setAdeudoTotal(String adeudoTotal) {
		this.adeudoTotal = adeudoTotal;
	}
	public String getNominaEmpleadoID() {
		return nominaEmpleadoID;
	}
	public void setNominaEmpleadoID(String nominaEmpleadoID) {
		this.nominaEmpleadoID = nominaEmpleadoID;
	}
	public String getConvenioNominaID() {
		return convenioNominaID;
	}
	public void setConvenioNominaID(String convenioNominaID) {
		this.convenioNominaID = convenioNominaID;
	}
	public String getDescripcionConvenio() {
		return descripcionConvenio;
	}
	public void setDescripcionConvenio(String descripcionConvenio) {
		this.descripcionConvenio = descripcionConvenio;
	}
	public String getTipoEmpleadoID() {
		return tipoEmpleadoID;
	}
	public void setTipoEmpleadoID(String tipoEmpleadoID) {
		this.tipoEmpleadoID = tipoEmpleadoID;
	}
	public String getDescripcionTipoEmpleado() {
		return descripcionTipoEmpleado;
	}
	public void setDescripcionTipoEmpleado(String descripcionTipoEmpleado) {
		this.descripcionTipoEmpleado = descripcionTipoEmpleado;
	}
	public String getNoEmpleado() {
		return noEmpleado;
	}
	public void setNoEmpleado(String noEmpleado) {
		this.noEmpleado = noEmpleado;
	}
	public String getPuestoOcupacionID() {
		return puestoOcupacionID;
	}
	public void setPuestoOcupacionID(String puestoOcupacionID) {
		this.puestoOcupacionID = puestoOcupacionID;
	}
	public String getDescripcionTipoPuesto() {
		return descripcionTipoPuesto;
	}
	public void setDescripcionTipoPuesto(String descripcionTipoPuesto) {
		this.descripcionTipoPuesto = descripcionTipoPuesto;
	}
	public String getEstatusCuenta() {
		return estatusCuenta;
	}
	public void setEstatusCuenta(String estatusCuenta) {
		this.estatusCuenta = estatusCuenta;
	}
	public String getQuinquenioID() {
		return quinquenioID;
	}
	public void setQuinquenioID(String quinquenioID) {
		this.quinquenioID = quinquenioID;
	}
	public String getCentroAdscripcion() {
		return centroAdscripcion;
	}
	public void setCentroAdscripcion(String centroAdscripcion) {
		this.centroAdscripcion = centroAdscripcion;
	}
	public String getFechaIngreso() {
		return fechaIngreso;
	}
	public void setFechaIngreso(String fechaIngreso) {
		this.fechaIngreso = fechaIngreso;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getNoPension() {
		return noPension;
	}
	public void setNoPension(String noPension) {
		this.noPension = noPension;
	}
	public String getCURP() {
		return CURP;
	}
	public void setCURP(String cURP) {
		CURP = cURP;
	}
	public String getRFC() {
		return RFC;
	}
	public void setRFC(String rFC) {
		RFC = rFC;
	}
	public String getDesPuestoOcupacion() {
		return desPuestoOcupacion;
	}
	public void setDesPuestoOcupacion(String desPuestoOcupacion) {
		this.desPuestoOcupacion = desPuestoOcupacion;
	}
	public String getDesQuinquenio() {
		return desQuinquenio;
	}
	public void setDesQuinquenio(String desQuinquenio) {
		this.desQuinquenio = desQuinquenio;
	}
	public String getDesTipoEmpleado() {
		return desTipoEmpleado;
	}
	public void setDesTipoEmpleado(String desTipoEmpleado) {
		this.desTipoEmpleado = desTipoEmpleado;
	}
	public String getClaveUsuario() {
		return claveUsuario;
	}
	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}
	public String getNombreSucursal() {
		return nombreSucursal;
	}
	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	
	public String getMontoAccesorio() {
		return montoAccesorio;
	}
	public void setMontoAccesorio(String montoAccesorio) {
		this.montoAccesorio = montoAccesorio;
	}
	
	public String getInteresAccesorios() {
		return interesAccesorios;
	}
	public void setInteresAccesorios(String interesAccesorios) {
		this.interesAccesorios = interesAccesorios;
	}
	public String getIvaInteresAccesorios() {
		return ivaInteresAccesorios;
	}
	public void setIvaInteresAccesorios(String ivaInteresAccesorios) {
		this.ivaInteresAccesorios = ivaInteresAccesorios;
	}

}
