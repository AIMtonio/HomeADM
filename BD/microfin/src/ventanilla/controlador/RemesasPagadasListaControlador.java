package ventanilla.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.RemesasPagadasBean;
import ventanilla.servicio.RemesasPagadasServicio;

public class RemesasPagadasListaControlador extends AbstractCommandController {

	RemesasPagadasServicio remesasPagadasServicio = null;

	public RemesasPagadasListaControlador() {
		setCommandClass(RemesasPagadasBean.class);
		setCommandName("remesasPagadasBean");
	}
	

	@Override
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors)
			throws Exception {

		RemesasPagadasBean remesasPagadasBean = (RemesasPagadasBean) command;
		
		List listResultado = new ArrayList();
		listResultado.add("1");
		listResultado.add("referencia");
		List listaConsultas = remesasPagadasServicio.lista(remesasPagadasBean.getReferencia());
		listResultado.add(listaConsultas);

		return new ModelAndView("ventanilla/remesasPagadasListaVista", "listResultado", listResultado);
	}

	public void setRemesasPagadasServicio(RemesasPagadasServicio remesasPagadasServicio) {
		this.remesasPagadasServicio = remesasPagadasServicio;
	}
}
