package cliente.bean;

import java.util.List;

import general.bean.BaseBean;
import herramientas.Utileria;

public class ClientesCancelaBean extends BaseBean{

	/* Atributos del Bean */
	private String clienteCancelaID;
	private String clienteID;
	private String areaCancela;
	private String usuarioRegistra;
	private String fechaRegistro;
	private String estatus;
	private String motivoActivaID;
	private String comentarios;
	private String sucursalRegistro; 
	private String usuarioAutoriza; 
	private String fechaAutoriza; 
	private String sucursalAutoriza;
	private String estatusDes;
	private String nombreCompleto;
	private String aplicaSeguro; 
	private String sucursalDes; 
	private String usuarioSesion;
	private String actaDefuncion; 
	private String fechaDefuncion;
	private String montoRecibir;
	private String tipoCuentaID;
	private String descripcionTipoCta;
	
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	/*Auxiliares del Bean */
	private String saldoFavorCliente;
	private String cliCancelaEntregaID;
	private String altaEncPoliza;
	private String nombreRecibePago;
	private String permiteReactivacion;
	private String polizaID;
	private String cuentaAhoID;
	private String personaID;
	private String clienteBenID;
	private String parentescoID;
	private String nombreBeneficiario;
	private String porcentaje;
	private String cantidadRecibir;
	private String inversionID;
	private String beneInverID;
	private String tipoInversionID;
	private String descripcionTipoInv;
	
	private String listaDistribucionBen;
	
	public String getPermiteReactivacion() {
		return permiteReactivacion;
	}
	public void setPermiteReactivacion(String permiteReactivacion) {
		this.permiteReactivacion = permiteReactivacion;
	}
	/* Atributos para reporte */
	private String fechaInicio;
	private String fechaFin;
	private String nombreInstitucion;
	private String fechaSistema;
	private String nombreUsuario;
	private String nombreCliente;
	private String sucursalCliente;
	private String sucursalID;
	
	
	public String getClienteCancelaID() {
		return clienteCancelaID;
	}
	public void setClienteCancelaID(String clienteCancelaID) {
		this.clienteCancelaID = clienteCancelaID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getAreaCancela() {
		return areaCancela;
	}
	public void setAreaCancela(String areaCancela) {
		this.areaCancela = areaCancela;
	}
	public String getUsuarioRegistra() {
		return usuarioRegistra;
	}
	public void setUsuarioRegistra(String usuarioRegistra) {
		this.usuarioRegistra = usuarioRegistra;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getMotivoActivaID() {
		return motivoActivaID;
	}
	public void setMotivoActivaID(String motivoActivaID) {
		this.motivoActivaID = motivoActivaID;
	}
	public String getComentarios() {
		return comentarios;
	}
	public void setComentarios(String comentarios) {
		this.comentarios = comentarios;
	}
	public String getSucursalRegistro() {
		return sucursalRegistro;
	}
	public void setSucursalRegistro(String sucursalRegistro) {
		this.sucursalRegistro = sucursalRegistro;
	}
	public String getUsuarioAutoriza() {
		return usuarioAutoriza;
	}
	public void setUsuarioAutoriza(String usuarioAutoriza) {
		this.usuarioAutoriza = usuarioAutoriza;
	}
	public String getFechaAutoriza() {
		return fechaAutoriza;
	}
	public void setFechaAutoriza(String fechaAutoriza) {
		this.fechaAutoriza = fechaAutoriza;
	}
	public String getSucursalAutoriza() {
		return sucursalAutoriza;
	}
	public void setSucursalAutoriza(String sucursalAutoriza) {
		this.sucursalAutoriza = sucursalAutoriza;
	}
	public String getEstatusDes() {
		return estatusDes;
	}
	public void setEstatusDes(String estatusDes) {
		this.estatusDes = estatusDes;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
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
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
	public String getNombreUsuario() {
		return nombreUsuario;
	}
	public void setNombreUsuario(String nombreUsuario) {
		this.nombreUsuario = nombreUsuario;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getSucursalCliente() {
		return sucursalCliente;
	}
	public void setSucursalCliente(String sucursalCliente) {
		this.sucursalCliente = sucursalCliente;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getAplicaSeguro() {
		return aplicaSeguro;
	}
	public void setAplicaSeguro(String aplicaSeguro) {
		this.aplicaSeguro = aplicaSeguro;
	}
	public String getSucursalDes() {
		return sucursalDes;
	}
	public void setSucursalDes(String sucursalDes) {
		this.sucursalDes = sucursalDes;
	}
	public String getUsuarioSesion() {
		return usuarioSesion;
	}
	public void setUsuarioSesion(String usuarioSesion) {
		this.usuarioSesion = usuarioSesion;
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
	public String getSaldoFavorCliente() {
		return saldoFavorCliente;
	}
	public void setSaldoFavorCliente(String saldoFavorCliente) {
		this.saldoFavorCliente = saldoFavorCliente;
	}
	public String getCliCancelaEntregaID() {
		return cliCancelaEntregaID;
	}
	public void setCliCancelaEntregaID(String cliCancelaEntregaID) {
		this.cliCancelaEntregaID = cliCancelaEntregaID;
	}
	public String getAltaEncPoliza() {
		return altaEncPoliza;
	}
	public void setAltaEncPoliza(String altaEncPoliza) {
		this.altaEncPoliza = altaEncPoliza;
	}
	public String getNombreRecibePago() {
		return nombreRecibePago;
	}
	public void setNombreRecibePago(String nombreRecibePago) {
		this.nombreRecibePago = nombreRecibePago;
	}
	public String getMontoRecibir() {
		return montoRecibir;
	}
	public void setMontoRecibir(String montoRecibir) {
		this.montoRecibir = montoRecibir;
	}
	public String getTipoCuentaID() {
		return tipoCuentaID;
	}
	public void setTipoCuentaID(String tipoCuentaID) {
		this.tipoCuentaID = tipoCuentaID;
	}
	public String getDescripcionTipoCta() {
		return descripcionTipoCta;
	}
	public void setDescripcionTipoCta(String descripcionTipoCta) {
		this.descripcionTipoCta = descripcionTipoCta;
	}
	
	public String getPolizaID() {
		return polizaID;
	}
	public void setPolizaID(String polizaID) {
		this.polizaID = polizaID;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getPersonaID() {
		return personaID;
	}
	public void setPersonaID(String personaID) {
		this.personaID = personaID;
	}
	public String getClienteBenID() {
		return clienteBenID;
	}
	public void setClienteBenID(String clienteBenID) {
		this.clienteBenID = clienteBenID;
	}
	public String getParentescoID() {
		return parentescoID;
	}
	public void setParentescoID(String parentescoID) {
		this.parentescoID = parentescoID;
	}
	public String getNombreBeneficiario() {
		return nombreBeneficiario;
	}
	public void setNombreBeneficiario(String nombreBeneficiario) {
		this.nombreBeneficiario = nombreBeneficiario;
	}
	public String getPorcentaje() {
		return porcentaje;
	}
	public void setPorcentaje(String porcentaje) {
		this.porcentaje = porcentaje;
	}
	public String getCantidadRecibir() {
		return cantidadRecibir;
	}
	public void setCantidadRecibir(String cantidadRecibir) {
		this.cantidadRecibir = cantidadRecibir;
	}

	public String getListaDistribucionBen() {
		return listaDistribucionBen;
	}
	public void setListaDistribucionBen(String listaDistribucionBen) {
		this.listaDistribucionBen = listaDistribucionBen;
	}
	public String getInversionID() {
		return inversionID;
	}
	public void setInversionID(String inversionID) {
		this.inversionID = inversionID;
	}
	public String getBeneInverID() {
		return beneInverID;
	}
	public void setBeneInverID(String beneInverID) {
		this.beneInverID = beneInverID;
	}
	public String getTipoInversionID() {
		return tipoInversionID;
	}
	public void setTipoInversionID(String tipoInversionID) {
		this.tipoInversionID = tipoInversionID;
	}
	public String getDescripcionTipoInv() {
		return descripcionTipoInv;
	}
	public void setDescripcionTipoInv(String descripcionTipoInv) {
		this.descripcionTipoInv = descripcionTipoInv;
	}

}