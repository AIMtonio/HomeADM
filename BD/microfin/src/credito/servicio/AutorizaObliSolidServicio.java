package credito.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.StringTokenizer;

import credito.bean.AutorizaObliSolidBean;
import credito.bean.AutorizaObliSolidDetalleBean;
import credito.bean.ObliSolidariosPorSoliciDetalleBean;
import credito.dao.AutorizaObliSolidDAO;
import credito.servicio.OblSoliPorSoliciServicio.Enum_Con_OblSolidarios;
import credito.servicio.OblSoliPorSoliciServicio.Enum_Lis_oblSolidarios;

public class AutorizaObliSolidServicio extends BaseServicio {

	private AutorizaObliSolidServicio(){
		super();
	}

	AutorizaObliSolidDAO autorizaObliSolidDAO = null;
	
	
	public static interface Enum_Lis_Obligados{
		int alfanumerica = 1;
		int listReestructura = 2;
	}
	
	public static interface Enum_Con_Obligados{
		int principal = 1;
		int OblAsignPorSoli = 2;
	}
	
	public static interface Enum_Tra_Obligados {
		int alta = 1;
		int baja = 2;
		int actualiza = 3;
		
	}
	
	public static interface Enum_Baj_Obligados {
		int AvPorSol	= 1;
	}

	
	public MensajeTransaccionBean grabaListaObligados(int tipoTransaccion, AutorizaObliSolidBean autorizaObliSolidBean, String integraDetalle){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ArrayList listaObligadosDetalle = (ArrayList) creaListaObligados(autorizaObliSolidBean, integraDetalle);
		switch(tipoTransaccion){
			case Enum_Tra_Obligados.alta:
				mensaje = autorizaObliSolidDAO.grabaListaObligados(autorizaObliSolidBean, listaObligadosDetalle, Enum_Baj_Obligados.AvPorSol);
				break;
			case Enum_Tra_Obligados.actualiza:
				mensaje = autorizaObliSolidDAO.actualizaListaObligados(autorizaObliSolidBean, listaObligadosDetalle, Enum_Baj_Obligados.AvPorSol);
				break;
		}
		return mensaje;
	}
	
	private List creaListaObligados(AutorizaObliSolidBean integra, String IntegraDetalle){		
		StringTokenizer tokensBean = new StringTokenizer(IntegraDetalle, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaObligadosDetalle = new ArrayList();
		AutorizaObliSolidBean autorizaObliSolidBean;
		
		while(tokensBean.hasMoreTokens()){
			autorizaObliSolidBean = new AutorizaObliSolidBean();
		
		stringCampos = tokensBean.nextToken();		
		tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");

		autorizaObliSolidBean.setSolicitudCreditoID(tokensCampos[0]);
		autorizaObliSolidBean.setObligadoID(tokensCampos[1]);
		autorizaObliSolidBean.setClienteID(tokensCampos[2]);
		autorizaObliSolidBean.setProspectoID(tokensCampos[3]);
		autorizaObliSolidBean.setTiempoConocido(tokensCampos[4]);
		autorizaObliSolidBean.setParentescoID(tokensCampos[5]);
		
		
		listaObligadosDetalle.add(autorizaObliSolidBean);
		}
		
		return listaObligadosDetalle;
	}
	
	public List lista(int tipoLista, AutorizaObliSolidBean obligados){		
		List listaAvales = null;
		switch (tipoLista) {
			case Enum_Lis_Obligados.alfanumerica:		
				listaAvales=  autorizaObliSolidDAO.listaAlfanumerica(obligados, Enum_Lis_Obligados.alfanumerica);	
				break;	
			case Enum_Lis_Obligados.listReestructura:		
				listaAvales=  autorizaObliSolidDAO.listaObligadosReest(obligados, Enum_Lis_Obligados.listReestructura);				
				break;	
		}		
		return listaAvales;
	}

	public AutorizaObliSolidDetalleBean consulta(int tipoConsulta, AutorizaObliSolidDetalleBean autorizaObliSolidDetalleBean){
		AutorizaObliSolidDetalleBean obligados = null;
		switch(tipoConsulta){
			case Enum_Con_Obligados.OblAsignPorSoli:
				obligados = autorizaObliSolidDAO.consultaOblAsignPorSoli(autorizaObliSolidDetalleBean, Enum_Con_Obligados.OblAsignPorSoli);
			break;
		}
		return obligados;
	}

	public AutorizaObliSolidDAO getAutorizaObliSolidDAO() {
		return autorizaObliSolidDAO;
	}

	public void setAutorizaObliSolidDAO(AutorizaObliSolidDAO autorizaObliSolidDAO) {
		this.autorizaObliSolidDAO = autorizaObliSolidDAO;
	}

	

	
}

