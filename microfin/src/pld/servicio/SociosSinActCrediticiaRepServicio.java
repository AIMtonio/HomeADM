package pld.servicio;

import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import cliente.bean.ReporteClienteLocMarginadasBean;
import pld.bean.SociosSinActCrediticiaRepBean;
import pld.servicio.SociosAltoRiesgoRepServicio.Enum_Lis_SociosAltoRiesgo;
import reporte.ParametrosReporte;
import reporte.Reporte;



public class SociosSinActCrediticiaRepServicio extends BaseServicio{	
	public static interface Enum_Lis_SociosSinActCrediticia {
		int sociosSinActCrediticia = 1;
	}	
	
	private SociosSinActCrediticiaRepServicio(){
		super();
	}
	 
	// Reporte  de Socios Sin Activida Crediticia pdf
	public ByteArrayOutputStream creaRepSociosSinActCrePDF(SociosSinActCrediticiaRepBean sociosSinCreditos,String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_SucursalID",Utileria.convierteEntero(sociosSinCreditos.getSucursalID()));
		parametrosReporte.agregaParametro("Par_NombreSucursal",sociosSinCreditos.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_Periodo",Utileria.convierteDoble(sociosSinCreditos.getPeriodo()));
		
		parametrosReporte.agregaParametro("Par_NombreInstitucion",(!sociosSinCreditos.getNombreInstitucion().isEmpty())?sociosSinCreditos.getNombreInstitucion(): "TODAS");
		parametrosReporte.agregaParametro("Par_NombreUsuario",sociosSinCreditos.getUsuario());
		parametrosReporte.agregaParametro("Par_FechaEmision",sociosSinCreditos.getFechaEmision());

		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
}
