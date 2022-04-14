package cliente.bean;

import java.util.List;

import general.bean.BaseBean;

public class CliCancelaEntregaBean extends BaseBean{
	/* Atributos del Bean */
	private String cliCancelaEntregaID;
	private String clienteCancelaID;
	private String clienteID;
	private String cuentaAhoID;
	private String personaID;
	private String clienteBenID;
	private String parentesco;
	private String nombreBeneficiario;
	private String porcentaje;
	private String cantidadRecibir;
	private String estatus;
	private String nombreRecibePago;
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	/*auxiliares del bean*/
	private String radioEntregar;
	private String estatusDes;
	private String totalRecibir;
	
	/* Auxiliares para grid*/
	private List listaRadioEntregar;
	private List listaNombreRecibePago;
	private List listaCliCancelaEntregaID;
	
	
	public String getCliCancelaEntregaID() {
		return cliCancelaEntregaID;
	}
	public void setCliCancelaEntregaID(String cliCancelaEntregaID) {
		this.cliCancelaEntregaID = cliCancelaEntregaID;
	}
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
	public String getParentesco() {
		return parentesco;
	}
	public void setParentesco(String parentesco) {
		this.parentesco = parentesco;
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
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getNombreRecibePago() {
		return nombreRecibePago;
	}
	public void setNombreRecibePago(String nombreRecibePago) {
		this.nombreRecibePago = nombreRecibePago;
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
	public String getEstatusDes() {
		return estatusDes;
	}
	public void setEstatusDes(String estatusDes) {
		this.estatusDes = estatusDes;
	}
	public String getTotalRecibir() {
		return totalRecibir;
	}
	public void setTotalRecibir(String totalRecibir) {
		this.totalRecibir = totalRecibir;
	}
	public List getListaNombreRecibePago() {
		return listaNombreRecibePago;
	}
	public void setListaNombreRecibePago(List listaNombreRecibePago) {
		this.listaNombreRecibePago = listaNombreRecibePago;
	}
	public String getRadioEntregar() {
		return radioEntregar;
	}
	public void setRadioEntregar(String radioEntregar) {
		this.radioEntregar = radioEntregar;
	}
	public List getListaRadioEntregar() {
		return listaRadioEntregar;
	}
	public void setListaRadioEntregar(List listaRadioEntregar) {
		this.listaRadioEntregar = listaRadioEntregar;
	}
	public List getListaCliCancelaEntregaID() {
		return listaCliCancelaEntregaID;
	}
	public void setListaCliCancelaEntregaID(List listaCliCancelaEntregaID) {
		this.listaCliCancelaEntregaID = listaCliCancelaEntregaID;
	}
	
}