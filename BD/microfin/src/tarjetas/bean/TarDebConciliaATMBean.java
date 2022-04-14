package tarjetas.bean;

import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class TarDebConciliaATMBean extends BaseBean{

	private MultipartFile file;
	private String codigo;
	private String fecha;
	private String totalTransac;
	
	private String emisor;
	private String terminalID;
	private String tarjetaDebID;
	private String cuentaOrigen;
	private String descripcion;
	private String codigoRespuesta;
	private String secuencia;
	private String fechaTransac;
	private String horaTransac;
	private String red;
	private String montoTransac;
	private String comision;
	private String numAutorizacion;
	
	//Auxiliares
	private String conciliaATMID;
	private String fechaRegistro;
	private String ruta;
		
	
	public MultipartFile getFile() {
		return file;
	}
	public void setFile(MultipartFile file) {
		this.file = file;
	}
	public String getCodigo() {
		return codigo;
	}
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	public String getFecha() {
		return fecha;
	}
	public void setFecha(String fecha) {
		this.fecha = fecha;
	}
	public String getTotalTransac() {
		return totalTransac;
	}
	public void setTotalTransac(String totalTransac) {
		this.totalTransac = totalTransac;
	}
	public String getEmisor() {
		return emisor;
	}
	public void setEmisor(String emisor) {
		this.emisor = emisor;
	}
	public String getTerminalID() {
		return terminalID;
	}
	public void setTerminalID(String terminalID) {
		this.terminalID = terminalID;
	}
	public String getTarjetaDebID() {
		return tarjetaDebID;
	}
	public void setTarjetaDebID(String tarjetaDebID) {
		this.tarjetaDebID = tarjetaDebID;
	}
	public String getCuentaOrigen() {
		return cuentaOrigen;
	}
	public void setCuentaOrigen(String cuentaOrigen) {
		this.cuentaOrigen = cuentaOrigen;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getCodigoRespuesta() {
		return codigoRespuesta;
	}
	public void setCodigoRespuesta(String codigoRespuesta) {
		this.codigoRespuesta = codigoRespuesta;
	}
	public String getSecuencia() {
		return secuencia;
	}
	public void setSecuencia(String secuencia) {
		this.secuencia = secuencia;
	}
	public String getFechaTransac() {
		return fechaTransac;
	}
	public void setFechaTransac(String fechaTransac) {
		this.fechaTransac = fechaTransac;
	}
	public String getHoraTransac() {
		return horaTransac;
	}
	public void setHoraTransac(String horaTransac) {
		this.horaTransac = horaTransac;
	}
	public String getMontoTransac() {
		return montoTransac;
	}
	public String getRed() {
		return red;
	}
	public void setRed(String red) {
		this.red = red;
	}
	public void setMontoTransac(String montoTransac) {
		this.montoTransac = montoTransac;
	}
	public String getComision() {
		return comision;
	}
	public void setComision(String comision) {
		this.comision = comision;
	}
	public String getNumAutorizacion() {
		return numAutorizacion;
	}
	public void setNumAutorizacion(String numAutorizacion) {
		this.numAutorizacion = numAutorizacion;
	}
	public String getConciliaATMID() {
		return conciliaATMID;
	}
	public void setConciliaATMID(String conciliaATMID) {
		this.conciliaATMID = conciliaATMID;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getRuta() {
		return ruta;
	}
	public void setRuta(String ruta) {
		this.ruta = ruta;
	}
}