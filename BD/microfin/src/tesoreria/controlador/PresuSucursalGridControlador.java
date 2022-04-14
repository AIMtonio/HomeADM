package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.PresupuestoSucursalBean;
import tesoreria.servicio.PresupSucurGridServicio;
import tesoreria.servicio.PresupSucursalServicio;

public class PresuSucursalGridControlador extends AbstractCommandController {

	
	public PresuSucursalGridControlador(){
		setCommandClass(PresupuestoSucursalBean.class);
		setCommandName("presSucursalBean");
		
	}
	
	PresupSucurGridServicio preSucGridServicio = null;
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		// TODO Auto-generated method stub
		//cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		  preSucGridServicio.getPresupSucursalDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		PresupuestoSucursalBean presupSucurBean = new PresupuestoSucursalBean();
		
		String  folio = (request.getParameter("folio")!=null) ? request.getParameter("folio") : "";
		int tipoConsulta = (request.getParameter("tipoConsulta")!=null) ? Integer.parseInt(request.getParameter("tipoConsulta")) : 0;
        int rolUsuario = (request.getParameter("rolUsuario")!=null) ? Integer.parseInt(request.getParameter("rolUsuario")) : 0;
        int rolTesoreria = (request.getParameter("rolTesoreria")!=null) ? Integer.parseInt(request.getParameter("rolTesoreria")) : 0;
        int rolTesoreriaAdmin = (request.getParameter("rolTesoreriaAdmin")!=null) ? Integer.parseInt(request.getParameter("rolTesoreriaAdmin")) : 0;

		presupSucurBean.setFolio(folio);
		
		List listaResul = preSucGridServicio.listaGrid(tipoConsulta, presupSucurBean);
		
		List listaResultado = (List)new ArrayList();
		
		listaResultado.add(rolUsuario);
		listaResultado.add(rolTesoreria);
		listaResultado.add(rolTesoreriaAdmin);
		listaResultado.add(listaResul);
		String paginaRegreso = null;
				
		//Falta redireccionar a jsp de autoriza
		return new ModelAndView("tesoreria/presupSucGridVista", "listaResultado", listaResultado);		
	}
	
	
	
	//Getters y Setters
	public PresupSucurGridServicio getPreSucGridServicio() {
		return preSucGridServicio;
	}
	public void setPreSucGridServicio(PresupSucurGridServicio preSucGridServicio) {
		this.preSucGridServicio = preSucGridServicio;
	}
	
}
