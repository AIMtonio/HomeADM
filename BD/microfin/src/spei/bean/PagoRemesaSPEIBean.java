package spei.bean;

import general.bean.BaseBean;

public class PagoRemesaSPEIBean extends BaseBean{

	//Declaracion de Constantes
	public static int LONGITUD_ID = 11;

	private String cuentaBanco;
	private String fecha;
	private String tipoBusqueda;

	private String numero;
	private String cuentaOrigen;
	private String cuentaDestino;
	private String nomBeneficiario;
	private String monto;


	private String usuarioEnvio;
	private String folioSpeiID;
	private String claveRastreo;
	private String cuentaOrd;
	private String cuentaBeneficiario;
	private String nombreBeneficiario;
	private String speiRemID;
	private String estatus;
	private String cuentaAhoID;
	private String clienteID;
	private String usuarioAutoriza;
	private String tipoOperacion;
	private String cuentaAho;
	private String estatusCuenta;
	private String SaldoDisponible;
	private String EstatusOrd;
	private String nombreOrd;
	private String razonSocial;
	private String tipoCuenta;

	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;

	private String visa;
	private String pasaporte;
	private String greenCard;
	private String segSocial;
	private String matrConsular;
	private String ife;
	private String licencia;

	private String metodo;
	private String cadenaRespuesta;
	private String bankAutho;

	// carta Autorización
    private String cuentaClabe;
	private String Banco;
    private String fechaHora;
    private String ivaPorPagar;
    private String comision;

	private String conceptoPago;
    private String totalCargo;
	private String sumaTotalLetras;

	public String getCuentaBanco() {
		return cuentaBanco;
	}
	public void setCuentaBanco(String cuentaBanco) {
		this.cuentaBanco = cuentaBanco;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public String getNumero() {
		return numero;
	}
	public void setNumero(String numero) {
		this.numero = numero;
	}
	public String getCuentaOrigen() {
		return cuentaOrigen;
	}
	public void setCuentaOrigen(String cuentaOrigen) {
		this.cuentaOrigen = cuentaOrigen;
	}
	public String getCuentaDestino() {
		return cuentaDestino;
	}
	public void setCuentaDestino(String cuentaDestino) {
		this.cuentaDestino = cuentaDestino;
	}
	public String getNomBeneficiario() {
		return nomBeneficiario;
	}
	public void setNomBeneficiario(String nomBeneficiario) {
		this.nomBeneficiario = nomBeneficiario;
	}

	public String getUsuarioEnvio() {
		return usuarioEnvio;
	}
	public void setUsuarioEnvio(String usuarioEnvio) {
		this.usuarioEnvio = usuarioEnvio;
	}
	public String getFolioSpeiID() {
		return folioSpeiID;
	}
	public void setFolioSpeiID(String folioSpeiID) {
		this.folioSpeiID = folioSpeiID;
	}
	public String getClaveRastreo() {
		return claveRastreo;
	}
	public void setClaveRastreo(String claveRastreo) {
		this.claveRastreo = claveRastreo;
	}
	public String getCuentaOrd() {
		return cuentaOrd;
	}
	public void setCuentaOrd(String cuentaOrd) {
		this.cuentaOrd = cuentaOrd;
	}
	public String getCuentaBeneficiario() {
		return cuentaBeneficiario;
	}
	public void setCuentaBeneficiario(String cuentaBeneficiario) {
		this.cuentaBeneficiario = cuentaBeneficiario;
	}
	public String getNombreBeneficiario() {
		return nombreBeneficiario;
	}
	public void setNombreBeneficiario(String nombreBeneficiario) {
		this.nombreBeneficiario = nombreBeneficiario;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getTipoBusqueda() {
		return tipoBusqueda;
	}
	public void setTipoBusqueda(String tipoBusqueda) {
		this.tipoBusqueda = tipoBusqueda;
	}

	public String getSpeiRemID() {
		return speiRemID;
	}
	public void setSpeiRemID(String speiRemID) {
		this.speiRemID = speiRemID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getUsuarioAutoriza() {
		return usuarioAutoriza;
	}
	public void setUsuarioAutoriza(String usuarioAutoriza) {
		this.usuarioAutoriza = usuarioAutoriza;
	}
	public String getTipoOperacion() {
		return tipoOperacion;
	}
	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
	}


	public String getCuentaAho() {
		return cuentaAho;
	}
	public void setCuentaAho(String cuentaAho) {
		this.cuentaAho = cuentaAho;
	}
	public String getNombreOrd() {
		return nombreOrd;
	}
	public void setNombreOrd(String nombreOrd) {
		this.nombreOrd = nombreOrd;
	}
	public String getRazonSocial() {
		return razonSocial;
	}
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}
	public String getTipoCuenta() {
		return tipoCuenta;
	}
	public void setTipoCuenta(String tipoCuenta) {
		this.tipoCuenta = tipoCuenta;
	}

	public String getEstatusCuenta() {
		return estatusCuenta;
	}
	public void setEstatusCuenta(String estatusCuenta) {
		this.estatusCuenta = estatusCuenta;
	}
	public String getSaldoDisponible() {
		return SaldoDisponible;
	}
	public void setSaldoDisponible(String saldoDisponible) {
		SaldoDisponible = saldoDisponible;
	}
	public String getEstatusOrd() {
		return EstatusOrd;
	}
	public void setEstatusOrd(String estatusOrd) {
		EstatusOrd = estatusOrd;
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
	public static int getLONGITUD_ID() {
		return LONGITUD_ID;
	}
	public static void setLONGITUD_ID(int lONGITUD_ID) {
		LONGITUD_ID = lONGITUD_ID;
	}
	public String getVisa() {
		return visa;
	}
	public void setVisa(String visa) {
		this.visa = visa;
	}
	public String getPasaporte() {
		return pasaporte;
	}
	public void setPasaporte(String pasaporte) {
		this.pasaporte = pasaporte;
	}
	public String getGreenCard() {
		return greenCard;
	}
	public void setGreenCard(String greenCard) {
		this.greenCard = greenCard;
	}
	public String getSegSocial() {
		return segSocial;
	}
	public void setSegSocial(String segSocial) {
		this.segSocial = segSocial;
	}
	public String getMatrConsular() {
		return matrConsular;
	}
	public void setMatrConsular(String matrConsular) {
		this.matrConsular = matrConsular;
	}
	public String getIfe() {
		return ife;
	}
	public void setIfe(String ife) {
		this.ife = ife;
	}
	public String getLicencia() {
		return licencia;
	}
	public void setLicencia(String licencia) {
		this.licencia = licencia;
	}
	public String getMetodo() {
		return metodo;
	}
	public void setMetodo(String metodo) {
		this.metodo = metodo;
	}
	public String getCadenaRespuesta() {
		return cadenaRespuesta;
	}
	public void setCadenaRespuesta(String cadenaRespuesta) {
		this.cadenaRespuesta = cadenaRespuesta;
	}
	public String getBankAutho() {
		return bankAutho;
	}
	public void setBankAutho(String bankAutho) {
		this.bankAutho = bankAutho;
	}
	public String getCuentaClabe() {
		return cuentaClabe;
	}
	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}
	public String getBanco() {
		return Banco;
	}
	public void setBanco(String banco) {
		Banco = banco;
	}
	public String getFechaHora() {
		return fechaHora;
	}
	public void setFechaHora(String fechaHora) {
		this.fechaHora = fechaHora;
	}
	public String getIvaPorPagar() {
		return ivaPorPagar;
	}
	public void setIvaPorPagar(String ivaPorPagar) {
		this.ivaPorPagar = ivaPorPagar;
	}
	public String getComision() {
		return comision;
	}
	public void setComision(String comision) {
		this.comision = comision;
	}
	public String getConceptoPago() {
		return conceptoPago;
	}
	public void setConceptoPago(String conceptoPago) {
		this.conceptoPago = conceptoPago;
	}
	public String getTotalCargo() {
		return totalCargo;
	}
	public void setTotalCargo(String totalCargo) {
		this.totalCargo = totalCargo;
	}
	public String getSumaTotalLetras() {
		return sumaTotalLetras;
	}
	public void setSumaTotalLetras(String sumaTotalLetras) {
		this.sumaTotalLetras = sumaTotalLetras;
	}
}
