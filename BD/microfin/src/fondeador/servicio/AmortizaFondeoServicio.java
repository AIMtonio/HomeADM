package fondeador.servicio;

import fondeador.bean.AmortizaFondeoBean;
import fondeador.beanWS.request.ConsultaAmortiFondeoBERequest;
import fondeador.beanWS.response.ConsultaAmortiFondeoBEResponse;
import fondeador.dao.AmortizaFondeoDAO;
import general.servicio.BaseServicio;

import java.util.Iterator;
import java.util.List;

import soporte.PropiedadesSAFIBean;

public class AmortizaFondeoServicio extends BaseServicio {
	AmortizaFondeoDAO amortizaFondeoDAO = null;
	
	private AmortizaFondeoServicio(){
		super();
	}
	
	String codigo= "";
	
	public static interface Enum_Lis_AmortizacionCredito{
		int amortizacion		= 1; /* muestra todas las amortizaciones filtradas por credito pasivo */
		int amortizacionesVig	= 2; /* Muestra las amortizaciones vigentes menores a la fecha del sistema*/
		int amortiCred			= 3;/* lista las amortizaciones de los creditos de fondeo*/
	}
	
	
	public List listaGrid(int tipoLista, AmortizaFondeoBean amortiCredFonBean){
		List amortizacionCreditoLista = null;
		switch(tipoLista){
			case Enum_Lis_AmortizacionCredito.amortizacionesVig:
				amortizacionCreditoLista= amortizaFondeoDAO.listaConsultaAmortiCredVig(amortiCredFonBean, tipoLista);
				break;
			case Enum_Lis_AmortizacionCredito.amortizacion:
				amortizacionCreditoLista= amortizaFondeoDAO.listaAmortizacionesCredito(amortiCredFonBean, tipoLista);
				break;
		}
		return amortizacionCreditoLista;
	}

	// Lista de CreditosFondeo  WS
   	public Object listaAmortiCreditosWS(int tipoLista, ConsultaAmortiFondeoBERequest consultaAmortiFondeoBERequest){
			Object obj= null;
			String cadena = "";
			
			ConsultaAmortiFondeoBEResponse respuestaLista = new ConsultaAmortiFondeoBEResponse();
			List<ConsultaAmortiFondeoBEResponse> listaAmorti = amortizaFondeoDAO.listaConsultaAmorti(consultaAmortiFondeoBERequest, tipoLista);
			if (listaAmorti != null ){
				cadena = CreaString(listaAmorti);
			}
				respuestaLista.setListaAmortizaciones(cadena);
				
					obj=(Object)respuestaLista;
					return obj;
			}	
 
   	// Separador de campos y registros de la lista de CreditosFondeo WS
		private String CreaString(List listaAmorti)
	    {
	        String resultado= "";
	        String separadorCampos = "[";
	 		String separadorRegistro = "]";
	 		
	 		AmortizaFondeoBean amortizaFondeoBean;
	        if(listaAmorti!= null)
	        {   
	            Iterator<AmortizaFondeoBean> it = listaAmorti.iterator();
	            while(it.hasNext())
	            {    
	            	amortizaFondeoBean = (AmortizaFondeoBean)it.next();             	
	            	resultado += amortizaFondeoBean.getAmortizacionID()+separadorCampos+
	            			amortizaFondeoBean.getFechaInicio()+separadorCampos+
	            			amortizaFondeoBean.getFechaVencim()+separadorCampos+
	            			amortizaFondeoBean.getEstatus()+separadorCampos+
	            			amortizaFondeoBean.getCapital()+separadorCampos+
	            			amortizaFondeoBean.getInteres()+separadorCampos+
	            			amortizaFondeoBean.getSaldoIVAInteres()+separadorCampos+
	            			amortizaFondeoBean.getTotalCuota()+ separadorRegistro;
	            }
	        }
	 		if(resultado.length() !=0){
	 				resultado = resultado.substring(0,resultado.length()-1);
	 		}
	        return resultado;
	    }

	
	
	
	public void setAmortizaFondeoDAO(AmortizaFondeoDAO amortizaFondeoDAO) {
		this.amortizaFondeoDAO = amortizaFondeoDAO;
	}

	public AmortizaFondeoDAO getAmortizaFondeoDAO() {
		return amortizaFondeoDAO;
	}

}