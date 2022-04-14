package bancaMovil.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import bancaMovil.servicio.BANTiposCuentaServicio;

@SuppressWarnings("deprecation")
public class BANTiposCuentaGridControlador extends AbstractCommandController {
	BANTiposCuentaServicio banTiposCuentaServicio = null;

	public BANTiposCuentaGridControlador() {
		setCommandClass(BANTiposCuentaGridControlador.class);
		setCommandName("tiposCuenta");
	}

	@SuppressWarnings("rawtypes")
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List tiposCuentaList = banTiposCuentaServicio.lista(tipoLista);
		return new ModelAndView("bancaMovil/BANTiposCuentaGridVista", "tiposCuentaList", tiposCuentaList);
	}

	public void setBANTiposCuentaServicio(BANTiposCuentaServicio banTiposCuentaServicio) {
		this.banTiposCuentaServicio = banTiposCuentaServicio;
	}

}
