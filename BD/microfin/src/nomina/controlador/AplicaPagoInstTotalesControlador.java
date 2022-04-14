package nomina.controlador;

import java.util.List;
import herramientas.Utileria;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.AplicaPagoInstBean;
import nomina.bean.TotalesBeanAplicaPago;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class AplicaPagoInstTotalesControlador extends AbstractCommandController {

	public AplicaPagoInstTotalesControlador(){
		setCommandClass(AplicaPagoInstBean.class);
		setCommandName("pagoInstBean");
	}
	@Override
	protected ModelAndView handle(HttpServletRequest arg0,
			HttpServletResponse arg1, Object arg2, BindException arg3)
			throws Exception {
		// TODO Auto-generated method stub

		List listaAplicaPagoInstBean;
		List listaNoAplicados;
		PagedListHolder listaPaginada = null;
		PagedListHolder listaPaginadaNoAplicados = null;

		TotalesBeanAplicaPago totalesBeanAplicaPago = new TotalesBeanAplicaPago();
		String seleccionado = arg0.getParameter("seleccionado");
		int consecutivo = Utileria.convierteEntero(arg0.getParameter("consecutivo"));
		String tipoLista =  arg0.getParameter("tipoLista");
		double totalesAplicado = 0.0;
		double totalesNoAplicado = 0.0;
		String tipoCheck = arg0.getParameter("tipoCheck");
		String chekTodosInd = "N";


		if(tipoLista.equalsIgnoreCase("Inicializar")){
			arg0.getSession().removeAttribute("ListaPaginadaPagoInstitucion");
			arg0.getSession().removeAttribute("ListaPaginadaNoAplicado");
			arg0.getSession().setAttribute("SeleccionadosPagoTodos", "N");
			arg0.getSession().setAttribute("SeleccionadosImportadosTodos", "N");
		}
		// Lista de Grid para Pagos de Institucion
		if (arg0.getSession().getAttribute("ListaPaginadaPagoInstitucion") != null) {
			listaAplicaPagoInstBean = (List) arg0.getSession().getAttribute("ListaPaginadaPagoInstitucion");

			listaPaginada = (PagedListHolder) listaAplicaPagoInstBean.get(1);
			List listaElementos = listaPaginada.getSource();
			if(tipoLista.equalsIgnoreCase("pagoInstitucion")){
				if(tipoCheck.equalsIgnoreCase("T") && seleccionado.equalsIgnoreCase("S")){
					arg0.getSession().setAttribute("SeleccionadosPagoTodos", "S");
				}else{
					arg0.getSession().setAttribute("SeleccionadosPagoTodos", "N");
				}
				actSeleccionadoAplicaPago(consecutivo, seleccionado,listaElementos, tipoCheck);
				if(tipoCheck.equalsIgnoreCase("I")){
					chekTodosInd = validaCheckTotInv(listaElementos);

					if(chekTodosInd.equalsIgnoreCase("S")){
						arg0.getSession().setAttribute("SeleccionadosPagoTodos", "S");
					}
				}
			}
			totalesAplicado = sumaAplicaPago(listaElementos);
		}

		// Lista de Grid para Pagos No Aplicados
		if (arg0.getSession().getAttribute("ListaPaginadaNoAplicado") != null) {
			listaNoAplicados = (List) arg0.getSession().getAttribute("ListaPaginadaNoAplicado");

			listaPaginadaNoAplicados = (PagedListHolder) listaNoAplicados.get(1);
			List listaElementosNoAplicados = listaPaginadaNoAplicados.getSource();
			if(tipoLista.equalsIgnoreCase("pagoNoAplicados")){
				if(tipoCheck.equalsIgnoreCase("T") && seleccionado.equalsIgnoreCase("S")){
					arg0.getSession().setAttribute("SeleccionadosImportadosTodos", "S");
				}else{
					arg0.getSession().setAttribute("SeleccionadosImportadosTodos", "N");
				}
				actSeleccionadoAplicaPagoNoImportados(consecutivo, seleccionado,listaElementosNoAplicados,tipoCheck );
			}
			totalesNoAplicado = sumaNoAplicaPago(listaElementosNoAplicados);

		}
		totalesBeanAplicaPago.setTotalAplicaPago(totalesAplicado + "");
		totalesBeanAplicaPago.setTotalNoAplicados(totalesNoAplicado + "");
		totalesBeanAplicaPago.setTotalSumatoria((totalesAplicado + totalesNoAplicado)+"" );
		totalesBeanAplicaPago.setCheckPagosTodos((String.valueOf(arg0.getSession().getAttribute("SeleccionadosPagoTodos"))));
		totalesBeanAplicaPago.setCheckImportadosTodos((String.valueOf(arg0.getSession().getAttribute("SeleccionadosImportadosTodos"))));

		Utileria.respuestaJsonTransaccion(totalesBeanAplicaPago, arg1);

		return null;

	}


	public void actSeleccionadoAplicaPago(int consecutivo, String seleccionado, List listaObjetos, String tipoCheck){
		for (int i = 0; i < listaObjetos.size(); i++) {
			AplicaPagoInstBean aplicaPagoBean = (AplicaPagoInstBean) listaObjetos.get(i);

			if(Utileria.convierteEntero(aplicaPagoBean.getConsecutivoID()) == consecutivo || tipoCheck.equalsIgnoreCase("T")){
				aplicaPagoBean.setEsSeleccionado(seleccionado);
			}
		}
	}

	public void actSeleccionadoAplicaPagoNoImportados(int consecutivo, String seleccionado, List listaObjetos, String tipoCheck){
		for (int i = 0; i < listaObjetos.size(); i++) {
			AplicaPagoInstBean aplicaPagoBean = (AplicaPagoInstBean) listaObjetos.get(i);

			if(Utileria.convierteEntero(aplicaPagoBean.getConsecutivoID()) == consecutivo || tipoCheck.equalsIgnoreCase("T")){
				aplicaPagoBean.setEsSeleccionado(seleccionado);
			}
		}

	}

	public double sumaAplicaPago( List listaObjetos){
		double sumaTotal = 0.0;
		for (int i = 0; i < listaObjetos.size(); i++) {
			AplicaPagoInstBean aplicaPagoBean = (AplicaPagoInstBean) listaObjetos.get(i);
			if(aplicaPagoBean.getEsSeleccionado().equalsIgnoreCase("S")){
				sumaTotal += Utileria.convierteDoble(aplicaPagoBean.getMontoPagos());
			}
		}

		return sumaTotal;
	}

	public double sumaNoAplicaPago( List listaObjetos){
		double sumaTotal = 0.0;
		for (int i = 0; i < listaObjetos.size(); i++) {
			AplicaPagoInstBean aplicaPagoBean = (AplicaPagoInstBean) listaObjetos.get(i);
			if(aplicaPagoBean.getEsSeleccionado().equalsIgnoreCase("S")){
				sumaTotal += Utileria.convierteDoble(aplicaPagoBean.getMontoPagos());
			}
		}

		return sumaTotal;
	}

	public String validaCheckTotInv( List listaObjetos){
		int numTotRegistos = listaObjetos.size(); // Total de Registros del GRID
		int numCheckInd = 0; // Total de Registros Seleccionados de manera Individual
		String checkTodosInv = "N";
		for (int i = 0; i < listaObjetos.size(); i++) {
			AplicaPagoInstBean aplicaPagoBean = (AplicaPagoInstBean) listaObjetos.get(i);
			if(aplicaPagoBean.getEsSeleccionado().equalsIgnoreCase("S")){
				numCheckInd ++;
			}
		}

		if(numTotRegistos == numCheckInd){
			checkTodosInv = "S";
		}else{
			checkTodosInv = "N";
		}

		return checkTodosInv;
	}


}
