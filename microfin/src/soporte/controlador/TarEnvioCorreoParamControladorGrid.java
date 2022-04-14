package soporte.controlador;


import java.util.ArrayList;
import java.util.List;

import org.springframework.validation.BindException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.TarEnvioCorreoParamBean;
import soporte.servicio.TarEnvioCorreoParamServicio;

public class TarEnvioCorreoParamControladorGrid extends AbstractCommandController {
	
	private TarEnvioCorreoParamServicio	tarEnvioCorreoParamServicio = null;
	

	public TarEnvioCorreoParamControladorGrid() {
	setCommandClass(TarEnvioCorreoParamBean.class);
	setCommandName("TarEnvioCorreoParamGrid");
}


protected ModelAndView handle(HttpServletRequest request,
HttpServletResponse response,
Object command,
BindException errors) throws Exception {

int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));

String controlID = request.getParameter("controlID");

TarEnvioCorreoParamBean tarEnvioCorreoParam = (TarEnvioCorreoParamBean) command;
List envioCorreoParam = tarEnvioCorreoParamServicio.lista(tipoLista, tarEnvioCorreoParam);

	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(envioCorreoParam);


	logger.info(listaResultado);
return new ModelAndView("soporte/remitentesCorreoGridVista", "listaResultado",listaResultado);
}

public TarEnvioCorreoParamServicio getTarEnvioCorreoParamServicio() {
	return tarEnvioCorreoParamServicio;
}


public void setTarEnvioCorreoParamServicio(
		TarEnvioCorreoParamServicio tarEnvioCorreoParamServicio) {
	this.tarEnvioCorreoParamServicio = tarEnvioCorreoParamServicio;
}



}
