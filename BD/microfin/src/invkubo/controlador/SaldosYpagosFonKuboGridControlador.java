package invkubo.controlador;

import invkubo.bean.FondeoKuboBean;
import invkubo.bean.FondeoSolicitudBean;
import invkubo.servicio.FondeoKuboServicio;
import invkubo.servicio.FondeoSolicitudServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class SaldosYpagosFonKuboGridControlador extends AbstractCommandController {

	FondeoKuboServicio fondeoKuboServicio = null;
	
	public SaldosYpagosFonKuboGridControlador() {
		// TODO Auto-generated constructor stub
		
		setCommandClass(FondeoKuboBean.class);
		setCommandName("fondeoKubo");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {			
		FondeoKuboBean fondeoKubo = (FondeoKuboBean) command;
		fondeoKuboServicio.getFondeoKuboDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
		List saldosYpagosInv = fondeoKuboServicio.listaGrid(tipoLista, fondeoKubo);
		List listaResultado = (List)new ArrayList(); 
		listaResultado.add(saldosYpagosInv);

		return new ModelAndView("invKubo/SaldosYpagosInvKuboGridVista", "listaResultado", listaResultado);
	}

	public void setFondeoKuboServicio(FondeoKuboServicio fondeoKuboServicio) {
		this.fondeoKuboServicio = fondeoKuboServicio;
	}

	
}
