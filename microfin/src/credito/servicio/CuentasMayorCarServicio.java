package credito.servicio;

import credito.bean.CuentasMayorCarBean;
import credito.dao.CuentasMayorCarDAO;
import general.servicio.BaseServicio;

public class CuentasMayorCarServicio extends BaseServicio{
	
	//---------- Variables ------------------------------------------------------------------------

	CuentasMayorCarDAO cuentasMayorCarDAO = null;
	
	public CuentasMayorCarServicio(){
		super();
	}
	
	//---------- Tipos de Transacciones---------------------------------------------------------------

	public static interface Enum_Tra_CuentasMayorCar {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}
	
	//---------- Tipos de Consultas---------------------------------------------------------------

	public static interface Enum_Con_CuentasMayorCar {
		int principal = 1;
		int foranea = 2;
	}

	//---------- Tipos de Listas---------------------------------------------------------------

	public static interface Enum_Lis_CuentasMayorCar {
		int principal = 1;
		int foranea = 2;
	}
	
	//---------- Metodo que contiene las consultas ---------------------------------------------------------------

	public CuentasMayorCarBean consulta(int tipoConsulta, CuentasMayorCarBean cuentasMayorCarBean){
		CuentasMayorCarBean cuentasMayorCar = null;
		
		switch(tipoConsulta){
			case Enum_Con_CuentasMayorCar.principal:
				cuentasMayorCar = cuentasMayorCarDAO.consultaPrincipal(cuentasMayorCarBean, tipoConsulta);
				break;
		}
		
		return cuentasMayorCar;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	

	public CuentasMayorCarDAO getCuentasMayorCarDAO() {
		return cuentasMayorCarDAO;
	}

	public void setCuentasMayorCarDAO(CuentasMayorCarDAO cuentasMayorCarDAO) {
		this.cuentasMayorCarDAO = cuentasMayorCarDAO;
	}

}
