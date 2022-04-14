package inversiones.servicio;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import inversiones.dao.SubCtaTiPerInvDAO;
import inversiones.servicio.SubCtaTiPerInvServicio.Enum_Con_SubCtaTiPerInv;
import inversiones.bean.SubCtaTiPerInvBean;
import inversiones.bean.SubCtaTiPerInvBean;

public class SubCtaTiPerInvServicio  extends BaseServicio {

	private SubCtaTiPerInvServicio(){
		super();
	}

	SubCtaTiPerInvDAO subCtaTiPerInvDAO = null;

	public static interface Enum_Tra_SubCtaTiPerInv {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaTiPerInv{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_SubCtaTiPerInv{
		int principal = 1;
		int foranea = 2;
	}

	
	public SubCtaTiPerInvBean consulta(int tipoConsulta, SubCtaTiPerInvBean subCtaTiPerInv){
		SubCtaTiPerInvBean subCtaTiPerInvBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaTiPerInv.principal:
				subCtaTiPerInvBean = subCtaTiPerInvDAO.consultaPrincipal(subCtaTiPerInv, Enum_Con_SubCtaTiPerInv.principal);
			break;		
		}
		return subCtaTiPerInvBean;
	}

	public void setSubCtaTiPerInvDAO(SubCtaTiPerInvDAO subCtaTiPerInvDAO) {
		this.subCtaTiPerInvDAO = subCtaTiPerInvDAO;
	}
	
}


