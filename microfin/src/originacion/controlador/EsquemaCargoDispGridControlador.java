package originacion.controlador;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.EsquemaCargoDispBean;
import originacion.servicio.EsquemaCargoDispServicio;

public class EsquemaCargoDispGridControlador extends SimpleFormController {

	EsquemaCargoDispServicio esquemaCargoDispServicio;
	
	public EsquemaCargoDispGridControlador() {
		setCommandClass(EsquemaCargoDispBean.class);
		setCommandName("esquemaCargoDispBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		EsquemaCargoDispBean esquemaBean = (EsquemaCargoDispBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		List<EsquemaCargoDispBean> lista = esquemaCargoDispServicio.lista(tipoLista, esquemaBean);
		return new ModelAndView(getSuccessView(), "listaResultado", lista);
	}

	public EsquemaCargoDispServicio getEsquemaCargoDispServicio() {
		return esquemaCargoDispServicio;
	}

	public void setEsquemaCargoDispServicio(
			EsquemaCargoDispServicio esquemaCargoDispServicio) {
		this.esquemaCargoDispServicio = esquemaCargoDispServicio;
	}

}