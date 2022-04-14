package bancaMovil.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import bancaMovil.bean.BAMOperacionBean;
import bancaMovil.servicio.BAMBitacoraOperServicio;

@SuppressWarnings("deprecation")
public class BAMBitacoraOperGridControlador extends AbstractCommandController {
	BAMBitacoraOperServicio bamBitacoraOperServicio = null;

	public BAMBitacoraOperGridControlador() {
		setCommandClass(BAMOperacionBean.class);
		setCommandName("operacionBean");
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command,
			BindException errors) throws Exception {

		BAMOperacionBean operacionBean = (BAMOperacionBean) command;

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String clienteID = request.getParameter("clienteID");
		String tipoOperacion = request.getParameter("tipoOperacion");

		operacionBean.setClienteID(clienteID);
		operacionBean.setTipoOperacion(tipoOperacion);

		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);/// tipo de lista principal

		return new ModelAndView("bancaMovil/BAMBitacoraOperGridVista", "listaResultado", listaResultado);

	}

	public BAMBitacoraOperServicio getBamBitacoraOperServicio() {
		return bamBitacoraOperServicio;
	}

	public void setBamBitacoraOperServicio(BAMBitacoraOperServicio bamBitacoraOperServicio) {
		this.bamBitacoraOperServicio = bamBitacoraOperServicio;
	}
}
