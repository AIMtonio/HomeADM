
package cliente.reporte;



import herramientas.Constantes;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ReporteIDEBean;
import cliente.servicio.ReporteIDEServicio;


   
public class RepIDEControlador  extends AbstractCommandController{	
	ReporteIDEServicio reporteIDEServicio = null;
	String nomReporte= null;
	String successView = null;
	HSSFSheet excel = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipRepor {
		  int  ReporExcel= 1 ;
		  int  ReporXML	 = 2 ;
		}
	public RepIDEControlador () {
		setCommandClass(ReporteIDEBean.class);
		setCommandName("reporteIDEBean");
	}

	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		ReporteIDEBean reporteBean = (ReporteIDEBean) command;

	int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):0;
			
	String htmlString= "";
	String contentOriginal = response.getContentType(); 
	
		switch(tipoLista){
		
		case Enum_Con_TipRepor.ReporExcel:
			List<ReporteIDEBean> excel = reporteIDEServicio.listaReportes(tipoLista,reporteBean, response);
		break;
	
		case Enum_Con_TipRepor.ReporXML:
			return reporteIDEServicio.generaIDEXml(response, contentOriginal,reporteBean);
		
		default:
		    htmlString = Constantes.htmlErrorReporteCirculo;
 			response.addHeader("Content-Disposition","");
	 		response.setContentType(contentOriginal);
	 		response.setContentLength(htmlString.length());
 			return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);
 			
		
		}
				
		return null;
			
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


	public ReporteIDEServicio getReporteIDEServicio() {
		return reporteIDEServicio;
	}


	public void setReporteIDEServicio(ReporteIDEServicio reporteIDEServicio) {
		this.reporteIDEServicio = reporteIDEServicio;
	}



	
	
}
