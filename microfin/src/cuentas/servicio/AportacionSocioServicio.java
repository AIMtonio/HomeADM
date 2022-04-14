package cuentas.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;
 
import javax.servlet.http.HttpServletRequest;



import reporte.ParametrosReporte;
import reporte.Reporte;

import cuentas.bean.AportacionSocioBean;
import cuentas.bean.RepAportaSocioMovBean;
import cuentas.bean.ReporteMovimientosBean;
import cuentas.dao.AportacionSocioDAO;

import general.servicio.BaseServicio;
import herramientas.Utileria;


public class AportacionSocioServicio extends BaseServicio {
	
	AportacionSocioDAO aportacionSocioDAO = null;
	
	public AportacionSocioServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Aportacion {
		int principal = 1;
	}
	public static interface Enum_Lis_Aportacion {
		int principal = 1;
	}

	public static interface Enum_Rep_Aportacion {
		int aportaSocioMov = 1;
	}

	public AportacionSocioBean consulta(int tipoConsulta, AportacionSocioBean aportacionSocioBean){
		AportacionSocioBean aportacionSocio = null;
		switch (tipoConsulta) {
			case Enum_Con_Aportacion.principal:		
				aportacionSocio = aportacionSocioDAO.consultaPrincipal(aportacionSocioBean, tipoConsulta);				
				break;							
		}
		return aportacionSocio;
	}

	public List listaMovAportaSocio(int tipoLista, RepAportaSocioMovBean repAportaSocioMovBean){
		List listaMovimientos = null;
		switch (tipoLista) {
	        case  Enum_Lis_Aportacion.principal:
	        	listaMovimientos = aportacionSocioDAO.listaMovimientos(repAportaSocioMovBean, tipoLista);
	        break;
		}
		return listaMovimientos;
	}
		// Reporte  de Certificado de Aportacion
		public ByteArrayOutputStream repCertificadoAportaPDF(RepAportaSocioMovBean repAportaSocioMovBean, 
			String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_NomInstitucion",repAportaSocioMovBean.getNombreInstit());
			parametrosReporte.agregaParametro("Par_DirecInstit",repAportaSocioMovBean.getDirecInstit());
			parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(repAportaSocioMovBean.getClienteID()));
			parametrosReporte.agregaParametro("Par_RFCInt",repAportaSocioMovBean.getRFCInstit());
			parametrosReporte.agregaParametro("Par_TelInst",repAportaSocioMovBean.getTelInstit());
			parametrosReporte.agregaParametro("Par_SucursalID",Utileria.convierteEntero(repAportaSocioMovBean.getSucursalID()));
			parametrosReporte.agregaParametro("Par_NombreCompleto",repAportaSocioMovBean.getNombreCliente());
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}
		
		// Reporte  de Solicitud de Baja del Socio
		public ByteArrayOutputStream repSolicitudBajaSocioPDF(RepAportaSocioMovBean repAportaSocioMovBean, 
			String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_NomInstitucion",repAportaSocioMovBean.getNombreInstit());
			parametrosReporte.agregaParametro("Par_DirecInstit",repAportaSocioMovBean.getDirecInstit());
			parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(repAportaSocioMovBean.getClienteID()));
			parametrosReporte.agregaParametro("Par_RFCInt",repAportaSocioMovBean.getRFCInstit());
			parametrosReporte.agregaParametro("Par_TelInst",repAportaSocioMovBean.getTelInstit());
			parametrosReporte.agregaParametro("Par_NombreCompleto",repAportaSocioMovBean.getNombreCliente());
			
			parametrosReporte.agregaParametro("Par_FechaEmision", repAportaSocioMovBean.getFechaEmision());
			parametrosReporte.agregaParametro("Par_DireccionSucursal",repAportaSocioMovBean.getDireccionSucursal());
			parametrosReporte.agregaParametro("Par_RepresentanteLegal",repAportaSocioMovBean.getRepresentanteLegal());
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}

	public String reporteAportaSocioMov(RepAportaSocioMovBean repAportaSocioMovBean,HttpServletRequest request, String nombreReporte, int tipoConsulta) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		List  listaRepMov = null;
		ReporteMovimientosBean reporteMovimientos;
		switch (tipoConsulta) {
	        case  Enum_Rep_Aportacion.aportaSocioMov:
	        	listaRepMov = aportacionSocioDAO.listaMovimientos(repAportaSocioMovBean, tipoConsulta);
	        break;
		}
		
		
		for(int i=0; i<listaRepMov.size(); i++){
			reporteMovimientos = (ReporteMovimientosBean)listaRepMov.get(i);
			if(i==1){
				break;
			}
			parametrosReporte.agregaParametro("Par_NumCte",	 	reporteMovimientos.getClienteID());
			/*parametrosReporte.agregaParametro("Par_Nombre", 	reporteMovimientos.getNombreCompleto());
			parametrosReporte.agregaParametro("Par_FechaSistema", reporteMovimientos.getFechaSistemaMov());*/
		} 
		parametrosReporte.agregaParametro("Par_Con",tipoConsulta);
		//parametrosReporte.agregaParametro("Par_NomCajero", request.getParameter("nomCajero"));
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	
		
	}
	
	//-----------------setter y getter----------
	public AportacionSocioDAO getAportacionSocioDAO() {
		return aportacionSocioDAO;
	}

	public void setAportacionSocioDAO(AportacionSocioDAO aportacionSocioDAO) {
		this.aportacionSocioDAO = aportacionSocioDAO;
	}
	
	
	
}
