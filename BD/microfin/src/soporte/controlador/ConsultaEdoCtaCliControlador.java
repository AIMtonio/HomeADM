package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.EdoCtaEnvioCorreoBean;
import soporte.servicio.EdoCtaEnvioCorreoServicio;

public class ConsultaEdoCtaCliControlador extends SimpleFormController {

	EdoCtaEnvioCorreoServicio edoCtaEnvioCorreoServicio  = null;

	public ConsultaEdoCtaCliControlador() {
		// TODO Auto-generated constructor stub
		setCommandClass(EdoCtaEnvioCorreoBean.class);
		setCommandName("edoCtaEnvioCorreoBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		EdoCtaEnvioCorreoBean estadoCuenta = (EdoCtaEnvioCorreoBean) command;

		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : 0;

		String seleccionTodos = (request.getParameter("seleccionTodos") != null) ? request.getParameter("seleccionTodos") : "";

		if (seleccionTodos.equals(Constantes.STRING_SI)) {
			int tipoLista = (request.getParameter("tipoLista")!=null) ? Utileria.convierteEntero(request.getParameter("tipoLista")) : 0;

			List<EdoCtaEnvioCorreoBean> edoCtaEnvioCorreoBeanList = edoCtaEnvioCorreoServicio.lista(tipoLista, estadoCuenta);

			List<String> listaPeriodos = new ArrayList<String>();
			List<String> listaSucursales = new ArrayList<String>();
			List<String> listaClientes = new ArrayList<String>();
			List<String> listaPDF = new ArrayList<String>();
			List<String> listaXML = new ArrayList<String>();
			List<String> listaCorreos = new ArrayList<String>();

			for (EdoCtaEnvioCorreoBean envioCorreoBean : edoCtaEnvioCorreoBeanList) {
				listaPeriodos.add(envioCorreoBean.getAnioMes());
				listaSucursales.add(envioCorreoBean.getSucursalID());
				listaClientes.add(envioCorreoBean.getClienteID());
				listaPDF.add(envioCorreoBean.getRutaPDF());
				listaXML.add(envioCorreoBean.getRutaXML());
				listaCorreos.add(envioCorreoBean.getCorreo());
			}

			estadoCuenta.setListaPeriodos(listaPeriodos);
			estadoCuenta.setListaSucursales(listaSucursales);
			estadoCuenta.setListaClientes(listaClientes);
			estadoCuenta.setListaPDF(listaPDF);
			estadoCuenta.setListaXML(listaXML);
			estadoCuenta.setListaCorreos(listaCorreos);
		}

		MensajeTransaccionBean mensaje = null;
		mensaje = edoCtaEnvioCorreoServicio.grabaTransaccion(tipoTransaccion, estadoCuenta);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setEdoCtaEnvioCorreoServicio(EdoCtaEnvioCorreoServicio edoCtaEnvioCorreoServicio) {
		this.edoCtaEnvioCorreoServicio = edoCtaEnvioCorreoServicio;
	}

}
