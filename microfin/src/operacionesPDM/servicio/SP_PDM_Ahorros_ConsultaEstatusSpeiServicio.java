package operacionesPDM.servicio;

import java.util.List;

import general.servicio.BaseServicio;
import operacionesPDM.bean.ConsultaEstatusSepiBean;
import operacionesPDM.beanWS.request.SP_PDM_Ahorros_ConsultaEstatusSpeiRequest;
import operacionesPDM.beanWS.response.SP_PDM_Ahorros_ConsultaEstatusSpeiResponse;
import operacionesPDM.dao.SP_PDM_Ahorros_ConsultaEstatusSpeiDAO;

public class SP_PDM_Ahorros_ConsultaEstatusSpeiServicio extends BaseServicio {
	
	SP_PDM_Ahorros_ConsultaEstatusSpeiDAO sP_PDM_Ahorros_ConsultaEstatusSpeiDAO =null;
	
	
	public SP_PDM_Ahorros_ConsultaEstatusSpeiServicio(){
		super();
	}
	
	public static interface Enum_Lis_EnvioSpei{
		
		int listaSpeiEnvios = 4;    
		
	}
	
	public SP_PDM_Ahorros_ConsultaEstatusSpeiResponse listaSpeiEnviosWS(SP_PDM_Ahorros_ConsultaEstatusSpeiRequest request){		
		SP_PDM_Ahorros_ConsultaEstatusSpeiResponse respuestaLista = new SP_PDM_Ahorros_ConsultaEstatusSpeiResponse();			
		List listaSpeiEnvios;
		ConsultaEstatusSepiBean speiEnviadosBean;
		
		listaSpeiEnvios = sP_PDM_Ahorros_ConsultaEstatusSpeiDAO.listaSpeiEnvios(request,Enum_Lis_EnvioSpei.listaSpeiEnvios);
		if(listaSpeiEnvios !=null){ 			
			try{
				for(int i=0; i<listaSpeiEnvios.size(); i++){	
					speiEnviadosBean = (ConsultaEstatusSepiBean)listaSpeiEnvios.get(i);
							
					respuestaLista.addConSpei(speiEnviadosBean);
				}
							
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista Spei Enviados WS", e);
			}			
		}		
		return respuestaLista;
	}
	
	

	public SP_PDM_Ahorros_ConsultaEstatusSpeiDAO getSP_PDM_Ahorros_ConsultaEstatusSpeiDAO() {
		return sP_PDM_Ahorros_ConsultaEstatusSpeiDAO;
	}

	public void setSP_PDM_Ahorros_ConsultaEstatusSpeiDAO(
			SP_PDM_Ahorros_ConsultaEstatusSpeiDAO sP_PDM_Ahorros_ConsultaEstatusSpeiDAO) {
		this.sP_PDM_Ahorros_ConsultaEstatusSpeiDAO = sP_PDM_Ahorros_ConsultaEstatusSpeiDAO;
	}

}
