package cliente.bean;

import general.bean.BaseBean;

public class ApoyoEscolarSolBean extends BaseBean  {
	
	/*ATRIBUTOS DE LA TABLA */
	private String apoyoEscSolID;
	private String clienteID;
	private String apoyoEscCicloID;
	private String gradoEscolar;
	private String promedioEscolar;
	private String edadCliente;
	private String cicloEscolar;
	private String nombreEscuela;
	private String direccionEscuela;
	private String usuarioRegistra;
	private String usuarioAutoriza;
	private String estatus;
	private String fechaRegistro;
	private String fechaAutoriza;
	private String fechaPago;
	private String monto;
	private String transaccionPago;
	private String polizaID;
	private String cajaID;
	private String sucursalCajaID;
	private String sucursalRegistroID;
	private String comentario;
	private String nombreCompleto;
	private String desCicloEscolar;
	private String descripcionSolcitud;

	
	/*PARAMETROS DE AUDITORIA */
	private String empresaID;
	private String usuario;
	private String fechaActual;  
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	public static int LONGITUD_ID = 10;
	
	
	/*=========== SETTER'S Y GETTER'S ============== */
	
	public String getApoyoEscSolID() {
		return apoyoEscSolID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public String getApoyoEscCicloID() {
		return apoyoEscCicloID;
	}
	public String getGradoEscolar() {
		return gradoEscolar;
	}
	public String getPromedioEscolar() {
		return promedioEscolar;
	}
	public String getEdadCliente() {
		return edadCliente;
	}
	public String getCicloEscolar() {
		return cicloEscolar;
	}
	public String getNombreEscuela() {
		return nombreEscuela;
	}
	public String getDireccionEscuela() {
		return direccionEscuela;
	}
	public String getUsuarioRegistra() {
		return usuarioRegistra;
	}
	public String getUsuarioAutoriza() {
		return usuarioAutoriza;
	}
	public String getEstatus() {
		return estatus;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public String getFechaAutoriza() {
		return fechaAutoriza;
	}
	public String getFechaPago() {
		return fechaPago;
	}
	public String getMonto() {
		return monto;
	}
	public String getTransaccionPago() {
		return transaccionPago;
	}
	public String getPolizaID() {
		return polizaID;
	}
	public String getCajaID() {
		return cajaID;
	}
	public String getSucursalCajaID() {
		return sucursalCajaID;
	}
	public String getSucursalRegistroID() {
		return sucursalRegistroID;
	}
	public String getComentario() {
		return comentario;
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
	public void setApoyoEscSolID(String apoyoEscSolID) {
		this.apoyoEscSolID = apoyoEscSolID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public void setApoyoEscCicloID(String apoyoEscCicloID) {
		this.apoyoEscCicloID = apoyoEscCicloID;
	}
	public void setGradoEscolar(String gradoEscolar) {
		this.gradoEscolar = gradoEscolar;
	}
	public void setPromedioEscolar(String promedioEscolar) {
		this.promedioEscolar = promedioEscolar;
	}
	public void setEdadCliente(String edadCliente) {
		this.edadCliente = edadCliente;
	}
	public void setCicloEscolar(String cicloEscolar) {
		this.cicloEscolar = cicloEscolar;
	}
	public void setNombreEscuela(String nombreEscuela) {
		this.nombreEscuela = nombreEscuela;
	}
	public void setDireccionEscuela(String direccionEscuela) {
		this.direccionEscuela = direccionEscuela;
	}
	public void setUsuarioRegistra(String usuarioRegistra) {
		this.usuarioRegistra = usuarioRegistra;
	}
	public void setUsuarioAutoriza(String usuarioAutoriza) {
		this.usuarioAutoriza = usuarioAutoriza;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public void setFechaAutoriza(String fechaAutoriza) {
		this.fechaAutoriza = fechaAutoriza;
	}
	public void setFechaPago(String fechaPago) {
		this.fechaPago = fechaPago;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public void setTransaccionPago(String transaccionPago) {
		this.transaccionPago = transaccionPago;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public void setCajaID(String cajaID) {
		this.cajaID = cajaID;
	}
	public void setSucursalCajaID(String sucursalCajaID) {
		this.sucursalCajaID = sucursalCajaID;
	}
	public void setSucursalRegistroID(String sucursalRegistroID) {
		this.sucursalRegistroID = sucursalRegistroID;
	}
	public void setComentario(String comentario) {
		this.comentario = comentario;
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
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getDesCicloEscolar() {
		return desCicloEscolar;
	}
	public void setDesCicloEscolar(String desCicloEscolar) {
		this.desCicloEscolar = desCicloEscolar;
	}

	public String getDescripcionSolcitud() {
		return descripcionSolcitud;
	}
	public void setDescripcionSolcitud(String descripcionSolcitud) {
		this.descripcionSolcitud = descripcionSolcitud;
	}
	
	

}
