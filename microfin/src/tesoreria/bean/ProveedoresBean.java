package tesoreria.bean;

import java.util.List;

import general.bean.BaseBean;

public class ProveedoresBean extends BaseBean {

	private String proveedorID;
	private String institucionID;
	private String apellidoPaterno;
	private String apellidoMaterno;
	private String primerNombre;
	private String segundoNombre;
	private String tipoPersona;
	private String fechaNacimiento;
	private String CURP;
	private String razonSocial;
	private String RFC;
	private String RFCpm;
	private String tipoPago;
	private String cuentaClave;
	private String cuentaCompleta;
	private String cuentaAnticipo;
	private String tipoProveedorID;
	private String correo;
	private String telefono;
	private String telefonoCelular;
	private String estatus;
	private String extTelefonoPart;
	private String tipoTerceroID;
	private String descripTipoTer;
	private String tipoOperacionID;
	private String descripTipoOper;
	private String paisResidencia;
	private String descPaisResidencia;
	private String nacionalidad;
	private String idFiscal;
	private String paisNacimiento;
	private String estadoNacimiento;

	// beans de pantalla de relacion entre prov. y tipos de gasto
	private String tipoGastoID;
	private List ListaSucursales;

	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;

	public String getProveedorID() {
		return proveedorID;
	}

	public void setProveedorID(String proveedorID) {
		this.proveedorID = proveedorID;
	}

	public String getInstitucionID() {
		return institucionID;
	}

	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}

	public String getApellidoPaterno() {
		return apellidoPaterno;
	}

	public void setApellidoPaterno(String apellidoPaterno) {
		this.apellidoPaterno = apellidoPaterno;
	}

	public String getApellidoMaterno() {
		return apellidoMaterno;
	}

	public void setApellidoMaterno(String apellidoMaterno) {
		this.apellidoMaterno = apellidoMaterno;
	}

	public String getPrimerNombre() {
		return primerNombre;
	}

	public void setPrimerNombre(String primerNombre) {
		this.primerNombre = primerNombre;
	}

	public String getSegundoNombre() {
		return segundoNombre;
	}

	public void setSegundoNombre(String segundoNombre) {
		this.segundoNombre = segundoNombre;
	}

	public String getTipoPersona() {
		return tipoPersona;
	}

	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}

	public String getFechaNacimiento() {
		return fechaNacimiento;
	}

	public void setFechaNacimiento(String fechaNacimiento) {
		this.fechaNacimiento = fechaNacimiento;
	}

	public String getCURP() {
		return CURP;
	}

	public void setCURP(String cURP) {
		CURP = cURP;
	}

	public String getRazonSocial() {
		return razonSocial;
	}

	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}

	public String getRFC() {
		return RFC;
	}

	public void setRFC(String rFC) {
		RFC = rFC;
	}

	public String getRFCpm() {
		return RFCpm;
	}

	public void setRFCpm(String rFCpm) {
		RFCpm = rFCpm;
	}

	public String getTipoPago() {
		return tipoPago;
	}

	public void setTipoPago(String tipoPago) {
		this.tipoPago = tipoPago;
	}

	public String getCuentaClave() {
		return cuentaClave;
	}

	public void setCuentaClave(String cuentaClave) {
		this.cuentaClave = cuentaClave;
	}

	public String getCuentaCompleta() {
		return cuentaCompleta;
	}

	public void setCuentaCompleta(String cuentaCompleta) {
		this.cuentaCompleta = cuentaCompleta;
	}

	public String getCuentaAnticipo() {
		return cuentaAnticipo;
	}

	public void setCuentaAnticipo(String cuentaAnticipo) {
		this.cuentaAnticipo = cuentaAnticipo;
	}

	public String getTipoProveedorID() {
		return tipoProveedorID;
	}

	public void setTipoProveedorID(String tipoProveedorID) {
		this.tipoProveedorID = tipoProveedorID;
	}

	public String getCorreo() {
		return correo;
	}

	public void setCorreo(String correo) {
		this.correo = correo;
	}

	public String getTelefono() {
		return telefono;
	}

	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}

	public String getTelefonoCelular() {
		return telefonoCelular;
	}

	public void setTelefonoCelular(String telefonoCelular) {
		this.telefonoCelular = telefonoCelular;
	}

	public String getEstatus() {
		return estatus;
	}

	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}

	public String getTipoGastoID() {
		return tipoGastoID;
	}

	public void setTipoGastoID(String tipoGastoID) {
		this.tipoGastoID = tipoGastoID;
	}

	public List getListaSucursales() {
		return ListaSucursales;
	}

	public void setListaSucursales(List listaSucursales) {
		ListaSucursales = listaSucursales;
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

	public String getExtTelefonoPart() {
		return extTelefonoPart;
	}

	public void setExtTelefonoPart(String extTelefonoPart) {
		this.extTelefonoPart = extTelefonoPart;
	}

	public String getTipoTerceroID() {
		return tipoTerceroID;
	}

	public void setTipoTerceroID(String tipoTerceroID) {
		this.tipoTerceroID = tipoTerceroID;
	}

	public String getDescripTipoTer() {
		return descripTipoTer;
	}

	public void setDescripTipoTer(String descripTipoTer) {
		this.descripTipoTer = descripTipoTer;
	}

	public String getTipoOperacionID() {
		return tipoOperacionID;
	}

	public void setTipoOperacionID(String tipoOperacionID) {
		this.tipoOperacionID = tipoOperacionID;
	}

	public String getDescripTipoOper() {
		return descripTipoOper;
	}

	public void setDescripTipoOper(String descripTipoOper) {
		this.descripTipoOper = descripTipoOper;
	}

	public String getPaisResidencia() {
		return paisResidencia;
	}

	public void setPaisResidencia(String paisResidencia) {
		this.paisResidencia = paisResidencia;
	}

	public String getDescPaisResidencia() {
		return descPaisResidencia;
	}

	public void setDescPaisResidencia(String descPaisResidencia) {
		this.descPaisResidencia = descPaisResidencia;
	}

	public String getNacionalidad() {
		return nacionalidad;
	}

	public void setNacionalidad(String nacionalidad) {
		this.nacionalidad = nacionalidad;
	}

	public String getIdFiscal() {
		return idFiscal;
	}

	public void setIdFiscal(String idFiscal) {
		this.idFiscal = idFiscal;
	}

	public String getPaisNacimiento() {
		return paisNacimiento;
	}

	public void setPaisNacimiento(String paisNacimiento) {
		this.paisNacimiento = paisNacimiento;
	}

	public String getEstadoNacimiento() {
		return estadoNacimiento;
	}

	public void setEstadoNacimiento(String estadoNacimiento) {
		this.estadoNacimiento = estadoNacimiento;
	}

}