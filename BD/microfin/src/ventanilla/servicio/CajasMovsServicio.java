package ventanilla.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import reporte.ParametrosReporte;
import reporte.Reporte;
import ventanilla.bean.CajasMovsBean;
import ventanilla.dao.CajasMovsDAO;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class CajasMovsServicio extends BaseServicio{
	CajasMovsDAO	cajasMovsDAO	=null;

	 

	public static interface Enum_LisReporteCajasMovs{
		int reporteCajaPrincipal = 2;
	
	}
	
	
	public ByteArrayOutputStream reporteCajaPrincipalPDF(CajasMovsBean cajasMovsBean,String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		 
		parametrosReporte.agregaParametro("Par_FechaInicio",cajasMovsBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin",cajasMovsBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!cajasMovsBean.getNombreInstitucion().isEmpty())?cajasMovsBean.getNombreInstitucion(): "TODOS");
		
		parametrosReporte.agregaParametro("Par_NomUsuario",cajasMovsBean.getClaveUsuario());
		parametrosReporte.agregaParametro("Par_FechaEmision",cajasMovsBean.getFechaEmision());			
		parametrosReporte.agregaParametro("Par_Moneda",Utileria.convierteEntero(cajasMovsBean.getMonedaID()));
		parametrosReporte.agregaParametro("Par_NombreMoneda",(!cajasMovsBean.getNombreMoneda().isEmpty())? cajasMovsBean.getNombreMoneda() : "TODAS");
		parametrosReporte.agregaParametro("Par_NombreCaja",(!cajasMovsBean.getNombreCaja().isEmpty())? cajasMovsBean.getNombreCaja() : "TODAS");
		parametrosReporte.agregaParametro("Par_CajaID",Utileria.convierteEntero(cajasMovsBean.getCajaID()));
		

		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	public List listaReporteCajaPrincipal(int tipoLista, CajasMovsBean cajasMovsBean, HttpServletResponse response){
		 List listaCajas=null;
		switch(tipoLista){
			case Enum_LisReporteCajasMovs.reporteCajaPrincipal:
				listaCajas = cajasMovsDAO.listaReporteCajaPrincipal(cajasMovsBean, tipoLista); 
				break;	
		}
		
		return listaCajas;
	}
	
	
	//-------------getter y setter ------------
	public CajasMovsDAO getCajasMovsDAO() {
		return cajasMovsDAO;
	}

	public void setCajasMovsDAO(CajasMovsDAO cajasMovsDAO) {
		this.cajasMovsDAO = cajasMovsDAO;
	}
	
	
	
	
}
