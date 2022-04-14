package tesoreria.controlador; 

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.servicio.ReqGastosSucServicio;
import tesoreria.bean.ReqGastosSucBean;

public class ReqGastosSucListaControlador extends AbstractCommandController {

	ReqGastosSucServicio reqGastosSucServicio = null;

 	public ReqGastosSucListaControlador(){
 		setCommandClass(ReqGastosSucBean.class);
 		setCommandName("reqGastosSucBean");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
        
        ReqGastosSucBean reqGastosSucBean = (ReqGastosSucBean) command;
        List cuentasAho = reqGastosSucServicio.lista(tipoLista, reqGastosSucBean);
        
        List listaResultado = (List)new ArrayList();
        listaResultado.add(tipoLista);
        listaResultado.add(controlID);
        listaResultado.add(cuentasAho);
 		return new ModelAndView("tesoreria/reqGastosSucListaVista", "listaResultado", listaResultado);
 	}

	public ReqGastosSucServicio getReqGastosSucServicio() {
		return reqGastosSucServicio;
	}

	public void setReqGastosSucServicio(ReqGastosSucServicio reqGastosSucServicio) {
		this.reqGastosSucServicio = reqGastosSucServicio;
	}
 } 
