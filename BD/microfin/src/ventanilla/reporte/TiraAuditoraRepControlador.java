package ventanilla.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.CajasVentanillaBean;
import ventanilla.servicio.CajasVentanillaServicio;

public class TiraAuditoraRepControlador extends AbstractCommandController{
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPantalla= 1 ;
		  int  ReporPDF= 2 ;
	}
	
	CajasVentanillaServicio cajasVentanillaServicio = null;
	String nomReporte = null;
	String successView = null;
	
	public TiraAuditoraRepControlador(){
		setCommandClass(CajasVentanillaBean.class);
		setCommandName("cajasVentanillaBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		CajasVentanillaBean cajasVentanilla = (CajasVentanillaBean) command;
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tioTransaccion")):
					0;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
			0;
		cajasVentanillaServicio.getCajasVentanillaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		String htmlString= "";
		
		switch(tipoReporte){
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = reporteTiraAuditora(cajasVentanilla, nomReporte, response);
			break;
		
		}
		if(tipoReporte == Enum_Con_TipRepor.ReporPantalla ){
				return new ModelAndView(getSuccessView(), "reporte", htmlString);
			}else {
				return null;
			}
		}
		
		// Reporte Tira Auditora PDF
		public ByteArrayOutputStream reporteTiraAuditora(CajasVentanillaBean cajasVentanillaBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = cajasVentanillaServicio.reporteTiraAuditora(cajasVentanillaBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteTiraAuditora.pdf");
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


	public void setCajasVentanillaServicio(
			CajasVentanillaServicio cajasVentanillaServicio) {
		this.cajasVentanillaServicio = cajasVentanillaServicio;
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
	
	
}
