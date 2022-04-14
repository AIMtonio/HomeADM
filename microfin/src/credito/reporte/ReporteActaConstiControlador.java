package credito.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.ActaConstitutivaGrupBean;
import credito.servicio.ActaConstitutivaGrupServicio;

public class ReporteActaConstiControlador extends AbstractCommandController{
	
	ActaConstitutivaGrupServicio actaConstitutivaGrupServicio = null;
	String nombreReporte = null;
	String successView = null;	
	
	public ReporteActaConstiControlador(){
		setCommandClass(ActaConstitutivaGrupBean.class);
		setCommandName("reporteActaConstitutiva");
	}
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
	}
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		ActaConstitutivaGrupBean gruposCreditosBean =(ActaConstitutivaGrupBean) command;
		// TODO Auto-generated method stub
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
				
				String htmlString= "";
				
				switch(tipoReporte){
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = reporteActaConstitutivaPDF(gruposCreditosBean, nombreReporte,response);
				break;
		
	}
				return null;
}
	private ByteArrayOutputStream reporteActaConstitutivaPDF(
			ActaConstitutivaGrupBean gruposCreditosBean, String nombreReporte2,
			HttpServletResponse response) {	ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = actaConstitutivaGrupServicio.reporteActaConstiPDF(gruposCreditosBean, nombreReporte);
				response.addHeader("Content-Disposition","inline; filename=ActaConstitutiva.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlStringPDF.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			} catch (Exception e) {
				e.printStackTrace();
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		
		return htmlStringPDF;
		}
	public String getNombreReporte() {
		return nombreReporte;
	}
	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	public ActaConstitutivaGrupServicio getActaConstitutivaGrupServicio() {
		return actaConstitutivaGrupServicio;
	}
	public void setActaConstitutivaGrupServicio(
			ActaConstitutivaGrupServicio actaConstitutivaGrupServicio) {
		this.actaConstitutivaGrupServicio = actaConstitutivaGrupServicio;
	}


	
}