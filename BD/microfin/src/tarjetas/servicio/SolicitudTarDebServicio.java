package tarjetas.servicio;


import java.util.List;

import cliente.bean.ClienteBean;

import cuentas.bean.CuentasAhoBean;
import cuentas.servicio.CuentasAhoServicio.Enum_Act_CuentasAho;

import tarjetas.bean.SolicitudTarDebBean;
import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.dao.SolicitudTarDebDAO;
import tarjetas.servicio.TarjetaDebitoServicio.Enum_Con_tarjetaDebito;
import tarjetas.servicio.TarjetaDebitoServicio.Enum_lis_tarjetaDebito;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;



public class SolicitudTarDebServicio extends BaseServicio {
	
	SolicitudTarDebDAO solicitudTarDebDAO = null;
	
	public SolicitudTarDebServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public static interface Enum_Tra_tarjetaDebito{
		int nuevaTarjeta = 1;
		int reposicion   = 2;
		int actualizacion =3;
	}
	public static interface Enum_Act_tarjetaDebito{
		int actualizacion =3;
		
	}


	public static interface Enum_Lis_tarjetaDebito{
		int listaFolios = 1;
		int listaFoliosTarNueva = 2;
		int listaFoliosTarRep = 3;
	}
	
	public static interface Enum_Con_tarjetaDebito{
		int consultaFolios			= 1;
		int consultaFolioTarNueva	=2;
		int consultaFolioTarRepo	=3;
		int solicNominativa			=4;
	}
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SolicitudTarDebBean solicitudTarDebBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_tarjetaDebito.nuevaTarjeta:
			mensaje = solicitudTarDebDAO.solicitud(tipoTransaccion,solicitudTarDebBean);
			break;
		case Enum_Tra_tarjetaDebito.reposicion:
			mensaje = solicitudTarDebDAO.solicitud(tipoTransaccion,solicitudTarDebBean);
			break;
		case Enum_Tra_tarjetaDebito.actualizacion:
			mensaje = actualiza(solicitudTarDebBean,Enum_Tra_tarjetaDebito.actualizacion);
			break;
		}

		return mensaje;
	}
	
	
	
	public MensajeTransaccionBean actualiza( SolicitudTarDebBean solicitudTarDebBean, int tipoTransaccion){
		MensajeTransaccionBean mensaje = null;
		mensaje = solicitudTarDebDAO.solicitudCancela(tipoTransaccion,solicitudTarDebBean);		
		return mensaje;
	}
	
	
	
	
	
	
	public SolicitudTarDebBean consulta(int tipoConsulta, SolicitudTarDebBean solicitudTarDebBean){
		SolicitudTarDebBean foliosTarjeta = null;
		switch(tipoConsulta){
			case Enum_Con_tarjetaDebito.consultaFolios:
				foliosTarjeta = solicitudTarDebDAO.consulta(Enum_Con_tarjetaDebito.consultaFolios, solicitudTarDebBean);
			break;	
			case Enum_Con_tarjetaDebito.consultaFolioTarNueva:
				foliosTarjeta = solicitudTarDebDAO.consulta(Enum_Con_tarjetaDebito.consultaFolioTarNueva, solicitudTarDebBean);
			break;	
			case Enum_Con_tarjetaDebito.consultaFolioTarRepo:
				foliosTarjeta = solicitudTarDebDAO.consulta(Enum_Con_tarjetaDebito.consultaFolioTarRepo, solicitudTarDebBean);
			break;	
			case Enum_Con_tarjetaDebito.solicNominativa:
				foliosTarjeta = solicitudTarDebDAO.consultaSolNominativa(Enum_Con_tarjetaDebito.solicNominativa, solicitudTarDebBean);
			break;
		}
		return foliosTarjeta;
	}

	public List lista(int tipoLista, SolicitudTarDebBean solicitudTarDebBean){		
		List listaTarjetaDebito = null;
		switch (tipoLista) {
			case Enum_Lis_tarjetaDebito.listaFolios:		
				listaTarjetaDebito = solicitudTarDebDAO.listaFolioTarjetas(solicitudTarDebBean, tipoLista);				
				break;	
			case Enum_Lis_tarjetaDebito.listaFoliosTarNueva:
				listaTarjetaDebito = solicitudTarDebDAO.listaFolioTarjetas(solicitudTarDebBean, tipoLista);		
			break;
			case Enum_Lis_tarjetaDebito.listaFoliosTarRep:
				listaTarjetaDebito = solicitudTarDebDAO.listaFolioTarjetas(solicitudTarDebBean, tipoLista);		
			break;
			
		}			
		return listaTarjetaDebito;
	}
	
	public SolicitudTarDebDAO getSolicitudTarDebDAO() {
		return solicitudTarDebDAO;
	}
	public void setSolicitudTarDebDAO(SolicitudTarDebDAO solicitudTarDebDAO) {
		this.solicitudTarDebDAO = solicitudTarDebDAO;
	}

	
	
	
			
		
									
			

	
}