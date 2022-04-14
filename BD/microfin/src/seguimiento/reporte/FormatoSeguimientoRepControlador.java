package seguimiento.reporte;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import seguimiento.bean.FormatoSeguimientoBean;
import seguimiento.bean.SeguimientoBean;
import seguimiento.reporte.SegtoCampoRepControlador.Enum_Con_TipRepor;
import seguimiento.servicio.FormatoSeguimientoServicio;
import seguimiento.servicio.SeguimientoServicio;

public class FormatoSeguimientoRepControlador extends AbstractCommandController{
	public static interface Enum_Con_TipRepor {
		  int  ReportePDF= 1;
	}
	FormatoSeguimientoServicio formatoSeguimientoServicio = null;
	String nombreReporte = null;
	String successView = null;		

	public FormatoSeguimientoRepControlador(){
		setCommandClass(FormatoSeguimientoBean.class);
		setCommandName("formatoSeguimientoBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {	
		
			FormatoSeguimientoBean formatoSeguimientoBean =(FormatoSeguimientoBean) command;
			// TODO Auto-generated method stub
			int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;

			
			formatoSeguimientoServicio.getSeguimientoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			String htmlString= "";
				
			switch(tipoReporte){
				case Enum_Con_TipRepor.ReportePDF:
					ByteArrayOutputStream htmlStringPDF = formatoSeguimientoPDF(formatoSeguimientoBean, nombreReporte, response);
				break;
			}
			return null;
		}
	// Reporte de Seguimiento de Campo en PDF
	private ByteArrayOutputStream formatoSeguimientoPDF(FormatoSeguimientoBean formatoSeguimientoBean, String nombreReporte,
			HttpServletResponse response) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = formatoSeguimientoServicio.formatoSegtoCampoPDF(formatoSeguimientoBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=FormatoSeguimientoCampo.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
		}		
		return htmlStringPDF;
	}

	public FormatoSeguimientoServicio getFormatoSeguimientoServicio() {
		return formatoSeguimientoServicio;
	}

	public void setFormatoSeguimientoServicio(
			FormatoSeguimientoServicio formatoSeguimientoServicio) {
		this.formatoSeguimientoServicio = formatoSeguimientoServicio;
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
}