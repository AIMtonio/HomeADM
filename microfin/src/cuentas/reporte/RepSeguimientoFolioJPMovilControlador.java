package cuentas.reporte;



import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.RepSeguimientoFolioJPMovilBean;
import cuentas.servicio.RepSeguimientoFolioJPMovilServicio;


public class RepSeguimientoFolioJPMovilControlador extends AbstractCommandController{
	RepSeguimientoFolioJPMovilServicio repSeguimientoFolioJPMovilServicio = null;
	
	public static interface Enum_Con_TipoReporte {
		  int  ReporteExcel	= 1;
	}
	
	public  RepSeguimientoFolioJPMovilControlador () {
		setCommandClass(RepSeguimientoFolioJPMovilBean.class);
		setCommandName("repSeguimientoFolioJPMovilBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		RepSeguimientoFolioJPMovilBean repSeguimientoFolioJPMovilBean = (RepSeguimientoFolioJPMovilBean) command;

		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;

				
		switch(tipoReporte){
			case Enum_Con_TipoReporte.ReporteExcel:		
				 repSeguimientoFolioJPMovilServicio.generaReporteExcel(response, repSeguimientoFolioJPMovilBean, tipoReporte);
			}
			return null;
		}

	public RepSeguimientoFolioJPMovilServicio getRepSeguimientoFolioJPMovilServicio() {
		return repSeguimientoFolioJPMovilServicio;
	}

	public void setRepSeguimientoFolioJPMovilServicio(
			RepSeguimientoFolioJPMovilServicio repSeguimientoFolioJPMovilServicio) {
		this.repSeguimientoFolioJPMovilServicio = repSeguimientoFolioJPMovilServicio;
	}
}
