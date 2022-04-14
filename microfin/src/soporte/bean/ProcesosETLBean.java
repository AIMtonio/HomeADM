package soporte.bean;

import general.bean.BaseBean;

public class ProcesosETLBean extends BaseBean {
	private String procesoETLID;
	private String rutaArchivoSH;
	private String rutaCarpetaETL;
	private String rutaCarpetaPentaho;
	private String descripcion;
	
	public String getProcesoETLID() {
		return procesoETLID;
	}
	public void setProcesoETLID(String procesoETLID) {
		this.procesoETLID = procesoETLID;
	}
	public String getRutaArchivoSH() {
		return rutaArchivoSH;
	}
	public void setRutaArchivoSH(String rutaArchivoSH) {
		this.rutaArchivoSH = rutaArchivoSH;
	}
	public String getRutaCarpetaETL() {
		return rutaCarpetaETL;
	}
	public void setRutaCarpetaETL(String rutaCarpetaETL) {
		this.rutaCarpetaETL = rutaCarpetaETL;
	}
	public String getRutaCarpetaPentaho() {
		return rutaCarpetaPentaho;
	}
	public void setRutaCarpetaPentaho(String rutaCarpetaPentaho) {
		this.rutaCarpetaPentaho = rutaCarpetaPentaho;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
}
