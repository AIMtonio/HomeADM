package fondeador.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletResponse;
 
import reporte.ParametrosReporte;
import reporte.Reporte;

import fondeador.bean.AmortizaFondeoBean;
import fondeador.bean.CreditoFondeoBean;
import fondeador.beanWS.request.ListaCreditoFondeoBERequest;
import fondeador.beanWS.response.ListaCreditoFondeoBEResponse;
import fondeador.dao.CreditoFondeoDAO;

public class CreditoFondeoServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	CreditoFondeoDAO creditoFondeoDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_CreditoFondeo {
		int principal 	= 1;
		int foranea   	= 2;
		int ajusteMovs 	= 3;
		int exigible	= 4;
		int bancaLinea	= 5;
		int prepago		= 6;
		int relacionesCred = 7;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_CreditoFondeo {
		int principal = 1;
		int foranea   = 2;
		int detLinFon = 3;
		int Nopagados =4;
		int vigentesWS =5;
		int folioPasFondeo = 6;
	}
    public static interface Enum_Lis_CredRep{
    	int salTotalRepEx = 1;
    	int anaCarPasEx = 2;
    	int credFonMovsRepExcel = 3;
    }
	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_CreditoFondeo {
		int alta			= 1;
		int modificacion	= 2;
		int pagoCredito		= 3;
		int prepago			= 4;
	}
	
	public static interface Enum_Sim_PagAmortizacionesFondeo{
		int pagosCrecientes 	= 1;
		int pagosIguales 		= 2;
		int pagosLibresTasaFija = 3;
		int pagosTasaVar 		= 4;
		int pagosLibresTasaVar 	= 5;
		int tmpPagAmort			= 6;
		int pagLibFecCapTasaFija= 7;	// para simular pagos libres que incluyan fecha y capital 
		int pagLibFecCapTasaVar	= 8;
		int actPagLib			= 9;	// para indicar que tipo de actualizacion se trata en el simulador
		int actPagLibFecCap		= 10;	// para indicar que tipo de actualizacion se trata en el simulador
		int pagosCapitalizacion	= 11;	// para indicar que tipo de actualizacion se trata en el simulador
	}
	public CreditoFondeoServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CreditoFondeoBean creditoFondeoBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_CreditoFondeo.alta:		
				mensaje = altaLineaFond(creditoFondeoBean);				
				break;				
			case Enum_Tra_CreditoFondeo.modificacion:
				mensaje = modificaLineaFond(creditoFondeoBean);				
				break;
			case Enum_Tra_CreditoFondeo.pagoCredito:
				mensaje = pagoCreditoPasivo(creditoFondeoBean);
				break;
			case Enum_Tra_CreditoFondeo.prepago:
				mensaje = creditoFondeoDAO.prepagoCreditoPasivo(creditoFondeoBean);
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaLineaFond(CreditoFondeoBean creditoFondeoBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = creditoFondeoDAO.alta(creditoFondeoBean);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaLineaFond(CreditoFondeoBean creditoFondeoBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = creditoFondeoDAO.modifica(creditoFondeoBean);		
		return mensaje;
	}
	
	public MensajeTransaccionBean pagoCreditoPasivo(CreditoFondeoBean creditoFondeoBean){
		MensajeTransaccionBean mensaje = null;
		MensajeTransaccionBean mensajeActualizaDetallePago = null;
		
		String numeroCredito = creditoFondeoBean.getCreditoID();
		mensaje = creditoFondeoDAO.pagoCreditoPasivo(creditoFondeoBean);
		
		if((mensaje.getNumero() == 0 || mensaje.getNumero() == 000) && numeroCredito != ""){
			creditoFondeoBean.setNumeroTransaccion(0);
			mensajeActualizaDetallePago = creditoFondeoDAO.actualizaDetallePago(creditoFondeoBean);	
		}
		
		return mensaje;
	}
	
	public CreditoFondeoBean consulta(int tipoConsulta, CreditoFondeoBean creditoFondeoBean){
		CreditoFondeoBean creditoFondeo = null;
		switch (tipoConsulta) {
			case Enum_Con_CreditoFondeo.principal:		
				creditoFondeo = creditoFondeoDAO.consultaPrincipal(creditoFondeoBean, tipoConsulta);				
				break;
			case Enum_Con_CreditoFondeo.foranea:		
				creditoFondeo = creditoFondeoDAO.consultaForanea(creditoFondeoBean, tipoConsulta);				
				break;
			case Enum_Con_CreditoFondeo.ajusteMovs:		
				creditoFondeo = creditoFondeoDAO.consultaAjusteMovimientos(creditoFondeoBean, tipoConsulta);				
				break;
			case Enum_Con_CreditoFondeo.exigible:
				creditoFondeo = creditoFondeoDAO.consultaExigible(creditoFondeoBean, tipoConsulta);				
				break;
			case Enum_Con_CreditoFondeo.bancaLinea:
				creditoFondeo = creditoFondeoDAO.consultaCreditodFondeoWS(creditoFondeoBean, tipoConsulta);				
				break;
			case Enum_Con_CreditoFondeo.prepago:
				creditoFondeo = creditoFondeoDAO.consultaPrepago(creditoFondeoBean, tipoConsulta);				
				break;
			case Enum_Con_CreditoFondeo.relacionesCred:
				creditoFondeo = creditoFondeoDAO.consultaRelacionCred(creditoFondeoBean, tipoConsulta);				
				break;
		}
		return creditoFondeo;
	}
	
	public List lista(int tipoLista, CreditoFondeoBean creditoFondeoBean){		
		List listaLineasFond = null;
		switch (tipoLista) {
			case Enum_Lis_CreditoFondeo.principal:		
				listaLineasFond = creditoFondeoDAO.listaPrincipal(creditoFondeoBean, tipoLista);				
				break;
			case Enum_Lis_CreditoFondeo.foranea:		
				listaLineasFond = creditoFondeoDAO.listaForanea(creditoFondeoBean, tipoLista);				
				break;
			case Enum_Lis_CreditoFondeo.detLinFon:		
				listaLineasFond = creditoFondeoDAO.listaDetalleLinFon(creditoFondeoBean, tipoLista);				
				break;
			case Enum_Lis_CreditoFondeo.Nopagados:		
				listaLineasFond = creditoFondeoDAO.listaForanea(creditoFondeoBean, tipoLista);				
				break;
			case Enum_Lis_CreditoFondeo.folioPasFondeo:		
				listaLineasFond = creditoFondeoDAO.folioPasFondeo(creditoFondeoBean, tipoLista);				
				break;
				
		}		
		return listaLineasFond;
	}

	public List simuladorAmortizacionesFondeo(int tipoLista, CreditoFondeoBean creditoFondeoBean){
		List listaCreditos = null;
		switch (tipoLista) {
			case Enum_Sim_PagAmortizacionesFondeo.pagosCrecientes:		
				listaCreditos = creditoFondeoDAO.simPagCrecientesFondeo(creditoFondeoBean);				
				break;				
			case Enum_Sim_PagAmortizacionesFondeo.pagosIguales:		
				listaCreditos = creditoFondeoDAO.simPagIgualesFondeo(creditoFondeoBean);				
				break;				
			case Enum_Sim_PagAmortizacionesFondeo.pagosLibresTasaFija:		
				listaCreditos = creditoFondeoDAO.simPagLibresFondeo(creditoFondeoBean);				
				break;				
			case Enum_Sim_PagAmortizacionesFondeo.pagosTasaVar:
				listaCreditos = creditoFondeoDAO.simPagTasaVarFondeo(creditoFondeoBean);				
				break;	
			case Enum_Sim_PagAmortizacionesFondeo.pagosLibresTasaVar:
				listaCreditos = creditoFondeoDAO.simPagLibresFondeo(creditoFondeoBean);				
				break;		
			case Enum_Sim_PagAmortizacionesFondeo.tmpPagAmort:
				listaCreditos = creditoFondeoDAO.conTempPagAmortFondeo(creditoFondeoBean,tipoLista);
				break;
			case Enum_Sim_PagAmortizacionesFondeo.pagosCapitalizacion:
				listaCreditos = creditoFondeoDAO.simPagIgualesConCapitalizacionFondeo(creditoFondeoBean);
				break;
		}		
		return listaCreditos;
	}
	
	//Recalculo de Saldos para pagos libres con tasa fija 
	public List grabaListaSimPagLibFondeo(CreditoFondeoBean creditoFondeoBean, String montosCapital){
		List listaCreditos = null;
		List listaCreditosMensaje = (List)new ArrayList();
		MensajeTransaccionBean mensaje = null;
		ArrayList listaSimPagLib = (ArrayList) creaListaSimPagLibFondeo(montosCapital);
		
		String diaHabil= creditoFondeoBean.getFechaInhabil();
		mensaje= creditoFondeoDAO.grabaListaSimPagLibFondeo(creditoFondeoBean, listaSimPagLib,Enum_Sim_PagAmortizacionesFondeo.actPagLib, diaHabil);
		listaCreditos = creditoFondeoDAO.recalculoSimPagLibresFondeo(creditoFondeoBean);
		
		listaCreditosMensaje.add(mensaje);
		listaCreditosMensaje.add(listaCreditos);
		return listaCreditosMensaje;		 
	}
	//Recalculo de Saldos para pagos libres con tasa variable 
	public List grabaListaSimPagLibTasaVar(CreditoFondeoBean creditoFondeoBean, String montosCapital){
		List listaCreditos = null;
		List listaCreditosMensaje = (List)new ArrayList();
		MensajeTransaccionBean mensaje = null;
		ArrayList listaSimPagLib = (ArrayList) creaListaSimPagLibFondeo(montosCapital);
		
		String diaHabil= creditoFondeoBean.getFechaInhabil();
		mensaje= creditoFondeoDAO.grabaListaSimPagLibFondeo(creditoFondeoBean, listaSimPagLib,Enum_Sim_PagAmortizacionesFondeo.actPagLib, diaHabil);		
		listaCreditos = creditoFondeoDAO.recalculoSimPagLibresFondeo(creditoFondeoBean);
		//listaCreditos = simuladorAmortizacionesFondeo(Enum_Sim_PagAmortizacionesFondeo.tmpPagAmort,creditoFondeoBean);
		listaCreditosMensaje.add(mensaje);
		listaCreditosMensaje.add(listaCreditos);
		return listaCreditosMensaje;		 
	}
		
	//calculo de fecha exigible y saldos  para pagos libres con tasa fija 
	public List grabaListaSimPagLibFecCapTasVar(CreditoFondeoBean creditoFondeoBean, String montosCapital) {
		List listaCreditos = null;
		List listaCreditosMensaje = (List) new ArrayList();
		try {
			MensajeTransaccionBean mensaje = null;

			String diaHabil = "";
			List listaSimPagLib = grabaListaSimPagLibFecCap(creditoFondeoBean, montosCapital);
			List<AmortizaFondeoBean> listaAm = (List<AmortizaFondeoBean>) listaSimPagLib.get(1);

			// creditosBean.setFechaInhabil("S");
			diaHabil = creditoFondeoBean.getFechaInhabil();
			mensaje = creditoFondeoDAO.grabaListaSimPagLibFondeo(creditoFondeoBean, listaAm, Enum_Sim_PagAmortizacionesFondeo.actPagLib, diaHabil);
			listaCreditos = simuladorAmortizacionesFondeo(Enum_Sim_PagAmortizacionesFondeo.tmpPagAmort, creditoFondeoBean);
			listaCreditosMensaje.add(mensaje);
			listaCreditosMensaje.add(listaAm);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return listaCreditosMensaje;
	}
	
	// metodo para separar el String que contiene los montos del capital en un bean
	private List creaListaSimPagLibFondeo(String montosCapital){	
		StringTokenizer tokensBean = new StringTokenizer(montosCapital, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaMontos = new ArrayList();
		AmortizaFondeoBean amortizaFondeoBean;		
		while(tokensBean.hasMoreTokens()){
			amortizaFondeoBean = new AmortizaFondeoBean();
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			amortizaFondeoBean.setAmortizacionID(tokensCampos[0]);
			amortizaFondeoBean.setCapital(tokensCampos[1]);
			amortizaFondeoBean.setNumTransaccion(tokensCampos[2]);
			listaMontos.add(amortizaFondeoBean);		
		}
		return listaMontos;
	}
	
	//calculo de fecha exigible y saldos  para pagos libres con tasa fija 
	public List grabaListaSimPagLibFecCap(CreditoFondeoBean creditoFondeoBean, String montosCapital){
		List<AmortizaFondeoBean> listaCreditos = null;
		List listaCreditosMensaje = (List)new ArrayList();
		MensajeTransaccionBean mensaje = null;
		
		String diaHabil="";
		List<AmortizaFondeoBean> listaSimPagLib = creaListaSimPagLibFecCapFondeo(montosCapital);
		diaHabil= creditoFondeoBean.getFechaInhabil(); 
		mensaje= creditoFondeoDAO.grabaListaSimPagLibFondeo(creditoFondeoBean, listaSimPagLib,Enum_Sim_PagAmortizacionesFondeo.actPagLibFecCap, diaHabil);		
		listaCreditos = creditoFondeoDAO.recalculoSimPagLibresFondeo(creditoFondeoBean);
		
		listaCreditosMensaje.add(mensaje);
		listaCreditosMensaje.add(listaCreditos);
		return listaCreditosMensaje;		 
	}
		
	// metodo para separas el String que contiene: la fecha de inicio, de vencimiento y los montos del capital en un bean
	private List<AmortizaFondeoBean> creaListaSimPagLibFecCapFondeo(String montosCapital){	
		StringTokenizer tokensBean = new StringTokenizer(montosCapital, "[");
		String stringCampos;
		String tokensCampos[];
		List<AmortizaFondeoBean> listaMontos = new ArrayList<AmortizaFondeoBean>();
		AmortizaFondeoBean amortizacionesBean;
		
		while(tokensBean.hasMoreTokens()){
			amortizacionesBean = new AmortizaFondeoBean();
		
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
	
			amortizacionesBean.setAmortizacionID(tokensCampos[0]);
			amortizacionesBean.setCapital(tokensCampos[1]);
			amortizacionesBean.setFechaInicio(tokensCampos[2]);
			amortizacionesBean.setFechaVencim(tokensCampos[3]);
					
			listaMontos.add(amortizacionesBean);		
		}
		
		return listaMontos;
	}
	/*case para listas de reportes de credito*/
	public List listaReportesCreditos(int tipoLista, CreditoFondeoBean creditosBean, HttpServletResponse response){

		// List listaCreditos = null;
		 List listaCreditos=null;
	
		switch(tipoLista){
		
			case Enum_Lis_CredRep.salTotalRepEx:
				listaCreditos = creditoFondeoDAO.consultaRepVencimientosPasivos(creditosBean, tipoLista);; 
				break;
			case Enum_Lis_CredRep.anaCarPasEx:
				listaCreditos = creditoFondeoDAO.consultaRepAnaliticoCarteraPas(creditosBean, tipoLista);; 
				break;
			case Enum_Lis_CredRep.credFonMovsRepExcel:
				listaCreditos = creditoFondeoDAO.consultaRepCreditoFondeoMovs(creditosBean, tipoLista);
				break;
				
		}
		
		return listaCreditos;
	}

	// Reporte  de Vencimientos pasivos
	public ByteArrayOutputStream creaRepVencimientosPasivPDF(CreditoFondeoBean creditosBean, 
						String nombreReporte) throws Exception{
						ParametrosReporte parametrosReporte = new ParametrosReporte();
						parametrosReporte.agregaParametro("Par_FechaInicio",creditosBean.getFechaInicio());
						parametrosReporte.agregaParametro("Par_FechaFin",creditosBean.getFechaVencimien());
						parametrosReporte.agregaParametro("Par_InstitutFondID",Utileria.convierteEntero(creditosBean.getInstitutFondID()));
						parametrosReporte.agregaParametro("Par_CalculoInteres",creditosBean.getCalculoInteres());
						parametrosReporte.agregaParametro("Par_FechaEmision",creditosBean.getParFechaEmision());
						
						parametrosReporte.agregaParametro("Par_NomInstitFon",(!creditosBean.getNombreInstitFon().isEmpty())? creditosBean.getNombreInstitFon():"TODOS");
						parametrosReporte.agregaParametro("Par_NomUsuario",(!creditosBean.getNombreUsuario().isEmpty())?creditosBean.getNombreUsuario(): "TODOS");
						parametrosReporte.agregaParametro("Par_NomInstitucion",(!creditosBean.getNombreInstitucion().isEmpty())?creditosBean.getNombreInstitucion(): "TODOS");
						parametrosReporte.agregaParametro("Par_NivelDetalle",(!creditosBean.getNivelDetalle().isEmpty())?creditosBean.getNivelDetalle(): "1");
	
						
						return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
					}
	// reporte de Contrato inversionista
	public ByteArrayOutputStream repContratoPDF(CreditoFondeoBean creditoFondeoBean, String nombreReporte)
			throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_CreditoFondeoID",Utileria.convierteLong(creditoFondeoBean.getCreditoFondeoID()));
		parametrosReporte.agregaParametro("Par_NomInstitucion",creditoFondeoBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_Fecha",creditoFondeoBean.getFechaActual());
		parametrosReporte.agregaParametro("Aud_Sucursal",creditoFondeoBean.getSucursal());
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	// reporte de Contrato Credito Paasivo
		public ByteArrayOutputStream repContratoCreditoPasivo(CreditoFondeoBean creditoFondeoBean, String nombreReporte)
				throws Exception {
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_CreditoID",Utileria.convierteEntero(creditoFondeoBean.getCreditoFondeoID()));
			parametrosReporte.agregaParametro("Par_InstitutFondID",Utileria.convierteEntero(creditoFondeoBean.getInstitutFondID()));
			parametrosReporte.agregaParametro("Par_RutaImagen", creditoFondeoBean.getRutaImagen());
			
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}
		
	
	
	// Lista de CreditosFondeo  WS
   	public Object listaCreditosWS(int tipoLista, ListaCreditoFondeoBERequest listaCreditoFondeoBERequest){
			Object obj= null;
			String cadena = "";
			
			ListaCreditoFondeoBEResponse respuestaLista = new ListaCreditoFondeoBEResponse();
			List<ListaCreditoFondeoBEResponse> listaCredito = creditoFondeoDAO.creditosFondeo(listaCreditoFondeoBERequest, tipoLista);
			if (listaCredito != null ){
				cadena = CreaString(listaCredito);
			}
					respuestaLista.setListaCreditos(cadena);
				
					obj=(Object)respuestaLista;
					return obj;
			}	
 
   	// Separador de campos y registros de la lista de CreditosFondeo WS
		private String CreaString(List listaCredito)
	    {
	        String resultado= "";
	        String separadorCampos = "[";
	 		String separadorRegistro = "]";
	 		
	 		CreditoFondeoBean creditoFondeoBean;
	        if(listaCredito!= null)
	        {   
	            Iterator<CreditoFondeoBean> it = listaCredito.iterator();
	            while(it.hasNext())
	            {    
	            	creditoFondeoBean = (CreditoFondeoBean)it.next();             	
	            	resultado += creditoFondeoBean.getCreditoFondeoID()+separadorCampos+
	            			     creditoFondeoBean.getFechaTerminaci()+separadorCampos+
	            				 creditoFondeoBean.getMonto()+ separadorRegistro;
	            }
	        }
	 		if(resultado.length() !=0){
	 				resultado = resultado.substring(0,resultado.length()-1);
	 		}
	        return resultado;
	    }

	
	//------------------ Geters y Seters ------------------------------------------------------	
	public CreditoFondeoDAO getCreditoFondeoDAO() {
		return creditoFondeoDAO;
	}

	public void setCreditoFondeoDAO(CreditoFondeoDAO creditoFondeoDAO) {
		this.creditoFondeoDAO = creditoFondeoDAO;
	}
		
}

