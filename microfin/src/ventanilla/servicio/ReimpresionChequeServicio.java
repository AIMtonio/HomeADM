package ventanilla.servicio;

import java.util.List;

import ventanilla.bean.ReimpresionChequeBean;
import ventanilla.dao.ReimpresionChequeDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ReimpresionChequeServicio extends BaseServicio{

	ReimpresionChequeDAO reimpresionChequeDAO = null;
	
	public static interface Enum_Con_Cheques {
		int principal = 1;		
	}
	
	public static interface Enum_Lis_ChequesEmitidos{
		int emitidos  = 1;
	}
	
	public ReimpresionChequeServicio(){
		super();
	}		
		
	public ReimpresionChequeBean consulta(int tipoConsulta, ReimpresionChequeBean reimpresionChequeBean){
		ReimpresionChequeBean cheque= null;
		switch (tipoConsulta) {
			case Enum_Con_Cheques.principal:		
				cheque = reimpresionChequeDAO.consultaCheques(tipoConsulta, reimpresionChequeBean);				
				break;			
		}
		return cheque;
	}
	
	public List lista(int tipoLista, ReimpresionChequeBean reimpresionChequeBean){		
		List listaReimpresionCheques = null;
		switch (tipoLista) {
			case Enum_Lis_ChequesEmitidos.emitidos:		
				listaReimpresionCheques = reimpresionChequeDAO.listaPrincipal(reimpresionChequeBean, tipoLista);				
				break;			
		}	
		return listaReimpresionCheques;
	}	

	public ReimpresionChequeDAO getReimpresionChequeDAO() {
		return reimpresionChequeDAO;
	}

	public void setReimpresionChequeDAO(ReimpresionChequeDAO reimpresionChequeDAO) {
		this.reimpresionChequeDAO = reimpresionChequeDAO;
	}
	
	
	
}
