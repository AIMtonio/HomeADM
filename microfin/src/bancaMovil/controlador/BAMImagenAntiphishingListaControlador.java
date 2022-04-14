package bancaMovil.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import bancaMovil.bean.BAMImagenAntiphishingBean;
import bancaMovil.servicio.BAMImagenAntiphishingServicio;

@SuppressWarnings("deprecation")
public class BAMImagenAntiphishingListaControlador extends AbstractCommandController {

	BAMImagenAntiphishingServicio imagenServicio = null;

	public BAMImagenAntiphishingListaControlador() {
		setCommandClass(BAMImagenAntiphishingBean.class);
		setCommandName("imagen");
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		int identificador = Integer.parseInt(request.getParameter("identificador"));
		BAMImagenAntiphishingBean imagen = (BAMImagenAntiphishingBean) command;
		List imagenes = imagenServicio.lista(tipoLista, imagen);
		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(imagenes);
		listaResultado.add(identificador);
		return new ModelAndView("bancaMovil/BAMImagenesAntiphishingListaVista", "listaResultado", listaResultado);
	}

	public BAMImagenAntiphishingServicio getImagenServicio() {
		return imagenServicio;
	}

	public void setImagenServicio(BAMImagenAntiphishingServicio imagenServicio) {
		this.imagenServicio = imagenServicio;
	}

}
