package credito.reporte;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.TotalAplicadosWSBean;
import credito.servicio.TotalAplicadosWSServicio;

public class TotalAplicadosWSRepControlador extends AbstractCommandController{
	
	private TotalAplicadosWSServicio totalAplicadosWSServicio = null;
	
	
	public TotalAplicadosWSRepControlador(){
		setCommandClass(TotalAplicadosWSBean.class);
		setCommandName("totalAplicadosWSBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		TotalAplicadosWSBean totalAplicadosWSBean =  (TotalAplicadosWSBean) command;
		int tipoLista =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
					0;
		totalAplicadosWSServicio.generaReporteExcel(tipoLista, totalAplicadosWSBean, response, request);
		return null;
	}

	public TotalAplicadosWSServicio getTotalAplicadosWSServicio() {
		return totalAplicadosWSServicio;
	}

	public void setTotalAplicadosWSServicio(
			TotalAplicadosWSServicio totalAplicadosWSServicio) {
		this.totalAplicadosWSServicio = totalAplicadosWSServicio;
	}
	
}
