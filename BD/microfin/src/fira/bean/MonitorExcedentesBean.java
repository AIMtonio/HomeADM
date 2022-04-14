package fira.bean;
import java.util.List;
import general.bean.BaseBean;

public class MonitorExcedentesBean extends BaseBean{
	
	private String grupoID;
	private String riesgoID;
	private String clienteID;
	private String nombreIntegrante;
	private String tipoPersona;
	private String rfc;
	private String curp;
	private String saldoIntegrante;
	private String saldoGrupal;

	
	private List lisGrupoID;
	private List lisRiesgoID;
	private List lisClienteID;
	private List lisNombreIntegrante;
	private List lisTipoPersona;
	private List lisRFC;
	private List lisCURP;
	private List lisSaldoIntegrante;
	private List lisSaldoGrupal;

	
	public String getGrupoID() {
		return grupoID;
	}
	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}
	public String getRiesgoID() {
		return riesgoID;
	}
	public void setRiesgoID(String riesgoID) {
		this.riesgoID = riesgoID;
	}
	public String getNombreIntegrante() {
		return nombreIntegrante;
	}
	public void setNombreIntegrante(String nombreIntegrante) {
		this.nombreIntegrante = nombreIntegrante;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getRfc() {
		return rfc;
	}
	public void setRfc(String rfc) {
		this.rfc = rfc;
	}
	public String getCurp() {
		return curp;
	}
	public void setCurp(String curp) {
		this.curp = curp;
	}
	public String getSaldoIntegrante() {
		return saldoIntegrante;
	}
	public void setSaldoIntegrante(String saldoIntegrante) {
		this.saldoIntegrante = saldoIntegrante;
	}
	public String getSaldoGrupal() {
		return saldoGrupal;
	}
	public void setSaldoGrupal(String saldoGrupal) {
		this.saldoGrupal = saldoGrupal;
	}
	public List getLisGrupoID() {
		return lisGrupoID;
	}
	public void setLisGrupoID(List lisGrupoID) {
		this.lisGrupoID = lisGrupoID;
	}
	public List getLisRiesgoID() {
		return lisRiesgoID;
	}
	public void setLisRiesgoID(List lisRiesgoID) {
		this.lisRiesgoID = lisRiesgoID;
	}
	public List getLisNombreIntegrante() {
		return lisNombreIntegrante;
	}
	public void setLisNombreIntegrante(List lisNombreIntegrante) {
		this.lisNombreIntegrante = lisNombreIntegrante;
	}
	public List getLisTipoPersona() {
		return lisTipoPersona;
	}
	public void setLisTipoPersona(List lisTipoPersona) {
		this.lisTipoPersona = lisTipoPersona;
	}
	public List getLisRFC() {
		return lisRFC;
	}
	public void setLisRFC(List lisRFC) {
		this.lisRFC = lisRFC;
	}
	public List getLisCURP() {
		return lisCURP;
	}
	public void setLisCURP(List lisCURP) {
		this.lisCURP = lisCURP;
	}
	public List getLisSaldoIntegrante() {
		return lisSaldoIntegrante;
	}
	public void setLisSaldoIntegrante(List lisSaldoIntegrante) {
		this.lisSaldoIntegrante = lisSaldoIntegrante;
	}
	public List getLisSaldoGrupal() {
		return lisSaldoGrupal;
	}
	public void setLisSaldoGrupal(List lisSaldoGrupal) {
		this.lisSaldoGrupal = lisSaldoGrupal;
	}
	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public List getLisClienteID() {
		return lisClienteID;
	}
	public void setLisClienteID(List lisClienteID) {
		this.lisClienteID = lisClienteID;
	}
}
