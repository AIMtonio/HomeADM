	package inversiones.reporte;
	
	import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import inversiones.bean.RepExcepcionesInverBean;
import inversiones.servicio.RepExcepcionesInverServicio;

			public class ReporteExcepcionesInverControlador extends AbstractCommandController{

				RepExcepcionesInverServicio repExcepcionesInverServicio = null;
				String nombreReporte= null;
				String successView = null;
			
				public static interface Enum_Con_TipoReporte {
					  int  ReportePDF = 1;

				}
				public ReporteExcepcionesInverControlador () {
					
					setCommandClass(RepExcepcionesInverBean.class);
			 		setCommandName("repExcepcionesInverBean");
			 		
			 	}
				protected ModelAndView handle(HttpServletRequest request,
						HttpServletResponse response,
						Object command,
						BindException errors)throws Exception {
					RepExcepcionesInverBean repExcepcionesInverBean = (RepExcepcionesInverBean) command;
					int tipoReporte =(request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")):0;
						String htmlString= "";
							switch(tipoReporte){
							
								case Enum_Con_TipoReporte.ReportePDF:
									ByteArrayOutputStream htmlStringPDF = ExcepcionesInverRep(repExcepcionesInverBean, nombreReporte, response);
								break;
							
							}
								return null;
						}
						
				// Reporte de Movimientos por Tarjeta
				public ByteArrayOutputStream ExcepcionesInverRep(RepExcepcionesInverBean repExcepcionesInverBean, String nombreReporte, HttpServletResponse response){
					ByteArrayOutputStream htmlStringPDF = null;
					try {
						htmlStringPDF = repExcepcionesInverServicio.reporteExcepcionesInver(repExcepcionesInverBean, nombreReporte);
						response.addHeader("Content-Disposition","inline; filename=ReporteExcepcionesInversion.pdf");
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

				// Getter y Setter
				
				
			
				public RepExcepcionesInverServicio getRepExcepcionesInverServicio() {
					return repExcepcionesInverServicio;
				}
				public void setRepExcepcionesInverServicio(RepExcepcionesInverServicio repExcepcionesInverServicio) {
					this.repExcepcionesInverServicio = repExcepcionesInverServicio;
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
