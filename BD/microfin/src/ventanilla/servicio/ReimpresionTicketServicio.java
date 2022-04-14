package ventanilla.servicio;

import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.util.List;

import ventanilla.bean.ReimpresionTicketBean;
import ventanilla.dao.ReimpresionTicketDAO;
import ventanilla.servicio.IngresosOperacionesServicio.Enum_Tra_Ventanilla;

public class ReimpresionTicketServicio extends BaseServicio{
	ReimpresionTicketDAO reimpresionTicketDAO = null;
	
	public interface Enum_Lista_Reimpresion{
		int numeroTrans = 1;
		int gridReimpresion = 2;
	}
	public static interface Enum_Ticket_Ventanilla {
		int cargoCuenta 			= 1;
		int abonoCuenta 			= 2;
		int rev_cargoCuenta			= 31;
		int rev_abonoCuenta			= 32;
	}
	
	public List lista(int tipoLista, ReimpresionTicketBean reimpresionBean){
		List listaReimpresionTicket = null;
		switch(tipoLista){
				case Enum_Lista_Reimpresion.numeroTrans:
						listaReimpresionTicket=reimpresionTicketDAO.listaReimpresionTicket(tipoLista, reimpresionBean);
					break;
				case Enum_Lista_Reimpresion.gridReimpresion:
						listaReimpresionTicket = reimpresionTicketDAO.consultaGrid(tipoLista,reimpresionBean); 
					break;
		}
		return listaReimpresionTicket;
	}
	
	/**
	 * Método para realizar la reimpresion de los tickets.
	 * @param tipoConsulta : {@link Enum_Tra_Ventanilla} Numero de Operacion
	 * @param reimpresionTicketBean : {@link ReimpresionTicketBean} Bean con la informacion del ticket a consultar, obligatoriamente debe enviar el valor <b>TransaccionID</b> 
	 * @return {@link ReimpresionTicketBean}
	 */
	public ReimpresionTicketBean consulta(ReimpresionTicketBean reimpresionTicketBean) {
		ReimpresionTicketBean resultado = null;
		try {
			int tipoConsulta = Utileria.convierteEntero(reimpresionTicketBean.getTipoOpera());
			switch (tipoConsulta) {
				case Enum_Ticket_Ventanilla.cargoCuenta :
				case Enum_Ticket_Ventanilla.abonoCuenta :
				case Enum_Ticket_Ventanilla.rev_cargoCuenta :
				case Enum_Ticket_Ventanilla.rev_abonoCuenta :
					resultado = reimpresionTicketDAO.consultaPrincipal(reimpresionTicketBean, tipoConsulta);
				break;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return resultado;
	}
	

	public ReimpresionTicketDAO getReimpresionTicketDAO() {
		return reimpresionTicketDAO;
	}

	public void setReimpresionTicketDAO(ReimpresionTicketDAO reimpresionTicketDAO) {
		this.reimpresionTicketDAO = reimpresionTicketDAO;
	}

	
}
