package originacion.bean;

import java.util.List;

import general.bean.BaseBean;

public class ClidatsocioeBean extends BaseBean{
	
	private String socioEID;
	private String linNegID;
	private String prospectoID;
	private String clienteID;
	private String solicitudCreditoID;
	private String catSocioEID;
	private String monto;
	private String fechaRegistro;
	private String ingresos;
	private String egresos;
	private String egresosPasivos;
	private String montoAlimentacion;
	private String descripcion;
	private String tipo;
	
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	 
	//Auxiliar grid datos socioeconomicos
	private String tipoPersona;
	private String tipoDatoSocioe;
	private List LSocioEID;
	private List LcatSocioEID;
	private List Lmonto;
	
	
	public List getLSocioEID() {
		return LSocioEID;
	}
	public void setLSocioEID(List lSocioEID) {
		LSocioEID = lSocioEID;
	}
	public List getLcatSocioEID() {
		return LcatSocioEID;
	}
	public void setLcatSocioEID(List lcatSocioEID) {
		LcatSocioEID = lcatSocioEID;
	}
	public List getLmonto() {
		return Lmonto;
	}
	public void setLmonto(List lmonto) {
		Lmonto = lmonto;
	}
	public String getTipoDatoSocioe() {
		return tipoDatoSocioe;
	}
	public void setTipoDatoSocioe(String tipoDatoSocioe) {
		this.tipoDatoSocioe = tipoDatoSocioe;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getLinNegID() {
		return linNegID;
	}
	public void setLinNegID(String linNegID) {
		this.linNegID = linNegID;
	}
	public String getSocioEID() {
		return socioEID;
	}
	public void setSocioEID(String socioEID) {
		this.socioEID = socioEID;
	}
	public String getProspectoID() {
		return prospectoID;
	}
	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getSolicitudCreditoID() {
		return solicitudCreditoID;
	}
	public void setSolicitudCreditoID(String solicitudCreditoID) {
		this.solicitudCreditoID = solicitudCreditoID;
	}
	public String getCatSocioEID() {
		return catSocioEID;
	}
	public void setCatSocioEID(String catSocioEID) {
		this.catSocioEID = catSocioEID;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
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
	public String getIngresos() {
		return ingresos;
	}
	public String getEgresos() {
		return egresos;
	}
	public void setIngresos(String ingresos) {
		this.ingresos = ingresos;
	}
	public void setEgresos(String egresos) {
		this.egresos = egresos;
	}
	public String getEgresosPasivos() {
		return egresosPasivos;
	}
	public String getMontoAlimentacion() {
		return montoAlimentacion;
	}
	public void setEgresosPasivos(String egresosPasivos) {
		this.egresosPasivos = egresosPasivos;
	}
	public void setMontoAlimentacion(String montoAlimentacion) {
		this.montoAlimentacion = montoAlimentacion;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public String getTipo() {
		return tipo;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}

	
	
}
