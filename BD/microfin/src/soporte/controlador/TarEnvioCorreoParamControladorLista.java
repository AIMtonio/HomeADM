package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.TarEnvioCorreoParamBean;
import soporte.servicio.TarEnvioCorreoParamServicio;

public class TarEnvioCorreoParamControladorLista extends AbstractCommandController {

	private TarEnvioCorreoParamServicio	tarEnvioCorreoParamServicio = null;
	

	public TarEnvioCorreoParamControladorLista() {
	setCommandClass(TarEnvioCorreoParamBean.class);
	setCommandName("TarEnvioCorreoParamLista");
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


return new ModelAndView("soporte/remitentesCorreoListaVista", "listaResultado",listaResultado);
}

public TarEnvioCorreoParamServicio getTarEnvioCorreoParamServicio() {
	return tarEnvioCorreoParamServicio;
}


public void setTarEnvioCorreoParamServicio(
		TarEnvioCorreoParamServicio tarEnvioCorreoParamServicio) {
	this.tarEnvioCorreoParamServicio = tarEnvioCorreoParamServicio;
}
}
