package nomina.bean;

import general.bean.BaseBean;

/**
 * @author cardinal
 *
 */
public class NomTipoClavePresupBean extends BaseBean{

	private String nomTipoClavePresupID;
	private String descripcion;			
	private String reqClave;
	private String nomClavePresupID;
	
	
	public String getNomTipoClavePresupID() {
		return nomTipoClavePresupID;
	}
	public void setNomTipoClavePresupID(String nomTipoClavePresupID) {
		this.nomTipoClavePresupID = nomTipoClavePresupID;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getReqClave() {
		return reqClave;
	}
	public void setReqClave(String reqClave) {
		this.reqClave = reqClave;
	}

	public String getNomClavePresupID() {
		return nomClavePresupID;
	}
	public void setNomClavePresupID(String nomClavePresupID) {
		this.nomClavePresupID = nomClavePresupID;
	}
	
	
}
