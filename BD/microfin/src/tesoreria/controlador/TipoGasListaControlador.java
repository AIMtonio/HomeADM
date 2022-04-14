package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;



import tesoreria.bean.TipoGasBean;
import tesoreria.servicio.TipoGasServicio;

public class TipoGasListaControlador extends AbstractCommandController{
	
TipoGasServicio tipoGasServicio = null;

public TipoGasListaControlador() {
	setCommandClass(TipoGasBean.class);
	setCommandName("tipoGasto");
}

protected ModelAndView handle(HttpServletRequest request,
		  HttpServletResponse response,
		  Object command,
		  BindException errors) throws Exception {


int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
String controlID = request.getParameter("controlID");

TipoGasBean tipoGas = (TipoGasBean) command;
List tipoGasList =	tipoGasServicio.lista(tipoLista, tipoGas);

List listaResultado = (List)new ArrayList();
listaResultado.add(tipoLista);
listaResultado.add(controlID);
listaResultado.add(tipoGasList);

return new ModelAndView("tesoreria/tipoGasListaVista", "listaResultado", listaResultado);
}


public void setTipoGasServicio(
TipoGasServicio tipoGasServicio) {
this.tipoGasServicio = tipoGasServicio;
}


}
