package tesoreria.bean;

import general.bean.BaseBean;

public class BonificacionesBean extends BaseBean {

	private String bonificacionID;
	private String fechaInicio;
	private String fechaFin;
	private String estatus;
	private String tipoReporte;

	private String tipoLista;
	private String clienteID;
	private String nombreCliente;
	private String cuentaAhoID;
	private String monto;

	private String tipoDispersion;
	private String folioDispersion;
	private String meses;
	private String montoAmortizado;
	private String montoPorAmortizar;

	private String nombreUsuario;
	private String fechaEmision;
	private String horaEmision;
	private String nombreInstitucion;
	private String descripcionEstatus;

	public String getBonificacionID() {
		return bonificacionID;
	}
	public void setBonificacionID(String bonificacionID) {
		this.bonificacionID = bonificacionID;
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
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getTipoReporte() {
		return tipoReporte;
	}
	public void setTipoReporte(String tipoReporte) {
		this.tipoReporte = tipoReporte;
	}
	public String getTipoLista() {
		return tipoLista;
	}
	public void setTipoLista(String tipoLista) {
		this.tipoLista = tipoLista;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getTipoDispersion() {
		return tipoDispersion;
	}
	public void setTipoDispersion(String tipoDispersion) {
		this.tipoDispersion = tipoDispersion;
	}
	public String getFolioDispersion() {
		return folioDispersion;
	}
	public void setFolioDispersion(String folioDispersion) {
		this.folioDispersion = folioDispersion;
	}
	public String getMeses() {
		return meses;
	}
	public void setMeses(String meses) {
		this.meses = meses;
	}
	public String getMontoAmortizado() {
		return montoAmortizado;
	}
	public void setMontoAmortizado(String montoAmortizado) {
		this.montoAmortizado = montoAmortizado;
	}
	public String getMontoPorAmortizar() {
		return montoPorAmortizar;
	}
	public void setMontoPorAmortizar(String montoPorAmortizar) {
		this.montoPorAmortizar = montoPorAmortizar;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	public String getHoraEmision() {
		return horaEmision;
	}
	public void setHoraEmision(String horaEmision) {
		this.horaEmision = horaEmision;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getDescripcionEstatus() {
		return descripcionEstatus;
	}
	public void setDescripcionEstatus(String descripcionEstatus) {
		this.descripcionEstatus = descripcionEstatus;
	}
}