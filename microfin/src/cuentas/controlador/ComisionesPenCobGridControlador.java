package cuentas.controlador; 

 import java.util.ArrayList;
 import java.util.List;
 import javax.servlet.http.HttpServletRequest;
 import javax.servlet.http.HttpServletResponse;

 import general.bean.MensajeTransaccionBean;

 import org.springframework.validation.BindException;
 import org.springframework.web.servlet.ModelAndView;
 import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.ComisionesSaldoPromedioBean;
import cuentas.servicio.ComisionesSaldoPromedioServicio;


 public class ComisionesPenCobGridControlador extends AbstractCommandController {

	 ComisionesSaldoPromedioServicio comisionesSaldoPromedioServicio = null;

 	public ComisionesPenCobGridControlador(){
 		setCommandClass(ComisionesSaldoPromedioBean.class);
 		setCommandName("comisionesSaldoPromedioBean");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
        
        ComisionesSaldoPromedioBean comisionesSaldoPromedioBean = (ComisionesSaldoPromedioBean) command;
	        List cuentasAho = comisionesSaldoPromedioServicio.lista(tipoLista, comisionesSaldoPromedioBean);
	         
	        List listaResultado = (List)new ArrayList();                
	 		listaResultado.add(tipoLista); // 0
	 		listaResultado.add(cuentasAho); // 1
 		return new ModelAndView("cuentas/comisionesSaldoPromGridVista", "listaResultado", listaResultado);
 	}

	public ComisionesSaldoPromedioServicio getComisionesSaldoPromedioServicio() {
		return comisionesSaldoPromedioServicio;
	}

	public void setComisionesSaldoPromedioServicio(ComisionesSaldoPromedioServicio comisionesSaldoPromedioServicio) {
		this.comisionesSaldoPromedioServicio = comisionesSaldoPromedioServicio;
	}

	
 	
 } 
