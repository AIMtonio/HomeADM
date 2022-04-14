package credito.servicio;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;

import java.util.List;

import credito.bean.RespaldoPagoCreditoBean;
import credito.dao.RespaldoPagoCreditoDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class RespaldoPagoCreditoServicio extends BaseServicio{

	RespaldoPagoCreditoDAO respaldoPagoCreditoDAO = null;
	
	public RespaldoPagoCreditoServicio(){
		super();
	}
						   	
	//---------- Tipo de Transacciones ----------------------------------------------------------------	
		public static interface Enum_Tra_Creditos {
			int alta = 1;
		}
	
	public static interface Enum_Con_ResPagCredito {
		int principal 				= 1;
	}
	
	//---------- Consultas ------------------------------------------------------------------------

		public RespaldoPagoCreditoBean consulta(int tipoConsulta, RespaldoPagoCreditoBean respaldoPagoCreditoBean){
			RespaldoPagoCreditoBean respaldoPagoCredito = null;
			switch(tipoConsulta){
				case Enum_Con_ResPagCredito.principal:						
					respaldoPagoCredito = respaldoPagoCreditoDAO.consultaPrincipal(tipoConsulta, respaldoPagoCreditoBean);
				break;	
				
			}
			return respaldoPagoCredito;
		}
		
		public List lista(int tipoLista, RespaldoPagoCreditoBean respaldoPagoCreditoBean){		
			List listaCreditos = null;
			switch (tipoLista) {
				case Enum_Con_ResPagCredito.principal:		
					listaCreditos = respaldoPagoCreditoDAO.listaCreditoPagadosDia(respaldoPagoCreditoBean, tipoLista);				
					break;
			}
			return listaCreditos;
			
		}
		
		
		
		//-------------------------------------------------------------------------------------------------
		// -------------------- TRANSACCIONES (ALTAS MODIFICACIONES, ACTUALIZACIONES)
		//-------------------------------------------------------------------------------------------------	
		public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	RespaldoPagoCreditoBean respaldoPagoCreditoBean,
				HttpServletRequest request) {
			MensajeTransaccionBean mensaje = null;		
			switch (tipoTransaccion) {
				case Enum_Tra_Creditos.alta:		
					//mensaje = altaRespaldoPagCredito(respaldoPagoCreditoBean,request);				
					break;
			}
			return mensaje;
		}
		
		

	public RespaldoPagoCreditoDAO getRespaldoPagoCreditoDAO() {
		return respaldoPagoCreditoDAO;
	}

	public void setRespaldoPagoCreditoDAO(
			RespaldoPagoCreditoDAO respaldoPagoCreditoDAO) {
		this.respaldoPagoCreditoDAO = respaldoPagoCreditoDAO;
	}

}
