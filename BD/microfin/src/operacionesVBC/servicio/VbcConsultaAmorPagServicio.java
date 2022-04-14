package operacionesVBC.servicio;
    
import general.servicio.BaseServicio;

import java.util.List;

import operacionesVBC.bean.VbcConsultaAmortiPagosBean;
import operacionesVBC.beanWS.request.VbcConsultaAmorPagRequest;
import operacionesVBC.beanWS.response.VbcConsultaAmorPagResponse;
import operacionesVBC.dao.VbcConsultaAmorPagDAO;
                         
public class VbcConsultaAmorPagServicio extends BaseServicio {

	VbcConsultaAmorPagDAO vbcConsultaAmorPagDAO = null;
 
	
	public VbcConsultaAmorPagServicio() {
		super();
		// TODO Auto-generated constructor stub
	}		
	
	/* lista simulador para WS */
	public VbcConsultaAmorPagResponse listaPagosAmortizacionesWS(VbcConsultaAmorPagRequest bean){
		VbcConsultaAmorPagResponse respuestaLista = new VbcConsultaAmorPagResponse();			
		List listaAmortiPagosDet;
		VbcConsultaAmortiPagosBean amotizacionesBean;
		
		listaAmortiPagosDet = vbcConsultaAmorPagDAO.vbcPagoAmortizacionesLista(bean);
		if(listaAmortiPagosDet !=null){ 			
			try{
				for(int i=0; i<listaAmortiPagosDet.size(); i++){	
					amotizacionesBean = (VbcConsultaAmortiPagosBean)listaAmortiPagosDet.get(i);
					respuestaLista.addAmortiPagos(amotizacionesBean);
					respuestaLista.setCodigoRespuesta(amotizacionesBean.getCodigoError());
					respuestaLista.setMensajeRespuesta(amotizacionesBean.getMensajeError());
				}
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de pagos WS", e);
			}		
		}	
		return respuestaLista;
	}

	public VbcConsultaAmorPagDAO getVbcConsultaAmorPagDAO() {
		return vbcConsultaAmorPagDAO;
	}

	public void setVbcConsultaAmorPagDAO(VbcConsultaAmorPagDAO vbcConsultaAmorPagDAO) {
		this.vbcConsultaAmorPagDAO = vbcConsultaAmorPagDAO;
	}

}
  
