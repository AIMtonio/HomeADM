package cliente.servicio;

import java.util.List;

import cliente.bean.AdicionalPersonaMoralBean;
import cliente.dao.AdicionalPersonaMoralDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;


public class AdicionalPersonaMoralServicio extends BaseServicio {
	
	AdicionalPersonaMoralDAO adicionalPersonaMoralDAO = null;
	
	public static interface Enum_Tra_PersonaMoral{
		int grabar = 1;
		int modificar = 2;
	}
	
	public static interface Enum_Con_PersonaMoral{
		int principal   = 1;				
	}
	
	public static interface Enum_Lis_PersonaMoral{
		int directivosReg = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, AdicionalPersonaMoralBean adicionalPersonaBean){		
		MensajeTransaccionBean mensaje = null;		
		switch(tipoTransaccion){		
			case Enum_Tra_PersonaMoral.grabar:
				mensaje = adicionalPersonaMoralDAO.altaAdicionalPersonaMoral(adicionalPersonaBean);	
			break;	
			case Enum_Tra_PersonaMoral.modificar:
				mensaje = adicionalPersonaMoralDAO.modificaAdicionalPersonaMoral(adicionalPersonaBean);
			break;			
		}		
		return mensaje;	
	}
	
	// Consulta de la información adicional de Persona Morales
	public AdicionalPersonaMoralBean consulta(int tipoConsulta, AdicionalPersonaMoralBean adicionalPersonaMoralBean){
		AdicionalPersonaMoralBean adicionalPersonaMoralBeanCon = null;
		switch(tipoConsulta){
			case Enum_Con_PersonaMoral.principal:
				adicionalPersonaMoralBeanCon = adicionalPersonaMoralDAO.consultaPrincipal(adicionalPersonaMoralBean, tipoConsulta);
			break;			
		
		}
		return adicionalPersonaMoralBeanCon;
	}
	
	public List lista(int tipoLista, AdicionalPersonaMoralBean adicionalPersonaMoralBean) {
		List listaPersonaMoral = null;
		switch (tipoLista) {
			case Enum_Lis_PersonaMoral.directivosReg:
				listaPersonaMoral = adicionalPersonaMoralDAO.listaDirectivos(adicionalPersonaMoralBean, tipoLista);
			break;			
			
		}
		return listaPersonaMoral;
	}

	public AdicionalPersonaMoralDAO getAdicionalPersonaMoralDAO() {
		return adicionalPersonaMoralDAO;
	}

	public void setAdicionalPersonaMoralDAO(
			AdicionalPersonaMoralDAO adicionalPersonaMoralDAO) {
		this.adicionalPersonaMoralDAO = adicionalPersonaMoralDAO;
	}
	
	
	

}
