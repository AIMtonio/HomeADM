package tesoreria.servicio;

import java.util.ArrayList;
import java.util.List;

import tesoreria.bean.MotivoCancelacionChequesBean;
import tesoreria.dao.MotivoCancelacionChequesDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class MotivoCancelacionChequesServicio extends BaseServicio{
	
	//---------- Variables ------------------------------------------------------------------------
	MotivoCancelacionChequesDAO motivoCancelacionChequesDAO = null;
		
		public MotivoCancelacionChequesServicio () {
			super();
		}

		//---------- Tipos de transacciones---------------------------------------------------------------
		public static interface Enum_Lis_MotivCancela{	
			int listaGridMotivos = 1;
			int listaMotivosCan  = 2;
		}
		
		public static interface Enum_Tra_MotivCancela {
			int graba = 1;

		}
		
		public static interface Enum_Con_MotivCancela {
			int motivosCancela = 1;
			int chequesCancela = 2;
			
		}
		
		public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, MotivoCancelacionChequesBean motivoCancelChequeBean){
			ArrayList listaBean = (ArrayList) creaListaMotivos(motivoCancelChequeBean);
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			switch(tipoTransaccion){
			case Enum_Tra_MotivCancela.graba:
				mensaje = motivoCancelacionChequesDAO.grabaMotivosCancelaCheques(motivoCancelChequeBean, listaBean);
				break;

				}
			return mensaje;

		}
		
		
		/* Arma la lista de beans */
		public List creaListaMotivos( MotivoCancelacionChequesBean bean) {		
			List<String> motivoID = bean.getLmotivoID();
			List<String> descripcion = bean.getLdescripcion();
			List<String> estatus = bean.getLestatus();
						
			ArrayList listaDetalle = new ArrayList();
			MotivoCancelacionChequesBean beanAux = null;	
			
			if(motivoID != null){
				int tamanio = motivoID.size();			
				for (int i = 0; i < tamanio; i++) {
					beanAux = new MotivoCancelacionChequesBean();
					beanAux.setMotivoID(motivoID.get(i));
					beanAux.setDescripcion(descripcion.get(i));
					beanAux.setEstatus(estatus.get(i));

					listaDetalle.add(beanAux);
				}
			}
			return listaDetalle;
		}

		public List listaMotivos(int tipoLista, MotivoCancelacionChequesBean motivoCancelChequeBean){		
			List motivoCancelCheque = null;
			switch (tipoLista) {	
				case Enum_Lis_MotivCancela.listaGridMotivos:		
					motivoCancelCheque = motivoCancelacionChequesDAO.listaGridMotivos(motivoCancelChequeBean, tipoLista);			
					break;		
				case Enum_Lis_MotivCancela.listaMotivosCan:		
					motivoCancelCheque = motivoCancelacionChequesDAO.listaMotivosCancelacion(motivoCancelChequeBean, tipoLista);			
					break;	
			}

			return motivoCancelCheque;
			}
		

		public MotivoCancelacionChequesBean consultaMotivos(int tipoConsulta, MotivoCancelacionChequesBean motivoCancelacionCheques){
			MotivoCancelacionChequesBean motivosBean = null;
			switch (tipoConsulta) {
				case Enum_Con_MotivCancela.motivosCancela:		
					motivosBean = motivoCancelacionChequesDAO.conMotivosCancelacion(motivoCancelacionCheques, tipoConsulta);				
					break;	
				case Enum_Con_MotivCancela.chequesCancela:		
					motivosBean = motivoCancelacionChequesDAO.conChequesCancela(motivoCancelacionCheques, tipoConsulta);				
					break;	
				
			}
			
			return motivosBean;
		}
		
		
		public MotivoCancelacionChequesDAO getMotivoCancelacionChequesDAO() {
			return motivoCancelacionChequesDAO;
		}


		public void setMotivoCancelacionChequesDAO(
				MotivoCancelacionChequesDAO motivoCancelacionChequesDAO) {
			this.motivoCancelacionChequesDAO = motivoCancelacionChequesDAO;
		}



}
