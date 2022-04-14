package bancaMovil.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import bancaMovil.bean.BAMCuentasOrigenBean;
import bancaMovil.servicio.BAMCuentasOrigenServicio;

@SuppressWarnings("deprecation")
public class BAMCuentasOrigenGridControlador extends AbstractCommandController{
	BAMCuentasOrigenServicio cuentasOrigenServicio = null;

	public BAMCuentasOrigenGridControlador() {
		setCommandClass(BAMCuentasOrigenBean.class);
		setCommandName("cuentasOrigen");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		BAMCuentasOrigenBean cuentasOrigenBean = (BAMCuentasOrigenBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List<?> cuentasOrigenList = cuentasOrigenServicio.lista(tipoLista, cuentasOrigenBean);
		
		return new ModelAndView("bancaMovil/BAMCuentasOrigenGridVista", "cuentasOrigenList", cuentasOrigenList);
	}

	public void setBAMCuentasOrigenServicio(
			BAMCuentasOrigenServicio cuentasOrigenServicio) {
		this.cuentasOrigenServicio = cuentasOrigenServicio;
	}
}
