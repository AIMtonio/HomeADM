package operacionesPDA.servicio;
    
import general.servicio.BaseServicio;

import java.util.List;

import operacionesPDA.bean.SP_PDA_OtrosCat_Descarga3ReyesBean;
import operacionesPDA.beanWS.request.SP_PDA_OtrosCat_Descarga3ReyesRequest;
import operacionesPDA.beanWS.response.SP_PDA_OtrosCat_Descarga3ReyesResponse;
import operacionesPDA.dao.SP_PDA_OtrosCat_Descarga3ReyesDAO;
                         


public class SP_PDA_OtrosCat_Descarga3ReyesServicio extends BaseServicio {

	SP_PDA_OtrosCat_Descarga3ReyesDAO sp_PDA_OtrosCat_Descarga3ReyesDAO = null;
 
	
	public SP_PDA_OtrosCat_Descarga3ReyesServicio() {
		super();
		// TODO Auto-generated constructor stub
	}		
	
	
	/* lista otros catalogos para WS */
  public SP_PDA_OtrosCat_Descarga3ReyesResponse listaOtrosCatWS(SP_PDA_OtrosCat_Descarga3ReyesRequest bean){
	  SP_PDA_OtrosCat_Descarga3ReyesResponse respuestaLista = new SP_PDA_OtrosCat_Descarga3ReyesResponse();			
	   List listaOtrosCat;
	   SP_PDA_OtrosCat_Descarga3ReyesBean otrosCat;
		
	   listaOtrosCat = sp_PDA_OtrosCat_Descarga3ReyesDAO.listaOtrosCatWS(bean);
	   if(listaOtrosCat !=null){ 			
		try{
			for(int i=0; i<listaOtrosCat.size(); i++){	
				otrosCat = (SP_PDA_OtrosCat_Descarga3ReyesBean)listaOtrosCat.get(i);
							
				respuestaLista.addOtrosCat(otrosCat);
				}
							
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Otros Catalogos WS", e);
				}			
	   }	
	return respuestaLista;
  }


 public SP_PDA_OtrosCat_Descarga3ReyesDAO getSp_PDA_OtrosCat_Descarga3ReyesDAO() {
	return sp_PDA_OtrosCat_Descarga3ReyesDAO;
}


  public void setSp_PDA_OtrosCat_Descarga3ReyesDAO(
		SP_PDA_OtrosCat_Descarga3ReyesDAO sp_PDA_OtrosCat_Descarga3ReyesDAO) {
	this.sp_PDA_OtrosCat_Descarga3ReyesDAO = sp_PDA_OtrosCat_Descarga3ReyesDAO;
  }

}
  
