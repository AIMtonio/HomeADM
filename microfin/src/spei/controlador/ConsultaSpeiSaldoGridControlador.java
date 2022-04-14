	package spei.controlador;

	import java.util.ArrayList;
	import java.util.List;

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;

	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.AbstractCommandController;

	import spei.bean.ConsultaSpeiBean;
	import spei.servicio.ConsultaSpeiServicio;



	public class ConsultaSpeiSaldoGridControlador extends AbstractCommandController{

		ConsultaSpeiServicio consultaSpeiServicio = null;

		public ConsultaSpeiSaldoGridControlador() {
			setCommandClass(ConsultaSpeiBean.class);
			setCommandName("consultaSpeiBean");
		}
		
		protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
			
			ConsultaSpeiBean consultaSpeiBean = (ConsultaSpeiBean) command;
			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			List consultaSpeiList = consultaSpeiServicio.lista(tipoLista, consultaSpeiBean);
		
			List listaResultado = new ArrayList();
			listaResultado.add(tipoLista);
			listaResultado.add(consultaSpeiList);
			
			return new ModelAndView("spei/consultaSpeiSaldoGridVista", "listaResultado", listaResultado);
		
		}

		public ConsultaSpeiServicio getConsultaSpeiServicio() {
			return consultaSpeiServicio;
		}

		public void setConsultaSpeiServicio(ConsultaSpeiServicio consultaSpeiServicio) {
			this.consultaSpeiServicio = consultaSpeiServicio;
		}



		

	}

