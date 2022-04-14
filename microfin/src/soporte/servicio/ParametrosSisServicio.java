package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import soporte.bean.ParametrosSisBean;
import soporte.dao.ParametrosSisDAO;

public class ParametrosSisServicio extends BaseServicio {
	//---------- Variables ---------------------------------
		ParametrosSisDAO parametrosSisDAO = null;
	
	public ParametrosSisServicio() {
		super();
	}
	
	public static interface Enum_Tra_ParametrosSis {
		int	alta			= 1;
		int	modificacion	= 2;
	}
	public static interface Enum_Act_ParametrosSis {
		int	actualizacionPLD	= 1;
	}
	// tipo de consulta
	public static interface Enum_Con_ParametrosSis {
		int	principal				= 1;
		int	paramEdoCtaCons			= 5;
		int	timbrado				= 6;
		int	fechaHora				= 7;
		int	representanteLegal		= 8;
		int	consultaFechaAnterior	= 9;
		int	conDatosCte				= 10;
		int	cambiaPromotor			= 12;
		int	principalExterna		= 13;
		int	conDatosCteExterno		= 14;
		int	tipoInstitFin			= 15;
		int	paramSeccionEsp			= 16;	// Parametros que habilitan segmentos especificos del cliente
		int	calculaCURPyRFC			= 17;
		int fechaConsDisp			= 18;
		int oficialCumplimiento		= 19;
		int validaCFDI				= 21;
		int configContra			= 23;
		int valRolFlujoSol			= 24;
		int cierreAutomatico		= 27;
		int cargaLayoutXLSDepRef	= 31;
	}
	
	public static interface Enum_Lis_ParametrosSis {
		int	principal		= 1;
		int	representLegal	= 2;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParametrosSisBean parametrosSisBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_ParametrosSis.alta :
				mensaje = altaParametrosSis(parametrosSisBean);
				break;
			case Enum_Tra_ParametrosSis.modificacion :
				mensaje = modificaParametrosSis(parametrosSisBean);
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean actualizacion(int tipoTransaccion, ParametrosSisBean parametrosSisBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Act_ParametrosSis.actualizacionPLD :
				mensaje = parametrosSisDAO.actualizacionPLD(parametrosSisBean,tipoTransaccion);
				break;
		}
		return mensaje;
	}
		
	public MensajeTransaccionBean altaParametrosSis(ParametrosSisBean parametrosSisBean) {
		MensajeTransaccionBean mensaje = null;
		mensaje = parametrosSisDAO.altaParametrosSis(parametrosSisBean);
		return mensaje;
	}
	
	public MensajeTransaccionBean modificaParametrosSis(ParametrosSisBean parametrosSisBean) {
		MensajeTransaccionBean mensaje = null;
		mensaje = parametrosSisDAO.modificaParametrosSis(parametrosSisBean);
		return mensaje;
	}

		
		public ParametrosSisBean consulta(int tipoConsulta,ParametrosSisBean parametrosSisB){
			ParametrosSisBean parametrosSisBean = null;
			switch (tipoConsulta) {
				case Enum_Con_ParametrosSis.principal:		
					parametrosSisBean = parametrosSisDAO.consultaPrincipal(parametrosSisB, Enum_Con_ParametrosSis.principal);				
					break;
				case Enum_Con_ParametrosSis.timbrado:		
					parametrosSisBean = parametrosSisDAO.verTimbrado(parametrosSisB, Enum_Con_ParametrosSis.timbrado);				
					break;
				case Enum_Con_ParametrosSis.paramEdoCtaCons:
					parametrosSisBean = parametrosSisDAO.consultaEdoCtaCons(parametrosSisB, Enum_Con_ParametrosSis.paramEdoCtaCons);
					break;
				case Enum_Con_ParametrosSis.fechaHora:
					parametrosSisBean = parametrosSisDAO.consultaFechaHoraWS(parametrosSisB, Enum_Con_ParametrosSis.fechaHora);
					break;
				case Enum_Con_ParametrosSis.representanteLegal:
					parametrosSisBean = parametrosSisDAO.consultaRepresentanteLegal(parametrosSisB, Enum_Con_ParametrosSis.representanteLegal);
					break;
				case Enum_Con_ParametrosSis.consultaFechaAnterior:
					parametrosSisBean = parametrosSisDAO.consultaFechaAnterior(parametrosSisB, Enum_Con_ParametrosSis.consultaFechaAnterior);
					break;
				case Enum_Con_ParametrosSis.conDatosCte:
					parametrosSisBean = parametrosSisDAO.consultaDatosCte(parametrosSisB, Enum_Con_ParametrosSis.conDatosCte);
					break;
				case Enum_Con_ParametrosSis.conDatosCteExterno:
					parametrosSisBean = parametrosSisDAO.consultaDatosCteExterna(parametrosSisB, Enum_Con_ParametrosSis.conDatosCte);
					break;
				case Enum_Con_ParametrosSis.cambiaPromotor:	
					parametrosSisBean = parametrosSisDAO.consultaCambiaPromotor(parametrosSisB, Enum_Con_ParametrosSis.cambiaPromotor);		
					break;
				case Enum_Con_ParametrosSis.principalExterna:						
					parametrosSisBean = parametrosSisDAO.consultaPrincipalExterna(parametrosSisB, Enum_Con_ParametrosSis.principal);				
					break;
				case Enum_Con_ParametrosSis.tipoInstitFin:						
					parametrosSisBean = parametrosSisDAO.consultaTipoInstFin(parametrosSisB, Enum_Con_ParametrosSis.tipoInstitFin);				
					break;
				case Enum_Con_ParametrosSis.paramSeccionEsp:
					parametrosSisBean = parametrosSisDAO.consultaParamSeccionEsp(parametrosSisB, Enum_Con_ParametrosSis.paramSeccionEsp);				
					break;
				case Enum_Con_ParametrosSis.calculaCURPyRFC:
					parametrosSisBean = parametrosSisDAO.consultaCalculaCURPyRFC(parametrosSisB, Enum_Con_ParametrosSis.calculaCURPyRFC);				
					break;	
				case Enum_Con_ParametrosSis.fechaConsDisp:
					parametrosSisBean = parametrosSisDAO.consultaFechaConsultaDisp(parametrosSisB, Enum_Con_ParametrosSis.fechaConsDisp);				
					break;	
				case Enum_Con_ParametrosSis.oficialCumplimiento:
					parametrosSisBean = parametrosSisDAO.consultaOficialCumplimiento(parametrosSisB, Enum_Con_ParametrosSis.oficialCumplimiento);				
					break;
				case Enum_Con_ParametrosSis.validaCFDI:
					parametrosSisBean = parametrosSisDAO.consultaParametroValidaCFDI(parametrosSisB,Enum_Con_ParametrosSis.validaCFDI);
					break;
				case Enum_Con_ParametrosSis.configContra:
					parametrosSisBean = parametrosSisDAO.consultaParamConfigContra(parametrosSisB,Enum_Con_ParametrosSis.configContra);
					break;
				case Enum_Con_ParametrosSis.valRolFlujoSol:
					parametrosSisBean = parametrosSisDAO.consultaValRolFlujoSol(parametrosSisB,Enum_Con_ParametrosSis.valRolFlujoSol);
					break;
				case Enum_Con_ParametrosSis.cierreAutomatico:
					parametrosSisBean = parametrosSisDAO.consultaCierreAutomatico(parametrosSisB,Enum_Con_ParametrosSis.cierreAutomatico);
					break;
				case Enum_Con_ParametrosSis.cargaLayoutXLSDepRef:
					parametrosSisBean = parametrosSisDAO.consultaCargaLayoutXLSDepRef(parametrosSisB,Enum_Con_ParametrosSis.cargaLayoutXLSDepRef);
					break;
					
			}
			
			return parametrosSisBean;
		}		

		public List lista(int tipoLista, ParametrosSisBean parametrosSisBean){		
			List listaParametrosSis = null;
			switch (tipoLista) {
				case Enum_Lis_ParametrosSis.principal:		
					listaParametrosSis = parametrosSisDAO.listaPrincipal(parametrosSisBean, tipoLista);				
					break;
				case Enum_Lis_ParametrosSis.representLegal:		
					listaParametrosSis = parametrosSisDAO.listaRepresentLegal(parametrosSisBean, tipoLista);				
					break;		
			}		
			return listaParametrosSis;
		}	
		
		
		//------------------ Getters y Setters ------------------------------------------------------	
		public void setParametrosSisDAO(ParametrosSisDAO parametrosSisDAO) {
			this.parametrosSisDAO = parametrosSisDAO;
		}

		public ParametrosSisDAO getParametrosSisDAO() {
			return parametrosSisDAO;
		}				
}