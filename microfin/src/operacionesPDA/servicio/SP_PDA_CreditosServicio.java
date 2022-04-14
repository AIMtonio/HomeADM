package operacionesPDA.servicio;
    
import general.servicio.BaseServicio;
import java.util.List;
import operacionesPDA.beanWS.request.SP_PDA_Creditos_DescargaRequest;
import operacionesPDA.beanWS.response.SP_PDA_Creditos_DescargaResponse;
import operacionesPDA.dao.SP_PDA_CreditosDAO;
import credito.bean.CreditosBean;
                         


public class SP_PDA_CreditosServicio extends BaseServicio {

	public int numResp = 0; // numero de respuesta de el proceso de escalamiento interno
	public int numTransaccionEscala = 1; // numero de respuesta de el proceso de escalamiento interno
	//---------- Variables ------------------------------------------------------------------------
	SP_PDA_CreditosDAO sp_PDA_CreditosDAO = null;

	 
	public SP_PDA_CreditosServicio() {
		super();
		// TODO Auto-generated constructor stub
	}		
	
	
	/* lista creditos (grupos no solidarios) para WS */
  public SP_PDA_Creditos_DescargaResponse listaCreditosWS(SP_PDA_Creditos_DescargaRequest bean){
	   SP_PDA_Creditos_DescargaResponse respuestaLista = new SP_PDA_Creditos_DescargaResponse();			
	   List listaCreditos;
	   CreditosBean credito;
		
	   listaCreditos = sp_PDA_CreditosDAO.listaCreditosGNSWS(bean);
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


 public SP_PDA_CreditosDAO getSp_PDA_CreditosDAO() {
	return sp_PDA_CreditosDAO;
}


 public void setSp_PDA_CreditosDAO(SP_PDA_CreditosDAO sp_PDA_CreditosDAO) {
	this.sp_PDA_CreditosDAO = sp_PDA_CreditosDAO;
   }
  
}
  
