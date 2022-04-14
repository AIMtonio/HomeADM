package credito.bean;

import general.bean.BaseBean;

public class RepPerfilGrupoCreditoBean extends BaseBean {
	
	private String GrupoID;
	private String nombreGrupo;
	private String fechaRegistro;
	private String cicloActual;
	private String SucursalID;
	private String nombreSucur;
	private String estatusCiclo;
	private String fechaUltCiclo;
	private String nombrePromotor;
	private String direccionCompleta;
	
// variables auxiliares del Bean
	private String nombreInstitucion;
	private String Usuario;
	private String fechaEmision;
	
	public String getGrupoID() {
		return GrupoID;
	}
	public void setGrupoID(String grupoID) {
		GrupoID = grupoID;
	}
	public String getNombreGrupo() {
		return nombreGrupo;
	}
	public void setNombreGrupo(String nombreGrupo) {
		this.nombreGrupo = nombreGrupo;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getCicloActual() {
		return cicloActual;
	}
	public void setCicloActual(String cicloActual) {
		this.cicloActual = cicloActual;
	}
	public String getSucursalID() {
		return SucursalID;
	}
	public void setSucursalID(String sucursalID) {
		SucursalID = sucursalID;
	}
	public String getNombreSucur() {
		return nombreSucur;
	}
	public void setNombreSucur(String nombreSucur) {
		this.nombreSucur = nombreSucur;
	}
	public String getEstatusCiclo() {
		return estatusCiclo;
	}
	public void setEstatusCiclo(String estatusCiclo) {
		this.estatusCiclo = estatusCiclo;
	}
	public String getFechaUltCiclo() {
		return fechaUltCiclo;
	}
	public void setFechaUltCiclo(String fechaUltCiclo) {
		this.fechaUltCiclo = fechaUltCiclo;
	}
	public String getNombrePromotor() {
		return nombrePromotor;
	}
	public void setNombrePromotor(String nombrePromotor) {
		this.nombrePromotor = nombrePromotor;
	}
	public String getDireccionCompleta() {
		return direccionCompleta;
	}
	public void setDireccionCompleta(String direccionCompleta) {
		this.direccionCompleta = direccionCompleta;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getUsuario() {
		return Usuario;
	}
	public void setUsuario(String usuario) {
		Usuario = usuario;
	}
	public String getFechaEmision() {
		return fechaEmision;
	}
	public void setFechaEmision(String fechaEmision) {
		this.fechaEmision = fechaEmision;
	}
	

}
