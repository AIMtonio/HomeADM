package operacionesCRCB.beanWS.request;

public class AltaGrupoRequest extends BaseRequestBean {

		
	private String nombreGrupo;
	private String sucursalID;
	private String cicloActual;
	
	public String getNombreGrupo() {
		return nombreGrupo;
	}
	public void setNombreGrupo(String nombreGrupo) {
		this.nombreGrupo = nombreGrupo;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getCicloActual() {
		return cicloActual;
	}
	public void setCicloActual(String cicloActual) {
		this.cicloActual = cicloActual;
	}

	
	
	
}
