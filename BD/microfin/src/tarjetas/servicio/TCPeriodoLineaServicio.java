package tarjetas.servicio;

import java.util.List;

import tarjetas.bean.TCPeriodoLineaBean;
import tarjetas.dao.TCPeriodoLineaDAO;
import general.servicio.BaseServicio;

public class TCPeriodoLineaServicio extends BaseServicio {
	
	public TCPeriodoLineaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	TCPeriodoLineaDAO tCPeriodoLineaDAO = null;
	
	public static interface Enum_Con_tarjetaCredito{			
		int InfoLineaCredido				= 1; //CONSULTA DE INFORMACION DE LINEA DE CREDITO
	}

	public static interface Enum_lis_tarjetaCredito{
		int fechasCorte			 = 1;
	}

	///LISTAS
		public List lista(int tipoLista, TCPeriodoLineaBean tCPeriodoLineaBean){	
			List listaTarjetaCredito = null;
			switch (tipoLista) {
			case Enum_lis_tarjetaCredito.fechasCorte:		
				listaTarjetaCredito = tCPeriodoLineaDAO.listaFechaCorte(tipoLista, tCPeriodoLineaBean);				
			break;				
		}
		return listaTarjetaCredito;		
	}

		
		// CONSUTAS
		public TCPeriodoLineaBean consulta(int tipoConsulta, TCPeriodoLineaBean tCPeriodoLineaBean){
			TCPeriodoLineaBean tarjetaCredito = null;
			switch(tipoConsulta){
				case Enum_Con_tarjetaCredito.InfoLineaCredido:
					tarjetaCredito = tCPeriodoLineaDAO.infoLineaCredido(tipoConsulta, tCPeriodoLineaBean);
				break;
				
			}
			return tarjetaCredito;
		}


		public TCPeriodoLineaDAO gettCPeriodoLineaDAO() {
			return tCPeriodoLineaDAO;
		}


		public void settCPeriodoLineaDAO(TCPeriodoLineaDAO tCPeriodoLineaDAO) {
			this.tCPeriodoLineaDAO = tCPeriodoLineaDAO;
		}

}
