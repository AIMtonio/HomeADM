package originacion.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.DestinosCredProdBean;
import originacion.servicio.DestinosCredProdServicio;

public class DestinosCredProdGridControlador extends AbstractCommandController{
	DestinosCredProdServicio destinosCredProdServicio = null;
	
	public DestinosCredProdGridControlador() {
		setCommandClass(DestinosCredProdBean.class);
		setCommandName("destinosCredProd");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {
		DestinosCredProdBean destinosCredProdBean = (DestinosCredProdBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
		List destinosCredProdList = destinosCredProdServicio.lista(tipoLista, destinosCredProdBean);
		
		return new ModelAndView("originacion/destinosCredProdGridVista", "listaResultado", destinosCredProdList);
	}

	public DestinosCredProdServicio getDestinosCredProdServicio() {
		return destinosCredProdServicio;
	}

	public void setDestinosCredProdServicio(
			DestinosCredProdServicio destinosCredProdServicio) {
		this.destinosCredProdServicio = destinosCredProdServicio;
	}
}

