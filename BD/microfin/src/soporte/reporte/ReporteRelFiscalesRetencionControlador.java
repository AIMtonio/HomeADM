package soporte.reporte;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.RelacionadosFiscalesBean;
import soporte.servicio.RelacionadosFiscalesServicio;

public class ReporteRelFiscalesRetencionControlador extends AbstractCommandController{
	RelacionadosFiscalesServicio relacionadosFiscalesServicio = null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		int  Excel = 1 ;
	}
	
	public ReporteRelFiscalesRetencionControlador(){
		setCommandClass(RelacionadosFiscalesBean.class);
		setCommandName("relacionadosFiscalesBean");		
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		RelacionadosFiscalesBean relacionadosFiscalesBean = (RelacionadosFiscalesBean) command;
		
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):0;
		
		String htmlString= "";
				
		switch(tipoReporte){
			case Enum_Con_TipRepor.Excel:
				List listaReportes = relacionadosFiscalesServicio.listaReporteRelFiscalRetExcel(tipoLista, relacionadosFiscalesBean ,response);
			break;
		}
		return null;		
	}

	public RelacionadosFiscalesServicio getRelacionadosFiscalesServicio() {
		return relacionadosFiscalesServicio;
	}

	public void setRelacionadosFiscalesServicio(
			RelacionadosFiscalesServicio relacionadosFiscalesServicio) {
		this.relacionadosFiscalesServicio = relacionadosFiscalesServicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}
