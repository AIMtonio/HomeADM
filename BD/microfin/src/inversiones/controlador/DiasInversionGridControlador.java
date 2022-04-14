package inversiones.controlador;

import inversiones.bean.DiasInversionBean;
import inversiones.servicio.DiasInversionServicio;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class DiasInversionGridControlador extends AbstractCommandController{
		
	DiasInversionServicio diasInversionServicio = null;

	public DiasInversionGridControlador() {
		setCommandClass(DiasInversionBean.class);
		setCommandName("diasInversion");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		DiasInversionBean diasInversionBean = (DiasInversionBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List diasInversionList =	diasInversionServicio.lista(tipoLista, diasInversionBean);
				
		return new ModelAndView("inversiones/diasInversionGridVista", "diasInversion", diasInversionList);
	}

	public void setDiasInversionServicio(DiasInversionServicio diasInversionServicio) {
		this.diasInversionServicio = diasInversionServicio;
	}


	
	
}
