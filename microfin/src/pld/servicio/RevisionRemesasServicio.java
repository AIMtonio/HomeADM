package pld.servicio;

import java.util.List;

import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import pld.bean.RevisionRemesasBean;
import pld.dao.RevisionRemesasDAO;

public class RevisionRemesasServicio extends BaseServicio{
	
	public RevisionRemesasServicio(){
		super();
	}
	
	RevisionRemesasDAO revisionRemesasDAO = null;

	//---------- Tipos de Transacciones------------
	public static interface Enum_Tra_RevisionRem {
		int grabar   = 1;	// Grabar Revisión de Remesas
	}
	
	// -------- Tipo Transaccion Documentos ---------
	public static interface Enum_Tra_DocumentosRemesas {
		int altaDocsRemesas		= 1; 	//	Alta de Documentos de Revisión de Remesas
	}
	
	//---------- Tipos de Consulta ----------------
	public static interface Enum_Con_RevisionRem {
		int refereRemesa 			= 1;	// Consulta de Referencia de Remesas
		int numDocCheckListRemesa 	= 2;	// Consulta Número de Documentos de Check List de Remesas
		int refereClabeRemesa		= 3;
	}
		
	// --------- Tipo Lista de Documentos de Revisión de Remesas -----------
	public static interface Enum_Lis_DocRevisionRem{
		int listaDocRevisionRemesas    	= 1; 	// Lista de Documentos de Revisión de Remesas
		int reportePDF					= 2; 	// Opción de lista para crear el expediente de la Revisión de Remesas en formato pdf
	}
	
	// Transacción de Revisión de Remesas
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, RevisionRemesasBean revisionRemesasBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Tra_RevisionRem.grabar:
				mensaje = revisionRemesasDAO.grabarRevisionRemesas(revisionRemesasBean);
			break;
		}
		
		return mensaje;
	}
	
	// Transacción de Documentos de Revisión de Remesas
	public MensajeTransaccionArchivoBean grabaTransaccionDocumento(int tipoTransaccion, RevisionRemesasBean revisionRemesasBean) {
		MensajeTransaccionArchivoBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_DocumentosRemesas.altaDocsRemesas:
				mensaje = altaDocumentosRemesas(revisionRemesasBean);
			break;			
		}
		return mensaje;
	}
	
	// Alta de Documentos de Revisión de Remesas
	public MensajeTransaccionArchivoBean altaDocumentosRemesas(RevisionRemesasBean revisionRemesasBean){
		MensajeTransaccionArchivoBean mensaje = null;
		mensaje = revisionRemesasDAO.altaDocumentosRemesas(revisionRemesasBean);		
		return mensaje;
	}
	
	// Consulta de Revisión de Remesas
	public RevisionRemesasBean consulta(int tipoConsulta, RevisionRemesasBean revisionRemesasBean){
		RevisionRemesasBean revRemesas = null;
		switch (tipoConsulta) {
			case Enum_Con_RevisionRem.refereRemesa:
				revRemesas = revisionRemesasDAO.consultaRefereRemesas(revisionRemesasBean, tipoConsulta);
			break;
			case Enum_Con_RevisionRem.numDocCheckListRemesa:
				revRemesas = revisionRemesasDAO.consultaDocumentosCheckListRemesa(revisionRemesasBean, tipoConsulta);
			break;
			case Enum_Con_RevisionRem.refereClabeRemesa:
				revRemesas = revisionRemesasDAO.conRefereClabeCobRemesas(revisionRemesasBean, tipoConsulta);
			break;
		}
		return revRemesas;
	}
	
	// Lista de Documentos de Revisión de Remesas
	public List listaDocumentosRevRemesas(int tipoLista, RevisionRemesasBean revisionRemesasBean){		
		List listaDocumentosRemesas = null;
		switch (tipoLista) {
			case Enum_Lis_DocRevisionRem.listaDocRevisionRemesas:		
				listaDocumentosRemesas = revisionRemesasDAO.listaDocumentosRevisionRem(revisionRemesasBean, tipoLista);				
			break;	
		}		
		return listaDocumentosRemesas;
	}
	
	// Lista de Archivos de Revisión de Remesas
	public List listaArchivosRevisionRemesas(int tipoLista, RevisionRemesasBean revisionRemesasBean) {
		List listaArchRevRemesas = null;
		switch (tipoLista) {
			case Enum_Lis_DocRevisionRem.reportePDF:
				listaArchRevRemesas = revisionRemesasDAO.listaArchivosReporte(revisionRemesasBean, tipoLista);
			break;
		}
		return listaArchRevRemesas;
	}
	
	// GETTER && SETTER
	public RevisionRemesasDAO getRevisionRemesasDAO() {
		return revisionRemesasDAO;
	}

	public void setRevisionRemesasDAO(RevisionRemesasDAO revisionRemesasDAO) {
		this.revisionRemesasDAO = revisionRemesasDAO;
	}
}
