package operacionesPDM.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import operacionesPDM.bean.CuentasDestinoBean;
import operacionesPDM.beanWS.request.SP_PDM_Ahorros_ConsultaCtaDestinoRequest;
import operacionesPDM.beanWS.response.SP_PDM_Ahorros_ConsultaCtaDestinoResponse;
import operacionesPDM.dao.SP_PDM_Ahorros_ConsultaCtaDestinoDAO;

public class SP_PDM_Ahorros_ConsultaCtaDestinoServicio extends BaseServicio {
	
	SP_PDM_Ahorros_ConsultaCtaDestinoDAO sP_PDM_Ahorros_ConsultaCtaDestinoDAO =null;
	
	public SP_PDM_Ahorros_ConsultaCtaDestinoServicio(){
		super();
	}
		
	public static interface Enum_Lis_CtaDestino{
		
		int consultaCtaDestino = 6;    
		
	}
	
	public MensajeTransaccionBean cuentasTrasnfersVal(SP_PDM_Ahorros_ConsultaCtaDestinoRequest cuentasTransBean){
		MensajeTransaccionBean mensaje = null;
		
		mensaje = sP_PDM_Ahorros_ConsultaCtaDestinoDAO.validaCtaTransfer(cuentasTransBean);
		
		return mensaje;	
		
	}
	
	public SP_PDM_Ahorros_ConsultaCtaDestinoResponse listaCtaDestinoWS(SP_PDM_Ahorros_ConsultaCtaDestinoRequest bean){		
		SP_PDM_Ahorros_ConsultaCtaDestinoResponse respuestaLista = new SP_PDM_Ahorros_ConsultaCtaDestinoResponse();			
		List listaCtaDestino;
		CuentasDestinoBean cuentasDestinoBean;
		
		listaCtaDestino = sP_PDM_Ahorros_ConsultaCtaDestinoDAO.listaCtaSpei(bean,Enum_Lis_CtaDestino.consultaCtaDestino);
		if(listaCtaDestino !=null){ 			
			try{
				for(int i=0; i<listaCtaDestino.size(); i++){	
					cuentasDestinoBean = (CuentasDestinoBean)listaCtaDestino.get(i);
							
					respuestaLista.addCtaDestino(cuentasDestinoBean);
				}
							
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de Cuentas Destino WS", e);
			}			
		}		
		return respuestaLista;
	}
	
	
	public SP_PDM_Ahorros_ConsultaCtaDestinoDAO getsP_PDM_Ahorros_ConsultaCtaDestinoDAO() {
		return sP_PDM_Ahorros_ConsultaCtaDestinoDAO;
	}

	public void setsP_PDM_Ahorros_ConsultaCtaDestinoDAO(
			SP_PDM_Ahorros_ConsultaCtaDestinoDAO sP_PDM_Ahorros_ConsultaCtaDestinoDAO) {
		this.sP_PDM_Ahorros_ConsultaCtaDestinoDAO = sP_PDM_Ahorros_ConsultaCtaDestinoDAO;
	}
}
