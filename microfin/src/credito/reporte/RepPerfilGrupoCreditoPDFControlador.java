package credito.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.RepPerfilGrupoCreditoBean;
import credito.servicio.RepPerfilGrupoCreditoServicio;

public class RepPerfilGrupoCreditoPDFControlador extends AbstractCommandController{
	RepPerfilGrupoCreditoServicio repPerfilGrupoCreditoServicio = null;
	String nombreReporte = null;
	String successView = null;	
	
	public RepPerfilGrupoCreditoPDFControlador(){
		setCommandClass(RepPerfilGrupoCreditoBean.class);
		setCommandName("repPerfilGrupoCreditoBean");
	}

	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {	
		RepPerfilGrupoCreditoBean repPerfilGrupoCreditoBean =(RepPerfilGrupoCreditoBean) command;
		// TODO Auto-generated method stub
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
				
				String htmlString= "";
				
				switch(tipoReporte){
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = repPerfilGrupoCreditoPDF(repPerfilGrupoCreditoBean, nombreReporte,response);
				break;
		
	}
				return null;
}
	private ByteArrayOutputStream repPerfilGrupoCreditoPDF(
			RepPerfilGrupoCreditoBean repPerfilGrupoCreditoBean, String nombreReporte2,
			HttpServletResponse response) {	ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = repPerfilGrupoCreditoServicio.reportePerfilGrupoPDF(repPerfilGrupoCreditoBean, nombreReporte);
				response.addHeader("Content-Disposition","inline; filename=ReportePerfilGrupo.pdf");
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
	
	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	public void setRepPerfilGrupoCreditoServicio(
			RepPerfilGrupoCreditoServicio repPerfilGrupoCreditoServicio) {
		this.repPerfilGrupoCreditoServicio = repPerfilGrupoCreditoServicio;
	}
	

}
