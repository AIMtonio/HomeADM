package credito.servicio;

import general.servicio.BaseServicio;
import herramientas.Utileria;
 
import java.io.ByteArrayOutputStream;
import java.util.Iterator;
import java.util.List;

import reporte.ParametrosReporte;
import reporte.Reporte;
import credito.bean.AmortizacionCreditoBean;
import credito.bean.CreditosBean;
import credito.beanWS.request.ConsultaAmortiCreditoBERequest;
import credito.beanWS.request.ConsultaDetallePagosRequest;
import credito.beanWS.response.ConsultaAmortiCreditoBEResponse;
import credito.beanWS.response.ConsultaDetallePagosResponse;
import credito.dao.AmortizacionCreditoDAO;
import credito.dao.CreditosDAO;
import credito.servicio.CreditosServicio.Enum_Con_Creditos;

public class AmortizacionCreditoServicio  extends BaseServicio {
	private AmortizacionCreditoServicio(){
		super();
	}

	AmortizacionCreditoDAO amortizacionCreditoDAO = null;
	CreditosDAO creditosDAO = null;
	String codigo= "";

	public static interface Enum_Lis_AmortizacionCredito {
		int	principal		= 1;
		int	saldos			= 2;
		int	amortPagare		= 3;
		int amortContigente = 5;
		int repExcel		= 6;
	}
	
	public static interface Enum_Lis_AmortizacionCreditoAgro {
		int	principal		= 1;
		int	saldos			= 2;
		int	amortPagare		= 3;
	}
	
	public static interface Enum_Lis_PagareGrupal{
		int pagareGrupal 	= 2;

	}
	
	public static interface Enum_Con_AmortizacionCredito{
		int repMov 			= 1;		
		int diasAtraso		= 7;
		int conCapVignente 	= 9; // se usa para consultar capital vigente para validación prepago de crédito ventanilla 
		int cuotasCon 		=10; // se usa para consultar las cuotas
		int saldoFinalPlazo	=11; // se usa en consulta saldos ws SANA TUS FINANZAS
	}
	
	public static interface Enum_Con_AmortizacionCreditoWS{
		int detallePagosWS 		= 1;
	}

	public AmortizacionCreditoBean consulta(int tipoConsulta, AmortizacionCreditoBean amortizacionCredito){
		AmortizacionCreditoBean amortizacion = null;
		switch (tipoConsulta) {
			case Enum_Con_Creditos.principal:		
				break;	
			case Enum_Con_AmortizacionCredito.diasAtraso:		
				amortizacion = amortizacionCreditoDAO.consultaDiasAtraso(amortizacionCredito,tipoConsulta);// creditos = amortizacionCreditoDAO(amortizacionCredito, tipoConsulta);				
				break;

			case Enum_Con_AmortizacionCredito.cuotasCon:
				amortizacion = amortizacionCreditoDAO.consultaCuotas(amortizacionCredito, tipoConsulta);				
				break;
			case Enum_Con_AmortizacionCredito.saldoFinalPlazo:
				amortizacion = amortizacionCreditoDAO.consultaSaldoFinalPlazo(amortizacionCredito, tipoConsulta);				
				break;
		}
		return amortizacion;
	}
	
	public Object consultaDetallePagosWS(int tipoConsulta, ConsultaDetallePagosRequest consultaRequest){
		Object obj= null;
		String cadena;
		codigo = "01";
		ConsultaDetallePagosResponse res=new ConsultaDetallePagosResponse();
		List<ConsultaDetallePagosResponse> tmpDetallePagos = amortizacionCreditoDAO.consultaDetallePagosWS(consultaRequest, tipoConsulta );
		if (tmpDetallePagos != null ){
			cadena=transformArray(tmpDetallePagos);
			if (codigo.equals("0")){
				res.setInfoDetallePagos(cadena);
				res.setCodigoRespuesta("0");
				res.setMensajeRespuesta("Exito");
			}
			else
			{	res.setInfoDetallePagos(" ");
				res.setCodigoRespuesta("01");
				res.setMensajeRespuesta("Fallo");
			}	
		} else
		{	res.setInfoDetallePagos(" ");
			res.setCodigoRespuesta("01");
			res.setMensajeRespuesta("Fallo");
		}	
		
		obj=(Object)res;
		return obj;
	}
	
	private String transformArray(List  a)
    {
        String res ="";
        ConsultaDetallePagosResponse temp;
        if(a!=null)
        {   
            Iterator<ConsultaDetallePagosResponse> it = a.iterator();
            while(it.hasNext())
            {    
                temp = (ConsultaDetallePagosResponse)it.next();
                codigo = temp.getCodigoRespuesta();                	
                res+= temp.getInfoDetallePagos()+"&|&";
            }
        }
        return res;
    }
	
	public List lista(int tipoLista,CreditosBean creditosBean){
		List amortizacionCreditoLista = null;
		switch (tipoLista) {
	        case  Enum_Lis_AmortizacionCredito.principal:
	        	amortizacionCreditoLista = creditosDAO.listaCreditosBean(creditosBean, tipoLista);
	        break;
		}
		return amortizacionCreditoLista;
	}
	
	public List listaGrid(int tipoLista, AmortizacionCreditoBean amortiCredBean){
		List amortizacionCreditoLista = null;
		switch(tipoLista){
			case Enum_Lis_AmortizacionCredito.saldos:
				amortizacionCreditoLista= amortizacionCreditoDAO.listaConsultaAmortiCred(amortiCredBean, tipoLista);
				break;
			case Enum_Lis_AmortizacionCredito.amortPagare:
				amortizacionCreditoLista= amortizacionCreditoDAO.listaConsultaAmortiCredPagare(amortiCredBean, tipoLista);
			break;
	        case Enum_Lis_AmortizacionCredito.amortContigente:
	        	amortizacionCreditoLista= amortizacionCreditoDAO.listaConsultaAmortiCredContingente(amortiCredBean, tipoLista);       	
			break;
	        case Enum_Lis_AmortizacionCredito.repExcel:
	        	amortizacionCreditoLista = amortizacionCreditoDAO.listAmortReporteExcel(amortiCredBean);
		}
		
		return amortizacionCreditoLista;
		
	}
	
	/**
	 * Lista las amortizaciones de los creditos agropecuarios. Modulo Creditos Agropecuarios
	 * @param tipoLista : Numero de Lista
	 * @param amortiCredBean : {@link AmortizacionCreditoBean} Bean con los datos de las amortizaciones  consultar
	 * @return List<{@link AmortizacionCreditoBean}
	 */
	public List<AmortizacionCreditoBean> listaAgroGrid(int tipoLista, AmortizacionCreditoBean amortiCredBean) {
		List<AmortizacionCreditoBean> amortizacionCreditoLista = null;
		switch (tipoLista) {
			case Enum_Lis_AmortizacionCreditoAgro.saldos:
				amortizacionCreditoLista = amortizacionCreditoDAO.listaConsultaAmortiCred(amortiCredBean, tipoLista);
				break;
			case Enum_Lis_AmortizacionCredito.amortPagare:
				amortizacionCreditoLista = amortizacionCreditoDAO.listaConAmortiCredAgroPagare(amortiCredBean, tipoLista);
				break;
		}
		return amortizacionCreditoLista;
	}
	
	// Lista de AMORTIZACIONES ws
  	public Object listaAmort(int tipoLista, ConsultaAmortiCreditoBERequest consultaAmortiCreditoBERequest){
			Object obj= null;
			String cadena = "";
			
			ConsultaAmortiCreditoBEResponse respuestaLista = new ConsultaAmortiCreditoBEResponse();
			List<AmortizacionCreditoBean> listaCredito = amortizacionCreditoDAO.listaConsultaAmorti(consultaAmortiCreditoBERequest, tipoLista);
			if (listaCredito != null ){
				cadena = CreaString(listaCredito);
			}
					respuestaLista.setListaAmort(cadena);
					
					obj=(Object)respuestaLista;
					return obj;
			}	
 
   	// Separador de campos y registros de la lista de Creditos WS
		private String CreaString(List listaCredito)
	    {
	        String resultado= "";
	        String separadorCampos = "[";
	 		String separadorRegistro = "]";
	 		
	 		AmortizacionCreditoBean amortizacionCreditoBean;
	        if(listaCredito!= null)
	        {   
	            Iterator<AmortizacionCreditoBean> it = listaCredito.iterator();
	            while(it.hasNext())
	            {    
	            	amortizacionCreditoBean = (AmortizacionCreditoBean)it.next();             	
	            	resultado += amortizacionCreditoBean.getAmortizacionID()+separadorCampos+
	            			amortizacionCreditoBean.getFechaInicio()+separadorCampos+
	            			amortizacionCreditoBean.getFechaVencim()+separadorCampos+
	            			amortizacionCreditoBean.getFechaExigible()+separadorCampos+
	            			amortizacionCreditoBean.getEstatus()+separadorCampos+
	            			amortizacionCreditoBean.getCapital()+separadorCampos+
	            			amortizacionCreditoBean.getInteres()+separadorCampos+
	            			amortizacionCreditoBean.getIvaInteres()+separadorCampos+
	            			amortizacionCreditoBean.getTotalPago()+separadorCampos+
	            		    amortizacionCreditoBean.getSaldoCapital()+ separadorRegistro;
	            }
	        }
	 		if(resultado.length() !=0){
	 				resultado = resultado.substring(0,resultado.length()-1);
	 		}
	        return resultado;
	    } 
		
		// Lista de pagare grupal
		public List listaGrupal(int tipoLista, AmortizacionCreditoBean amortiCredBean){		
			List pagareGrupal = null;
			switch (tipoLista) {	
				case Enum_Lis_PagareGrupal.pagareGrupal:		
					pagareGrupal = amortizacionCreditoDAO.listaPagareGrupal(tipoLista, amortiCredBean);			
					break;			 
			}				
			return pagareGrupal;
		}


		
		
		/* =========  Reporte PDF de Proyeccion de Credito (amortizaciones del simulador)  =========== */
		public ByteArrayOutputStream reporteProyeccionCredito(int tipoReporte, AmortizacionCreditoBean bean , String nomReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			int alta=1;
			int baja=2;
			amortizacionCreditoDAO. proyectaCreditoAccesorios(bean,alta);
			parametrosReporte.agregaParametro("Par_ClienteID",bean.getClienteID());
			parametrosReporte.agregaParametro("Par_NombreCliente",bean.getNombreCliente());
			parametrosReporte.agregaParametro("Par_CapitalPagar",Utileria.convierteDoble(bean.getTotalCap()));
			parametrosReporte.agregaParametro("Par_InteresPagar",Utileria.convierteDoble(bean.getTotalInteres()));
			parametrosReporte.agregaParametro("Par_IVAPagar",Utileria.convierteDoble(bean.getTotalIva()));
			parametrosReporte.agregaParametro("Par_CalifCliente",bean.getCalifCliente());
			parametrosReporte.agregaParametro("Par_Ejecutivo",bean.getUsuario());
			parametrosReporte.agregaParametro("Par_Frecuencia",bean.getFrecuencia());
			parametrosReporte.agregaParametro("Par_FrecuenciaInt",bean.getFrecuenciaInt()); 
			parametrosReporte.agregaParametro("Par_FrecuenciaDes",bean.getFrecuenciaDes());
			parametrosReporte.agregaParametro("Par_TasaFija",bean.getTasaFija());
			parametrosReporte.agregaParametro("Par_NumCuotas",bean.getNumCuotas());
			parametrosReporte.agregaParametro("Par_NumCuotasInt",bean.getNumCuotasInt());	
			parametrosReporte.agregaParametro("Par_NumTransaccion",bean.getNumTransaccion());			
			parametrosReporte.agregaParametro("Par_NumRep",tipoReporte);
			parametrosReporte.agregaParametro("Par_NombreInstitucion",bean.getNombreInstitucion());
			
			parametrosReporte.agregaParametro("Par_Monto",bean.getMontoSol());
			parametrosReporte.agregaParametro("Par_Periodicidad",bean.getPeriodicidad());
			parametrosReporte.agregaParametro("Par_PeriodicidadInt",bean.getPeriodicidadInt()); 
			parametrosReporte.agregaParametro("Par_DiaPago",bean.getDiaPago());
			parametrosReporte.agregaParametro("Par_DiaPagoInt",bean.getDiaPagoInt());	
			parametrosReporte.agregaParametro("Par_DiaMes",bean.getDiaMes());
			parametrosReporte.agregaParametro("Par_DiaMesInt",bean.getDiaMesInt());	
			parametrosReporte.agregaParametro("Par_FechaInicio",bean.getFechaInicio());
			parametrosReporte.agregaParametro("Par_ProducCreditoID",bean.getProducCreditoID());
			parametrosReporte.agregaParametro("Par_DiaHabilSig",bean.getDiaHabilSig());
			parametrosReporte.agregaParametro("Par_AjustaFecAmo",bean.getAjustaFecAmo());
			parametrosReporte.agregaParametro("Par_AjusFecExiVen",bean.getAjusFecExiVen());
			parametrosReporte.agregaParametro("Par_ComApertura",bean.getComApertura());
			parametrosReporte.agregaParametro("Par_CalculoInt",bean.getCalculoInt());
			parametrosReporte.agregaParametro("Par_TipoCalculoInt",bean.getTipoCalculoInt());
			parametrosReporte.agregaParametro("Par_TipoPagCap",bean.getTipoPagCap());
			parametrosReporte.agregaParametro("Par_CAT",bean.getCat());
			parametrosReporte.agregaParametro("Par_LeyendaTasaVar", bean.getLeyendaTasaVariable());
			parametrosReporte.agregaParametro("Par_CobraSeguroCuota", bean.getCobraSeguroCuota());
			parametrosReporte.agregaParametro("Par_CobraIVASeguroCuota", bean.getCobraIVASeguroCuota());
			parametrosReporte.agregaParametro("Par_MontoSeguroCuota", bean.getMontoSeguroCuota());
			parametrosReporte.agregaParametro("Par_ConvenioNominaID", Utileria.convierteEntero(bean.getConvenioNominaID()));
			
			
			return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}
		
		
		public void reporteProyeccionCreditoBajaAccesorios(AmortizacionCreditoBean bean){
			int bajaAccesorios = 2;
			amortizacionCreditoDAO. proyectaCreditoAccesorios(bean,bajaAccesorios);
		}
	
	public void setAmortizacionCreditoDAO(AmortizacionCreditoDAO amortizacionCreditoDAO) {
		this.amortizacionCreditoDAO = amortizacionCreditoDAO;
	}
	public AmortizacionCreditoDAO getAmortizacionCreditoDAO() {
		return amortizacionCreditoDAO;
	}

	public void setCreditosDAO(CreditosDAO creditosDAO) {
		this.creditosDAO = creditosDAO;
	}
	
}
