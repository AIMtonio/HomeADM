package ventanilla.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.AsignarChequeSucurBean;
import tesoreria.servicio.AsignarChequeSucurServicio;
import ventanilla.servicio.CajasVentanillaServicio;
import ventanilla.bean.CajasVentanillaBean;

public class AsignarChequeSucurGridControlador extends AbstractCommandController {
	CajasVentanillaServicio cajasVentanillaServicio = null;
	AsignarChequeSucurServicio asignarChequeSucurServicio = null;

	public AsignarChequeSucurGridControlador() {
		setCommandClass(AsignarChequeSucurBean.class);
		//setCommandClass(CajasVentanillaBean.class);
		setCommandName("gridAsignaCheque");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		//CajasVentanillaBean cajasVentanillaBean = (CajasVentanillaBean) command;
		AsignarChequeSucurBean asignarChequeSucurBean = (AsignarChequeSucurBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));

		List asignaChequeCajas = asignarChequeSucurServicio.listaCuentasConChequera(tipoLista, asignarChequeSucurBean);
		return new ModelAndView("tesoreria/asignarChequeSucurGridVista", "asignaChequeCajas", asignaChequeCajas);
	}

	public CajasVentanillaServicio getCajasVentanillaServicio() {
		return cajasVentanillaServicio;
	}

	public void setCajasVentanillaServicio(
			CajasVentanillaServicio cajasVentanillaServicio) {
		this.cajasVentanillaServicio = cajasVentanillaServicio;
	}

	public AsignarChequeSucurServicio getAsignarChequeSucurServicio() {
		return asignarChequeSucurServicio;
	}

	public void setAsignarChequeSucurServicio(
			AsignarChequeSucurServicio asignarChequeSucurServicio) {
		this.asignarChequeSucurServicio = asignarChequeSucurServicio;
	}
}
