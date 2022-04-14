package inversiones.controlador;

import inversiones.bean.MontoInversionBean;
import inversiones.servicio.MontoInversionServicio;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class MontoInversionGridControlador extends AbstractCommandController{
		
	MontoInversionServicio montoInversionServicio = null;

	public MontoInversionGridControlador() {
		setCommandClass(MontoInversionBean.class);
		setCommandName("montoInversion");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		MontoInversionBean montoInversionBean = (MontoInversionBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List montosInversionList = montoInversionServicio.lista(tipoLista, montoInversionBean);
				
		return new ModelAndView("inversiones/montosInversionGridVista", "montosInversion", montosInversionList);
	}

	public void setMontoInversionServicio(
			MontoInversionServicio montoInversionServicio) {
		this.montoInversionServicio = montoInversionServicio;
	}
	
}

