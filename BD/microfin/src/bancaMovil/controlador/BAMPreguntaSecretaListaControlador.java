package bancaMovil.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import bancaMovil.bean.BAMPregutaSecretaBean;
import bancaMovil.servicio.BAMPreguntaSecretaServicio;

@SuppressWarnings("deprecation")
public class BAMPreguntaSecretaListaControlador extends AbstractCommandController {

	BAMPreguntaSecretaServicio preguntaSecretaServicio = null;

	public BAMPreguntaSecretaListaControlador() {
		setCommandClass(BAMPregutaSecretaBean.class);
		setCommandName("pregunta");
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		BAMPregutaSecretaBean pregunta = (BAMPregutaSecretaBean) command;
		List preguntas = preguntaSecretaServicio.lista(tipoLista, pregunta);
		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(preguntas);

		return new ModelAndView("bancaMovil/BAMPreguntasSecretasListaVista", "listaResultado", listaResultado);
	}

	public void setPreguntaSecretaServicio(BAMPreguntaSecretaServicio preguntaSecretaServicio) {
		this.preguntaSecretaServicio = preguntaSecretaServicio;
	}
}
