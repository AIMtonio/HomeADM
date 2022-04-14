package tesoreria.bean;

import general.bean.BaseBean;

public class AlgoritmoDepRefBean extends BaseBean{
	private String institucionID;
	private String algoritmoID;
	private String nombreAlgoritmo;
	private String procedimiento;
	
	public String getInstitucionID() {
		return institucionID;
	}
	public String getAlgoritmoID() {
		return algoritmoID;
	}
	public String getNombreAlgoritmo() {
		return nombreAlgoritmo;
	}
	public String getProcedimiento() {
		return procedimiento;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public void setAlgoritmoID(String algoritmoID) {
		this.algoritmoID = algoritmoID;
	}
	public void setNombreAlgoritmo(String nombreAlgoritmo) {
		this.nombreAlgoritmo = nombreAlgoritmo;
	}
	public void setProcedimiento(String procedimiento) {
		this.procedimiento = procedimiento;
	}
}
