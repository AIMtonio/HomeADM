package inversiones.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import inversiones.bean.MontoInversionBean;
import inversiones.dao.MontosInversionDAO;
import inversiones.servicio.DiasInversionServicio.Enum_Lis_DiasInver;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

public class MontoInversionServicio extends BaseServicio {
	
	// ------------------ Propiedades y Atributos ------------------------------------------
	MontosInversionDAO montosInversionDAO = null;
	
	private MontoInversionServicio(){
		super();
	}

	public static interface Enum_Tra_MontosInver {
		int alta = 1;
		int modificacion = 2;
	}

	public static interface Enum_Con_MontosInver{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_MontosInver{
		int principal = 1;
		int foranea = 2;
	}
	
	
	public MensajeTransaccionBean grabaListaMontosInversion(int tipoTransaccion, MontoInversionBean montoInversion,
															String plazosInferior, String plazosSuperior){
		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"servicio antes de la lista: "+ plazosSuperior);				
		ArrayList listaMontosInversion = (ArrayList) creaListaMontosInversion(montoInversion, plazosInferior, plazosSuperior);
		mensaje = montosInversionDAO.grabaListaMontosInversion(montoInversion, listaMontosInversion);
		return mensaje;		
	}
	

	public List lista(int tipoLista, MontoInversionBean montoInversion){

		List montosInverLista = null;

		switch (tipoLista) {
			case Enum_Lis_MontosInver.principal:
				montosInverLista = montosInversionDAO.lista(montoInversion, tipoLista);
				break;
		}
		return montosInverLista;
	}

	public Object[] listaCombo(int tipoLista, MontoInversionBean montoInversion){

		List montosInverLista = null;

		switch (tipoLista) {
			case Enum_Lis_MontosInver.foranea:
				montosInverLista = montosInversionDAO.listaForanea(montoInversion, tipoLista);
				break;
		}
		return montosInverLista.toArray();
	}
	
	
	private List creaListaMontosInversion(MontoInversionBean montoInversion,
										String plazosInferior,
			   							String plazosSuperior){

		StringTokenizer tokensInferior = new StringTokenizer(plazosInferior, ",");
		StringTokenizer tokensSuperior = new StringTokenizer(plazosSuperior, ",");
		loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"despues de tonkenizer: "+ tokensSuperior);
		ArrayList listaMontos = new ArrayList();
		MontoInversionBean montoInversionBean;
		
		String montosInferior[] = new String[tokensInferior.countTokens()];
		String montosSuperior[] = new String[tokensSuperior.countTokens()];
		
		int i=0;		
		
		while(tokensInferior.hasMoreTokens()){
			montosInferior[i] = tokensInferior.nextToken();
			i++;
		}
		i=0;
		while(tokensSuperior.hasMoreTokens()){
			montosSuperior[i] = tokensSuperior.nextToken();
			i++;
		}
		
		for(int contador=0; contador < montosInferior.length; contador++){		
			loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Monto Servicio for: "+ montosSuperior[contador]);
			montoInversionBean = new MontoInversionBean();
			montoInversionBean.setTipoInversionID(montoInversion.getTipoInversionID());
			montoInversionBean.setPlazoInferior(montosInferior[contador]);
			montoInversionBean.setPlazoSuperior(montosSuperior[contador]);
			loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Monto Servicio: "+ montoInversionBean.getPlazoSuperior());
			listaMontos.add(montoInversionBean);
		}
		return listaMontos;
	}


	//--------------- 
	public void setMontosInversionDAO(MontosInversionDAO montosInversionDAO) {
		this.montosInversionDAO = montosInversionDAO;
	}


	public MontosInversionDAO getMontosInversionDAO() {
		return montosInversionDAO;
	}

	
	
}
