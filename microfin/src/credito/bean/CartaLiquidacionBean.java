package credito.bean;

import general.bean.BaseBean;

public class CartaLiquidacionBean extends BaseBean {
	
	private String cartaLiquidaID;
	private String creditoID;
	private String clienteID;
	private String cliente;
	private String montoOriginal;
	private String fechaVencimiento;
	private String institucionID;
	private String institucion;
	private String convenio;
	private String archivoIdCarta;
	private String recurso;
	private String comentario;
	private String montoProyectado;
	private String fechaGeneracion;
	private String usuarioGenara;
	private byte[] qrImage;
	private String archivoBlob;
	
	private String nuevaCarta;
	
	public String getCartaLiquidaID() {
		return cartaLiquidaID;
	}
	public void setCartaLiquidaID(String cartaLiquidaID) {
		this.cartaLiquidaID = cartaLiquidaID;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCliente() {
		return cliente;
	}
	public void setCliente(String cliente) {
		this.cliente = cliente;
	}
	public String getMontoOriginal() {
		return montoOriginal;
	}
	public void setMontoOriginal(String montoOriginal) {
		this.montoOriginal = montoOriginal;
	}
	public String getFechaVencimiento() {
		return fechaVencimiento;
	}
	public void setFechaVencimiento(String fechaVencimiento) {
		this.fechaVencimiento = fechaVencimiento;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getInstitucion() {
		return institucion;
	}
	public void setInstitucion(String institucion) {
		this.institucion = institucion;
	}
	public String getConvenio() {
		return convenio;
	}
	public void setConvenio(String convenio) {
		this.convenio = convenio;
	}
	public String getNuevaCarta() {
		return nuevaCarta;
	}
	public void setNuevaCarta(String nuevaCarta) {
		this.nuevaCarta = nuevaCarta;
	}
	public String getArchivoIdCarta() {
		return archivoIdCarta;
	}
	public void setArchivoIdCarta(String archivoIdCarta) {
		this.archivoIdCarta = archivoIdCarta;
	}
	public String getRecurso() {
		return recurso;
	}
	public void setRecurso(String recurso) {
		this.recurso = recurso;
	}
	public String getMontoProyectado() {
		return montoProyectado;
	}
	public void setMontoProyectado(String montoProyectado) {
		this.montoProyectado = montoProyectado;
	}
	public String getFechaGeneracion() {
		return fechaGeneracion;
	}
	public void setFechaGeneracion(String fechaGeneracion) {
		this.fechaGeneracion = fechaGeneracion;
	}
	public String getUsuarioGenara() {
		return usuarioGenara;
	}
	public void setUsuarioGenara(String usuarioGenara) {
		this.usuarioGenara = usuarioGenara;
	}
	public byte[] getQrImage() {
		return qrImage;
	}
	public void setQrImage(byte[] qrImage) {
		this.qrImage = qrImage;
	}
	public String getComentario() {
		return comentario;
	}
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
	public String getArchivoBlob() {
		return archivoBlob;
	}
	public void setArchivoBlob(String archivoBlob) {
		this.archivoBlob = archivoBlob;
	}
}
