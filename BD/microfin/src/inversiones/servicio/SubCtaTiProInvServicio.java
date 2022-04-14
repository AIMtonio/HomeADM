package inversiones.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import inversiones.dao.SubCtaTiProInvDAO;
import inversiones.servicio.SubCtaTiProInvServicio.Enum_Con_SubCtaTiProInv;
import inversiones.bean.SubCtaTiProInvBean;
import inversiones.bean.SubCtaTiProInvBean;
public class SubCtaTiProInvServicio  extends BaseServicio {

	private SubCtaTiProInvServicio(){
		super();
	}

	SubCtaTiProInvDAO subCtaTiProInvDAO = null;

	public static interface Enum_Tra_SubCtaTiProInv {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaTiProInv{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_SubCtaTiProInv{
		int principal = 1;
		int foranea = 2;
	}

	public SubCtaTiProInvBean consulta(int tipoConsulta, SubCtaTiProInvBean subCtaTiProInv){
		SubCtaTiProInvBean subCtaTiProInvBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaTiProInv.principal:
				subCtaTiProInvBean = subCtaTiProInvDAO.consultaPrincipal(subCtaTiProInv, Enum_Con_SubCtaTiProInv.principal);
			break;		
		}
		return subCtaTiProInvBean;
	}

	public void setSubCtaTiProInvDAO(SubCtaTiProInvDAO subCtaTiProInvDAO) {
		this.subCtaTiProInvDAO = subCtaTiProInvDAO;
	}
}

