package operacionesPDA.servicio;
    
import general.servicio.BaseServicio;

import java.util.List;

import credito.bean.CreditosBean;
import operacionesPDA.beanWS.request.SP_PDA_Creditos_DescargaRequest;
import operacionesPDA.beanWS.response.SP_PDA_Creditos_DescargaResponse;
import operacionesPDA.dao.SP_PDA_Creditos_Descarga3ReyesDAO;
 

public class SP_PDA_Creditos_Descarga3ReyesServicio extends BaseServicio {

	public int numResp = 0; // numero de respuesta de el proceso de escalamiento interno
	public int numTransaccionEscala = 1; // numero de respuesta de el proceso de escalamiento interno
	//---------- Variables ------------------------------------------------------------------------
	SP_PDA_Creditos_Descarga3ReyesDAO sP_PDA_Creditos_Descarga3ReyesDAO = null;

	
	public SP_PDA_Creditos_Descarga3ReyesServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	public static interface Enum_Lis_Creditos {
		int creditosWS   	= 1;	

	}
	/* lista creditos (grupos no solidarios) para WS */
	public SP_PDA_Creditos_DescargaResponse listaCreditosWS(SP_PDA_Creditos_DescargaRequest bean){
	   SP_PDA_Creditos_DescargaResponse respuestaLista = new SP_PDA_Creditos_DescargaResponse();			
	   List listaCreditos;
	   CreditosBean credito;
		
	   listaCreditos = sP_PDA_Creditos_Descarga3ReyesDAO.lisCreditosWS(bean,Enum_Lis_Creditos.creditosWS);
	   if(listaCreditos !=null){ 			
		try{
			for(int i=0; i<listaCreditos.size(); i++){	
				credito = (CreditosBean)listaCreditos.get(i);
							
				respuestaLista.addCredito(credito);
				}
							
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de Creditos Grupos No Solidarios WS", e);
				}			
	   }		
	return respuestaLista;
  }
	
	  
    //-------------------------------------------------------------------------------------------------
		//------------------ GETTERS Y SETTERS ------------------------------------------------------------ 
		//-------------------------------------------------------------------------------------------------		


	public SP_PDA_Creditos_Descarga3ReyesDAO getsP_PDA_Creditos_Descarga3ReyesDAO() {
		return sP_PDA_Creditos_Descarga3ReyesDAO;
	}
	public void setsP_PDA_Creditos_Descarga3ReyesDAO(
			SP_PDA_Creditos_Descarga3ReyesDAO sP_PDA_Creditos_Descarga3ReyesDAO) {
		this.sP_PDA_Creditos_Descarga3ReyesDAO = sP_PDA_Creditos_Descarga3ReyesDAO;
	}

}
  
