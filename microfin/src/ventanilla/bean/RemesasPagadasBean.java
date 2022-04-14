package ventanilla.bean;

import general.bean.BaseBean;

public class RemesasPagadasBean extends BaseBean {

	private String referencia;
	private String remesadora;
	private String monto;
	private int clienteID;
	private String cliente;
	private int usuarioID;
	private String usuario;
	private String direccion;
	private String numeroTelefono;
	private String formaPago;
	private int numeroReimpresiones;
	private String moneda;

	private String numeroTrasnaccion;

	private int denominiacionID;
	private String cantidad;

	private String tipoConsulta;

	private int valor;

	public String getReferencia() {
		return referencia;
	}

	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}

	public String getRemesadora() {
		return remesadora;
	}

	public void setRemesadora(String remesadora) {
		this.remesadora = remesadora;
	}

	public String getMonto() {
		return monto;
	}

	public void setMonto(String monto) {
		this.monto = monto;
	}

	public int getClienteID() {
		return clienteID;
	}

	public void setClienteID(int clienteID) {
		this.clienteID = clienteID;
	}

	public String getCliente() {
		return cliente;
	}

	public void setCliente(String cliente) {
		this.cliente = cliente;
	}

	public int getUsuarioID() {
		return usuarioID;
	}

	public void setUsuarioID(int usuarioID) {
		this.usuarioID = usuarioID;
	}

	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}

	public String getDireccion() {
		return direccion;
	}

	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}

	public String getNumeroTelefono() {
		return numeroTelefono;
	}

	public void setNumeroTelefono(String numeroTelefono) {
		this.numeroTelefono = numeroTelefono;
	}

	public String getFormaPago() {
		return formaPago;
	}

	public void setFormaPago(String formaPago) {
		this.formaPago = formaPago;
	}

	public String getNumeroTrasnaccion() {
		return numeroTrasnaccion;
	}

	public void setNumeroTrasnaccion(String numeroTrasnaccion) {
		this.numeroTrasnaccion = numeroTrasnaccion;
	}

	public int getDenominiacionID() {
		return denominiacionID;
	}

	public void setDenominiacionID(int denominiacionID) {
		this.denominiacionID = denominiacionID;
	}

	public String getCantidad() {
		return cantidad;
	}

	public void setCantidad(String cantidad) {
		this.cantidad = cantidad;
	}

	public String getTipoConsulta() {
		return tipoConsulta;
	}

	public void setTipoConsulta(String tipoConsulta) {
		this.tipoConsulta = tipoConsulta;
	}

	public int getValor() {
		return valor;
	}

	public void setValor(int valor) {
		this.valor = valor;
	}
	
	public int getNumeroReimpresiones() {
		return numeroReimpresiones;
	}
	
	public void setNumeroReimpresiones(int numeroReimpresiones) {
		this.numeroReimpresiones = numeroReimpresiones;
	}
	
	public String getMoneda() {
		return moneda;
	}
	
	public void setMoneda(String moneda) {
		this.moneda = moneda;
	}
}
