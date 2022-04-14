package operacionesVBC.servicio;
    
import general.servicio.BaseServicio;

import java.util.List;

import operacionesVBC.bean.VbcSimuladorCreditoBean;
import operacionesVBC.beanWS.request.VbcSimuladorCreditoRequest;
import operacionesVBC.beanWS.response.VbcSimuladorCreditoResponse;
import operacionesVBC.dao.VbcSimuladorCreditoDAO;
                         
public class VbcSimuladorCreditoServicio extends BaseServicio {

	VbcSimuladorCreditoDAO vbcSimuladorCreditoDAO = null;
 
	
	public VbcSimuladorCreditoServicio() {
		super();
		// TODO Auto-generated constructor stub
	}		
	
	/* lista simulador para WS */
	public VbcSimuladorCreditoResponse listaDetalleSimWS(VbcSimuladorCreditoRequest bean){
		VbcSimuladorCreditoResponse respuestaLista = new VbcSimuladorCreditoResponse();			
		List listaSimulaDet;
		VbcSimuladorCreditoBean simCredBean;
		
		listaSimulaDet = vbcSimuladorCreditoDAO.vbcSimuladorCreditoLista(bean);
		if(listaSimulaDet !=null){ 			
			try{
				for(int i=0; i<listaSimulaDet.size(); i++){	
					simCredBean = (VbcSimuladorCreditoBean)listaSimulaDet.get(i);
					respuestaLista.addAmortiSimulador(simCredBean);
					respuestaLista.setCodigoRespuesta(simCredBean.getCodigoError());
					respuestaLista.setMensajeRespuesta(simCredBean.getMensajeError());
				}
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Otros Catalogos WS", e);
			}		
		}	
		return respuestaLista;
	}


	public VbcSimuladorCreditoDAO getVbcSimuladorCreditoDAO() {
		return vbcSimuladorCreditoDAO;
	}


	public void setVbcSimuladorCreditoDAO(
			VbcSimuladorCreditoDAO vbcSimuladorCreditoDAO) {
		this.vbcSimuladorCreditoDAO = vbcSimuladorCreditoDAO;
	}

}
  
