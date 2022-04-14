package inversiones.controlador;


import inversiones.bean.BeneficiariosInverBean;
import inversiones.servicio.BeneficiariosInverServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class BeneficiariosInverListaControlador extends AbstractCommandController {

	BeneficiariosInverServicio beneficiariosInverServicio = null;
	
	public BeneficiariosInverListaControlador() {
		setCommandClass(BeneficiariosInverBean.class);
		setCommandName("beneficiariosInverBean");
		}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		BeneficiariosInverBean beneficiariosInver = (BeneficiariosInverBean) command;
		List beneficiarios =	beneficiariosInverServicio.lista(tipoLista, beneficiariosInver);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(beneficiarios);
		
		return new ModelAndView("inversiones/beneficiariosInverLista", "listaResultado",listaResultado);
	}

	public BeneficiariosInverServicio getBeneficiariosInverServicio() {
		return beneficiariosInverServicio;
	}

	public void setBeneficiariosInverServicio(
			BeneficiariosInverServicio beneficiariosInverServicio) {
		this.beneficiariosInverServicio = beneficiariosInverServicio;
	}

	
	
	
}


