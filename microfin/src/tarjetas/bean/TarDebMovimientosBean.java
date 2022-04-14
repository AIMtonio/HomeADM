package tarjetas.bean;
import general.bean.BaseBean;
public class TarDebMovimientosBean extends BaseBean{

	private String tarjetaDebID;
	private String tarjetaID;
	private String estatus;
	private String clienteID;
	private String nombreCompleto;
	private String tipoTarjetaDebID;
	private String nombreTarjeta;
	private String coorporativo;   
	private String nombreCoorp;
	private String cuentaAho;   
	private String nombreTipoCuenta;
	
	private String fecha;
	private String operacion;
	private String transaccion;
	private String monto;
	
	private String fechaInicio;
	private String fechaVencimiento;
	private String tipoOperacion;
	
	public static int LONGITUD_ID = 10;

	private String fechaEmision;
	private String nombreUsuario;
	private String nombreInstitucion;
	private String numeroReporte;
	
	// Auxiliares
	private String terminalID;
	private String nomUbicacionTer;
	private String datosTpoAire;
	
	// Reporte Mov Cuenta
	private String fechaRegOper;
	private String descripcionMov;
	private String naturaleza;
	private String referenciaCta;
	private String codAutorizacion;
	private String fechaTrasaccion;
	private String horaTransaccion;

	
	public String getTarjetaDebID() {
		return tarjetaDebID;
	}

	public void setTarjetaDebID(String tarjetaDebID) {
		this.tarjetaDebID = tarjetaDebID;
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

	public String getNombreCompleto() {
		return nombreCompleto;
	}

	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}

	public String getTipoTarjetaDebID() {
		return tipoTarjetaDebID;
	}

	public void setTipoTarjetaDebID(String tipoTarjetaDebID) {
		this.tipoTarjetaDebID = tipoTarjetaDebID;
	}

	public String getNombreTarjeta() {
		return nombreTarjeta;
	}

	public void setNombreTarjeta(String nombreTarjeta) {
		this.nombreTarjeta = nombreTarjeta;
	}

	public String getCoorporativo() {
		return coorporativo;
	}

	public void setCoorporativo(String coorporativo) {
		this.coorporativo = coorporativo;
	}

	public String getNombreCoorp() {
		return nombreCoorp;
	}

	public void setNombreCoorp(String nombreCoorp) {
		this.nombreCoorp = nombreCoorp;
	}

	public String getCuentaAho() {
		return cuentaAho;
	}

	public void setCuentaAho(String cuentaAho) {
		this.cuentaAho = cuentaAho;
	}

	public String getNombreTipoCuenta() {
		return nombreTipoCuenta;
	}

	public void setNombreTipoCuenta(String nombreTipoCuenta) {
		this.nombreTipoCuenta = nombreTipoCuenta;
	}

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public String getOperacion() {
		return operacion;
	}

	public void setOperacion(String operacion) {
		this.operacion = operacion;
	}

	public String getTransaccion() {
		return transaccion;
	}

	public void setTransaccion(String transaccion) {
		this.transaccion = transaccion;
	}

	public String getMonto() {
		return monto;
	}

	public void setMonto(String monto) {
		this.monto = monto;
	}

	public static int getLONGITUD_ID() {
		return LONGITUD_ID;
	}

	public static void setLONGITUD_ID(int lONGITUD_ID) {
		LONGITUD_ID = lONGITUD_ID;
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

	public String getTipoOperacion() {
		return tipoOperacion;
	}

	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
	}

	public String getNumeroReporte() {
		return numeroReporte;
	}

	public void setNumeroReporte(String numeroReporte) {
		this.numeroReporte = numeroReporte;
	}

	public String getTerminalID() {
		return terminalID;
	}

	public void setTerminalID(String terminalID) {
		this.terminalID = terminalID;
	}

	public String getNomUbicacionTer() {
		return nomUbicacionTer;
	}

	public void setNomUbicacionTer(String nomUbicacionTer) {
		this.nomUbicacionTer = nomUbicacionTer;
	}

	public String getDatosTpoAire() {
		return datosTpoAire;
	}

	public void setDatosTpoAire(String datosTpoAire) {
		this.datosTpoAire = datosTpoAire;
	}

	public String getTarjetaID() {
		return tarjetaID;
	}

	public void setTarjetaID(String tarjetaID) {
		this.tarjetaID = tarjetaID;
	}

	public String getFechaRegOper() {
		return fechaRegOper;
	}

	public void setFechaRegOper(String fechaRegOper) {
		this.fechaRegOper = fechaRegOper;
	}

	public String getDescripcionMov() {
		return descripcionMov;
	}

	public void setDescripcionMov(String descripcionMov) {
		this.descripcionMov = descripcionMov;
	}

	public String getNaturaleza() {
		return naturaleza;
	}

	public void setNaturaleza(String naturaleza) {
		this.naturaleza = naturaleza;
	}

	public String getReferenciaCta() {
		return referenciaCta;
	}

	public void setReferenciaCta(String referenciaCta) {
		this.referenciaCta = referenciaCta;
	}

	public String getCodAutorizacion() {
		return codAutorizacion;
	}

	public void setCodAutorizacion(String codAutorizacion) {
		this.codAutorizacion = codAutorizacion;
	}

	public String getFechaTrasaccion() {
		return fechaTrasaccion;
	}

	public void setFechaTrasaccion(String fechaTrasaccion) {
		this.fechaTrasaccion = fechaTrasaccion;
	}

	public String getHoraTransaccion() {
		return horaTransaccion;
	}

	public void setHoraTransaccion(String horaTransaccion) {
		this.horaTransaccion = horaTransaccion;
	}
	
	
}
