package cliente.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.InfoAdiContaBean;

public class InfoAdiContaSubControlador extends AbstractCommandController{
	public InfoAdiContaSubControlador() {
		setCommandClass(InfoAdiContaBean.class);
		setCommandName("infoAdiConta");
	}
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		InfoAdiContaBean infoAdiContaBean = (InfoAdiContaBean) command;
		int tipoLista = Utileria.convierteEntero(infoAdiContaBean.getTipoSub());
		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		
		return new ModelAndView("cliente/infoAdiContaSubVista", "listaResultado", listaResultado);
	}

}
