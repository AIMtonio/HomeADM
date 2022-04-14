package aportaciones.servicio;

import java.util.List;

import aportaciones.bean.AportacionesAnclajeBean;
import aportaciones.dao.AportacionesAnclajeDAO;
import cuentas.servicio.MonedasServicio;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class AportacionesAnclajeServicio extends BaseServicio{

	AportacionesAnclajeDAO aportacionesAnclajeDAO = null;
	MonedasServicio monedasServicio = null;

	//---------- Constructor ------------------------------------------------------------------------
	public AportacionesAnclajeServicio(){
		super();
	}


	public static interface Enum_Tra_AportacionesAnclaje{
		int alta				    = 1;
	}

	public static interface Enum_Con_AportacionesAnclaje {
		int principal 				= 1;
		int foranea					= 2;
		int anclaje                 = 3;
		int anclajeHijo             = 4;
	}

	public static interface Enum_Lis_AportacionesAnclaje {
		int general 	=1;
		int anclaje 	=2;
		int sinAnclaje	=3;
	}


	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, AportacionesAnclajeBean aportacionesAnclajeBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case(Enum_Tra_AportacionesAnclaje.alta):
			mensaje = aportacionesAnclajeDAO.alta(aportacionesAnclajeBean, tipoTransaccion);
		break;

		}

		return mensaje;
	}

	public AportacionesAnclajeBean consulta(int tipoConsulta, AportacionesAnclajeBean aportacionesAnclajeBean){

		AportacionesAnclajeBean aportacionesAnclaBean = null;

		switch(tipoConsulta){
		case(Enum_Con_AportacionesAnclaje.principal):
			aportacionesAnclaBean = aportacionesAnclajeDAO.consultaPrincipal(aportacionesAnclajeBean, tipoConsulta);
		break;
		case(Enum_Con_AportacionesAnclaje.foranea):
			aportacionesAnclaBean = aportacionesAnclajeDAO.consultaForanea(aportacionesAnclajeBean, tipoConsulta);
		break;
		case(Enum_Con_AportacionesAnclaje.anclaje):
			aportacionesAnclaBean = aportacionesAnclajeDAO.consultaAnclaje(aportacionesAnclajeBean, tipoConsulta);
		break;
		case(Enum_Con_AportacionesAnclaje.anclajeHijo):
			aportacionesAnclaBean = aportacionesAnclajeDAO.consultaAnclaje(aportacionesAnclajeBean, tipoConsulta);
		break;
		}
		return aportacionesAnclaBean;
	}

	public List lista(int tipoLista, AportacionesAnclajeBean aportacionesAnclajeBean){
		List inverLista = null;

		switch (tipoLista) {
		case  Enum_Lis_AportacionesAnclaje.general:
			inverLista = aportacionesAnclajeDAO.listaPrincipal(aportacionesAnclajeBean, tipoLista);
			break;
		case  Enum_Lis_AportacionesAnclaje.anclaje:
			inverLista = aportacionesAnclajeDAO.listaConAnclaje(aportacionesAnclajeBean, tipoLista);
			break;
		case  Enum_Lis_AportacionesAnclaje.sinAnclaje:
			inverLista = aportacionesAnclajeDAO.listaSinAnclaje(aportacionesAnclajeBean, tipoLista);
			break;
		}
		return inverLista;
	}

	public AportacionesAnclajeDAO getAportacionesAnclajeDAO() {
		return aportacionesAnclajeDAO;
	}

	public void setAportacionesAnclajeDAO(
			AportacionesAnclajeDAO aportacionesAnclajeDAO) {
		this.aportacionesAnclajeDAO = aportacionesAnclajeDAO;
	}

	public MonedasServicio getMonedasServicio() {
		return monedasServicio;
	}

	public void setMonedasServicio(MonedasServicio monedasServicio) {
		this.monedasServicio = monedasServicio;
	}

}