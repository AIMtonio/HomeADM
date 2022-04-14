package ventanilla.servicio;

import ventanilla.bean.ParamFaltaSobraBean;
import ventanilla.dao.ParamFaltaSobraDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ParamFaltaSobraServicio extends BaseServicio{

	ParamFaltaSobraDAO paramFaltaSobraDAO	=null;
	public ParamFaltaSobraServicio(){
		super();
	}
	
	public static interface Enum_Tran_Parametros{
		int alta		=1;
		int modifica	=2;
	}
	public static interface Enum_Con_Parametros{
		int Con_Principal	=1;
	}
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	ParamFaltaSobraBean paramFaltaSobraBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tran_Parametros.alta:		
				mensaje = paramFaltaSobraDAO.altaParametrosFaltaSobra(paramFaltaSobraBean);								
				break;			
			case Enum_Tran_Parametros.modifica:		
				mensaje = paramFaltaSobraDAO.modificaParametros(paramFaltaSobraBean);								
				break;	
		}
		return mensaje;
	}
	
	public ParamFaltaSobraBean consulta(int tipoConsulta, ParamFaltaSobraBean paramFaltaSobraBean){
		ParamFaltaSobraBean parametros = null;
		switch (tipoConsulta) {
			case Enum_Con_Parametros.Con_Principal:	
				parametros = paramFaltaSobraDAO.consultaPrincipal(paramFaltaSobraBean,tipoConsulta);
				break;				
		}
		return parametros;
	}

	
	// ---------------getter y Setter
	public ParamFaltaSobraDAO getParamFaltaSobraDAO() {
		return paramFaltaSobraDAO;
	}

	public void setParamFaltaSobraDAO(ParamFaltaSobraDAO paramFaltaSobraDAO) {
		this.paramFaltaSobraDAO = paramFaltaSobraDAO;
	}			
	
}
