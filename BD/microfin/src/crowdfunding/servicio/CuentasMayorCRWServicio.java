package crowdfunding.servicio;

import crowdfunding.bean.CuentasMayorCRWBean;
import crowdfunding.dao.CuentasMayorCRWDAO;
import general.servicio.BaseServicio;

public class CuentasMayorCRWServicio extends BaseServicio{

	CuentasMayorCRWDAO cuentasMayorCRWDAO = null;

	public CuentasMayorCRWServicio() {
		super();
	}

	public static interface Enum_Tra_CuentasMayorCRW {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_CuentasMayorCRW {
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_CuentasMayorCRW {
		int principal = 1;
		int foranea = 2;
	}

	public CuentasMayorCRWBean consulta(int tipoConsulta, CuentasMayorCRWBean cuentasMayorCRWBean){
		CuentasMayorCRWBean cuentasMayorCRW = null;

		switch(tipoConsulta){
			case Enum_Con_CuentasMayorCRW.principal:
				cuentasMayorCRW = cuentasMayorCRWDAO.consultaPrincipal(cuentasMayorCRWBean, tipoConsulta);
				break;
		}
		return cuentasMayorCRW;
	}

	public CuentasMayorCRWDAO getCuentasMayorCRWDAO() {
		return cuentasMayorCRWDAO;
	}

	public void setCuentasMayorCRWDAO(CuentasMayorCRWDAO cuentasMayorCRWDAO) {
		this.cuentasMayorCRWDAO = cuentasMayorCRWDAO;
	}
}