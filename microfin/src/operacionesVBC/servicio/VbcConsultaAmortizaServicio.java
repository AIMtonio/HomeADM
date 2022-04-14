package operacionesVBC.servicio;
    
import general.servicio.BaseServicio;

import java.util.List;
import operacionesVBC.bean.VbcConsultaAmortizacionesBean;
import operacionesVBC.beanWS.request.VbcConsultaAmortizaRequest;
import operacionesVBC.beanWS.response.VbcConsultaAmortizaResponse;
import operacionesVBC.dao.VbcConsultaAmortizaDAO;
                         
public class VbcConsultaAmortizaServicio extends BaseServicio {

	VbcConsultaAmortizaDAO vbcConsultaAmortizaDAO = null;
 
	
	public VbcConsultaAmortizaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}		
	
	/* lista simulador para WS */
	public VbcConsultaAmortizaResponse listaAmortizacionesWS(VbcConsultaAmortizaRequest bean){
		VbcConsultaAmortizaResponse respuestaLista = new VbcConsultaAmortizaResponse();			
		List listaAmortiDet;
		VbcConsultaAmortizacionesBean amotizacionesBean;
		
		listaAmortiDet = vbcConsultaAmortizaDAO.vbcAmortizacionesLista(bean);
		if(listaAmortiDet !=null){ 			
			try{
				for(int i=0; i<listaAmortiDet.size(); i++){	
					amotizacionesBean = (VbcConsultaAmortizacionesBean)listaAmortiDet.get(i);
					respuestaLista.addAmortizaciones(amotizacionesBean);
					respuestaLista.setCodigoRespuesta(amotizacionesBean.getCodigoError());
					respuestaLista.setMensajeRespuesta(amotizacionesBean.getMensajeError());
				}
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta Amorizaciones", e);
			}		
		}	
		return respuestaLista;
	}

	public VbcConsultaAmortizaDAO getVbcConsultaAmortizaDAO() {
		return vbcConsultaAmortizaDAO;
	}

	public void setVbcConsultaAmortizaDAO(
			VbcConsultaAmortizaDAO vbcConsultaAmortizaDAO) {
		this.vbcConsultaAmortizaDAO = vbcConsultaAmortizaDAO;
	}



}
  
