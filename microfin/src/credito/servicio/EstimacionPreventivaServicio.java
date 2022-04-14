package credito.servicio;

import credito.bean.EstimacionPreventivaBean;
import credito.dao.EstimacionPreventivaDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class EstimacionPreventivaServicio extends BaseServicio{

	public EstimacionPreventivaServicio(){
		super();
	}
	
	EstimacionPreventivaDAO estimacionPreventivaDAO = null;
	
	public static interface Enum_Con_Est{
		int principal 		= 1;
		int reserva			= 2;
		int consultaFecha	= 4;
	}
	
	public static interface Enum_Con_CalifYEstimacion{
		int fechaEstimacion	= 1;
		
	}
	
	public MensajeTransaccionBean grabaFormaTransaccion(int tipoConsulta, EstimacionPreventivaBean estimacionPreventivaBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoConsulta){
			case Enum_Con_Est.principal:
				mensaje = generaEstimacion(estimacionPreventivaBean);
			break;
		}
		return mensaje;
	}
	
	public EstimacionPreventivaBean consulta(EstimacionPreventivaBean estimacionPreventivaBean, int tipoConsulta){
		EstimacionPreventivaBean mensaje = null;
		switch (tipoConsulta){
			case Enum_Con_Est.consultaFecha:
				mensaje = consultaFecha (estimacionPreventivaBean, tipoConsulta);
			break;
			
		}
		return mensaje;
	}
	
	public EstimacionPreventivaBean consultaEstimacion(EstimacionPreventivaBean estimacionPreventivaBean, int tipoConsulta){
		EstimacionPreventivaBean mensaje = null;
		switch (tipoConsulta){
			case Enum_Con_CalifYEstimacion.fechaEstimacion:
				mensaje = estimacionPreventivaDAO.consultaFechaEstimacion(estimacionPreventivaBean, tipoConsulta);
			break;
		}
		return mensaje;
	}
	
	
	public EstimacionPreventivaBean consultaReservas(int tipoConsulta, EstimacionPreventivaBean estimacionPreventivaBean){
		EstimacionPreventivaBean mensaje = null;
		switch (tipoConsulta){
		case Enum_Con_Est.reserva:
			mensaje = estimacionPreventivaDAO.consultaFechaCred(estimacionPreventivaBean, tipoConsulta);
		break;
		}
		return mensaje;
	}
	
	
	
	
	public EstimacionPreventivaBean consultaFecha (EstimacionPreventivaBean estimacionPreventivaBean, int tipoConsulta){
		EstimacionPreventivaBean mensaje = null;
		mensaje = estimacionPreventivaDAO.consultaFecha(estimacionPreventivaBean, tipoConsulta);
		return mensaje;
	}
	
	public MensajeTransaccionBean generaEstimacion(EstimacionPreventivaBean estimacionPreventivaBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = estimacionPreventivaDAO.estimacionPreventiva(estimacionPreventivaBean);
		return mensaje;
	}
	
	// -- Setters y Getters --------------------------------------------------------------- 
	public EstimacionPreventivaDAO getEstimacionPreventivaDAO() {
		return estimacionPreventivaDAO;
	}

	public void setEstimacionPreventivaDAO(
			EstimacionPreventivaDAO estimacionPreventivaDAO) {
		this.estimacionPreventivaDAO = estimacionPreventivaDAO;
	}
	
	
}
