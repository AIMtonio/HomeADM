package cobranza.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cobranza.bean.BitacoraSegCobBean;
import cobranza.servicio.BitacoraSegCobServicio;

public class PromesaSegCobGridControlador extends AbstractCommandController{
	BitacoraSegCobServicio bitacoraSegCobServicio = null;
	
	public PromesaSegCobGridControlador(){
		setCommandClass(BitacoraSegCobBean.class);
		setCommandName("bitacoraSegCobBean");	
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		BitacoraSegCobBean bitacoraBean = (BitacoraSegCobBean)command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));

		List listaResultado = new ArrayList();
		List parametrosList = bitacoraSegCobServicio.listaPromesaSegCob(tipoLista, bitacoraBean);

		listaResultado.add(tipoLista);
		listaResultado.add(parametrosList);
		
		return new ModelAndView("cobranza/promesaSegCobGridVista", "listaResultado", listaResultado);
	}



	public BitacoraSegCobServicio getBitacoraSegCobServicio() {
		return bitacoraSegCobServicio;
	}



	public void setBitacoraSegCobServicio(
			BitacoraSegCobServicio bitacoraSegCobServicio) {
		this.bitacoraSegCobServicio = bitacoraSegCobServicio;
	}
}
