package soporte.servicio;

import java.util.List;

import soporte.bean.FirmaRepresentLegalBean;
import soporte.dao.FirmaRepresentLegalDAO;
import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
 
public class FirmaRepresentLegalServicio extends BaseServicio{
	FirmaRepresentLegalDAO firmaRepresentLegalDAO=null;
	
	public FirmaRepresentLegalServicio(){
		super();
	}
	
	public static interface Enum_Tra_firmaRepre{
		int adjuntar = 1; 
		int baja=2;
	}
	public static interface Enum_Lis_firmaRepre{
		int gridFirmas = 1; 
	}
	
	public MensajeTransaccionArchivoBean grabaTransaccion(int tipoTransaccion, FirmaRepresentLegalBean firmaBean){
		MensajeTransaccionArchivoBean mensaje= new MensajeTransaccionArchivoBean();
		switch(tipoTransaccion){
			case Enum_Tra_firmaRepre.adjuntar:
				mensaje = firmaRepresentLegalDAO.altaArchivosFirma(firmaBean);
			break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionArchivoBean bajaFirma(int tipoTransaccion,FirmaRepresentLegalBean firmaBean){
		MensajeTransaccionArchivoBean mensaje = null;		
		try{
			switch(tipoTransaccion){
			case Enum_Tra_firmaRepre.baja:		
				mensaje = firmaRepresentLegalDAO.bajaDeFirma(firmaBean);		
				break;				
		}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en transaccion de Firma", e);
		}
		
		return mensaje;
	}
	
	public List listaFirmasGrid(int tipoLista,FirmaRepresentLegalBean firmaRepresentLegalBean){
		List firmaArchivos=null;
		switch(tipoLista){
			case Enum_Lis_firmaRepre.gridFirmas:
					firmaArchivos = firmaRepresentLegalDAO.firmasArchivoGrid(firmaRepresentLegalBean,tipoLista);
				break;
		}
		return firmaArchivos;
	}
	public FirmaRepresentLegalDAO getFirmaRepresentLegalDAO() {
		return firmaRepresentLegalDAO;
	}

	public void setFirmaRepresentLegalDAO(
			FirmaRepresentLegalDAO firmaRepresentLegalDAO) {
		this.firmaRepresentLegalDAO = firmaRepresentLegalDAO;
	}
	
}
