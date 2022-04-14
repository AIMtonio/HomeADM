package arrendamiento.servicio;

import arrendamiento.bean.CuentasMayorArrendaBean;
import arrendamiento.dao.CuentasMayorArrendaDAO;

import general.servicio.BaseServicio;

public class CuentasMayorArrendaServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	CuentasMayorArrendaDAO cuentasMayorArrendaDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Arrenda {
		int principal = 1;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Arrenda {
		int principal = 1;
	}
	
	public CuentasMayorArrendaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public CuentasMayorArrendaBean consulta(int tipoConsulta, CuentasMayorArrendaBean cuentasMayorArrendaBean){
		CuentasMayorArrendaBean resultado = null;
		switch (tipoConsulta) {
			case Enum_Con_Arrenda.principal:		
				resultado = cuentasMayorArrendaDAO.consultaPrincipal(cuentasMayorArrendaBean, tipoConsulta);				
				break;	
		}	
		return resultado;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	

	public CuentasMayorArrendaDAO getCuentasMayorArrendaDAO() {
		return cuentasMayorArrendaDAO;
	}


	public void setCuentasMayorArrendaDAO(
			CuentasMayorArrendaDAO cuentasMayorArrendaDAO) {
		this.cuentasMayorArrendaDAO = cuentasMayorArrendaDAO;
	}
	
}


