package seguimiento.bean;

import java.util.List;

import general.bean.BaseBean;

public class RegistroGestorBean extends BaseBean{
	private String gestorID;
	private String tipoGestionID;
	private String supervisorID;
	private String tipoAmbito;
	private String nombreGestor;
	private String nombreTipoGestion;
	private String nombreSupervisor;
	
	private String sucursalID;
	private String descripcion;
	
	private String promotorID;
	private String nombrePromotor;
	private String descripcionProm;
	
	private String estadoID;
	private String descripcionEst;
	
	private String municipioID;
	private String descripcionMun;
	
	private String localidadID;
	private String descripcionLoc;
	
	private String coloniaID;
	private String descripcionCol;
	
	private List lsucursalID;
	private List ldescripcion;
	
	private List lpromotorID;
	private List ldescripcionProm;
	
	private List lestadoID;
	private List ldescripcionEst;
	
	private List lmunicipioID;
	private List ldescripcionMun;
	
	private List llocalidadID;
	private List ldescripcionLoc;
	
	private List lcoloniaID;
	private List ldescripcionCol;
	
	public String getGestorID() {
		return gestorID;
	}
	public void setGestorID(String gestorID) {
		this.gestorID = gestorID;
	}	
	public String getTipoGestionID() {
		return tipoGestionID;
	}
	public void setTipoGestionID(String tipoGestionID) {
		this.tipoGestionID = tipoGestionID;
	}
	
	public String getSupervisorID() {
		return supervisorID;
	}
	public void setSupervisorID(String supervisorID) {
		this.supervisorID = supervisorID;
	}
	public String getNombreTipoGestion() {
		return nombreTipoGestion;
	}
	public void setNombreTipoGestion(String nombreTipoGestion) {
		this.nombreTipoGestion = nombreTipoGestion;
	}
	public String getNombreSupervisor() {
		return nombreSupervisor;
	}
	public void setNombreSupervisor(String nombreSupervisor) {
		this.nombreSupervisor = nombreSupervisor;
	}
	public String getTipoAmbito() {
		return tipoAmbito;
	}
	public void setTipoAmbito(String tipoAmbito) {
		this.tipoAmbito = tipoAmbito;
	}
	public String getNombreGestor() {
		return nombreGestor;
	}
	public void setNombreGestor(String nombreGestor) {
		this.nombreGestor = nombreGestor;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getPromotorID() {
		return promotorID;
	}
	public void setPromotorID(String promotorID) {
		this.promotorID = promotorID;
	}
	public String getNombrePromotor() {
		return nombrePromotor;
	}
	public void setNombrePromotor(String nombrePromotor) {
		this.nombrePromotor = nombrePromotor;
	}
	public String getDescripcionProm() {
		return descripcionProm;
	}
	public void setDescripcionProm(String descripcionProm) {
		this.descripcionProm = descripcionProm;
	}
	public List getLsucursalID() {
		return lsucursalID;
	}
	public void setLsucursalID(List lsucursalID) {
		this.lsucursalID = lsucursalID;
	}
	public List getLdescripcion() {
		return ldescripcion;
	}
	public void setLdescripcion(List ldescripcion) {
		this.ldescripcion = ldescripcion;
	}
	public List getLpromotorID() {
		return lpromotorID;
	}
	public void setLpromotorID(List lpromotorID) {
		this.lpromotorID = lpromotorID;
	}
	public List getLdescripcionProm() {
		return ldescripcionProm;
	}
	public void setLdescripcionProm(List ldescripcionProm) {
		this.ldescripcionProm = ldescripcionProm;
	}
	public String getEstadoID() {
		return estadoID;
	}
	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
	}
	public String getDescripcionEst() {
		return descripcionEst;
	}
	public void setDescripcionEst(String descripcionEst) {
		this.descripcionEst = descripcionEst;
	}
	public String getMunicipioID() {
		return municipioID;
	}
	public void setMunicipioID(String municipioID) {
		this.municipioID = municipioID;
	}
	public String getDescripcionMun() {
		return descripcionMun;
	}
	public void setDescripcionMun(String descripcionMun) {
		this.descripcionMun = descripcionMun;
	}
	public String getLocalidadID() {
		return localidadID;
	}
	public void setLocalidadID(String localidadID) {
		this.localidadID = localidadID;
	}
	public String getDescripcionLoc() {
		return descripcionLoc;
	}
	public void setDescripcionLoc(String descripcionLoc) {
		this.descripcionLoc = descripcionLoc;
	}
	public String getColoniaID() {
		return coloniaID;
	}
	public void setColoniaID(String coloniaID) {
		this.coloniaID = coloniaID;
	}
	public String getDescripcionCol() {
		return descripcionCol;
	}
	public void setDescripcionCol(String descripcionCol) {
		this.descripcionCol = descripcionCol;
	}
	public List getLestadoID() {
		return lestadoID;
	}
	public void setLestadoID(List lestadoID) {
		this.lestadoID = lestadoID;
	}
	public List getLdescripcionEst() {
		return ldescripcionEst;
	}
	public void setLdescripcionEst(List ldescripcionEst) {
		this.ldescripcionEst = ldescripcionEst;
	}
	public List getLmunicipioID() {
		return lmunicipioID;
	}
	public void setLmunicipioID(List lmunicipioID) {
		this.lmunicipioID = lmunicipioID;
	}
	public List getLdescripcionMun() {
		return ldescripcionMun;
	}
	public void setLdescripcionMun(List ldescripcionMun) {
		this.ldescripcionMun = ldescripcionMun;
	}
	public List getLlocalidadID() {
		return llocalidadID;
	}
	public void setLlocalidadID(List llocalidadID) {
		this.llocalidadID = llocalidadID;
	}
	public List getLdescripcionLoc() {
		return ldescripcionLoc;
	}
	public void setLdescripcionLoc(List ldescripcionLoc) {
		this.ldescripcionLoc = ldescripcionLoc;
	}
	public List getLcoloniaID() {
		return lcoloniaID;
	}
	public void setLcoloniaID(List lcoloniaID) {
		this.lcoloniaID = lcoloniaID;
	}
	public List getLdescripcionCol() {
		return ldescripcionCol;
	}
	public void setLdescripcionCol(List ldescripcionCol) {
		this.ldescripcionCol = ldescripcionCol;
	}	
}
