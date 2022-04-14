package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import originacion.bean.InstruccionDispersionBean;
import originacion.bean.SolicitudCheckListBean;
import originacion.bean.SolicitudCreditoBean;
import originacion.dao.InstruccionDispersionDAO;
import originacion.servicio.SolicitudCreditoServicio.Enum_Con_SolCredito;



public class InstruccionDispersionServicio extends BaseServicio{

	
	InstruccionDispersionDAO instruccionDispersionDAO =null;
	
	public InstruccionDispersionServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	//
	public static interface Enum_Tra_InstruccionDispercion{
		int alta = 1;
		int autoriza = 2;
	}


	
	public static interface Enum_Lis_InstruccionDispercion {
		int nuevo = 0;
		int principal = 1;
	}
	
	public static interface Enum_Con_InstruccionDispercion {
		int consultaDispersion = 1;
	}
	
	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,String altainstruccionDispersion,InstruccionDispersionBean instruccionDispersionBean) {
		MensajeTransaccionBean mensaje = null;		
		

		switch(tipoTransaccion){		
		case Enum_Tra_InstruccionDispercion.alta:
			ArrayList listaaltainstruccionDispersion= (ArrayList) creaListaAltaInstruccionDispersion(altainstruccionDispersion,instruccionDispersionBean);
			mensaje = instruccionDispersionDAO.grabainstruccioDispersion(listaaltainstruccionDispersion);			
			break;
		case Enum_Tra_InstruccionDispercion.autoriza:
			mensaje = instruccionDispersionDAO.actualizainstrusccionDispersion(instruccionDispersionBean,1);			
			break;	
		}
		
		return mensaje;
	
	}
	
	// grabainstruccioDispersion
	private List creaListaAltaInstruccionDispersion(String datosAltainstruccionDispersion,InstruccionDispersionBean bajainstruccionDispersionBean){		
		StringTokenizer tokensBean = new StringTokenizer(datosAltainstruccionDispersion, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaAltainstruccionDispersion = new ArrayList();
		InstruccionDispersionBean instruccionDispersionBean;
		
		
		while(tokensBean.hasMoreTokens()){
			instruccionDispersionBean = new InstruccionDispersionBean();
			
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			
			instruccionDispersionBean.setTipoDispersion(tokensCampos[0]);
			instruccionDispersionBean.setBeneficiario(tokensCampos[1]);
			instruccionDispersionBean.setCuenta(tokensCampos[2]);
			instruccionDispersionBean.setMontoDispersion(tokensCampos[3]);
			instruccionDispersionBean.setPermiteModificar(tokensCampos[4]);
			instruccionDispersionBean.setSolicitudCreditoID(tokensCampos[5]);
			listaAltainstruccionDispersion.add(instruccionDispersionBean);
			
			
		}
		instruccionDispersionDAO.bajaBenficiarioDispersion(bajainstruccionDispersionBean);
		return listaAltainstruccionDispersion;
	 }

	//lista para el grid				
	public List listainstruccionDispersion(int tipoLista, InstruccionDispersionBean instruccionDispersionBean){		
		List listaEsquema= null;
		switch (tipoLista) {
			case Enum_Lis_InstruccionDispercion.nuevo:
			case Enum_Lis_InstruccionDispercion.principal:
				listaEsquema = instruccionDispersionDAO.listaGridinstruccionesDispersion(instruccionDispersionBean, tipoLista);				
				break;	
		}		
		return listaEsquema;
	}
	public InstruccionDispersionBean consulta(int tipoConsulta, InstruccionDispersionBean instruccionDispersionBean) {
		InstruccionDispersionBean instruccionDisperBean = null;
		switch (tipoConsulta) {
			case Enum_Con_InstruccionDispercion.consultaDispersion:
			
				instruccionDisperBean = instruccionDispersionDAO.consultaDispersion(instruccionDispersionBean, tipoConsulta);
				break;
			
		}

		return instruccionDisperBean;
	}

// ---------------setter y getter----------------------------------
	public InstruccionDispersionDAO getInstruccionDispersionDAO() {
		return instruccionDispersionDAO;
	}
	public void setInstruccionDispersionDAO(
			InstruccionDispersionDAO instruccionDispersionDAO) {
		this.instruccionDispersionDAO = instruccionDispersionDAO;
	}
	
}
