package aportaciones.servicio;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import aportaciones.bean.MontosAportacionesBean;
import aportaciones.dao.MontosAportacionesDAO;
import aportaciones.servicio.AportacionesServicio.Enum_Con_Aportaciones;

public class MontosAportacionesServicio extends BaseServicio{
	
	MontosAportacionesDAO montosAportacionesDAO = null;
	
	private MontosAportacionesServicio(){
		super();
	}

	public static interface Enum_Tra_MontosAportaciones {
		int alta = 1;
		int modificacion = 2;
	}

	public static interface Enum_Con_MontosAportaciones{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_MontosAportaciones{
		int principal 	= 1;
		int foranea 	= 2;
		int combo		= 3;
	}
	
	public MensajeTransaccionBean grabaListaMontosAportaciones(int tipoTransaccion, MontosAportacionesBean montoAportaciones,
			String plazosInferior, String plazosSuperior){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ArrayList listaMontosAportacion = (ArrayList) creaListaMontosAportacion(montoAportaciones, plazosInferior, plazosSuperior);
		mensaje = montosAportacionesDAO.grabaListaMontosAportaciones(montoAportaciones, listaMontosAportacion);
	return mensaje;		
	}
	
	public MontosAportacionesBean consulta(int tipoConsulta,MontosAportacionesBean montosAportacionesBean){
		MontosAportacionesBean montoAportacionesBean = null;
		switch (tipoConsulta) {
			case Enum_Con_Aportaciones.principal:		
				montoAportacionesBean = montosAportacionesDAO.consultaPrincipal(montosAportacionesBean, Enum_Con_MontosAportaciones.principal);				
				break;			
		}
		return montoAportacionesBean;
	}
	
	
	private List creaListaMontosAportacion(MontosAportacionesBean monto,String plazosInferior,String plazosSuperior){
		StringTokenizer tokensInferior = new StringTokenizer(plazosInferior, ",");
		StringTokenizer tokensSuperior = new StringTokenizer(plazosSuperior, ",");
		ArrayList listaMontos = new ArrayList();
		MontosAportacionesBean montosBean;
		
		String montosInferior[] = new String[tokensInferior.countTokens()];
		String montosSuperior[] = new String[tokensSuperior.countTokens()];
		
		int i=0;		
		
		while(tokensInferior.hasMoreTokens()){
			montosInferior[i] = tokensInferior.nextToken();
			i++;
		}
			i=0;
		while(tokensSuperior.hasMoreTokens()){
			montosSuperior[i] = tokensSuperior.nextToken();
			i++;
		}
		
		for(int contador=0; contador < montosInferior.length; contador++){		
			montosBean = new MontosAportacionesBean();
			montosBean.setTipoAportacionID(monto.getTipoAportacionID());
			montosBean.setMontoInferior(montosInferior[contador]);
			montosBean.setMontoSuperior(montosSuperior[contador]);
		listaMontos.add(montosBean);
		}
		return listaMontos;
	}
	
	
	/* Lista todos los detalles */
	public List lista(int tipoLista, MontosAportacionesBean bean){
		List lista = null;
		switch (tipoLista) {			
			case Enum_Lis_MontosAportaciones.foranea:
					lista = montosAportacionesDAO.lista(bean, tipoLista);
				break;		
		}
		return lista;	
	}
	
	public Object[] listaCombo(int tipoLista, MontosAportacionesBean bean){
		List montoslista = null;
		switch (tipoLista) {
			case Enum_Lis_MontosAportaciones.combo:
				montoslista = montosAportacionesDAO.listaComboBox(bean, tipoLista);
				break;
		}
		return montoslista.toArray();
	}

	public MontosAportacionesDAO getMontosAportacionesDAO() {
		return montosAportacionesDAO;
	}

	public void setMontosAportacionesDAO(MontosAportacionesDAO montosAportacionesDAO) {
		this.montosAportacionesDAO = montosAportacionesDAO;
	}

}
