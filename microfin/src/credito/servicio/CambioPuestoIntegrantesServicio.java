package credito.servicio;

import java.util.ArrayList;
import java.util.List;

import credito.bean.CambioPuestoIntegrantesBean;
import credito.dao.CambioPuestoIntegrantesDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CambioPuestoIntegrantesServicio  extends BaseServicio{

	CambioPuestoIntegrantesDAO cambioPuestoIntegrantesDAO = null;
	
	public CambioPuestoIntegrantesServicio() {
		super();
	}
	
	public static interface Enum_Act_CambioPuestos {
		int actualizaPuesto = 1; // Actualiza Cambio de Puestos de Integrantes de Grupo
	}

	public static interface Enum_Lis_Grupos{
		int integrantesGrupo = 13;			//Lista de Integrantes Grupos para Cambios de Puestos
	}
	
	/* Transacciones de Actualizacion de Cambio de Puestos de Integrantes de Grupo */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CambioPuestoIntegrantesBean cambioPuesto){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ArrayList listaBean = (ArrayList) creaListaDetalle(cambioPuesto);
		switch(tipoTransaccion) {		
			case Enum_Act_CambioPuestos.actualizaPuesto:	
				mensaje = cambioPuestoIntegrantesDAO.procesarCambioPuesto(listaBean);
			break;
		}
		return mensaje;
	}
	
	
	//Lista de integrantes de una solicitud grupal
	public List lista(int tipoLista, CambioPuestoIntegrantesBean cambioPuesto){		
		List listaGrupos = null;
		switch (tipoLista) {
			case Enum_Lis_Grupos.integrantesGrupo:		
				listaGrupos=  cambioPuestoIntegrantesDAO.listaIntegrantesGrupo(cambioPuesto, tipoLista);				
				break;
		}		
		return listaGrupos;
	}
	
	/* Arma la lista de beans */
	public List creaListaDetalle( CambioPuestoIntegrantesBean bean) {		
		List<String> solicitudCredito= bean.getLsolicitudCreditoID();
		List<String> cargo = bean.getLcargo();
		ArrayList listaDetalle = new ArrayList();
		CambioPuestoIntegrantesBean beanAux = null;	
		
		if(solicitudCredito != null){
			int tamanio = solicitudCredito.size();			
			for (int i = 0; i < tamanio; i++) {
				beanAux = new CambioPuestoIntegrantesBean();
				
				beanAux.setSolicitudCreditoID(solicitudCredito.get(i));
				beanAux.setCargo(cargo.get(i));
				beanAux.setGrupoID(bean.getGrupoID());
				beanAux.setCiclo(bean.getCiclo());
				listaDetalle.add(beanAux);
			}
		}
		return listaDetalle;
		
	}
	
	//* ============== Getter & Setter =============  //*
	public CambioPuestoIntegrantesDAO getCambioPuestoIntegrantesDAO() {
		return cambioPuestoIntegrantesDAO;
	}

	public void setCambioPuestoIntegrantesDAO(
			CambioPuestoIntegrantesDAO cambioPuestoIntegrantesDAO) {
		this.cambioPuestoIntegrantesDAO = cambioPuestoIntegrantesDAO;
	}
	
}
