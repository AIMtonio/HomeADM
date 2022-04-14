package tarjetas.bean;

import general.bean.BaseBean;

public class CatalogoBloqueoCancelacionTarDebitoBean extends BaseBean{
	
	private String motCanBloID;
	private String descripcion;
	
	public String getMotCanBloID() {
		return motCanBloID;
	}
	public void setMotCanBloID(String motCanBloID) {
		this.motCanBloID = motCanBloID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
}