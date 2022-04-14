package seguimiento.servicio;

import java.util.List;

import seguimiento.bean.SegtoManualBean;
import seguimiento.dao.SegtoManualDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class SegtoManualServicio extends BaseServicio {

	SegtoManualDAO segtoManualDAO = null;
	public SegtoManualServicio(){
		super();
	}
	
	
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_SegtoProgra {
		int principal	= 1;
		int foranea		= 2;
		int tipConCred 	= 3;
		int tipConGrup 	= 4;
		int tipConAval 	= 5;
		int supervisor 	= 6;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Segto {
		int calPrinc = 1;
		int foranea = 2;
		int calxMes = 3;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_Alta {
		int alta = 1;
		int modifica = 2;
		int elimina =3;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SegtoManualBean segtoManualBean){
		MensajeTransaccionBean mensaje = null;
		
		int tipoBaja = 1;
		switch (tipoTransaccion) {
			case Enum_Tra_Alta.alta:		
				mensaje = segtoManualDAO.alta(segtoManualBean);				
				break;				
			case Enum_Tra_Alta.modifica:
				mensaje =segtoManualDAO.modifica(segtoManualBean);				
				break;
			case Enum_Tra_Alta.elimina:
				mensaje =segtoManualDAO.elimina(segtoManualBean, tipoBaja);
				break;
		}
		return mensaje;
	}

	
	public SegtoManualBean consulta (int tipoConsulta, SegtoManualBean segtoManualBean){
		SegtoManualBean segtoManual = null;
		switch (tipoConsulta) {
			case Enum_Con_SegtoProgra.principal:		
				segtoManual = segtoManualDAO.consultaPrincipal(segtoManualBean, tipoConsulta);				
				break;
			case Enum_Con_SegtoProgra.tipConCred:		
				segtoManual = segtoManualDAO.consultaSolCred(segtoManualBean, tipoConsulta);				
				break;
			case Enum_Con_SegtoProgra.tipConGrup:		
				segtoManual = segtoManualDAO.consultaSolGrup(segtoManualBean, tipoConsulta);				
				break;	
			case Enum_Con_SegtoProgra.tipConAval:		
				segtoManual = segtoManualDAO.consultaAvales(segtoManualBean, tipoConsulta);				
				break;
			case Enum_Con_SegtoProgra.supervisor:		
				segtoManual = segtoManualDAO.consultaSupervisor(segtoManualBean, tipoConsulta);				
				break;
			}
		return segtoManual;
	}
	
	public List lista(int tipoLista, SegtoManualBean segtoManualBean){
		List listaCreditos = null;
		switch (tipoLista) {
			case Enum_Lis_Segto.calPrinc:		
				listaCreditos=  segtoManualDAO.ListaCalPrincipal(Enum_Lis_Segto.calPrinc,segtoManualBean );				
				break;
			case Enum_Lis_Segto.foranea:		
				listaCreditos=  segtoManualDAO.ListaForanea(Enum_Lis_Segto.foranea,segtoManualBean );				
				break;
			case Enum_Lis_Segto.calxMes:		
				listaCreditos=  segtoManualDAO.ListaCalPorMes(Enum_Lis_Segto.calxMes,segtoManualBean );				
				break;
		}
		return listaCreditos;
	}


	public SegtoManualDAO getSegtoManualDAO() {
		return segtoManualDAO;
	}

	public void setSegtoManualDAO(SegtoManualDAO segtoManualDAO) {
		this.segtoManualDAO = segtoManualDAO;
	}	
}