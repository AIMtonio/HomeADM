package cliente.servicio;


import java.util.ArrayList;
import java.util.List;


import cliente.bean.GruposNosolidariosBean;
import cliente.bean.IntegraGrupoNosolBean;
import cliente.dao.IntegraGrupoNosolDAO;


import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class IntegraGrupoNosolServicio  extends BaseServicio{
	
	IntegraGrupoNosolDAO integraGrupoNosolDAO =null;

	public static interface Enum_Tra_IntegraGrupos {
		int alta = 1;
		int modifica = 2;
		int elimina = 3;
	}
	
	public static interface Enum_Con_IntegraGrupos {
		int conSaldos = 2;
		
	}
	public static interface Enum_Lis_IntegraGrupos {
		int principal =1;
		
	}
	
	
	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,GruposNosolidariosBean gruposNosolidariosBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_IntegraGrupos.alta:
				mensaje = integraGrupoNosolDAO.grabaListaInt(gruposNosolidariosBean);
				break;
			case Enum_Tra_IntegraGrupos.modifica:
				//mensaje = integraGrupoNosolDAO.modificaGrupo(gruposNosolidariosBean);
				break;
			
		}
		return mensaje;
	}
	
	
	
	public IntegraGrupoNosolBean consulta(int tipoConsulta, IntegraGrupoNosolBean integraGrupoNosolBean){

		IntegraGrupoNosolBean integraGrupoNosol = null;
		switch (tipoConsulta) { 
			case  Enum_Con_IntegraGrupos.conSaldos:				
				integraGrupoNosol = integraGrupoNosolDAO.consultaSaldo(integraGrupoNosolBean, tipoConsulta);
			break;
			
		}
		return integraGrupoNosol;
	}
	
	
	public Object[] lista(int tipoLis, IntegraGrupoNosolBean integraGrupoNosolBean){
		List lista =null;
		switch (tipoLis) { 
		case  Enum_Lis_IntegraGrupos.principal:				
			lista = integraGrupoNosolDAO.listaIntegrantes(integraGrupoNosolBean, tipoLis);
		break;
		
		}
		return lista.toArray();

		
	}
	

		public IntegraGrupoNosolDAO getIntegraGrupoNosolDAO() {
			return integraGrupoNosolDAO;
		}

		public void setIntegraGrupoNosolDAO(IntegraGrupoNosolDAO integraGrupoNosolDAO) {
			this.integraGrupoNosolDAO = integraGrupoNosolDAO;
		}
		
}
