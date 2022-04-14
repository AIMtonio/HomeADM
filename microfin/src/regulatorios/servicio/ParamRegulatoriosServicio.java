package regulatorios.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import regulatorios.bean.ParamRegulatoriosBean;
import regulatorios.dao.ParamRegulatoriosDAO;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;

public class ParamRegulatoriosServicio extends BaseServicio{	
	ParamRegulatoriosDAO paramRegulatoriosDAO = null;
	
	public ParamRegulatoriosServicio() {
		super();
	}
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Lis_ParamRegulatorios {
		int principal = 1;
		int listaRegistro = 2;
	}
	public static interface Enum_Alt_ParamRegulatorios {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}
	
	public static interface Enum_Con_ParamRegulatorios {
		int principal = 1;
		int historico = 2;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	ParamRegulatoriosBean paramRegulatoriosBean ){

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				
			switch (tipoTransaccion) {
				case Enum_Alt_ParamRegulatorios.modificacion:		
					mensaje = paramRegulatoriosDAO.modificaParametrosRegulatorios(paramRegulatoriosBean);								
					break;			
			}		
		
		return mensaje;
	}
	

	
	public ParamRegulatoriosBean consulta(int tipoConsulta, ParamRegulatoriosBean paramRegulatoriosBean){
		ParamRegulatoriosBean parRegulatoriosBean = null;
		switch (tipoConsulta) {
			case Enum_Con_ParamRegulatorios.principal:		
				parRegulatoriosBean = paramRegulatoriosDAO.consultaPrincipal(paramRegulatoriosBean, tipoConsulta);								
				break;	
			case Enum_Con_ParamRegulatorios.historico:
				parRegulatoriosBean = paramRegulatoriosDAO.consultaHistorica(paramRegulatoriosBean, tipoConsulta); 
				break;	
		}
		
		return  parRegulatoriosBean;
	}
	
	
	
	
	public ParamRegulatoriosDAO getParamRegulatoriosDAO() {
		return paramRegulatoriosDAO;
	}

	public void setParamRegulatoriosDAO(ParamRegulatoriosDAO paramRegulatoriosDAO) {
		this.paramRegulatoriosDAO = paramRegulatoriosDAO;
	}
	
	
	
	
	
}