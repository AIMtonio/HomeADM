package inversiones.servicio;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import inversiones.dao.SubCtaMonedaInvDAO;
import inversiones.bean.SubCtaMonedaInvBean;

public class SubCtaMonedaInvServicio  extends BaseServicio  {

	private SubCtaMonedaInvServicio(){
		super();
	}

	SubCtaMonedaInvDAO subCtaMonedaInvDAO = null;

	public static interface Enum_Tra_SubCtaMonedaInv {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaMonedaInv{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_SubCtaMonedaInv{
		int principal = 1;
		int foranea = 2;
	}


	public SubCtaMonedaInvBean consulta(int tipoConsulta, SubCtaMonedaInvBean subCtaMonedaInv){
		SubCtaMonedaInvBean subCtaMonedaInvBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaMonedaInv.principal:
				subCtaMonedaInvBean = subCtaMonedaInvDAO.consultaPrincipal(subCtaMonedaInv, Enum_Con_SubCtaMonedaInv.principal);
			break;		
		}
		return subCtaMonedaInvBean;
	}
	
	public void setSubCtaMonedaInvDAO(SubCtaMonedaInvDAO subCtaMonedaInvDAO) {
		this.subCtaMonedaInvDAO = subCtaMonedaInvDAO;
	}
}

