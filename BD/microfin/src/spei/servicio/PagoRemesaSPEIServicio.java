package spei.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import cliente.bean.ClienteBean;
import cliente.servicio.ClienteServicio.Enum_Con_Cliente;
import spei.bean.PagoRemesaSPEIBean;
import spei.dao.PagoRemesaSPEIDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class PagoRemesaSPEIServicio extends BaseServicio {

	private PagoRemesaSPEIServicio() {
		super();
	}

	PagoRemesaSPEIDAO pagoRemesaSPEIDAO = null;

	public static interface Enum_Lis_PagoRemesa {
		int lisRemesas = 1;
		int lisAgentes = 2;
		int lisCuentas = 3;
		int lisAutorizacion = 4;
	}

	public static interface Enum_Tra_PagoRemesa {
		int remesas = 1;
		int agentes = 2;
		int cancela = 3;

	}

	public static interface Enum_Con_PagoRemesa {
		int ctasRemesa = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,
			PagoRemesaSPEIBean pagoRemesaSPEIBean, String listaGrid) {

		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_PagoRemesa.remesas:
			ArrayList listaCodigosResp = (ArrayList) creaListaGridRem(listaGrid);
			mensaje = pagoRemesaSPEIDAO.procesoRemesas(pagoRemesaSPEIBean,
					tipoTransaccion, listaCodigosResp);
			break;

		case Enum_Tra_PagoRemesa.agentes:
			ArrayList listaCodigosRespAg = (ArrayList) creaListaGridAge(listaGrid);
			mensaje = pagoRemesaSPEIDAO.procesoAgentes(pagoRemesaSPEIBean,
					tipoTransaccion, listaCodigosRespAg);
			break;

		case Enum_Tra_PagoRemesa.cancela:
			ArrayList listaCodigosRespCanc = (ArrayList) creaListaGridCancelacion(listaGrid);
			mensaje = pagoRemesaSPEIDAO.cancelaRemesas(pagoRemesaSPEIBean,
					tipoTransaccion, listaCodigosRespCanc);
			break;
		}

		return mensaje;

	}

	private List creaListaGridRem(String listaGrid) {
		StringTokenizer tokensBean = new StringTokenizer(listaGrid, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaCodigosResp = new ArrayList();
		PagoRemesaSPEIBean pagoRemesaSPEIBean;

		while (tokensBean.hasMoreTokens()) {
			pagoRemesaSPEIBean = new PagoRemesaSPEIBean();

			stringCampos = tokensBean.nextToken();
			tokensCampos = herramientas.Utileria
					.divideString(stringCampos, "]");

			pagoRemesaSPEIBean.setUsuarioAutoriza(tokensCampos[0]);
			pagoRemesaSPEIBean.setSpeiRemID(tokensCampos[1]);
			pagoRemesaSPEIBean.setClaveRastreo(tokensCampos[2]);

			listaCodigosResp.add(pagoRemesaSPEIBean);

		}

		return listaCodigosResp;
	}


	private List creaListaGridAge(String listaGrid) {
		StringTokenizer tokensBean = new StringTokenizer(listaGrid, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaCodigosResp = new ArrayList();
		PagoRemesaSPEIBean pagoRemesaSPEIBean;

		while (tokensBean.hasMoreTokens()) {
			pagoRemesaSPEIBean = new PagoRemesaSPEIBean();

			stringCampos = tokensBean.nextToken();
			tokensCampos = herramientas.Utileria
					.divideString(stringCampos, "]");

			pagoRemesaSPEIBean.setUsuarioAutoriza(tokensCampos[0]);
			pagoRemesaSPEIBean.setSpeiRemID(tokensCampos[1]);
			pagoRemesaSPEIBean.setCuentaAhoID(tokensCampos[2]);
			pagoRemesaSPEIBean.setClienteID(tokensCampos[3]);
			pagoRemesaSPEIBean.setClaveRastreo(tokensCampos[4]);

			listaCodigosResp.add(pagoRemesaSPEIBean);

		}

		return listaCodigosResp;
	}

	private List creaListaGridCancelacion(String listaGrid) {
		StringTokenizer tokensBean = new StringTokenizer(listaGrid, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaCodigosResp = new ArrayList();
		PagoRemesaSPEIBean pagoRemesaSPEIBean;

		while (tokensBean.hasMoreTokens()) {
			pagoRemesaSPEIBean = new PagoRemesaSPEIBean();

			stringCampos = tokensBean.nextToken();
			tokensCampos = herramientas.Utileria
					.divideString(stringCampos, "]");

			pagoRemesaSPEIBean.setUsuarioAutoriza(tokensCampos[0]);
			pagoRemesaSPEIBean.setSpeiRemID(tokensCampos[1]);
			pagoRemesaSPEIBean.setClaveRastreo(tokensCampos[2]);

			listaCodigosResp.add(pagoRemesaSPEIBean);

		}

		return listaCodigosResp;
	}

	public PagoRemesaSPEIBean consulta(int tipoConsulta, PagoRemesaSPEIBean pagoRemesaSPEIBean){
		ClienteBean cliente = null;
		switch (tipoConsulta) {
		case Enum_Con_PagoRemesa.ctasRemesa:
			pagoRemesaSPEIBean = pagoRemesaSPEIDAO.consultaCtasRem(pagoRemesaSPEIBean, tipoConsulta);
			break;
		}
		return pagoRemesaSPEIBean;
	}



	public List lista(int tipoLista, PagoRemesaSPEIBean pagoRemesa) {
		List listaPagoRemesa = null;
		switch (tipoLista) {
		case Enum_Lis_PagoRemesa.lisRemesas:
			listaPagoRemesa = pagoRemesaSPEIDAO.listaPagoRemesaVentanilla(
					pagoRemesa, Enum_Lis_PagoRemesa.lisRemesas);
			break;

		case Enum_Lis_PagoRemesa.lisAgentes:
			listaPagoRemesa = pagoRemesaSPEIDAO.listaPagoRemesaVentanilla(
					pagoRemesa, Enum_Lis_PagoRemesa.lisAgentes);
			break;

		case Enum_Lis_PagoRemesa.lisCuentas:
			listaPagoRemesa = pagoRemesaSPEIDAO.listaCuentasRemesas(
					pagoRemesa, Enum_Lis_PagoRemesa.lisCuentas);
			break;
		case Enum_Lis_PagoRemesa.lisAutorizacion:
			listaPagoRemesa = pagoRemesaSPEIDAO.listaAutorizacion(pagoRemesa, Enum_Lis_PagoRemesa.lisAutorizacion);
		break;

		}
		return listaPagoRemesa;
	}

	public PagoRemesaSPEIDAO getPagoRemesaSPEIDAO() {
		return pagoRemesaSPEIDAO;
	}

	public void setPagoRemesaSPEIDAO(PagoRemesaSPEIDAO pagoRemesaSPEIDAO) {
		this.pagoRemesaSPEIDAO = pagoRemesaSPEIDAO;
	}

}
