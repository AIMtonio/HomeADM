package fira.controlador;

import general.bean.MensajeTransaccionBean;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.AmortizacionCreditoBean;
import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;
import credito.servicio.CreditosServicio.Enum_Sim_PagAmortizaciones;

public class SimPagLibresReestAgroControlador extends AbstractCommandController {

	CreditosServicio	creditosServicio	= null;

	public SimPagLibresReestAgroControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditos");
	}

	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		List listaResultado = (List) new ArrayList();
		MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		try {
			int tipoLista = (request.getParameter("tipoLista") != null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
			String montosCapital = request.getParameter("montosCapital");
			String montosMinistraciones = request.getParameter("ministraciones");
			String cobraSeguroCuota = request.getParameter("cobraSeguroCuota");
			CreditosBean creditos = (CreditosBean) command;
			List LisCreditos = (List) new ArrayList();
			switch (tipoLista) {
				case Enum_Sim_PagAmortizaciones.pagosLibresTasaFija:
					LisCreditos = creditosServicio.grabaListaSimPagLibAgro(creditos, montosCapital, montosMinistraciones);
					listaResultado.add(tipoLista);
					listaResultado.add(LisCreditos.get(0));
					listaResultado.add(LisCreditos.get(1));
					break;
				case Enum_Sim_PagAmortizaciones.pagosLibresTasaVar:
					LisCreditos = creditosServicio.grabaListaSimPagLibTasaVarAgro(creditos, montosCapital, montosMinistraciones);
					listaResultado.add(tipoLista);
					listaResultado.add(LisCreditos.get(0));
					listaResultado.add(LisCreditos.get(1));
					break;
				case Enum_Sim_PagAmortizaciones.pagLibFecCapTasaFija:

					LisCreditos = creditosServicio.grabaListaSimPagLibFecCapAgro(creditos, montosCapital, montosMinistraciones);
					listaResultado.add(tipoLista);
					listaResultado.add(LisCreditos.get(0));
					listaResultado.add(LisCreditos.get(1));
					break;
				case Enum_Sim_PagAmortizaciones.pagLibFecCapTasaVar:

					LisCreditos = creditosServicio.grabaListaSimPagLibFecCapTasVarAgro(creditos, montosCapital, montosMinistraciones);
					listaResultado.add(tipoLista);
					listaResultado.add(LisCreditos.get(0));
					listaResultado.add(LisCreditos.get(1));
					break;
					
				case Enum_Sim_PagAmortizaciones.pagLibFecCapTasaFijaReest:

					LisCreditos = creditosServicio.grabaListaSimPagLibFecCapReestAgro(creditos, montosCapital, montosMinistraciones);
					listaResultado.add(tipoLista);
					listaResultado.add(LisCreditos.get(0));
					listaResultado.add(LisCreditos.get(1));
					break;
			}

			if (LisCreditos != null && LisCreditos.size() > 0) {
				List<AmortizacionCreditoBean> lista = (List<AmortizacionCreditoBean>) LisCreditos.get(1);
				if (lista != null && lista.size()>0) {
					String numeroError = lista.get(0).getCodigoError();
					String messError = lista.get(0).getMensajeError();
					listaResultado.add(numeroError);
					listaResultado.add(messError);
					listaResultado.add(cobraSeguroCuota);
				} else {
					listaResultado.add("999");
					listaResultado.add("Ocurrio un Error al Simular.");
					listaResultado.add("N");
				}
			} else {
				listaResultado.add("999");
				listaResultado.add("Ocurrio un Error al Simular.");
				listaResultado.add("N");
			}

		} catch (Exception ex) {
			ex.printStackTrace();
			
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al realizar la Operación:"+ex.getMessage());
			listaResultado.add(0); //Tipo de Lista
			listaResultado.add(mensaje); //Mensaje
			listaResultado.add(null); //Listaresultado
			listaResultado.add("999");
			listaResultado.add("Ocurrio un Error al Simular.");
		}
		
		return new ModelAndView("fira/simuladorLibresReestAgroGridVista", "listaResultado", listaResultado);

	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

}
