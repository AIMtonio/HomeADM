package spei.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import spei.bean.PagoRemesasTraspasosSpeiBean;
import spei.dao.PagoRemesasTraspasosSpeiDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class PagoRemesasTraspasosSpeiServicio extends BaseServicio{
	
	//---------- Variables ------------------------------------------------------------------------
	PagoRemesasTraspasosSpeiDAO pagoRemesasTraspasosSpeiDAO = null;
	

	public static interface Enum_Con_PagoRemesa {
		int ctasRemesaTras = 1;

	}
	public static interface Enum_Lis_PagoRemesa {
		int lisRemesas = 1;	
	}
	public static interface Enum_Tra_PagoRemesa {
		int remesas = 1;		
	}

	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,PagoRemesasTraspasosSpeiBean pagoRemesasTraspasosSpeiBean, String listaGrid) {
		
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_PagoRemesa.remesas:
			ArrayList listaCodigosResp = (ArrayList) creaListaGridRem(listaGrid);	
			mensaje = pagoRemesasTraspasosSpeiDAO.procesoRemesas(pagoRemesasTraspasosSpeiBean,tipoTransaccion, listaCodigosResp);
			break;
			
		}

		return mensaje;

	}

	private List creaListaGridRem(String listaGrid) {
		StringTokenizer tokensBean = new StringTokenizer(listaGrid, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaCodigosResp = new ArrayList();
		PagoRemesasTraspasosSpeiBean pagoRemesasTraspasosSpeiBean;

		while (tokensBean.hasMoreTokens()) {
			pagoRemesasTraspasosSpeiBean = new PagoRemesasTraspasosSpeiBean();

			stringCampos = tokensBean.nextToken();
			tokensCampos = herramientas.Utileria
					.divideString(stringCampos, "]");

			pagoRemesasTraspasosSpeiBean.setUsuarioAutoriza(tokensCampos[0]);
			pagoRemesasTraspasosSpeiBean.setSpeiTransID(tokensCampos[1]);
			pagoRemesasTraspasosSpeiBean.setCuentaAho(tokensCampos[2]);
			pagoRemesasTraspasosSpeiBean.setClienteID(tokensCampos[3]);
			pagoRemesasTraspasosSpeiBean.setMonto(tokensCampos[4]);
			
			listaCodigosResp.add(pagoRemesasTraspasosSpeiBean);

		}

		return listaCodigosResp;
	}

	
	public List lista(int tipoLista, PagoRemesasTraspasosSpeiBean pagoRemesasTraspasosSpeiBean) {
		List listaPagoRemesa = null;
		switch (tipoLista) {
		case Enum_Lis_PagoRemesa.lisRemesas:
			listaPagoRemesa = pagoRemesasTraspasosSpeiDAO.listaPagoRemesas(pagoRemesasTraspasosSpeiBean, tipoLista);
			break;	

		}
		return listaPagoRemesa;
	}
	
	
	//------------------ Geters y Seters ------------------------------------------------------		
	public PagoRemesasTraspasosSpeiDAO getPagoRemesasTraspasosSpeiDAO() {
		return pagoRemesasTraspasosSpeiDAO;
	}

	public void setPagoRemesasTraspasosSpeiDAO(PagoRemesasTraspasosSpeiDAO pagoRemesasTraspasosSpeiDAO) {
		this.pagoRemesasTraspasosSpeiDAO = pagoRemesasTraspasosSpeiDAO;
	}
}
