package credito.servicio;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;
import credito.bean.IntegraGruposBean;
import credito.bean.ReversaDesCreditoBean;
import credito.dao.ReversaDesCreditoDAO;

public class ReversaDesembolsoCreditoServicio extends BaseServicio{
	
	ReversaDesCreditoDAO reversaDesCreditoDAO = null;
	IntegraGruposServicio integraGruposServicio = null;
	protected TransaccionDAO transaccionDAO = null;
	protected ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	
	private ReversaDesembolsoCreditoServicio(){
		super();
	}
	public static interface Enum_Con_Reversa {
		int reversaCreditoIndividual 	= 1;
		int reversaCreditoGrupal   = 2;
	}
	public MensajeTransaccionBean grabaTransaccion(ReversaDesCreditoBean reversaBean){
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensaje = null;
		IntegraGruposBean integraGrupo 	= new IntegraGruposBean();
		List listaIntegrantes = null;
		integraGrupo.setGrupoID(reversaBean.getGrupoID());
		integraGrupo.setCiclo(reversaBean.getCicloID());
		listaIntegrantes = integraGruposServicio.lista(IntegraGruposServicio.Enum_Lis_Grupos.integrantesRevDesembolso, integraGrupo);
		mensaje = reversaDesCreditoDAO.reversaDesembolsoProceso(reversaBean, listaIntegrantes);
		return mensaje;
	}
	
	
	
	// ----------------- SETTER Y GETTERS ----------------------------------------------------

	public ReversaDesCreditoDAO getReversaDesCreditoDAO() {
		return reversaDesCreditoDAO;
	}

	public void setReversaDesCreditoDAO(ReversaDesCreditoDAO reversaDesCreditoDAO) {
		this.reversaDesCreditoDAO = reversaDesCreditoDAO;
	}



	public IntegraGruposServicio getIntegraGruposServicio() {
		return integraGruposServicio;
	}



	public void setIntegraGruposServicio(IntegraGruposServicio integraGruposServicio) {
		this.integraGruposServicio = integraGruposServicio;
	}



	public TransaccionDAO getTransaccionDAO() {
		return transaccionDAO;
	}



	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}



	public void setTransaccionDAO(TransaccionDAO transaccionDAO) {
		this.transaccionDAO = transaccionDAO;
	}



	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
	
	
	

}
