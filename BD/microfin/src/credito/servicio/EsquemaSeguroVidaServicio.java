package credito.servicio;

import java.util.ArrayList;
import java.util.List;

import originacion.servicio.EsquemaGarantiaLiqServicio.Enum_Tra_EsquemaGarantia;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import credito.bean.EsquemaSeguroVidaBean;
import credito.dao.EsquemaSeguroVidaDAO;


public class EsquemaSeguroVidaServicio extends BaseServicio{
		/* Declaracion de atributos de la clase */
	EsquemaSeguroVidaDAO esquemaSeguroVidaDAO = null;
		
public EsquemaSeguroVidaServicio() {
	   super();
	}
	
	/*Enumera los tipo de transaccion */
	public static interface Enum_Tra_EsquemaSeguroVida {
		int alta	 = 1;
		int actualizacion = 2;
		int baja = 3;
	}
	
	/*Enumera los tipo de lista */
	public static interface Enum_Lis_EsquemaSeguroVida {
		int principla  			= 1;
		int porProductoCredito 	= 2;		// lista esquemas por producto de credito, para grid
		int porTipoPago		 	= 3;		// lista esquemas por producto de credito, para grid
		int porTipPagoCre		= 4;
	}
	
	/*Enumera los tipo de consulta */
	public static interface Enum_Con_EsquemaSeguroVida {
		int principal 			= 1;
		int foranea				= 2;
		int porTipPago			= 3;
		int foraneaCred			= 4;

	}
	
	
	/* ========================== TRANSACCIONES ==============================  */

	/* Controla el tipo de transaccion que se debe ejecutar (alta,modifica,actualiza u otro que regrese datos(numError, MsjError,control y consecutivo))*/
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, EsquemaSeguroVidaBean bean){
		ArrayList listaEsquemasBean = (ArrayList) creaListaDetalle(bean);
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {		
			case Enum_Tra_EsquemaSeguroVida.alta:
				mensaje = esquemaSeguroVidaDAO.procesarAlta(listaEsquemasBean);					
				break;
			case Enum_Tra_EsquemaSeguroVida.baja:
				mensaje = esquemaSeguroVidaDAO.baja(bean);					
				break;
			case Enum_Tra_EsquemaSeguroVida.actualizacion:
				mensaje = esquemaSeguroVidaDAO.actualiza(bean);					
				break;
			
		}
		return mensaje;
	}
	
	/* controla el tipo de lista */
	public List lista(EsquemaSeguroVidaBean bean, int tipoLista){
		List listaEsquemas = null;
		switch (tipoLista) {			
			case Enum_Lis_EsquemaSeguroVida.porProductoCredito:
				listaEsquemas = esquemaSeguroVidaDAO.listaPorProducCredito(bean, tipoLista);				
			break;
			case Enum_Lis_EsquemaSeguroVida.porTipoPago:
				listaEsquemas = esquemaSeguroVidaDAO.listaComboTipoPago(bean, tipoLista);				
			break;
			case Enum_Lis_EsquemaSeguroVida.porTipPagoCre:
				listaEsquemas = esquemaSeguroVidaDAO.listaComboTipoPagoCred(bean, tipoLista);				
			break;	
		}
		return listaEsquemas;	
	}

	
	/* consulta esquemas de seguro de vida*/
	public EsquemaSeguroVidaBean consulta(int tipoConsulta,EsquemaSeguroVidaBean bean){	
		
		EsquemaSeguroVidaBean esquemas = null;
		switch (tipoConsulta) {
			case Enum_Con_EsquemaSeguroVida.principal:	
				esquemas = esquemaSeguroVidaDAO.consultaPrincipal(bean, tipoConsulta);				
				break;
			case Enum_Con_EsquemaSeguroVida.foranea:	
				esquemas = esquemaSeguroVidaDAO.consultaForanea(bean, tipoConsulta);				
				break;
			case Enum_Con_EsquemaSeguroVida.porTipPago:	
				esquemas = esquemaSeguroVidaDAO.consultaPorTipoPago(bean, tipoConsulta);				
				break;
			case Enum_Con_EsquemaSeguroVida.foraneaCred:	
				esquemas = esquemaSeguroVidaDAO.consultaPorTipoPagoCredito(bean, tipoConsulta);				
				break;
		}
			
		return esquemas;
	}

	
	/* Arma la lista de beans */
	public List creaListaDetalle(EsquemaSeguroVidaBean bean) {		
		List<String> tipoPagoSeguro	 	 = bean.getLtipoPagoSeguro();
		List<String> factorRiesgoSeguro	 = bean.getLfactorRiesgoSeguro();
		List<String> descuentoSeguro	 = bean.getLdescuentoSeguro();
		List<String> montoPolSegVida	 = bean.getLmontoPolSegVida();

		ArrayList listaDetalle = new ArrayList();
		EsquemaSeguroVidaBean beanAux = null;	
		
		if(tipoPagoSeguro != null){
			int tamanio = tipoPagoSeguro.size();			
			for (int i = 0; i < tamanio; i++) {
				beanAux = new EsquemaSeguroVidaBean();
				
				beanAux.setProductCreditoID(bean.getProductCreditoID());;
				beanAux.setTipoPagoSeguro(tipoPagoSeguro.get(i));
				beanAux.setFactorRiesgoSeguro(factorRiesgoSeguro.get(i));
				beanAux.setDescuentoSeguro(descuentoSeguro.get(i));
				beanAux.setMontoPolSegVida(montoPolSegVida.get(i));
				beanAux.setEsquemaSeguroID(bean.getEsquemaSeguroID());
				
				listaDetalle.add(beanAux);
			}
		}
		return listaDetalle;
		
	}
	

	public EsquemaSeguroVidaDAO getEsquemaSeguroVidaDAO() {
		return esquemaSeguroVidaDAO;
	}

	public void setEsquemaSeguroVidaDAO(EsquemaSeguroVidaDAO esquemaSeguroVidaDAO) {
		this.esquemaSeguroVidaDAO = esquemaSeguroVidaDAO;
	}
		
	
	
}
