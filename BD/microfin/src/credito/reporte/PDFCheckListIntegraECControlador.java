package credito.reporte;

import general.bean.ParametrosAuditoriaBean;
 
import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import reporte.ParametrosReporte;
import reporte.Reporte;
import credito.bean.IntegraExpCredBean;

public class PDFCheckListIntegraECControlador extends AbstractCommandController{
	
	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
	}
	
	String nomReporte = null;
	String successView = null;
	
	public PDFCheckListIntegraECControlador(){
		setCommandClass(IntegraExpCredBean.class);
		setCommandName("integraExpCredBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		IntegraExpCredBean integraExpCredBean = (IntegraExpCredBean) command;
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tioTransaccion")):
					0;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
			0;
		String htmlString= "";
		switch(tipoReporte){
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = reporteDenominacionMovs(integraExpCredBean, nomReporte, response);
			break;
		}
				return null;
		}
		
		// Reporte denominacion de movimientos PDF
		public ByteArrayOutputStream reporteDenominacionMovs(IntegraExpCredBean integraExpCredBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_NombreInstitucion",integraExpCredBean.getNombreInstitucion());
			parametrosReporte.agregaParametro("Par_NumeroGrupo",integraExpCredBean.getNumeroGrupo());
			parametrosReporte.agregaParametro("Par_NumeroCliente",integraExpCredBean.getNumeroCliente());
			parametrosReporte.agregaParametro("Par_NombreGrupo",integraExpCredBean.getNombreGrupo());
			parametrosReporte.agregaParametro("Par_NombreCliente",integraExpCredBean.getNombreCliente());

			htmlStringPDF =  Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			response.addHeader("Content-Disposition","inline; filename=IntegraciondeExpedientedeCredito.pdf");
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
