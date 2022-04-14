package spei.controlador;

	 import java.util.ArrayList;
	 import java.util.List;
	 import javax.servlet.http.HttpServletRequest;
	 import javax.servlet.http.HttpServletResponse;

	 import general.bean.MensajeTransaccionBean;

	 import org.springframework.validation.BindException;
	 import org.springframework.web.servlet.ModelAndView;
	 import org.springframework.web.servlet.mvc.AbstractCommandController;

	 import spei.bean.PagoRemesaSPEIBean;
	 import spei.servicio.PagoRemesaSPEIServicio;

	 public class PagoRemesasListaControlador extends AbstractCommandController {

		 PagoRemesaSPEIServicio pagoRemesaSPEIServicio = null;

	 	public PagoRemesasListaControlador(){
	 		setCommandClass(PagoRemesaSPEIBean.class);
	 		setCommandName("pagoRemesaSPEIBean");
	 	}

		protected ModelAndView handle(HttpServletRequest request,
				  HttpServletResponse response,
				  Object command,
				  BindException errors) throws Exception {

	 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	        String controlID = request.getParameter("controlID");
	        
	        PagoRemesaSPEIBean pagoRemesaSPEIBean = (PagoRemesaSPEIBean) command;
	                 List pagoremesas = pagoRemesaSPEIServicio.lista(tipoLista, pagoRemesaSPEIBean);
	                 
	                 List listaResultado = (List)new ArrayList();
	                 listaResultado.add(tipoLista);
	                 listaResultado.add(controlID);
	                 listaResultado.add(pagoremesas);
	 		return new ModelAndView("spei/pagoRemesaSPEIListaVista", "listaResultado", listaResultado);
	 	}

		public PagoRemesaSPEIServicio getPagoRemesaSPEIServicio() {
			return pagoRemesaSPEIServicio;
		}

		public void setPagoRemesaSPEIServicio(
				PagoRemesaSPEIServicio pagoRemesaSPEIServicio) {
			this.pagoRemesaSPEIServicio = pagoRemesaSPEIServicio;
		}

	 	
	 } 
