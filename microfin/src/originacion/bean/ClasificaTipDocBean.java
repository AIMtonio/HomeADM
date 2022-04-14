package originacion.bean;

import java.util.List;

import general.bean.BaseBean;

public class ClasificaTipDocBean extends BaseBean{
	private String clasificaTipDocID;
	private String clasificaDesc;
	private String clasificaTipo;
	private String tipoGrupInd;
	private String grupoAplica;
	private String esGarantia;
	
	//Grid de Clasificacion  por Doc
	private String clasDocID;
	private String tipoDocID;
	private String descDocumento;
	
	private List lisClasDocID;
	private List lisTipoDocID;
	private List lisDescDocumento;
	
	private String empresaID;
	private String usuario;
	private String fechaActual;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	private String numTransaccion;
	
	// beans auxiliares
	private String asignado;
	
	
	public String getAsignado() {
		return asignado;
	}
	public void setAsignado(String asignado) {
		this.asignado = asignado;
	}
	public String getClasificaTipDocID() {
		return clasificaTipDocID;
	}
	public String getClasificaDesc() {
		return clasificaDesc;
	}
	public String getClasificaTipo() {
		return clasificaTipo;
	}
	public String getTipoGrupInd() {
		return tipoGrupInd;
	}
	public String getGrupoAplica() {
		return grupoAplica;
	}
	public String getEsGarantia() {
		return esGarantia;
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
	public void setClasificaTipDocID(String clasificaTipDocID) {
		this.clasificaTipDocID = clasificaTipDocID;
	}
	public void setClasificaDesc(String clasificaDesc) {
		this.clasificaDesc = clasificaDesc;
	}
	public void setClasificaTipo(String clasificaTipo) {
		this.clasificaTipo = clasificaTipo;
	}
	public void setTipoGrupInd(String tipoGrupInd) {
		this.tipoGrupInd = tipoGrupInd;
	}
	public void setGrupoAplica(String grupoAplica) {
		this.grupoAplica = grupoAplica;
	}
	public void setEsGarantia(String esGarantia) {
		this.esGarantia = esGarantia;
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
	public String getDescDocumento() {
		return descDocumento;
	}
	public void setDescDocumento(String descDocumento) {
		this.descDocumento = descDocumento;
	}
	public String getClasDocID() {
		return clasDocID;
	}
	public void setClasDocID(String clasDocID) {
		this.clasDocID = clasDocID;
	}
	public String getTipoDocID() {
		return tipoDocID;
	}
	public void setTipoDocID(String tipoDocID) {
		this.tipoDocID = tipoDocID;
	}
	public List getLisClasDocID() {
		return lisClasDocID;
	}
	public void setLisClasDocID(List lisClasDocID) {
		this.lisClasDocID = lisClasDocID;
	}
	public List getLisTipoDocID() {
		return lisTipoDocID;
	}
	public void setLisTipoDocID(List lisTipoDocID) {
		this.lisTipoDocID = lisTipoDocID;
	}
	public List getLisDescDocumento() {
		return lisDescDocumento;
	}
	public void setLisDescDocumento(List lisDescDocumento) {
		this.lisDescDocumento = lisDescDocumento;
	}
	
	
	
}
