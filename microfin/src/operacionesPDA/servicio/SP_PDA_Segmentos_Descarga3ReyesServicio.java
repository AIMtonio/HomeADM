package operacionesPDA.servicio;

import java.util.List;

import operacionesPDA.beanWS.request.SP_PDA_Segmentos_DescargaRequest;
import operacionesPDA.beanWS.response.SP_PDA_Segmentos_DescargaResponse;
import operacionesPDA.dao.SP_PDA_Segmentos_Descarga3ReyesDAO;
import cliente.bean.PromotoresBean;
import general.servicio.BaseServicio;

public class SP_PDA_Segmentos_Descarga3ReyesServicio extends BaseServicio{
	
	public SP_PDA_Segmentos_Descarga3ReyesServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
		 
	SP_PDA_Segmentos_Descarga3ReyesDAO sp_PDA_Segmentos_Descarga3ReyesDAO = null;

	
	public static interface Enum_Lis_Promotor {
		int promSucur   	= 9;	

	}
	
	
	/* lista segmentos (promotores por sucursal) para WS */
	public SP_PDA_Segmentos_DescargaResponse listaPromotoresWS(SP_PDA_Segmentos_DescargaRequest bean){
		SP_PDA_Segmentos_DescargaResponse respuestaLista = new SP_PDA_Segmentos_DescargaResponse();			
		List listaPromotores;
		PromotoresBean promotores;
		
		listaPromotores = sp_PDA_Segmentos_Descarga3ReyesDAO.listaPromSucur(bean,Enum_Lis_Promotor.promSucur);
		
		if(listaPromotores !=null){ 			
			try{
				for(int i=0; i<listaPromotores.size(); i++){	
					promotores = (PromotoresBean)listaPromotores.get(i);
					
					respuestaLista.addSegmentos(promotores);
				}
				
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista segmentos para WS", e);
			}			
		}		
	 return respuestaLista;
	}


	public SP_PDA_Segmentos_Descarga3ReyesDAO getSp_PDA_Segmentos_Descarga3ReyesDAO() {
		return sp_PDA_Segmentos_Descarga3ReyesDAO;
	}


	public void setSp_PDA_Segmentos_Descarga3ReyesDAO(
			SP_PDA_Segmentos_Descarga3ReyesDAO sp_PDA_Segmentos_Descarga3ReyesDAO) {
		this.sp_PDA_Segmentos_Descarga3ReyesDAO = sp_PDA_Segmentos_Descarga3ReyesDAO;
	}
	
}
