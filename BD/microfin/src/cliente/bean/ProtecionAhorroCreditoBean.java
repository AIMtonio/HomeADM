package cliente.bean;

import general.bean.BaseBean;

public class ProtecionAhorroCreditoBean extends BaseBean{
	
	private String clienteID;
	private String cuentaAhoID;
	private String fechaRegistro;
	private String usuarioReg;
	private String monAplicaCuenta;	
	private String listaCreditos;
	private String listaCuentas;
	private String creditoID;
	private String proceso;
	
	//---------CLIAPLICAPROTEC
	private String usuarioAut;
	private String fechaAutoriza;
	private String comentario;
	private String claveUsuario;
	private String contraseniaAut;	
	private String monAplicaCredito;
	private String usuarioRechaza;
	private String fechaRechaza;
	
	//----------Lista de cuentas
	private String etiqueta;	
	private String descripcionTipoCta;
	private String fechaReg;
	private String saldo;
	private String tipoCuentaID;
	
	//-------lista de Creditos
	private String producCreditoID;
	private String fechaMinistrado;																				
	private String totalAdeudo; 	
	private String estatus;	
	private String montoCredito;
	private String porcentaje;
	
	//---------lista de Beneficiarios
	private String nombre;
	private String relacion;
	private String totalRecibir;
	private String personaID;
	private String nombRecibePago;
	private String actaDefuncion;
	private String fechaDefuncion;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getUsuarioReg() {
		return usuarioReg;
	}
	public void setUsuarioReg(String usuarioReg) {
		this.usuarioReg = usuarioReg;
	}
	public String getMonAplicaCuenta() {
		return monAplicaCuenta;
	}
	public void setMonAplicaCuenta(String monAplicaCuenta) {
		this.monAplicaCuenta = monAplicaCuenta;
	}
	public String getListaCreditos() {
		return listaCreditos;
	}
	public void setListaCreditos(String listaCreditos) {
		this.listaCreditos = listaCreditos;
	}
	public String getListaCuentas() {
		return listaCuentas;
	}
	public void setListaCuentas(String listaCuentas) {
		this.listaCuentas = listaCuentas;
	}
	public String getCreditoID() {
		return creditoID;
	}
	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}
	public String getProceso() {
		return proceso;
	}
	public void setProceso(String proceso) {
		this.proceso = proceso;
	}
	public String getUsuarioAut() {
		return usuarioAut;
	}
	public void setUsuarioAut(String usuarioAut) {
		this.usuarioAut = usuarioAut;
	}
	public String getFechaAutoriza() {
		return fechaAutoriza;
	}
	public void setFechaAutoriza(String fechaAutoriza) {
		this.fechaAutoriza = fechaAutoriza;
	}
	public String getComentario() {
		return comentario;
	}
	public void setComentario(String comentario) {
		this.comentario = comentario;
	}
	public String getClaveUsuario() {
		return claveUsuario;
	}
	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}
	public String getContraseniaAut() {
		return contraseniaAut;
	}
	public void setContraseniaAut(String contraseniaAut) {
		this.contraseniaAut = contraseniaAut;
	}
	public String getMonAplicaCredito() {
		return monAplicaCredito;
	}
	public void setMonAplicaCredito(String monAplicaCredito) {
		this.monAplicaCredito = monAplicaCredito;
	}
	public String getUsuarioRechaza() {
		return usuarioRechaza;
	}
	public void setUsuarioRechaza(String usuarioRechaza) {
		this.usuarioRechaza = usuarioRechaza;
	}
	public String getFechaRechaza() {
		return fechaRechaza;
	}
	public void setFechaRechaza(String fechaRechaza) {
		this.fechaRechaza = fechaRechaza;
	}
	public String getEtiqueta() {
		return etiqueta;
	}
	public void setEtiqueta(String etiqueta) {
		this.etiqueta = etiqueta;
	}
	public String getDescripcionTipoCta() {
		return descripcionTipoCta;
	}
	public void setDescripcionTipoCta(String descripcionTipoCta) {
		this.descripcionTipoCta = descripcionTipoCta;
	}
	public String getFechaReg() {
		return fechaReg;
	}
	public void setFechaReg(String fechaReg) {
		this.fechaReg = fechaReg;
	}
	public String getSaldo() {
		return saldo;
	}
	public void setSaldo(String saldo) {
		this.saldo = saldo;
	}
	public String getProducCreditoID() {
		return producCreditoID;
	}
	public void setProducCreditoID(String producCreditoID) {
		this.producCreditoID = producCreditoID;
	}
	public String getFechaMinistrado() {
		return fechaMinistrado;
	}
	public void setFechaMinistrado(String fechaMinistrado) {
		this.fechaMinistrado = fechaMinistrado;
	}
	public String getTotalAdeudo() {
		return totalAdeudo;
	}
	public void setTotalAdeudo(String totalAdeudo) {
		this.totalAdeudo = totalAdeudo;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getMontoCredito() {
		return montoCredito;
	}
	public void setMontoCredito(String montoCredito) {
		this.montoCredito = montoCredito;
	}
	public String getPorcentaje() {
		return porcentaje;
	}
	public void setPorcentaje(String porcentaje) {
		this.porcentaje = porcentaje;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getRelacion() {
		return relacion;
	}
	public void setRelacion(String relacion) {
		this.relacion = relacion;
	}
	public String getTotalRecibir() {
		return totalRecibir;
	}
	public void setTotalRecibir(String totalRecibir) {
		this.totalRecibir = totalRecibir;
	}
	public String getPersonaID() {
		return personaID;
	}
	public void setPersonaID(String personaID) {
		this.personaID = personaID;
	}
	public String getNombRecibePago() {
		return nombRecibePago;
	}
	public void setNombRecibePago(String nombRecibePago) {
		this.nombRecibePago = nombRecibePago;
	}
	public String getActaDefuncion() {
		return actaDefuncion;
	}
	public void setActaDefuncion(String actaDefuncion) {
		this.actaDefuncion = actaDefuncion;
	}
	public String getFechaDefuncion() {
		return fechaDefuncion;
	}
	public void setFechaDefuncion(String fechaDefuncion) {
		this.fechaDefuncion = fechaDefuncion;
	}
	public String getTipoCuentaID() {
		return tipoCuentaID;
	}
	public void setTipoCuentaID(String tipoCuentaID) {
		this.tipoCuentaID = tipoCuentaID;
	}	
}