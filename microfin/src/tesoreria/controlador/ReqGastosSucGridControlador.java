package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.ReqGastosSucBean;
import tesoreria.servicio.ReqGastosSucServicio;;


public class ReqGastosSucGridControlador extends AbstractCommandController {

	
	public ReqGastosSucGridControlador(){
		setCommandClass(ReqGastosSucBean.class);
		setCommandName("reqGasotosGridBean");
		
	}
	
	ReqGastosSucServicio reqGastosSucServicio = null;
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		// TODO Auto-generated method stub
		//cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		  
		ReqGastosSucBean reqGastosSucBean = new ReqGastosSucBean();
		
		String  numReqGasID = (request.getParameter("numReqGasID")!=null) ? request.getParameter("numReqGasID") : "";
		int tipoConsulta = (request.getParameter("tipoConsulta")!=null) ? Integer.parseInt(request.getParameter("tipoConsulta")) : 0;
        int rolUsuario = (request.getParameter("rolUsuario")!=null) ? Integer.parseInt(request.getParameter("rolUsuario")) : 0; 
        int rolTesoreria = (request.getParameter("rolTesoreria")!=null) ? Integer.parseInt(request.getParameter("rolTesoreria")) : 0; //--
        int rolTesoreriaAdmin = (request.getParameter("rolTesoreriaAdmin")!=null) ? Integer.parseInt(request.getParameter("rolTesoreriaAdmin")) : 0;//--

		
		reqGastosSucBean.setNumReqGasID(numReqGasID);
		List listaResul = reqGastosSucServicio.reqSucurGridlist(tipoConsulta, reqGastosSucBean);
		List listaResultado = (List)new ArrayList();
		
		listaResultado.add(rolUsuario);
		listaResultado.add(rolTesoreria);//--
		listaResultado.add(rolTesoreriaAdmin);//--
		listaResultado.add(listaResul);
		String paginaRegreso = null;
		
		
		
			/*paginaRegreso = "tesoreria/reqGastosGridVista";
				
		//Falta redireccionar a jsp de autoriza
		return new ModelAndView(paginaRegreso, "listaResultado", listaResultado);		
	}*/
	
	
	//Falta redireccionar a jsp de autoriza
	return new ModelAndView("tesoreria/reqGastosGridVista", "listaResultado", listaResultado);		//--
}
	
	
	//Getters y Setters
	public ReqGastosSucServicio getReqGastosSucServicio() {
		return reqGastosSucServicio;
	}
	public void setReqGastosSucServicio(ReqGastosSucServicio reqGastosSucServicio) {
		this.reqGastosSucServicio = reqGastosSucServicio;
	}
	
}
