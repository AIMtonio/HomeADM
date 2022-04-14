package tarjetas.bean;
import general.bean.BaseBean;
public class BitacoraEstatusTarDebBean extends BaseBean{
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
	private String tipoEvento;
	private String motivo;   
	private String descripcion;
	
	public static int LONGITUD_ID = 10;
	private String fechaEmision;
	private String nombreUsuario;
	private String nombreInstitucion;
	
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
	public String getTipoEvento() {
		return tipoEvento;
	}
	public void setTipoEvento(String tipoEvento) {
		this.tipoEvento = tipoEvento;
	}
	public String getMotivo() {
		return motivo;
	}
	public void setMotivo(String motivo) {
		this.motivo = motivo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
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
	public String getTarjetaID() {
		return tarjetaID;
	}
	public void setTarjetaID(String tarjetaID) {
		this.tarjetaID = tarjetaID;
	}



}
