package credito.servicio;


import credito.bean.ParamsReservCastigBean;
import credito.dao.ParamsReservCastigDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ParamsReservCastigServicio extends BaseServicio{
	
	ParamsReservCastigDAO paramsReservCastigDAO =null;
	
	public static interface Enum_Tran_Params {
		int modifica	= 2;
		
	}
	public static interface Enum_Con_Params {
		int principal	= 1;
		
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParamsReservCastigBean bean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tran_Params.modifica:
				mensaje = paramsReservCastigDAO.modificaParametros(bean);
				break;
		}
		return mensaje;
	}
	public ParamsReservCastigBean consulta(int tipoConsulta, ParamsReservCastigBean bean ){
		ParamsReservCastigBean paramsReservCastigBean =null;
		switch (tipoConsulta) {
			case Enum_Con_Params.principal:
				paramsReservCastigBean=paramsReservCastigDAO.consultaPrincipal(bean, tipoConsulta);
		}
		return paramsReservCastigBean;
		
	}

	
	//*********************GETTERS Y SETTERS*******************************//
	public ParamsReservCastigDAO getParamsReservCastigDAO() {
		return paramsReservCastigDAO;
	}

	public void setParamsReservCastigDAO(ParamsReservCastigDAO paramsReservCastigDAO) {
		this.paramsReservCastigDAO = paramsReservCastigDAO;
	}

}

