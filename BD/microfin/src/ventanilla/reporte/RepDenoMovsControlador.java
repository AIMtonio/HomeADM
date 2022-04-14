package ventanilla.reporte;

import general.bean.ParametrosAuditoriaBean;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import reporte.ParametrosReporte;
import reporte.Reporte;
import ventanilla.bean.DenominacionMovsBean;

public class RepDenoMovsControlador extends AbstractCommandController{
	 
	
	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
	}
	
	String nomReporte = null;
	String successView = null;
	
	public RepDenoMovsControlador(){
		setCommandClass(DenominacionMovsBean.class);
		setCommandName("denominacionMovsBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		DenominacionMovsBean denominacionMovsBean = (DenominacionMovsBean) command;
		
		
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
			0;
		switch(tipoReporte){
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = reporteDenominacionMovs(denominacionMovsBean, nomReporte, response);
			break;
		}
		return null;
	}
	public ByteArrayOutputStream reporteDenominacionMovs(DenominacionMovsBean denominacionMovsBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_NombreEmpresa",denominacionMovsBean.getProgramaID());
			parametrosReporte.agregaParametro("Par_NumSucursal",denominacionMovsBean.getSucursalID());
			parametrosReporte.agregaParametro("Par_NomSucursal",denominacionMovsBean.getSucursal());
			parametrosReporte.agregaParametro("Par_NumCaja",denominacionMovsBean.getCajaID());
			parametrosReporte.agregaParametro("Par_NumUsuario",denominacionMovsBean.getNumusuario());
			parametrosReporte.agregaParametro("Par_NomUsuario",denominacionMovsBean.getNomusuario());
			parametrosReporte.agregaParametro("Par_Fecha",denominacionMovsBean.getFecha());
			parametrosReporte.agregaParametro("Par_Hora",denominacionMovsBean.getFechaActual()); // Hora Par_Hora
			htmlStringPDF =  Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			response.addHeader("Content-Disposition","inline; filename=ReportedeDenominaciones.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		return htmlStringPDF;
	}


	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
	
	
}
