package inversiones.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import inversiones.dao.SubCtaPlazoInvDAO;
import inversiones.servicio.SubCtaPlazoInvServicio.Enum_Con_SubCtaPlazoInv;
import inversiones.bean.SubCtaPlazoInvBean;

public class SubCtaPlazoInvServicio  extends BaseServicio  {

	private SubCtaPlazoInvServicio(){
		super();
	}

	SubCtaPlazoInvDAO subCtaPlazoInvDAO = null;

	public static interface Enum_Tra_SubCtaPlazoInv {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaPlazoInv{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_SubCtaPlazoInv{
		int principal = 1;
		int foranea = 2;
	}


	public SubCtaPlazoInvBean consulta(int tipoConsulta, SubCtaPlazoInvBean subCtaPlazoInv){
		SubCtaPlazoInvBean subCtaPlazoInvBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaPlazoInv.principal:
				subCtaPlazoInvBean = subCtaPlazoInvDAO.consultaPrincipal(subCtaPlazoInv, Enum_Con_SubCtaPlazoInv.principal);
			break;		
		}
		return subCtaPlazoInvBean;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista,SubCtaPlazoInvBean subCtaPlazoInv) {
		List listaPlazoInversion = null;
		switch(tipoLista){
			case (Enum_Lis_SubCtaPlazoInv.principal): 
				listaPlazoInversion =  subCtaPlazoInvDAO.listaPlazos(subCtaPlazoInv,tipoLista);
				break;
		}
		return listaPlazoInversion.toArray();		
	}

	public void setSubCtaPlazoInvDAO(SubCtaPlazoInvDAO subCtaPlazoInvDAO) {
		this.subCtaPlazoInvDAO = subCtaPlazoInvDAO;
	}
}

