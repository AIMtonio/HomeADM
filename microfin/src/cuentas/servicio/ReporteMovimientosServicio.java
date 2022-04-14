package cuentas.servicio;
import java.util.Iterator;
import java.util.List;

import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.servicio.CorreoServicio;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletResponse;

import bancaEnLinea.beanWS.request.ConsultaSaldoDetalleBERequest;
import bancaEnLinea.beanWS.response.ConsultaSaldoDetalleBEResponse;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import cuentas.dao.ReporteMovimientosDAO;
import cuentas.bean.ReporteMovimientosBean;

public class ReporteMovimientosServicio  extends BaseServicio {
	private ReporteMovimientosServicio(){
		super();
	}

	ReporteMovimientosDAO reporteMovimientosDAO = null;
	CorreoServicio correoServicio = null;

	public static interface Enum_Lis_ReporteMovimientos{
		int principal 		= 1;
		int principalHis 		= 2;
	}
	
	public static interface Enum_Con_ReporteMovimientos{
		int repMov 		= 1;
		int repMovHis 		= 2;
	}
	
	public static interface Enum_Con_TipRepor{
		int ReporPantalla 		= 1;
		int ReporPDF	 		= 2;
		int ReporExcel			= 3;
	}
	
	public String reporteMovimientosCuenta(ReporteMovimientosBean reporteMovimientosBean, String nombreReporte, int tipoConsulta) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		List  listaRepMov = null;
		ReporteMovimientosBean reporteMovimientos;
		switch (tipoConsulta) {
	        case  Enum_Con_ReporteMovimientos.repMov:
	        	listaRepMov = reporteMovimientosDAO.listaReporteMovimientos(reporteMovimientosBean, Enum_Con_ReporteMovimientos.repMov);
	        break;
	        case  Enum_Con_ReporteMovimientos.repMovHis:
	        	listaRepMov = reporteMovimientosDAO.listaReporteMovimientos(reporteMovimientosBean, Enum_Con_ReporteMovimientos.repMovHis);
	        break;
		}
		
		
		for(int i=0; i<listaRepMov.size(); i++){
			reporteMovimientos = (ReporteMovimientosBean)listaRepMov.get(i);
			if(i==1){
				break;
			}
			parametrosReporte.agregaParametro("Par_NumCta",		reporteMovimientos.getCuentaAhoID());
			parametrosReporte.agregaParametro("Par_NumCte",	 	reporteMovimientos.getClienteID());
			parametrosReporte.agregaParametro("Par_Nombre", 	reporteMovimientos.getNombreCompleto());
			parametrosReporte.agregaParametro("Par_TipoC", 		reporteMovimientos.getTipoCuentaID());
			parametrosReporte.agregaParametro("Par_DesTC", 		reporteMovimientos.getDescripcionTC());
			parametrosReporte.agregaParametro("Par_NumMo", 		reporteMovimientos.getMonedaID());	
			parametrosReporte.agregaParametro("Par_DesMo",		reporteMovimientos.getDescripcionMo());
			parametrosReporte.agregaParametro("Par_SaldoIniMes",reporteMovimientos.getSaldoIniMes());
			parametrosReporte.agregaParametro("Par_CargosMes", 	reporteMovimientos.getCargosMes());
			parametrosReporte.agregaParametro("Par_AbonosMes", 	reporteMovimientos.getAbonosMes());
			parametrosReporte.agregaParametro("Par_SaldoIniDia",reporteMovimientos.getSaldoIniDia());
			parametrosReporte.agregaParametro("Par_CargosDia", 	reporteMovimientos.getCargosDia());
			parametrosReporte.agregaParametro("Par_AbonosDia", 	reporteMovimientos.getAbonosDia());
			parametrosReporte.agregaParametro("Par_Saldo", 		reporteMovimientos.getSaldo());
			parametrosReporte.agregaParametro("Par_SaldoDisp", 	reporteMovimientos.getSaldoDispon());
			parametrosReporte.agregaParametro("Par_SaldoBC", 	reporteMovimientos.getSaldoSBC());
			parametrosReporte.agregaParametro("Par_SaldoBloq", 	reporteMovimientos.getSaldoBloq());
			parametrosReporte.agregaParametro("Par_FechaSistema", reporteMovimientos.getFechaSistemaMov());
			parametrosReporte.agregaParametro("Par_SaldoProm", reporteMovimientos.getSaldoProm());
			parametrosReporte.agregaParametro("Par_NomUsuario",(reporteMovimientos.getUsuario()));
			parametrosReporte.agregaParametro("Par_NomInstitucion",(reporteMovimientos.getNombreInstitucion()));
		} 
		parametrosReporte.agregaParametro("Par_Cuenta",Utileria.convierteLong(reporteMovimientosBean.getCuentaAhoID()));
		parametrosReporte.agregaParametro("Par_Anio", reporteMovimientosBean.getAnio());
		parametrosReporte.agregaParametro("Par_Mes", reporteMovimientosBean.getMes());
		
		parametrosReporte.agregaParametro("Par_Con",tipoConsulta);
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	
		
	}
	
	public ByteArrayOutputStream reporteMovimientosCuentaPDF(ReporteMovimientosBean reporteMovimientosBean, String nombreReporte, int tipoConsulta) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		List  listaRepMov = null;
		ReporteMovimientosBean reporteMovimientos;
		switch (tipoConsulta) {
	        case  Enum_Con_ReporteMovimientos.repMov:
	        	listaRepMov = reporteMovimientosDAO.listaReporteMovimientos(reporteMovimientosBean, Enum_Con_ReporteMovimientos.repMov);
	        break;
	        case  Enum_Con_ReporteMovimientos.repMovHis:
	        	listaRepMov = reporteMovimientosDAO.listaReporteMovimientos(reporteMovimientosBean, Enum_Con_ReporteMovimientos.repMovHis);
	        break;
		}
		
		
		for(int i=0; i<listaRepMov.size(); i++){
			reporteMovimientos = (ReporteMovimientosBean)listaRepMov.get(i);
			if(i==1){
				break;
			}
			parametrosReporte.agregaParametro("Par_NumCta",		reporteMovimientos.getCuentaAhoID());
			parametrosReporte.agregaParametro("Par_NumCte",	 	reporteMovimientos.getClienteID());
			parametrosReporte.agregaParametro("Par_Nombre", 	reporteMovimientos.getNombreCompleto());
			parametrosReporte.agregaParametro("Par_TipoC", 		reporteMovimientos.getTipoCuentaID());
			parametrosReporte.agregaParametro("Par_DesTC", 		reporteMovimientos.getDescripcionTC());
			parametrosReporte.agregaParametro("Par_NumMo", 		reporteMovimientos.getMonedaID());	
			parametrosReporte.agregaParametro("Par_DesMo",		reporteMovimientos.getDescripcionMo());
			parametrosReporte.agregaParametro("Par_SaldoIniMes",reporteMovimientos.getSaldoIniMes());
			parametrosReporte.agregaParametro("Par_CargosMes", 	reporteMovimientos.getCargosMes());
			parametrosReporte.agregaParametro("Par_AbonosMes", 	reporteMovimientos.getAbonosMes());
			parametrosReporte.agregaParametro("Par_SaldoIniDia",reporteMovimientos.getSaldoIniDia());
			parametrosReporte.agregaParametro("Par_CargosDia", 	reporteMovimientos.getCargosDia());
			parametrosReporte.agregaParametro("Par_AbonosDia", 	reporteMovimientos.getAbonosDia());
			parametrosReporte.agregaParametro("Par_Saldo", 		reporteMovimientos.getSaldo());
			parametrosReporte.agregaParametro("Par_SaldoDisp", 	reporteMovimientos.getSaldoDispon());
			parametrosReporte.agregaParametro("Par_SaldoBC", 	reporteMovimientos.getSaldoSBC());
			parametrosReporte.agregaParametro("Par_SaldoBloq", 	reporteMovimientos.getSaldoBloq());
			parametrosReporte.agregaParametro("Par_CargosPend", 	reporteMovimientos.getSaldoCargosPend());
			parametrosReporte.agregaParametro("Par_FechaSistema", reporteMovimientos.getFechaSistemaMov());
			parametrosReporte.agregaParametro("Par_SaldoProm", reporteMovimientos.getSaldoProm());
			parametrosReporte.agregaParametro("Par_Gat", reporteMovimientos.getGat());
			parametrosReporte.agregaParametro("Par_GatReal", reporteMovimientos.getGatReal());
		} 
		parametrosReporte.agregaParametro("Par_Cuenta",Utileria.convierteLong(reporteMovimientosBean.getCuentaAhoID()));
		parametrosReporte.agregaParametro("Par_Anio", reporteMovimientosBean.getAnio());
		parametrosReporte.agregaParametro("Par_Mes", reporteMovimientosBean.getMes());
		parametrosReporte.agregaParametro("Par_NomUsuario",(reporteMovimientosBean.getUsuario()));
		parametrosReporte.agregaParametro("Par_NomInstitucion",(reporteMovimientosBean.getNombreInstitucion()));
		parametrosReporte.agregaParametro("Par_FechaSistema", reporteMovimientosBean.getFechaSistema());

		parametrosReporte.agregaParametro("Par_Con",tipoConsulta);
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	 
		
	}

	public List lista(int tipoLista, ReporteMovimientosBean reporteMovimientos){
		List reporteMovimientosLista = null;
		switch (tipoLista) {
	        case  Enum_Lis_ReporteMovimientos.principal:
	        	reporteMovimientosLista = reporteMovimientosDAO.listaMovimientos(reporteMovimientos, tipoLista);
	        break;
	        case  Enum_Lis_ReporteMovimientos.principalHis:
	        	reporteMovimientosLista = reporteMovimientosDAO.listaMovimientos(reporteMovimientos, tipoLista);
	        break;
		}
		return reporteMovimientosLista;
	}
	
	public List <ReporteMovimientosBean> listaReporte(int tipoReporte, ReporteMovimientosBean reporteMovimientos , HttpServletResponse response){
		 List <ReporteMovimientosBean>listaMovimientos=null;
	
		switch(tipoReporte){		
			case  Enum_Con_TipRepor.ReporExcel:	
				listaMovimientos = reporteMovimientosDAO.listaReporteMovExcel(reporteMovimientos, tipoReporte);
				break;
			}
		
		return listaMovimientos;
	}
	
	public List listaEncabezado(int tipoConsulta, ReporteMovimientosBean reporteMovimientosBean , HttpServletResponse response){
		 List  <ReporteMovimientosBean>listaRepMov = null;
		 switch (tipoConsulta) {
	        case  Enum_Con_ReporteMovimientos.repMov:
	        	listaRepMov = reporteMovimientosDAO.listaReporteMovimientos(reporteMovimientosBean, Enum_Con_ReporteMovimientos.repMov);
	        	
	        break;
	        case  Enum_Con_ReporteMovimientos.repMovHis:
	        	listaRepMov = reporteMovimientosDAO.listaReporteMovimientos(reporteMovimientosBean, Enum_Con_ReporteMovimientos.repMovHis);
	        break;
		}
			
		 return listaRepMov;
		
	}
	
	
	// Lista de detalle de saldos  WS
   	public Object ConsultaSaldoDetalleWS(ConsultaSaldoDetalleBERequest cuentaSaldoDetalleBERequest){
			Object obj= null;
			String cadena = "";
			
			ConsultaSaldoDetalleBEResponse respuestaLista = new ConsultaSaldoDetalleBEResponse();
			List<ConsultaSaldoDetalleBEResponse> listaSaldos = reporteMovimientosDAO.ConsultaSaldoDetalleWS(cuentaSaldoDetalleBERequest);
			if (listaSaldos != null ){
				cadena = transformArray(listaSaldos);
			}
					respuestaLista.setListaResult(cadena);
					respuestaLista.setCodigoRespuesta("0");
					respuestaLista.setMensajeRespuesta("Consulta Exitosa");
					
					obj=(Object)respuestaLista;
					return obj;
			}	

   	// Separador de campos y registros de la lista de detalle de saldos WS
	private String transformArray(List listaSaldos)
	    {
	        String resultado= "";
	        String separadorCampos = "[";
	 		String separadorRegistro = "]";
	 		char vacio=' ';
	 		
	 		ReporteMovimientosBean reporteMovimientosBean;
	        if(listaSaldos!= null)
	        {   
	            Iterator<ReporteMovimientosBean> it = listaSaldos.iterator();
	            while(it.hasNext())
	            {    
	            	reporteMovimientosBean = (ReporteMovimientosBean)it.next();             	
	            
	            	resultado += 
	            			
	            			reporteMovimientosBean.getFecha()+separadorCampos;
	            			if (reporteMovimientosBean.getNatMovimiento().isEmpty()){
	            				resultado += "   "+ separadorCampos+	
	            						reporteMovimientosBean.getDescripcionMov()+ separadorCampos +
	            						reporteMovimientosBean.getCantidadMov()+ separadorCampos;
	            				if (reporteMovimientosBean.getReferenciaMov().isEmpty())
	            					resultado +="  "+ separadorCampos +
	            							reporteMovimientosBean.getSaldo()+ separadorRegistro;
	            			else
	            						resultado += reporteMovimientosBean.getReferenciaMov()+ separadorCampos +
	            									 reporteMovimientosBean.getSaldo()+ separadorRegistro;

	            				
	            			}else
	            				resultado +=reporteMovimientosBean.getNatMovimiento()+ separadorCampos +
	 	            				reporteMovimientosBean.getDescripcionMov()+ separadorCampos +
	 	            				reporteMovimientosBean.getCantidadMov()+ separadorCampos +
	 	            				reporteMovimientosBean.getReferenciaMov()+ separadorCampos +
	 	            				reporteMovimientosBean.getSaldo()+ separadorRegistro;
	            	}		
	            }		
	        
	 		if(resultado.length() !=0){
	 				resultado = resultado.substring(0,resultado.length()-1);
	 		}
	        return resultado;
	    }
	    
	        
	        

	public void setReporteMovimientosDAO(ReporteMovimientosDAO reporteMovimientosDAO) {
		this.reporteMovimientosDAO = reporteMovimientosDAO;
	}

	public ReporteMovimientosDAO getReporteMovimientosDAO() {
		return reporteMovimientosDAO;
	}

	public void setCorreoServicio(CorreoServicio correoServicio) {
		this.correoServicio = correoServicio;
	}

}
