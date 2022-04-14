package contabilidad.reporte;

import java.io.ByteArrayOutputStream;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFSheet;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.RepPolizasIntersucBean;
import contabilidad.servicio.RepPolizasIntersucServicio;

   
public class ReporteTransCtasBanControlador  extends AbstractCommandController{	
	RepPolizasIntersucServicio reportePolizasIntersucServicio = null;
	String nomReporte= null;
	String successView = null;
	HSSFSheet excel = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipRepor {
		  int  ReporExcel= 1 ;
		
		}
	public ReporteTransCtasBanControlador () {
		setCommandClass(RepPolizasIntersucBean.class);
		setCommandName("repPolizasIntersucBean");
	}

	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		RepPolizasIntersucBean reportePolIntersucBean = (RepPolizasIntersucBean) command;

		
		
		
		reportePolizasIntersucServicio.getReportePolizasIntersucDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	int tipoLista =(request.getParameter("tipoLista")!=null)?
			Integer.parseInt(request.getParameter("tipoLista")):0;
			
	String htmlString= "";
		
		List<RepPolizasIntersucBean> excel = reportePolizasIntersucServicio.listaReportesTransferCtasBanc(tipoLista,reportePolIntersucBean, response);
				
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


	public RepPolizasIntersucServicio getReportePolizasIntersucServicio() {
		return reportePolizasIntersucServicio;
	}


	public void setReportePolizasIntersucServicio(
			RepPolizasIntersucServicio reportePolizasIntersucServicio) {
		this.reportePolizasIntersucServicio = reportePolizasIntersucServicio;
	}

	
}
