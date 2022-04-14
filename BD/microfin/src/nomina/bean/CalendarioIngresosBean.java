package nomina.bean;

import general.bean.BaseBean;

import java.util.List;

public class CalendarioIngresosBean extends BaseBean{
	private String institNominaID;
	private String convenioNominaID;
	private String anio;
	private String estatus;
	private String descripConvenio;
	private String descripcion;
	private String fechaLimiteEnvio;
	private String fechaPrimerDesc;
	private String fechaLimiteRecep;
	private String numCuotas;
	private String usuarioID;
	private String fechaRegistro;
	private String fechaPrimerAmorti;
	private List lisFechaLimiteEnvio;
	private List lisFechaPrimerDesc;
	private List lisFechaLimiteRecep;
	private List lisNumCuotas;
	
	
	
	public String getInstitNominaID() {
		return institNominaID;
	}
	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}
	public String getConvenioNominaID() {
		return convenioNominaID;
	}
	public void setConvenioNominaID(String convenioNominaID) {
		this.convenioNominaID = convenioNominaID;
	}
	public String getAnio() {
		return anio;
	}
	public void setAnio(String anio) {
		this.anio = anio;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getDescripConvenio() {
		return descripConvenio;
	}
	public void setDescripConvenio(String descripConvenio) {
		this.descripConvenio = descripConvenio;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getFechaLimiteEnvio() {
		return fechaLimiteEnvio;
	}
	public void setFechaLimiteEnvio(String fechaLimiteEnvio) {
		this.fechaLimiteEnvio = fechaLimiteEnvio;
	}
	public String getFechaPrimerDesc() {
		return fechaPrimerDesc;
	}
	public void setFechaPrimerDesc(String fechaPrimerDesc) {
		this.fechaPrimerDesc = fechaPrimerDesc;
	}
	
	public String getFechaLimiteRecep() {
		return fechaLimiteRecep;
	}
	public void setFechaLimiteRecep(String fechaLimiteRecep) {
		this.fechaLimiteRecep = fechaLimiteRecep;
	}
	public String getNumCuotas() {
		return numCuotas;
	}
	public void setNumCuotas(String numCuotas) {
		this.numCuotas = numCuotas;
	}
	public List getLisFechaLimiteEnvio() {
		return lisFechaLimiteEnvio;
	}
	public void setLisFechaLimiteEnvio(List lisFechaLimiteEnvio) {
		this.lisFechaLimiteEnvio = lisFechaLimiteEnvio;
	}
	public List getLisFechaPrimerDesc() {
		return lisFechaPrimerDesc;
	}
	public void setLisFechaPrimerDesc(List lisFechaPrimerDesc) {
		this.lisFechaPrimerDesc = lisFechaPrimerDesc;
	}
	public List getLisFechaLimiteRecep() {
		return lisFechaLimiteRecep;
	}
	public void setLisFechaLimiteRecep(List lisFechaLimiteRecep) {
		this.lisFechaLimiteRecep = lisFechaLimiteRecep;
	}

	public List getLisNumCuotas() {
		return lisNumCuotas;
	}
	public void setLisNumCuotas(List lisNumCuotas) {
		this.lisNumCuotas = lisNumCuotas;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getFechaPrimerAmorti() {
		return fechaPrimerAmorti;
	}
	public void setFechaPrimerAmorti(String fechaPrimerAmorti) {
		this.fechaPrimerAmorti = fechaPrimerAmorti;
	}
	
	
	
}
