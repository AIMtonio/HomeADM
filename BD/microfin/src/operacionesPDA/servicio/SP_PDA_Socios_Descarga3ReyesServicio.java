package operacionesPDA.servicio;

import java.util.List;

import cliente.bean.ClienteBean;
import general.servicio.BaseServicio;
import operacionesPDA.beanWS.request.SP_PDA_Socios_DescargaRequest;
import operacionesPDA.beanWS.response.SP_PDA_Socios_DescargaResponse;
import operacionesPDA.dao.SP_PDA_Socios_Descarga3ReyesDAO;

public class SP_PDA_Socios_Descarga3ReyesServicio extends BaseServicio {
 
	private SP_PDA_Socios_Descarga3ReyesServicio(){
		super();
	}

	SP_PDA_Socios_Descarga3ReyesDAO sp_PDA_Socios_Descarga3ReyesDAO = null;
	
	
	public static interface Enum_Lis_ClienteWS{
		int clientesWs =4;      
	}
	
	
	/* lista socios que pertenecen a un grupo no solidario para WS */
	public SP_PDA_Socios_DescargaResponse listaSociosWS(SP_PDA_Socios_DescargaRequest bean){
		SP_PDA_Socios_DescargaResponse respuestaLista = new SP_PDA_Socios_DescargaResponse();			
		List listaSocios;
		ClienteBean cliente;
		
		listaSocios = sp_PDA_Socios_Descarga3ReyesDAO.listaSociosWS(bean, Enum_Lis_ClienteWS.clientesWs);
		
		if(listaSocios !=null){ 			
			try{
				for(int i=0; i<listaSocios.size(); i++){	
					cliente = (ClienteBean)listaSocios.get(i);
					
					respuestaLista.addCliente(cliente);
				}
				
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista socios para WS", e);
			}			
		}		
	 return respuestaLista;
	}
	

	public SP_PDA_Socios_Descarga3ReyesDAO getSp_PDA_Socios_Descarga3ReyesDAO() {
		return sp_PDA_Socios_Descarga3ReyesDAO;
	}


	public void setSp_PDA_Socios_Descarga3ReyesDAO(
			SP_PDA_Socios_Descarga3ReyesDAO sp_PDA_Socios_Descarga3ReyesDAO) {
		this.sp_PDA_Socios_Descarga3ReyesDAO = sp_PDA_Socios_Descarga3ReyesDAO;
	}

}
