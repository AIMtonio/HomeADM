package inversiones.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import inversiones.dao.CuentasMayorInvDAO;
import inversiones.bean.CuentasMayorInvBean;
public class CuentasMayorInvServicio  extends BaseServicio {

	private CuentasMayorInvServicio(){
		super();
	}

	CuentasMayorInvDAO cuentasMayorInvDAO = null;

	public static interface Enum_Tra_InversionMayorInv {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_InversionMayorInv{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_InversionMayorInv{
		int principal = 1;
		int foranea = 2;
	}

	

	public CuentasMayorInvBean consulta(int tipoConsulta, CuentasMayorInvBean cuentaMayorInv){
		CuentasMayorInvBean cuentasMayorInvBean = null;
		switch(tipoConsulta){
			case Enum_Con_InversionMayorInv.principal:
				cuentasMayorInvBean = cuentasMayorInvDAO.consultaPrincipal(cuentaMayorInv, Enum_Con_InversionMayorInv.principal);
			break;		
		}
		return cuentasMayorInvBean;
	}



	public void setCuentasMayorInvDAO(CuentasMayorInvDAO cuentasMayorInvDAO) {
		this.cuentasMayorInvDAO = cuentasMayorInvDAO;
	}

}

