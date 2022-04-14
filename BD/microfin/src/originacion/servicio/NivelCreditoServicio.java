package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import originacion.bean.NivelCreditoBean;
import originacion.dao.NivelCreditoDAO;


public class NivelCreditoServicio extends BaseServicio {
	NivelCreditoDAO nivelCreditoDAO = null;
	
	public static interface Enum_Trans_NivelCre{
		int graba = 1;
	}
	
	public static interface Enum_Lis_NivelCre{
		int lisGridParametros   = 1;
		int listaCombo			= 2;
		int listaComboSolicitud = 3;
	}
	
	//transaccion nivel credito
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, NivelCreditoBean nivelCreditoBean){
		MensajeTransaccionBean mensaje = null;
		ArrayList listaBean = (ArrayList) listaGrid(nivelCreditoBean);
		switch(tipoTransaccion){
			case Enum_Trans_NivelCre.graba:
				mensaje = nivelCreditoDAO.grabaNivelCredito(nivelCreditoBean,listaBean);
				break;
		}
		return mensaje;
	}

	//lista de parametros del grid
	public List listaGrid(NivelCreditoBean lisNivelCreditoBean){

		List<String> nivelIDLis	  = lisNivelCreditoBean.getLisNivelID();
		List<String> descripcionLis = lisNivelCreditoBean.getLisDescripcion();
		
		ArrayList listaDetalle = new ArrayList();
		NivelCreditoBean nivelCreditoBean = null;
		if(nivelIDLis !=null){ 			
			try{
				
			int tamanio = nivelIDLis.size();
				for(int i=0; i<tamanio; i++){
				
					nivelCreditoBean = new NivelCreditoBean();
					
					nivelCreditoBean.setNivelID(nivelIDLis.get(i));
					nivelCreditoBean.setDescripcion(descripcionLis.get(i));
					
					listaDetalle.add(i,nivelCreditoBean);	
				}

			}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de grid niveles de credito", e);	
		}
	}
	return listaDetalle;
	}
	
	public List lista(int tipoLista, NivelCreditoBean nivelCreditoBean){
		List listaParametros = null;
		
		switch(tipoLista){
			case Enum_Lis_NivelCre.lisGridParametros:
				listaParametros = nivelCreditoDAO.listaGridNivelesCredito(tipoLista,nivelCreditoBean);
				break;
		}

		return listaParametros;
	}		
	
	// lista para comboBox 
	public  Object[] listaCombo(int tipoLista,  NivelCreditoBean nivelCreditoBean) {
		List listaBean = null;
			switch(tipoLista){
			case Enum_Lis_NivelCre.listaCombo:
				listaBean = nivelCreditoDAO.listaNivelesCombo(tipoLista,nivelCreditoBean);
				break;
			case Enum_Lis_NivelCre.listaComboSolicitud:
				listaBean = nivelCreditoDAO.listaNivelesCredito(tipoLista, nivelCreditoBean);
				break;
			}			
		return listaBean.toArray(); 
	}
	
	public NivelCreditoDAO getNivelCreditoDAO() {
		return nivelCreditoDAO;
	}

	public void setNivelCreditoDAO(NivelCreditoDAO nivelCreditoDAO) {
		this.nivelCreditoDAO = nivelCreditoDAO;
	}
	
	
}
