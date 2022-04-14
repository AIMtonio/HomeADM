package cuentas.servicio;
import java.io.ByteArrayOutputStream;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import bancaEnLinea.beanWS.request.ConsultaCargosPendientesBERequest;
import bancaEnLinea.beanWS.response.ConsultaCargosPendientesBEResponse;
 
import reporte.ParametrosReporte;
import reporte.Reporte;

import cuentas.bean.CobrosPendBean;
import general.servicio.BaseServicio;
import cuentas.dao.CobrosPendDAO;

public class CobrosPendServicio extends BaseServicio {

	private CobrosPendServicio(){
		super();
	}

	CobrosPendDAO cobrosPendDAO = null;
	
	public static interface Enum_Lis_CobrosPend{
		int porClienteYCuenta 		= 1;
		int porClienteYCuentaHistorico	= 2;

	}
	
	public static interface Enum_Lis_RepCobrosPend {
		int repCobrosPendientes = 1;  //reporte de  cobros pendientes
	}

	public List lista(int tipoLista, CobrosPendBean cobrosPendBean){
		List listaCobrosPendientes = null;
		switch (tipoLista) {
	        case  Enum_Lis_CobrosPend.porClienteYCuenta:
	        	listaCobrosPendientes = cobrosPendDAO.listaCobrosPendientesPorClienteCuenta(cobrosPendBean, tipoLista);
	        break;
	        case  Enum_Lis_CobrosPend.porClienteYCuentaHistorico:
	        	listaCobrosPendientes = cobrosPendDAO.listaCobrosPendientesPorClienteCuenta(cobrosPendBean, tipoLista);
	        break;
	        
		}
		return listaCobrosPendientes;
	}
	
	/*case para listas de reportes de credito*/
	public List listaReportesCobros(int tipoLista, CobrosPendBean cobrosPendBean, HttpServletResponse response){
		 List listaCobros=null;
		switch(tipoLista){		
			case Enum_Lis_RepCobrosPend.repCobrosPendientes:
				listaCobros = cobrosPendDAO.listaRepCobrosPendientes(cobrosPendBean, tipoLista);
				break;	
			}
		
		return listaCobros;
	}
	
	
	public ByteArrayOutputStream creaRepCobrosPendPDF(CobrosPendBean cobrosPendBean , String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
	
		parametrosReporte.agregaParametro("Par_FechaIni",cobrosPendBean.getFechaInicial());
		parametrosReporte.agregaParametro("Par_FechaFin",cobrosPendBean.getFechaFinal());
		parametrosReporte.agregaParametro("Par_ClienteID",cobrosPendBean.getClienteID());
		parametrosReporte.agregaParametro("Par_CuentaID",cobrosPendBean.getCuentaAhoID());
		
		parametrosReporte.agregaParametro("Par_FechaEmision",cobrosPendBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_Usuario",cobrosPendBean.getUsuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",cobrosPendBean.getNombreInstitucion());
		 	 
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	
	

	// Lista de saldos bloqueados  WS
   	public Object listaCobrosPendWS(int tipoLista, ConsultaCargosPendientesBERequest consultaCargosPendientesBERequest){
			Object obj= null;
			String cadena = "";
			
			ConsultaCargosPendientesBEResponse respuestaLista = new ConsultaCargosPendientesBEResponse();
			List<ConsultaCargosPendientesBEResponse> listaCargosPend = cobrosPendDAO.listaCobrosPendientesWS(consultaCargosPendientesBERequest, tipoLista);
			if (listaCargosPend != null ){
				cadena = transformArray(listaCargosPend);
			}
					respuestaLista.setListaCargos(cadena);
					respuestaLista.setCodigoRespuesta("0");
					respuestaLista.setMensajeRespuesta("Consulta Exitosa");
					
					obj=(Object)respuestaLista;
					return obj;
			}	

   	// Separador de campos y registros de la lista de Descuentos de Nomina WS
		private String transformArray(List listaSaldos)
	    {
	        String resultado= "";
	        String separadorCampos = "[";
	 		String separadorRegistro = "]";
	 		
	 		CobrosPendBean cobrosPendBean;
	        if(listaSaldos!= null)
	        {   
	            Iterator<CobrosPendBean> it = listaSaldos.iterator();
	            while(it.hasNext())
	            {    
	            	cobrosPendBean = (CobrosPendBean)it.next();             	
	            	resultado += cobrosPendBean.getFecha()+separadorCampos+
	            			cobrosPendBean.getDescripcion()+ separadorCampos +
	            			cobrosPendBean.getCantPenOri()+ separadorCampos +
	            			cobrosPendBean.getCantPenAct()+ separadorCampos +
	            			cobrosPendBean.getSumCanPenOri()+ separadorCampos +
	            			cobrosPendBean.getSumCanPenAct()+  separadorRegistro;
	            }
	        }
	 		if(resultado.length() !=0){
	 				resultado = resultado.substring(0,resultado.length()-1);
	 		}
	        return resultado;
	    }


	public CobrosPendDAO getCobrosPendDAO() {
		return cobrosPendDAO;
	}

	public void setCobrosPendDAO(CobrosPendDAO cobrosPendDAO) {
		this.cobrosPendDAO = cobrosPendDAO;
	}
	
}
