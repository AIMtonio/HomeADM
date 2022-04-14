package fondeador.servicio;

import fondeador.bean.AjusteMovimientosBean;
import fondeador.bean.AmortizaFondeoBean;
import fondeador.dao.AjusteMovimientosDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

public class AjusteMovimientosServicio extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	AjusteMovimientosDAO ajusteMovimientosDAO = null;			
	
	//------------Constantes------------------
	 
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_CreQuitas {
		int principal 			= 1;
		int numQuitaXCredito	= 2;		
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_CreQuitas {
		int principal 			= 1;
	}
	
	//---------- Tipo de Transacciones ----------------------------------------------------------------	
	public static interface Enum_Tra_CredFon {
		int alta = 1;
	}
	
	public static interface Enum_Act_CreQuitas {
		int autoriza = 1;
	}
	
	public AjusteMovimientosServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	public MensajeTransaccionBean grabaListaAjuste(int tipoTransaccion, AjusteMovimientosBean ajusteMovimientosBean,
			String ajusteDetalle){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ArrayList listaAjusteDetalle = (ArrayList) creaListaAjuste(ajusteDetalle);
		switch(tipoTransaccion){
			case Enum_Tra_CredFon.alta:
				mensaje = ajusteMovimientosDAO.grabaListaAjuste(ajusteMovimientosBean, listaAjusteDetalle, tipoTransaccion);
			break;			
		}			
		return mensaje;		 
	}
	
	private List creaListaAjuste(String detalle){		
		StringTokenizer tokensBean = new StringTokenizer(detalle, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaDetalle = new ArrayList();
		AmortizaFondeoBean amortizaFondeoBean;
		
		while(tokensBean.hasMoreTokens()){
			amortizaFondeoBean = new AmortizaFondeoBean();
		
		stringCampos = tokensBean.nextToken();		
		tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");

		amortizaFondeoBean.setAmortizacionID(tokensCampos[0]);
		amortizaFondeoBean.setEstatusAmortiza(tokensCampos[1]);
		amortizaFondeoBean.setSaldoInteres(tokensCampos[2]);
		amortizaFondeoBean.setSaldoMoratorios(tokensCampos[3]);
		amortizaFondeoBean.setSaldoComFaltaPago(tokensCampos[4]);
		amortizaFondeoBean.setSaldoOtrasComisiones(tokensCampos[5]);
		amortizaFondeoBean.setAltaEncPoliza(tokensCampos[6]);
		
		listaDetalle.add(amortizaFondeoBean);
		
		}
		
		return listaDetalle;
	}
		 
	
	
	//------------------ Getters y Setters ------------------------------------------------------	
	public AjusteMovimientosDAO getAjusteMovimientosDAO() {
		return ajusteMovimientosDAO;
	}


	public void setAjusteMovimientosDAO(AjusteMovimientosDAO ajusteMovimientosDAO) {
		this.ajusteMovimientosDAO = ajusteMovimientosDAO;
	}
	
}
