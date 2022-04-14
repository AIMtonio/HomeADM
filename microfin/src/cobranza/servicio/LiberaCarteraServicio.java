package cobranza.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import cobranza.bean.AsignaCarteraBean;
import cobranza.bean.LiberaCarteraBean;
import cobranza.dao.LiberaCarteraDAO;
import cobranza.servicio.AsignaCarteraServicio.Enum_Lis_CreditosGrid;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class LiberaCarteraServicio extends BaseServicio {
	LiberaCarteraDAO liberaCarteraDAO = null;
	
	public static interface Enum_Trans_LiberaCartera{
		int liberar 	= 1;
	}
	
	public static interface Enum_Rep_LiberaCartera{
		int excelRep = 1;
		int excelRepGestor =2;
	}
	
	public static interface Enum_Lis_CreditosGrid{
		int credLiberados = 1;
		int credLiberadosGestor = 2;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,LiberaCarteraBean liberaCartera, String credLib){
		MensajeTransaccionBean mensaje = null;
		ArrayList ListaBeanCredLib =(ArrayList) creaListaDetalle(credLib);
		switch (tipoTransaccion) {
			case Enum_Trans_LiberaCartera.liberar:
				mensaje = liberaCarteraDAO.liberaCredito(liberaCartera, ListaBeanCredLib, tipoTransaccion );
				break;
		}
		return mensaje;
	}
	
	private List creaListaDetalle(String credLib){		
		StringTokenizer tokensBean = new StringTokenizer(credLib, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaDetalleCred = new ArrayList();
		LiberaCarteraBean credLibera;
		while(tokensBean.hasMoreTokens()){
			credLibera = new LiberaCarteraBean();
		stringCampos = tokensBean.nextToken();		
		tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
		credLibera.setAsignadoID(tokensCampos[0]);
		credLibera.setCreditoID(tokensCampos[1]);
		credLibera.setEstatusCredLib(tokensCampos[2]);
		credLibera.setDiasAtrasoLib(tokensCampos[3]);
		credLibera.setSaldoCapitalLib(tokensCampos[4]);
		credLibera.setSaldoInteresLib(tokensCampos[5]);
		credLibera.setSaldoMoratorioLib(tokensCampos[6]);
		credLibera.setMotivoLiberacion(tokensCampos[7]);	
		credLibera.setLiberado(tokensCampos[8]);	
		listaDetalleCred.add(credLibera);
		}
		return listaDetalleCred;
	}
	

	public List listaCreditosLiberados(int tipoLista,LiberaCarteraBean liberaCartera){		
		List listaCred = null;
		switch(tipoLista){
		case Enum_Rep_LiberaCartera.excelRep:
			listaCred = liberaCarteraDAO.reporteCreditosLiberados(tipoLista,liberaCartera);
			break;
		}

		return listaCred;
	}
	
	public List listaGrid(int tipoLista,LiberaCarteraBean liberaCartera){		
		List listaCred = null;
		switch(tipoLista){
		case Enum_Lis_CreditosGrid.credLiberados:
			listaCred = liberaCarteraDAO.listaliberaCreditos(tipoLista,liberaCartera);
			break;		
		case Enum_Lis_CreditosGrid.credLiberadosGestor:
			listaCred = liberaCarteraDAO.listaliberaCreditos(tipoLista,liberaCartera);
			break;
		}

		return listaCred;
	}

	public LiberaCarteraDAO getLiberaCarteraDAO() {
		return liberaCarteraDAO;
	}

	public void setLiberaCarteraDAO(LiberaCarteraDAO liberaCarteraDAO) {
		this.liberaCarteraDAO = liberaCarteraDAO;
	}
}
