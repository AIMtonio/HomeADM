package cliente.bean;

import general.bean.BaseBean;

public class HiscambiosucurcliBean extends BaseBean{
	
	//Declaracion de Constantes
	public static int LONGITUD_ID = 10;
	
	/*ATRIBUTOS DE LA TABLA */
	private String clienteID;
	private String sucursalOrigen;
	private String sucursalDestino;
	private String promotorAnterior;
	private String promotorActual;
	private String usuarioID;
	private String fecha;
	
	/*ATRIBUTOS PARA REPORTE */
	private String clienteInicio;
	private String clienteFin;
	private String nombreInstitucion;
	private String fechaSistema;
	private String nombreUsuario;
	private String fechaInicial;
	private String fechaFinal;
	
	
	/*PARAMETROS DE AUDITORIA */
	private String empresaID;
	private String usuario;
	private String fechaActual;  
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	
	/* ========= GETTER'S AND SETTER'S ========== */
	
	public String getClienteID() {
		return clienteID;
	}
	
	public String getEmpresaID() {
		return empresaID;
	}
	public String getUsuario() {
		return usuario;
	}
	public String getFechaActual() {
		return fechaActual;
	}
	public String getDireccionIP() {
		return direccionIP;
	}
	public String getProgramaID() {
		return programaID;
	}
	public String getSucursal() {
		return sucursal;
	}
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	
	public void setEmpresaID(String empresaID) {
		this.empresaID = empresaID;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public void setFechaActual(String fechaActual) {
		this.fechaActual = fechaActual;
	}
	public void setDireccionIP(String direccionIP) {
		this.direccionIP = direccionIP;
	}
	public void setProgramaID(String programaID) {
		this.programaID = programaID;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}


	public String getSucursalOrigen() {
		return sucursalOrigen;
	}

	public String getSucursalDestino() {
		return sucursalDestino;
	}

	public String getPromotorAnterior() {
		return promotorAnterior;
	}

	public String getPromotorActual() {
		return promotorActual;
	}

	public String getUsuarioID() {
		return usuarioID;
	}

	public void setSucursalOrigen(String sucursalOrigen) {
		this.sucursalOrigen = sucursalOrigen;
	}

	public void setSucursalDestino(String sucursalDestino) {
		this.sucursalDestino = sucursalDestino;
	}

	public void setPromotorAnterior(String promotorAnterior) {
		this.promotorAnterior = promotorAnterior;
	}

	public void setPromotorActual(String promotorActual) {
		this.promotorActual = promotorActual;
	}

	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}

	public String getFecha() {
		return fecha;
	}

	public void setFecha(String fecha) {
		this.fecha = fecha;
	}

	public String getClienteInicio() {
		return clienteInicio;
	}

	public String getClienteFin() {
		return clienteFin;
	}

	public void setClienteInicio(String clienteInicio) {
		this.clienteInicio = clienteInicio;
	}

	public void setClienteFin(String clienteFin) {
		this.clienteFin = clienteFin;
	}

	public String getNombreInstitucion() {
		return nombreInstitucion;
	}

	public String getFechaSistema() {
		return fechaSistema;
	}

	public String getNombreUsuario() {
		return nombreUsuario;
	}

	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}

	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}

	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}

	public String getFechaInicial() {
		return fechaInicial;
	}

	public void setFechaInicial(String fechaInicial) {
		this.fechaInicial = fechaInicial;
	}

	public String getFechaFinal() {
		return fechaFinal;
	}

	public void setFechaFinal(String fechaFinal) {
		this.fechaFinal = fechaFinal;
	}
	
	

}
