package nomina.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import herramientas.Constantes;
import herramientas.Utileria;
import nomina.bean.PagoNominaBean;
import nomina.bean.TotalesBeanAplicaPago;

public class AplicaPagoTotalesControlador extends AbstractCommandController {

	public AplicaPagoTotalesControlador(){
		setCommandClass(PagoNominaBean.class);
		setCommandName("pagosNomina");
	}

	public static interface Enum_Page {
		String Inicializar	= "Inicializar";
	}

	public static String TODOS		= "T";
	public static String INDIVIDUAL	= "I";

	@Override
	protected ModelAndView handle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object object, BindException bindException) throws Exception {


		List listaPagoNominaBean;
		PagedListHolder<PagoNominaBean> listaPaginada = null;

		TotalesBeanAplicaPago totalesBeanAplicaPago = new TotalesBeanAplicaPago();

		//String seleccionarTodos	= Cons
		String esSeleccionado 	= httpServletRequest.getParameter("esSeleccionado");
		String tipoLista 		= httpServletRequest.getParameter("tipoLista");
		String tipoSeleccion 	= httpServletRequest.getParameter("tipoSeleccion");
		String consecutivoID 	= httpServletRequest.getParameter("consecutivoID");

		double totalesAplicado = 0.0;
		String seleccionarTodos = Constantes.STRING_NO;

		if(tipoLista.equalsIgnoreCase(Enum_Page.Inicializar)){
			httpServletRequest.getSession().removeAttribute(AplicacionPagosGridControlador.ListaAplicacionPagoInstitucion);
			seleccionarTodos = Constantes.STRING_NO;;
		} else {
			if (httpServletRequest.getSession().getAttribute(AplicacionPagosGridControlador.ListaAplicacionPagoInstitucion) != null) {

				listaPagoNominaBean = (List) httpServletRequest.getSession().getAttribute(AplicacionPagosGridControlador.ListaAplicacionPagoInstitucion);

				listaPaginada = (PagedListHolder) listaPagoNominaBean.get(1);
				List<PagoNominaBean> listaElementos = listaPaginada.getSource();

				seleccionarTodos = Constantes.STRING_NO;
				if(tipoSeleccion.equalsIgnoreCase(TODOS) && esSeleccionado.equalsIgnoreCase(Constantes.STRING_SI)){
					seleccionarTodos = Constantes.STRING_SI;
				}

				actualizarSeleccion(consecutivoID, esSeleccionado,listaElementos, tipoSeleccion);

				if(tipoSeleccion.equalsIgnoreCase(INDIVIDUAL)){

					if(seleccionarTodos.equalsIgnoreCase(Constantes.STRING_SI)){
						seleccionarTodos = Constantes.STRING_SI;
					} else {
						seleccionarTodos = esSeleccionarTodos(listaElementos);
					}
				}
				totalesAplicado = totalPago(listaElementos);
			}
		}

		totalesBeanAplicaPago.setTotalAplicaPago(String.valueOf(totalesAplicado));
		totalesBeanAplicaPago.setCheckPagosTodos(seleccionarTodos);
		Utileria.respuestaJsonTransaccion(totalesBeanAplicaPago, httpServletResponse);
		return null;
	}

	public void actualizarSeleccion(String consecutivoID, String esSeleccionado, List<PagoNominaBean> listaPagoNominaBean, String tipoSeleccion){
		for (int iteracion = 0; iteracion < listaPagoNominaBean.size(); iteracion++) {
			PagoNominaBean pagoNominaBean = (PagoNominaBean) listaPagoNominaBean.get(iteracion);
			if (pagoNominaBean.getConsecutivoID().equalsIgnoreCase(consecutivoID) || tipoSeleccion.equalsIgnoreCase(TODOS)){
				pagoNominaBean.setEsSeleccionado(esSeleccionado);
			}
		}

	}

	public double totalPago( List<PagoNominaBean> listaPagoNominaBean){
		double sumaTotal = Constantes.DOUBLE_VACIO;
		for (int iteracion = Constantes.ENTERO_CERO; iteracion < listaPagoNominaBean.size(); iteracion++) {
			PagoNominaBean pagoNominaBean = (PagoNominaBean) listaPagoNominaBean.get(iteracion);
			if(pagoNominaBean.getEsSeleccionado().equalsIgnoreCase(Constantes.STRING_SI)){
				sumaTotal += Utileria.convierteDoble(pagoNominaBean.getMontoPagos());
			}
		}

		return sumaTotal;
	}

	public String esSeleccionarTodos(List<PagoNominaBean> listaPagoNominaBean){
		//Total de Registros Seleccionados de manera Individual
		int seleccionIndividual = Constantes.ENTERO_CERO;
		String seleccionarTodos = Constantes.STRING_NO;

		for (int iteracion = Constantes.ENTERO_CERO; iteracion < listaPagoNominaBean.size(); iteracion++) {
			PagoNominaBean pagoNominaBean = (PagoNominaBean) listaPagoNominaBean.get(iteracion);
			if(pagoNominaBean.getEsSeleccionado().equalsIgnoreCase(Constantes.STRING_SI)){
				seleccionIndividual ++;
			}
		}

		if(listaPagoNominaBean.size() == seleccionIndividual){
			seleccionarTodos = Constantes.STRING_SI;
		}
		return seleccionarTodos;
	}
}
