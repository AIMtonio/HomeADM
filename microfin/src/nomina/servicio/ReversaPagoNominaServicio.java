package nomina.servicio;

import java.util.List;

import org.springframework.transaction.support.TransactionTemplate;

import nomina.bean.ReversaPagoNominaBean;
import nomina.dao.ReversaPagoNominaDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;

public class ReversaPagoNominaServicio extends BaseServicio{
	ReversaPagoNominaDAO reversaPagoNominaDAO = null;
	TransaccionDAO transaccionDAO = null;
	ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	protected TransactionTemplate transactionTemplate;
	
	public static interface Enum_Trans_ReversaPago{
		int reversa = 1;	
	}
	public static interface Enum_Lis_FolioPagoNomina{
		int folios = 1;
	}
	
	public static interface Enum_Lis_RevPagosNomina{
		int pagosAplicados = 1;
	}
	
	public static interface Enum_Con_RevPagoNomina{
		int foliosAplicados = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	ReversaPagoNominaBean reversaPagoNominaBean) {
		// TODO Auto-generated method stub
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensaje = null;
		
		switch(tipoTransaccion){			
			case Enum_Trans_ReversaPago.reversa:
				mensaje = reversaPagoNominaDAO.reversaPagoCreditoProceso(reversaPagoNominaBean);
				break;
		}		
		return mensaje;
	}
	
	public ReversaPagoNominaBean consulta(int tipoConsulta, ReversaPagoNominaBean reversaPagoNominaBean){
		ReversaPagoNominaBean consulta = null;
		switch(tipoConsulta){
			case Enum_Con_RevPagoNomina.foliosAplicados:
				consulta = reversaPagoNominaDAO.consultaFolio(reversaPagoNominaBean, tipoConsulta);
			break;
		}
		return consulta;
	}
	
	public List lista(int tipoLista, ReversaPagoNominaBean reversaPagoNominaBean){
		List pagoNominaLista = null;
		 switch (tipoLista) {
		    case  Enum_Lis_FolioPagoNomina.folios:          
		       	pagoNominaLista = reversaPagoNominaDAO.listaFolio(reversaPagoNominaBean, tipoLista);
		    break;
			}
		return pagoNominaLista;
	}
	
	public List listaPagos(int tipoLista, ReversaPagoNominaBean reversaPagoNominaBean){
		List pagoNominaLista = null;
		 switch (tipoLista) {
		    case  Enum_Lis_RevPagosNomina.pagosAplicados:          
		       	pagoNominaLista = reversaPagoNominaDAO.listaPagosGrid(reversaPagoNominaBean, tipoLista);
		    break;
			}
			return pagoNominaLista;
	}

	public ReversaPagoNominaDAO getReversaPagoNominaDAO() {
		return reversaPagoNominaDAO;
	}

	public void setReversaPagoNominaDAO(ReversaPagoNominaDAO reversaPagoNominaDAO) {
		this.reversaPagoNominaDAO = reversaPagoNominaDAO;
	}
	
	public TransaccionDAO getTransaccionDAO() {
		return transaccionDAO;
	}

	public void setTransaccionDAO(TransaccionDAO transaccionDAO) {
		this.transaccionDAO = transaccionDAO;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
		ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}

	public TransactionTemplate getTransactionTemplate() {
		return transactionTemplate;
	}

	public void setTransactionTemplate(TransactionTemplate transactionTemplate) {
		this.transactionTemplate = transactionTemplate;
	}
	
}
