package ventanilla.reporte;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.RemesasPagadasRepBean;
import ventanilla.servicio.RemesasPagadasRepServicio;

public class RemesasPagadasRepControlador extends AbstractCommandController {
	
	public static interface Enum_Con_TipRepor {
		  int reporteExcel = 1 ;
	}
	
	RemesasPagadasRepServicio remesasPagadasRepServicio = null;
	
	private String successView = null;

	public RemesasPagadasRepControlador() {
		setCommandClass(RemesasPagadasRepBean.class);
		setCommandName("remesasPagadasRepBean");
	}


	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		RemesasPagadasRepBean remesasPagadasRepBean = (RemesasPagadasRepBean) command;
		int tipoReporte =(request.getParameter("tipoRep")!=null)?
				Integer.parseInt(request.getParameter("tipoRep")):0;
				
		switch(tipoReporte){
			case Enum_Con_TipRepor.reporteExcel:
				List<RemesasPagadasRepBean> listaReportes = remesasPagadasRepServicio.listaReporteExcel(tipoReporte, remesasPagadasRepBean, response);
			break;
		}
		return null;	
	}


	public RemesasPagadasRepServicio getRemesasPagadasRepServicio() {
		return remesasPagadasRepServicio;
	}
	
	public void setRemesasPagadasRepServicio(RemesasPagadasRepServicio remesasPagadasRepServicio) {
		this.remesasPagadasRepServicio = remesasPagadasRepServicio;
	}
	
	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

}
