package inversiones.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import inversiones.dao.DiasInversionDAO;
import inversiones.bean.DiasInversionBean;

public class DiasInversionServicio extends BaseServicio {
	
	private DiasInversionServicio(){
		super();
	}

	DiasInversionDAO diasInversionDAO = null;

	
	public static interface Enum_Tra_DiasInver {
		int alta = 1;
		int modificacion = 2;
	}

	public static interface Enum_Con_DiasInver{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_DiasInver{
		int principal = 1;
		int foranea = 2;
	}
	
	
	public MensajeTransaccionBean grabaListaDiasInversion(int tipoTransaccion, DiasInversionBean diasInversion,
															String plazosInferior, String plazosSuperior){
		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				
		ArrayList listaDiasInversion = (ArrayList) creaListaDiasInversion(diasInversion, plazosInferior, plazosSuperior);
		mensaje = diasInversionDAO.grabaListaDiasInversion(diasInversion, listaDiasInversion);
		return mensaje;		
	}
	

	public List lista(int tipoLista, DiasInversionBean diasInversion){

		List diasInverLista = null;

		switch (tipoLista) {
			case Enum_Lis_DiasInver.principal:
				diasInverLista = diasInversionDAO.lista(diasInversion, tipoLista);
				break;
		}
		return diasInverLista;
	}

	public Object[] listaCombo(int tipoLista, DiasInversionBean diasInversion){

		List diasInverLista = null;

		switch (tipoLista) {
			case Enum_Lis_DiasInver.foranea:
				diasInverLista = diasInversionDAO.listaForanea(diasInversion, tipoLista);
				break;
		}
		return diasInverLista.toArray();
	}
	
	
	private List creaListaDiasInversion(DiasInversionBean diasInversion,
										String plazosInferior,
			   							String plazosSuperior){

		StringTokenizer tokensInferior = new StringTokenizer(plazosInferior, ",");
		StringTokenizer tokensSuperior = new StringTokenizer(plazosSuperior, ",");
		ArrayList listaDias = new ArrayList();
		DiasInversionBean diasInversionBean;
		
		int diasInferior[] = new int[tokensInferior.countTokens()];
		int diasSuperior[] = new int[tokensSuperior.countTokens()];
		
		int i=0;		
		
		while(tokensInferior.hasMoreTokens()){
			diasInferior[i] = Integer.parseInt(tokensInferior.nextToken());
			i++;
		}
		i=0;
		while(tokensSuperior.hasMoreTokens()){
			diasSuperior[i] = Integer.parseInt(tokensSuperior.nextToken());
			i++;
		}
		
		for(int contador=0; contador < diasInferior.length; contador++){			
			diasInversionBean = new DiasInversionBean();
			diasInversionBean.setTipoInvercionID(diasInversion.getTipoInvercionID());
			diasInversionBean.setPlazoInferior(diasInferior[contador]);
			diasInversionBean.setPlazoSuperior(diasSuperior[contador]);
			listaDias.add(diasInversionBean);
		}
		return listaDias;
	}

		
	public void setDiasInversionDAO(DiasInversionDAO diasInversionDAO) {
		this.diasInversionDAO = diasInversionDAO;
	}
	

}