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

public class RequisicionTipoGastoListaControlador extends AbstractCommandController {
	RequisicionGastosServicio requisicionGastosServicio = null; 

	public RequisicionTipoGastoListaControlador(){
		setCommandClass(RequisicionTipoGastoListaBean.class);
		setCommandName("requisicionTipoGastoLitaBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		String tp=request.getParameter("tipoLista");
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
       
        RequisicionTipoGastoListaBean requisicionTipoGastoListaBean = (RequisicionTipoGastoListaBean) command;
                List requisicionTipoGastosB = requisicionGastosServicio.listaTipoGasto(tipoLista, requisicionTipoGastoListaBean);
                
                List listaResultado = (List)new ArrayList();
                listaResultado.add(tipoLista);
                listaResultado.add(controlID);
                listaResultado.add(requisicionTipoGastosB);
		return new ModelAndView("tesoreria/requisicionTipoGastoListaVista", "listaResultado", listaResultado);
	}
	public void setRequisicionGastosServicio(RequisicionGastosServicio requisicionGastosServicio) {
		this.requisicionGastosServicio = requisicionGastosServicio;
	}
}
