package regulatorios.controlador;


import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.OpcionesMenuRegBean;
import regulatorios.bean.RegulatorioA1713Bean;
import regulatorios.servicio.OpcionesMenuRegServicio;
import regulatorios.servicio.RegulatorioA1713Servicio;

public class RegistroA1713ListaControlador extends AbstractCommandController {

	RegulatorioA1713Servicio regulatorioA1713Servicio = null;

	public RegistroA1713ListaControlador(){
		setCommandClass(RegulatorioA1713Bean.class);
		setCommandName("regulatorioA1713Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		RegulatorioA1713Bean regulatorioA1713Bean = (RegulatorioA1713Bean) command;
        List listaMenu = regulatorioA1713Servicio.lista(tipoLista, regulatorioA1713Bean);
        
        List listaResultado = (List)new ArrayList();
        listaResultado.add(tipoLista);
        listaResultado.add(controlID);
        listaResultado.add(listaMenu);
		return new ModelAndView("regulatorios/registroA1713ListaVista", "listaResultado", listaResultado);
	}

	public RegulatorioA1713Servicio getRegulatorioA1713Servicio() {
		return regulatorioA1713Servicio;
	}

	public void setRegulatorioA1713Servicio(
			RegulatorioA1713Servicio regulatorioA1713Servicio) {
		this.regulatorioA1713Servicio = regulatorioA1713Servicio;
	}

	
	
} 

