package cliente.bean;

import general.bean.BaseBean;

public class CuentasTransferBean  extends BaseBean{
	private String clienteID;
	private String cuentaTranID;
	private String institucionID;
	private String clabe;
	private String beneficiario;
	private String alias;
	private String fechaRegistro;
	private String usuarioAutoriza;
	private String fechaAutoriza;
	private String usuarioBaja;
	private String fechaBaja;
	private String estatus;
	private String tipoCuenta;
	private String cuentaDestino;
	private String clienteDestino;
	private String numClienteCa;
	private String cuentaAhoIDCa;
	private String CtaNomCompletTipoCta;
	private String tipoCuentaSpei;
	private String beneficiarioRFC;
	public String tipoCtaBenSPEI;
	private String esPrincipal;
	private String aplicaPara;
	private String estatusDomicilio;

	public String getTipoCtaBenSPEI() {
		return tipoCtaBenSPEI;
	}
	public void setTipoCtaBenSPEI(String tipoCtaBenSPEI) {
		this.tipoCtaBenSPEI = tipoCtaBenSPEI;
	}
	private String empresaID;
	private String usuario;
	private String sucursal;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String numTransaccion;
	
	
	
	//-----------auxiliares---------
	private String nombre;
	private String nombreClienteD;
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getCuentaTranID() {
		return cuentaTranID;
	}
	public void setCuentaTranID(String cuentaTranID) {
		this.cuentaTranID = cuentaTranID;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getClabe() {
		return clabe;
	}
	public void setClabe(String clabe) {
		this.clabe = clabe;
	}
	public String getBeneficiario() {
		return beneficiario;
	}
	public void setBeneficiario(String beneficiario) {
		this.beneficiario = beneficiario;
	}
	public String getAlias() {
		return alias;
	}
	public void setAlias(String alias) {
		this.alias = alias;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
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
	public String getUsuarioBaja() {
		return usuarioBaja;
	}
	public void setUsuarioBaja(String usuarioBaja) {
		this.usuarioBaja = usuarioBaja;
	}
	public String getFechaBaja() {
		return fechaBaja;
	}
	public void setFechaBaja(String fechaBaja) {
		this.fechaBaja = fechaBaja;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
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
	public String getSucursal() {
		return sucursal;
	}
	public void setSucursal(String sucursal) {
		this.sucursal = sucursal;
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
	public String getNumTransaccion() {
		return numTransaccion;
	}
	public void setNumTransaccion(String numTransaccion) {
		this.numTransaccion = numTransaccion;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getTipoCuenta() {
		return tipoCuenta;
	}
	public String getCuentaDestino() {
		return cuentaDestino;
	}
	public String getClienteDestino() {
		return clienteDestino;
	}
	public void setTipoCuenta(String tipoCuenta) {
		this.tipoCuenta = tipoCuenta;
	}
	public void setCuentaDestino(String cuentaDestino) {
		this.cuentaDestino = cuentaDestino;
	}
	public void setClienteDestino(String clienteDestino) {
		this.clienteDestino = clienteDestino;
	}
	public String getNombreClienteD() {
		return nombreClienteD;
	}
	public void setNombreClienteD(String nombreClienteD) {
		this.nombreClienteD = nombreClienteD;
	}
	public String getNumClienteCa() {
		return numClienteCa;
	}
	public String getCuentaAhoIDCa() {
		return cuentaAhoIDCa;
	}
	public void setNumClienteCa(String numClienteCa) {
		this.numClienteCa = numClienteCa;
	}
	public void setCuentaAhoIDCa(String cuentaAhoIDCa) {
		this.cuentaAhoIDCa = cuentaAhoIDCa;
	}
	public String getCtaNomCompletTipoCta() {
		return CtaNomCompletTipoCta;
	}
	public void setCtaNomCompletTipoCta(String ctaNomCompletTipoCta) {
		CtaNomCompletTipoCta = ctaNomCompletTipoCta;
	}
	public String getTipoCuentaSpei() {
		return tipoCuentaSpei;
	}
	public void setTipoCuentaSpei(String tipoCuentaSpei) {
		this.tipoCuentaSpei = tipoCuentaSpei;
	}
	public String getBeneficiarioRFC() {
		return beneficiarioRFC;
	}
	public void setBeneficiarioRFC(String beneficiarioRFC) {
		this.beneficiarioRFC = beneficiarioRFC;
	}
	public String getEsPrincipal() {
		return esPrincipal;
	}
	public void setEsPrincipal(String esPrincipal) {
		this.esPrincipal = esPrincipal;
	}
	public String getAplicaPara() {
		return aplicaPara;
	}
	public void setAplicaPara(String aplicaPara) {
		this.aplicaPara = aplicaPara;
	}
	public String getEstatusDomicilio() {
		return estatusDomicilio;
	}
	public void setEstatusDomicilio(String estatusDomicilio) {
		this.estatusDomicilio = estatusDomicilio;
	}

}
