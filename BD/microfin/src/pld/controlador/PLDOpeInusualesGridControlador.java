package pld.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.OpeInusualesBean;
import pld.servicio.OpeInusualesServicio;

public class PLDOpeInusualesGridControlador extends AbstractCommandController {
	OpeInusualesServicio opeInusualesServicio = null;

	public PLDOpeInusualesGridControlador() {
			setCommandClass(OpeInusualesBean.class);
			setCommandName("opeInusualesBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {


	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
		OpeInusualesBean operInusuales = (OpeInusualesBean) command;
		List listaResultado =	opeInusualesServicio.lista(tipoLista, operInusuales);


return new ModelAndView("pld/pldOpeInusualesGridVista", "listaResultado", listaResultado);
}

	
//-------------setter---------------
public void setOpeInusualesServicio(OpeInusualesServicio opeInusualesServicio) {
	this.opeInusualesServicio = opeInusualesServicio;
}




}
