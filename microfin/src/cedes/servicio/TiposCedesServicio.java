package cedes.servicio;

import general.bean.MensajeTransaccionBean;
import inversiones.bean.TipoInversionBean;
import inversiones.servicio.TipoInversionesServicio.Enum_Tra_TipoInversion;

import java.util.List;

import cedes.bean.TiposCedesBean;
import cedes.dao.TiposCedesDAO;
import cedes.servicio.CedesServicio.Enum_Lis_Cedes;

	public class TiposCedesServicio {
		
		private TiposCedesServicio(){
			super();
		}
		 
		TiposCedesDAO tiposCedesDAO = null;
		
		public static interface Enum_Tra_TiposCedes{
			int alta			= 1;
			int modificacion	= 2;
		}
		
		public static interface Enum_Con_TipoCedes {
			int principal = 1;
			int general		=2;
		}
		
		public static interface Enum_Lis_TipoCedes{
			int principal	=1;
		}

		
		public static interface Enum_Lis_TiposCedes{
			int listaPrincipal 	= 1;
			int comboTiposCedes = 2;
			int lis_TiposCedesAct =3;		// Lista de los tipos Cedes activos
			int lis_ComboTipCedesAct =4;	// Lista Combo de los tipos Cedes activos
		}
		
		public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TiposCedesBean tiposCedesBean){
			
			MensajeTransaccionBean mensaje = null;
			
			switch(tipoTransaccion){
				case (Enum_Tra_TipoInversion.alta):
						mensaje = tiposCedesDAO.alta(tiposCedesBean);
					break;
				case (Enum_Tra_TipoInversion.modificacion):
						mensaje = tiposCedesDAO.modifica(tiposCedesBean);
					break;
			}

			
			return mensaje;
			
		}
		
		
		public TiposCedesBean consulta(int tipoConsulta, TiposCedesBean tiposCedesBean){
			TiposCedesBean tiposCedes = null;
			
			switch(tipoConsulta){
				 case (Enum_Con_TipoCedes.principal):
					 tiposCedes = tiposCedesDAO.consultaPrincipal(tiposCedesBean, tipoConsulta);
				 		break;
				 case (Enum_Con_TipoCedes.general):
					 tiposCedes = tiposCedesDAO.consultaGeneral(tiposCedesBean, tipoConsulta);
				 		break;
				
			}
			return tiposCedes;		
		}
		
		
		public List lista(int tipoLista, TiposCedesBean tiposCedesBean){		
			List listaTiposCedes = null;
			switch (tipoLista) {
				case Enum_Lis_Cedes.principal:	
				case Enum_Lis_TiposCedes.lis_TiposCedesAct:	
					listaTiposCedes = tiposCedesDAO.listaPrincipal(tiposCedesBean, tipoLista);				
					break;				
			}
			return listaTiposCedes;
		}

	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaTiposCedes = null;
		switch(tipoLista){
			case (Enum_Lis_TiposCedes.comboTiposCedes):
			case (Enum_Lis_TiposCedes.lis_ComboTipCedesAct):
				listaTiposCedes =  tiposCedesDAO.listaCedes(tipoLista);
				break;
		}
		return listaTiposCedes.toArray();		
	}

		public TiposCedesDAO getTiposCedesDAO() {
			return tiposCedesDAO;
		}

		public void setTiposCedesDAO(TiposCedesDAO tiposCedesDAO) {
			this.tiposCedesDAO = tiposCedesDAO;
		}


	}
