package cedes.servicio;

import inversiones.bean.DiasInversionBean;
import inversiones.servicio.DiasInversionServicio.Enum_Lis_DiasInver;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import cedes.bean.MontosCedesBean;
import cedes.bean.PlazosCedesBean;
import cedes.dao.PlazosCedesDAO;
import cedes.servicio.CedesServicio.Enum_Con_Cedes;
import cedes.servicio.MontosCedesServicio.Enum_Con_MontosCedes;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
 
public class PlazosCedesServicio extends BaseServicio{

	PlazosCedesDAO plazosCedesDAO;
	
	public PlazosCedesServicio(){
		super();
	}
	
	
	public static interface Enum_Tra_PlazosCedes {
		int alta = 1;
		int modificacion = 2;
	}

	public static interface Enum_Con_PlazosCedes{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_PlazosCedes{
		int principal 	= 1;
		int foranea 	= 2;
		int combo		= 3;
	}
	
	public MensajeTransaccionBean grabaListaPlazosCedes(int tipoTransaccion, PlazosCedesBean plazosBean,
			String plazosInferior, String plazosSuperior){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ArrayList listaPlazosCede = (ArrayList) creaListaPlazosCede(plazosBean, plazosInferior, plazosSuperior);
		mensaje = plazosCedesDAO.grabaListaPlazosCedes(plazosBean, listaPlazosCede);
		return mensaje;		
	}
	
	
	public PlazosCedesBean consulta(int tipoConsulta,PlazosCedesBean plazosCedesBean){
		PlazosCedesBean plazoCedesBean = null;
		switch (tipoConsulta) {
			case Enum_Con_Cedes.principal:		
				plazoCedesBean = plazosCedesDAO.consultaPrincipal(plazosCedesBean, Enum_Con_MontosCedes.principal);				
				break;			
		}
		return plazoCedesBean;
	}
	
	
	
	private List creaListaPlazosCede(PlazosCedesBean plazos,String plazosInferior,String plazosSuperior){
		StringTokenizer tokensInferior = new StringTokenizer(plazosInferior, ",");
		StringTokenizer tokensSuperior = new StringTokenizer(plazosSuperior, ",");
		ArrayList listaMontos = new ArrayList();
		PlazosCedesBean plazoBean;
		
		String plaInferior[] = new String[tokensInferior.countTokens()];
		String plaSuperior[] = new String[tokensSuperior.countTokens()];
		
		int i=0;		
		
		while(tokensInferior.hasMoreTokens()){
			plaInferior[i] = tokensInferior.nextToken();
			i++;
		}
			i=0;
		while(tokensSuperior.hasMoreTokens()){
			plaSuperior[i] = tokensSuperior.nextToken();
			i++;
		}
		
		for(int contador=0; contador < plaInferior.length; contador++){		
			plazoBean = new PlazosCedesBean();
			plazoBean.setTipoCedeID(plazos.getTipoCedeID());
			plazoBean.setPlazoInferior(Utileria.convierteEntero(plaInferior[contador]));
			plazoBean.setPlazoSuperior(Utileria.convierteEntero(plaSuperior[contador]));
		listaMontos.add(plazoBean);
		}
		return listaMontos;
		}
	
	

	public List lista(int tipoLista, PlazosCedesBean bean){
		List listaPlazos = null;
		switch (tipoLista) {
			case Enum_Lis_PlazosCedes.foranea:
				listaPlazos = plazosCedesDAO.listaGrid(bean, tipoLista);
				break;
		}
		return listaPlazos;
	}
	
	
	public Object[] listaCombo(int tipoLista, PlazosCedesBean bean){
		List plazoslista = null;
		switch (tipoLista) {
			case Enum_Lis_PlazosCedes.combo:
				plazoslista = plazosCedesDAO.listaComboBox(bean, tipoLista);
				break;
		}
		return plazoslista.toArray();
	}
	
	
	public PlazosCedesDAO getPlazosCedesDAO() {
		return plazosCedesDAO;
	}

	public void setPlazosCedesDAO(PlazosCedesDAO plazosCedesDAO) {
		this.plazosCedesDAO = plazosCedesDAO;
	}
	
}
