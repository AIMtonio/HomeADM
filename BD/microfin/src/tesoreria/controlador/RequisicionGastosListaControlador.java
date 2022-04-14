package tesoreria.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.RequisicionGastosBean;
import tesoreria.bean.RequisicionTipoGastoListaBean;
import tesoreria.servicio.RequisicionGastosServicio;

public class RequisicionGastosListaControlador extends AbstractCommandController {
	RequisicionGastosServicio requisicionGastosServicio = null; 

	public RequisicionGastosListaControlador(){
		setCommandClass(RequisicionGastosBean.class);
		setCommandName("requisicionGastosBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		String tp=request.getParameter("tipoLista");

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
       
        RequisicionGastosBean requisicionGastosBean = (RequisicionGastosBean) command;
                List requisicionGastosB = requisicionGastosServicio.lista(tipoLista, requisicionGastosBean);
                
                List listaResultado = (List)new ArrayList();
                listaResultado.add(tipoLista);
                listaResultado.add(controlID);
                listaResultado.add(requisicionGastosB);
		return new ModelAndView("tesoreria/requisicionGastosListaVista", "listaResultado", listaResultado);
	}

	public void setRequisicionGastosServicio(RequisicionGastosServicio requisicionGastosServicio) {
		this.requisicionGastosServicio = requisicionGastosServicio;
	}
} 