package invkubo.servicio;



import invkubo.bean.CuentasMayorKuboBean;
import invkubo.dao.CuentasMayorKuboDAO;
import general.servicio.BaseServicio;

public class CuentasMayorKuboServicio extends BaseServicio{

	
	//---------- Variables ------------------------------------------------------------------------

	CuentasMayorKuboDAO cuentasMayorKuboDAO = null;
	
	public CuentasMayorKuboServicio() {
		super();
	}
	
	//---------- Tipos de Transacciones---------------------------------------------------------------

	public static interface Enum_Tra_CuentasMayorKubo {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}
	
	//---------- Tipos de Consultas---------------------------------------------------------------

	public static interface Enum_Con_CuentasMayorKubo {
		int principal = 1;
		int foranea = 2;
	}

	//---------- Tipos de Listas---------------------------------------------------------------

	public static interface Enum_Lis_CuentasMayorKubo {
		int principal = 1;
		int foranea = 2;
	}
	
	//---------- Metodo que contiene las consultas ---------------------------------------------------------------

	public CuentasMayorKuboBean consulta(int tipoConsulta, CuentasMayorKuboBean cuentasMayorKuboBean){
		CuentasMayorKuboBean cuentasMayorKubo = null;
		
		switch(tipoConsulta){
			case Enum_Con_CuentasMayorKubo.principal:
				cuentasMayorKubo = cuentasMayorKuboDAO.consultaPrincipal(cuentasMayorKuboBean, tipoConsulta);
				break;
		}
		
		return cuentasMayorKubo;
	}

	
	
	//------------------ Geters y Seters ------------------------------------------------------	

	
	public CuentasMayorKuboDAO getCuentasMayorKuboDAO() {
		return cuentasMayorKuboDAO;
	}

	public void setCuentasMayorKuboDAO(CuentasMayorKuboDAO cuentasMayorKuboDAO) {
		this.cuentasMayorKuboDAO = cuentasMayorKuboDAO;
	}
	
	
	

}
