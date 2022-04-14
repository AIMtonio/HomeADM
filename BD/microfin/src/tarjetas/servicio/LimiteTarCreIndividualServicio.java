package tarjetas.servicio;

import tarjetas.bean.LimitesTarCreIndividualBean;
import tarjetas.bean.LimitesTarDebIndividualBean;
import tarjetas.dao.LimitesTarCreIndividualDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class LimiteTarCreIndividualServicio extends BaseServicio {
	LimitesTarCreIndividualDAO limitesTarCreIndividualDAO = null;
	
	public LimiteTarCreIndividualServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	public static interface Enum_LimitesTarDeb {
		
		int alta=1;
		int modificacion=2;
	}
	
	public static interface Enum_Con_LimitesTarCre{
        int principal  =1;
    }
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, LimitesTarDebIndividualBean limitesTarDebIndividualBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
	    	case Enum_LimitesTarDeb.alta:
	    		mensaje = limitesTarCreIndividualDAO.limitesTardeb(limitesTarDebIndividualBean);
	    	break;
	    	case Enum_LimitesTarDeb.modificacion:  
	    		mensaje = limitesTarCreIndividualDAO.modificaLimitesTar(limitesTarDebIndividualBean);
			break;
		}
		return mensaje;
	}
	
	public LimitesTarCreIndividualBean consulta(int tipoConsulta, LimitesTarCreIndividualBean limitesTarCreIndividualBean){
		LimitesTarCreIndividualBean tarjetaDebito = null;
		switch(tipoConsulta){
			case Enum_Con_LimitesTarCre.principal:
				tarjetaDebito = limitesTarCreIndividualDAO.consultaLimitesTarDeb(Enum_Con_LimitesTarCre.principal, limitesTarCreIndividualBean);
			break;
			}
		return tarjetaDebito;
	}

	public LimitesTarCreIndividualDAO getLimitesTarCreIndividualDAO() {
		return limitesTarCreIndividualDAO;
	}

	public void setLimitesTarCreIndividualDAO(
			LimitesTarCreIndividualDAO limitesTarCreIndividualDAO) {
		this.limitesTarCreIndividualDAO = limitesTarCreIndividualDAO;
	}

}
