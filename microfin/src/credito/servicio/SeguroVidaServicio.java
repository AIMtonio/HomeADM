package credito.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import credito.bean.SeguroVidaBean;
import credito.dao.SeguroVidaDAO;

public class SeguroVidaServicio extends BaseServicio {
	
	//---------- Constructor ------------------------------------------------------------------------
	public SeguroVidaServicio() {
		super();
	}

	
	//---------- Variables ------------------------------------------------------------------------
	SeguroVidaDAO seguroVidaDAO = null;	
	
	
	public static interface Enum_Con_SeguroVida {
		int principal 				= 1;
		int porCreditoSolicitud	= 2;
	}
	public static interface Enum_Lis_SeguroVida {
		int segBeneficiario 		= 2;
		int segBeneficiarioCobro	=3;
	}
	
	//---------- Consultas ------------------------------------------------------------------------

	public SeguroVidaBean consulta(int tipoConsulta, SeguroVidaBean seguroVidaBean){
		SeguroVidaBean seguroVida = null;
		switch(tipoConsulta){
			case Enum_Con_SeguroVida.principal:				
				seguroVida = seguroVidaDAO.consultaPrincipal(seguroVidaBean, tipoConsulta);
			break;	
			case Enum_Con_SeguroVida.porCreditoSolicitud:
				seguroVida = seguroVidaDAO.consultaPorCreditoSolicitud(seguroVidaBean, tipoConsulta);
			break;
		}
		return seguroVida;
	}
//--------------------LISTAS--------------------------------------------------------------------------
	public List lista(int tipoLista, SeguroVidaBean seguroVidaBean){		
		List listaSeguro = null;
		switch (tipoLista) {
			case Enum_Lis_SeguroVida.segBeneficiario:		
				listaSeguro = seguroVidaDAO.listaBeneficiario(seguroVidaBean, tipoLista);				
				break;	
			case Enum_Lis_SeguroVida.segBeneficiarioCobro:		
				listaSeguro = seguroVidaDAO.listaBeneficiario(seguroVidaBean, tipoLista);				
				break;	
		}		
		return listaSeguro;
	}
	//-------------------------------------------------------------------------------------------------
	// -------------------- TRANSACCIONES (ALTAS MODIFICACIONES, ACTUALIZACIONES)
	//-------------------------------------------------------------------------------------------------	
	
	public MensajeTransaccionBean altaSeguroVida(SeguroVidaBean seguroVidaBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = seguroVidaDAO.altaSeguroVida(seguroVidaBean);

		return mensaje;
	}

	public MensajeTransaccionBean modificacionSeguroVida(SeguroVidaBean seguroVidaBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = seguroVidaDAO.modificaSeguroVida(seguroVidaBean);

		return mensaje;
	}
	
	//---------- Setters ------------------------------------------------------------------------
	
	public void setSeguroVidaDAO(SeguroVidaDAO seguroVidaDAO) {
		this.seguroVidaDAO = seguroVidaDAO;
	}
	public SeguroVidaDAO getSeguroVidaDAO() {
		return seguroVidaDAO;
	}

	
}
