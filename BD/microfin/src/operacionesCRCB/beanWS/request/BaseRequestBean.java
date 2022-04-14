package operacionesCRCB.beanWS.request;

import java.sql.Date;

import soporte.PropiedadesSAFIBean;

import general.bean.ParametrosAuditoriaBean;
import herramientas.Utileria;

public class BaseRequestBean {

	private String usuario;
	private String direccionIP;
	private String programaID;
	private String sucursal;
	
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
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
	
	// Metodo para cargar parametros de sesion
	public ParametrosAuditoriaBean asignaParametrosAud(ParametrosAuditoriaBean bean){
		
		bean.setOrigenDatos(PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosCRCB"));
		bean.setDireccionIP(this.direccionIP);
		bean.setUsuario(Utileria.convierteEntero(this.usuario));
		bean.setNombrePrograma(this.getProgramaID());
		bean.setSucursal(Utileria.convierteEntero(this.sucursal));
		bean.setEmpresaID(1);
		bean.setFecha(new Date(0, 0, 0));
	
		return bean;
		
	}
}
