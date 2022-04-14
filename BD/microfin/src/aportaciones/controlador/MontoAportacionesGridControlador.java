package aportaciones.controlador;

import inversiones.bean.MontoInversionBean;
import inversiones.servicio.MontoInversionServicio;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import aportaciones.bean.MontosAportacionesBean;
import aportaciones.servicio.MontosAportacionesServicio;

public class MontoAportacionesGridControlador extends AbstractCommandController{
	
	MontosAportacionesServicio montosAportacionesServicio = null;

	public MontoAportacionesGridControlador() {
		setCommandClass(MontosAportacionesBean.class);
		setCommandName("montoAportacion");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		MontosAportacionesBean montoBean = (MontosAportacionesBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List montosLista = montosAportacionesServicio.lista(tipoLista, montoBean);
		
		return new ModelAndView("aportaciones/montosAportacionesGridVista", "montosAportaciones", montosLista);
	}

	public MontosAportacionesServicio getMontosAportacionesServicio() {
		return montosAportacionesServicio;
	}

	public void setMontosAportacionesServicio(
			MontosAportacionesServicio montosAportacionesServicio) {
		this.montosAportacionesServicio = montosAportacionesServicio;
	}

}
