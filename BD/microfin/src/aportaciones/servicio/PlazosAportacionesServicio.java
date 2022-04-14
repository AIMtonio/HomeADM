package aportaciones.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import aportaciones.bean.PlazosAportacionesBean;
import aportaciones.dao.PlazosAportacionesDAO;
import aportaciones.servicio.AportacionesServicio.Enum_Con_Aportaciones;

public class PlazosAportacionesServicio extends BaseServicio{
	
	PlazosAportacionesDAO plazosAportacionesDAO;
	
	public PlazosAportacionesServicio(){
		super();
	}
	
	public static interface Enum_Tra_PlazosAportaciones {
		int alta = 1;
		int modificacion = 2;
	}

	public static interface Enum_Con_PlazosAportaciones{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_PlazosAportaciones{
		int principal 	= 1;
		int foranea 	= 2;
		int combo		= 3;
	}
	
	public MensajeTransaccionBean grabaListaPlazosAportaciones(int tipoTransaccion, PlazosAportacionesBean plazosBean,
			String plazosInferior, String plazosSuperior){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ArrayList listaPlazosAportacion = (ArrayList) creaListaPlazosAportacion(plazosBean, plazosInferior, plazosSuperior);
		mensaje = plazosAportacionesDAO.grabaListaPlazosAportaciones(plazosBean, listaPlazosAportacion);
		return mensaje;		
	}
	
	public PlazosAportacionesBean consulta(int tipoConsulta,PlazosAportacionesBean plazosAportacionesBean){
		PlazosAportacionesBean plazoAportacionesBean = null;
		switch (tipoConsulta) {
			case Enum_Con_Aportaciones.principal:		
				plazoAportacionesBean = plazosAportacionesDAO.consultaPrincipal(plazosAportacionesBean, tipoConsulta);				
				break;			
		}
		return plazoAportacionesBean;
	}
	
	
	private List creaListaPlazosAportacion(PlazosAportacionesBean plazos,String plazosInferior,String plazosSuperior){
		StringTokenizer tokensInferior = new StringTokenizer(plazosInferior, ",");
		StringTokenizer tokensSuperior = new StringTokenizer(plazosSuperior, ",");
		ArrayList listaMontos = new ArrayList();
		PlazosAportacionesBean plazoBean;
		
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
			plazoBean = new PlazosAportacionesBean();
			plazoBean.setTipoAportacionID(plazos.getTipoAportacionID());
			plazoBean.setPlazoInferior(Utileria.convierteEntero(plaInferior[contador]));
			plazoBean.setPlazoSuperior(Utileria.convierteEntero(plaSuperior[contador]));
			listaMontos.add(plazoBean);
		}
		return listaMontos;
	}
	
	public List lista(int tipoLista, PlazosAportacionesBean bean){
		List listaPlazos = null;
		switch (tipoLista) {
			case Enum_Lis_PlazosAportaciones.foranea:
				listaPlazos = plazosAportacionesDAO.listaGrid(bean, tipoLista);
				break;
		}
		return listaPlazos;
	}
	
	public Object[] listaCombo(int tipoLista, PlazosAportacionesBean bean){
		List plazoslista = null;
		switch (tipoLista) {
			case Enum_Lis_PlazosAportaciones.combo:
				plazoslista = plazosAportacionesDAO.listaComboBox(bean, tipoLista);
				break;
		}
		return plazoslista.toArray();
	}

	public PlazosAportacionesDAO getPlazosAportacionesDAO() {
		return plazosAportacionesDAO;
	}

	public void setPlazosAportacionesDAO(PlazosAportacionesDAO plazosAportacionesDAO) {
		this.plazosAportacionesDAO = plazosAportacionesDAO;
	}
	

}
