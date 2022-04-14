package credito.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.RompimientoGrupoBean;
import credito.servicio.RompimientoGrupoServicio;

public class RompimientoGrupoReporteControlador  extends AbstractCommandController{
	
	public static interface Enum_Con_TipRepor {
		  int  ReportePDF= 1;
	}
	
	RompimientoGrupoServicio rompimientoGrupoServicio = null;
	String nomReporte = null;
	String successView = null;

	public RompimientoGrupoReporteControlador(){
		setCommandClass(RompimientoGrupoBean.class);
		setCommandName("rompimientoGrupoBean");
	}
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		
		RompimientoGrupoBean rompimientoGrupoBean = (RompimientoGrupoBean) command;
		// TODO Auto-generated method stub
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):0;
			
			rompimientoGrupoServicio.getRompimientoGrupoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

			String htmlString= "";
			
			switch(tipoReporte){
				case Enum_Con_TipRepor.ReportePDF:
					ByteArrayOutputStream htmlStringPDF = repRompimientoGrupoPDF(rompimientoGrupoBean, nomReporte, response);
				break;
			}
			return null;
		}
		
	// Reporte Rompimiento de Grupo en PDF
	private ByteArrayOutputStream repRompimientoGrupoPDF(RompimientoGrupoBean rompimientoGrupoBean, String nomReporte,
			HttpServletResponse response) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = rompimientoGrupoServicio.creaRepRompimientoGrupoPDF(rompimientoGrupoBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=RompimientoGrupo.pdf");
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
	public RompimientoGrupoServicio getRompimientoGrupoServicio() {
		return rompimientoGrupoServicio;
	}
	public void setRompimientoGrupoServicio(
			RompimientoGrupoServicio rompimientoGrupoServicio) {
		this.rompimientoGrupoServicio = rompimientoGrupoServicio;
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
