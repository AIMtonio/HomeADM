	package spei.controlador;

	import java.util.ArrayList;
	import java.util.List;

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;

	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.AbstractCommandController;

	import spei.bean.AutorizaSpeiBean;
	import spei.servicio.AutorizaSpeiServicio;



	public class AutorizaSpeiGridControlador extends AbstractCommandController{
		
		AutorizaSpeiServicio autorizaSpeiServicio = null;

		public AutorizaSpeiGridControlador() {
			setCommandClass(AutorizaSpeiBean.class);
			setCommandName("autorizaSpeiBean");
		}
		
		protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
			AutorizaSpeiBean pagoRemesaTraspasoBean = (AutorizaSpeiBean) command;
			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			List autorizaSpeiList = autorizaSpeiServicio.lista(tipoLista, pagoRemesaTraspasoBean);
		
			List listaResultado = new ArrayList();
			listaResultado.add(tipoLista);
			listaResultado.add(autorizaSpeiList);
			
			return new ModelAndView("spei/autorizaSpeiGridVista", "listaResultado", listaResultado);
		
		}

		public AutorizaSpeiServicio getAutorizaSpeiServicio() {
			return autorizaSpeiServicio;
		}

		public void setAutorizaSpeiServicio(AutorizaSpeiServicio autorizaSpeiServicio) {
			this.autorizaSpeiServicio = autorizaSpeiServicio;
		}

		

	}

