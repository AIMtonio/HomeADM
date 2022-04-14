package credito.controlador;


import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.PerfilesAnalistasCreBean;
import credito.servicio.PerfilesAnalistasCreServicio;


public class PerfilesAnalistasCreGridControlador extends SimpleFormController {

	PerfilesAnalistasCreServicio perfilesAnalistasCreServicio;

	public PerfilesAnalistasCreGridControlador(){
		setCommandClass(PerfilesAnalistasCreBean.class);
		setCommandName("perfilesAnalistasCreBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		PerfilesAnalistasCreBean perfilesAnalistasCreBean = (PerfilesAnalistasCreBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		List<PerfilesAnalistasCreBean> lista = perfilesAnalistasCreServicio.lista(tipoLista, perfilesAnalistasCreBean);
		return new ModelAndView(getSuccessView(), "listaResultado", lista);
	}
	
	public void setPerfilesAnalistasCreServicio(PerfilesAnalistasCreServicio perfilesAnalistasCreServicio){
                    this.perfilesAnalistasCreServicio = perfilesAnalistasCreServicio;
	}

	public PerfilesAnalistasCreServicio getPerfilesAnalistasCreServicio() {
		return perfilesAnalistasCreServicio;
	}


} 
