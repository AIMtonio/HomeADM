package pld.reporte;
import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ReporteClienteLocMarginadasBean;
import cliente.reporte.RepClienteLocMarginadasControlador.Enum_Con_TipRepor;
import pld.bean.SociosSinActCrediticiaRepBean;
import pld.servicio.SociosSinActCrediticiaRepServicio;


public class RepSociosSinActCrediticiaControlador extends AbstractCommandController{

	SociosSinActCrediticiaRepServicio sociosSinActCrediticiaRepServicio = null;
		String nombreReporte= null;
		String successView = null;
		protected final Logger loggerSAFI = Logger.getLogger("SAFI");
		
		public static interface Enum_Con_TipRepor {
				int ReporPDF  = 1;			  
			    
		}
		public RepSociosSinActCrediticiaControlador () {
			setCommandClass(SociosSinActCrediticiaRepBean.class);
			setCommandName("sociosSinActCrediticiaRepBean");
		}
		
		protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors)throws Exception {
			
			SociosSinActCrediticiaRepBean sociosSinActCrediticiaRepBean = (SociosSinActCrediticiaRepBean) command;

				int tipoReporte =(request.getParameter("tipoReporte")!=null)?
								Integer.parseInt(request.getParameter("tipoReporte")):
								0;
				int tipoLista =(request.getParameter("tipoLista")!=null)?
								Integer.parseInt(request.getParameter("tipoLista")):
								0;
			
			switch(tipoReporte){	
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = sociosSinActCrediticiaPDF(sociosSinActCrediticiaRepBean, nombreReporte, response);
			break;			
			}
			return null;
				
		}
		
		// Reporte de Socios sin Actividad Crediticia 
		public ByteArrayOutputStream sociosSinActCrediticiaPDF(SociosSinActCrediticiaRepBean sociosSinActCrediticiaRepBean, String nombreReporte, HttpServletResponse response){
			ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = sociosSinActCrediticiaRepServicio.creaRepSociosSinActCrePDF(sociosSinActCrediticiaRepBean, nombreReporte);
				response.addHeader("Content-Disposition","inline; filename=SociosSinActCrediticia.pdf");
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
		
		// getter y setters //		
		public String getSuccessView() {
			return successView;
		}	

		public SociosSinActCrediticiaRepServicio getSociosSinActCrediticiaRepServicio() {
			return sociosSinActCrediticiaRepServicio;
		}

		public void setSociosSinActCrediticiaRepServicio(
				SociosSinActCrediticiaRepServicio sociosSinActCrediticiaRepServicio) {
			this.sociosSinActCrediticiaRepServicio = sociosSinActCrediticiaRepServicio;
		}

		public void setSuccessView(String successView) {
			this.successView = successView;
		}

		public String getNombreReporte() {
			return nombreReporte;
		}

		public void setNombreReporte(String nombreReporte) {
			this.nombreReporte = nombreReporte;
		}
		
		

}

