package cedes.controlador;
import inversiones.bean.MontoInversionBean;
import inversiones.servicio.MontoInversionServicio;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cedes.bean.MontosCedesBean;
import cedes.servicio.MontosCedesServicio;

public class MontoCedesGridControlador extends AbstractCommandController{		
	MontosCedesServicio montosCedesServicio = null;

	public MontoCedesGridControlador() {
		setCommandClass(MontosCedesBean.class);
		setCommandName("montoCede");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		MontosCedesBean montoBean = (MontosCedesBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List montosLista = montosCedesServicio.lista(tipoLista, montoBean);
				
		return new ModelAndView("cedes/montosCedesGridVista", "montosCedes", montosLista);
	}

	public void setMontosCedesServicio(MontosCedesServicio montosCedesServicio) {
		this.montosCedesServicio = montosCedesServicio;
	}


	 
}


