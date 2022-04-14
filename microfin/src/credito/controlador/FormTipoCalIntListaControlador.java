package credito.controlador;


import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.FormTipoCalIntBean;
import credito.servicio.FormTipoCalIntServicio;

public class FormTipoCalIntListaControlador extends AbstractCommandController {

	FormTipoCalIntServicio formTipoCalIntServicio = null;

	public FormTipoCalIntListaControlador(){
		setCommandClass(FormTipoCalIntBean.class);
		setCommandName("formTipoCalInt");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
       
        FormTipoCalIntBean formTipoCalInt = (FormTipoCalIntBean) command;
                List formTiposCalInt = formTipoCalIntServicio.lista(tipoLista, formTipoCalInt);
                
                List listaResultado = (List)new ArrayList();
                listaResultado.add(tipoLista);
                listaResultado.add(controlID);
                listaResultado.add(formTiposCalInt);
		return new ModelAndView("credito/formTipoCalIntListaVista", "listaResultado", listaResultado);
	}

	public void setFormTipoCalIntServicio(
			FormTipoCalIntServicio formTipoCalIntServicio) {
		this.formTipoCalIntServicio = formTipoCalIntServicio;
	}

	
} 

