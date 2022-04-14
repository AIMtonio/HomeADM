package tesoreria.bean;
import general.bean.BaseBean;
public class CuentasAhoSucBean extends BaseBean{

	public String cuentaSucurID; 
	public String sucursalID;
	public String institucionID; 
	public String cueClave; 
	public String esPrincipal; 
	public String estatus;
	public String cuentaAhoID;
	
	
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getCuentaSucurID() {
		return cuentaSucurID;
	}
	public void setCuentaSucurID(String cuentaSucurID) {
		this.cuentaSucurID = cuentaSucurID;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getCueClave() {
		return cueClave;
	}
	public void setCueClave(String cueClave) {
		this.cueClave = cueClave;
	}
	public String getEsPrincipal() {
		return esPrincipal;
	}
	public void setEsPrincipal(String esPrincipal) {
		this.esPrincipal = esPrincipal;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	

}
