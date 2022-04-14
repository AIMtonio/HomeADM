package sms.reporte;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import sms.bean.ResumenActividadSMSBean;
import sms.servicio.ResumenActividadSMSServicio;


public class DetalleResumenActRepControlador extends AbstractCommandController  {
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPantalla= 1 ;
		  int  ReporPDF= 2 ;
		  int  ReporExcel= 3 ;
	}
	
	ResumenActividadSMSServicio resumenActividadSMSServicio = null;
	String nomReporte= null;
	String successView = null;
	
	public DetalleResumenActRepControlador () {
		setCommandClass(ResumenActividadSMSBean.class);
		setCommandName("resumenActividadSMS");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
	ResumenActividadSMSBean resumenActividadSMS = (ResumenActividadSMSBean) command;
	int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
		0;
	
			resumenActividadSMSServicio.getResumenActividadSMSDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			String htmlString= "";
			
				switch(tipoReporte){
				
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = reporteDetalleResumenActPDF(resumenActividadSMS, nomReporte, response);
				break;
			}
				
				if(tipoReporte == Enum_Con_TipRepor.ReporPantalla ){
					return new ModelAndView(getSuccessView(), "reporte", htmlString);
				}else {
					return null;
				}
					
			}
			
			
	
	// Reporte de detalle de resumen de actividad sms pdf
		public ByteArrayOutputStream reporteDetalleResumenActPDF(ResumenActividadSMSBean resumenActividadSMS, String nomReporte, HttpServletResponse response){
			ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = resumenActividadSMSServicio.reporteDetalleResumenActPDF(resumenActividadSMS, nomReporte);
				response.addHeader("content-disposition", "inline;  filename=detalleResActSMS"+resumenActividadSMS.getCodigoRespuesta()+".pdf");
				//response.addHeader("Content-Disposition","attachment; filename=detalleResActSMS"+resumenActividadSMS.getCodigoRespuesta()+".pdf");
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


	public void setResumenActividadSMSServicio(
			ResumenActividadSMSServicio resumenActividadSMSServicio) {
		this.resumenActividadSMSServicio = resumenActividadSMSServicio;
	}

	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

}
