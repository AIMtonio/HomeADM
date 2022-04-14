package cliente.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cliente.dao.SectoresDAO;
import cliente.bean.SectoresBean;
public class SectoresServicio extends BaseServicio {

	private SectoresServicio(){
		super();
	}

	SectoresDAO sectoresDAO = null;

	public static interface Enum_Con_Sectores{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_Sectores{
		int principal = 1;
		int foranea = 2;
	}

	

	public SectoresBean consulta(int tipoConsulta, SectoresBean sectoresBean){
		SectoresBean sectores = null;

		switch(tipoConsulta){
			case Enum_Con_Sectores.principal:
				sectores = sectoresDAO.consultaPrincipal(sectoresBean, Enum_Con_Sectores.principal);
			break;
			case Enum_Con_Sectores.foranea:
				sectores = sectoresDAO.consultaForanea(sectoresBean, Enum_Con_Sectores.foranea);
			break;
		}
	return sectores;
	}

	
	public List lista(int tipoLista, SectoresBean sectoresBean){

		List sectoresLista = null;

		switch (tipoLista) {
		case Enum_Lis_Sectores.principal:
			sectoresLista = sectoresDAO.lista(sectoresBean, tipoLista);
			break;
         case Enum_Lis_Sectores.foranea:
			sectoresLista = sectoresDAO.lista(sectoresBean, tipoLista);
                 break;
		}
		return sectoresLista;
	}

	public void setSectoresDAO(SectoresDAO sectoresDAO ){
		this.sectoresDAO = sectoresDAO;
	}

}
