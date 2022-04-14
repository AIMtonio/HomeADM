package nomina.servicio;
import java.util.ArrayList;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import nomina.bean.EsqComAperNominaBean;
import nomina.dao.EsqComAperNominaDAO;



public class EsqComAperNominaServicio extends BaseServicio{
	
	EsqComAperNominaDAO esqComAperNominaDAO = null;

	// -------------- Tipo Transaccion ----------------
	public static interface Enum_Tipo_Transaccion{
		int grabar     	= 1;			// Grabar Configuración Esquema
		int modificar   = 2;			// Modificar Configuración Esquema
		int grabarEsq   = 3;
	}
	
	// -------------- Tipo Consulta ----------------
	public static interface Enum_Con_Eaquema{
		int conPrincipal	= 1;
	}
		
	// -------------- Tipo Lista ----------------
	public static interface Enum_Lis_Esquema{
		int lisEsquemaComApert	= 1;		// Lista de Esquemas de Cobro Comision Apertura
	}
	
	public static interface Enum_Con_Esquema{
		int ConPrincipal	= 1;		// Consulta principal Esquema 
		int ConForanea		= 2;		// Consulta foranea Esquema 
		int ConExisteEsqQ	= 3;		// Consulta foranea Esquema 
	}
	
	
	/**
	 * 
	 * @param tipoTransaccion : Tipo de Transacción 
	 * @param EsqComAperNominaBean : Bean de Esquema de Comisión por Apertura
	 * @return
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,EsqComAperNominaBean esqComAperNominaBean) {
	 	MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tipo_Transaccion.grabar:
				mensaje = esqComAperNominaDAO.esqComAperNominaAlt(esqComAperNominaBean);
			break;
			case Enum_Tipo_Transaccion.modificar:
				mensaje = esqComAperNominaDAO.esqComAperNominaMod(esqComAperNominaBean);
			break;
			case Enum_Tipo_Transaccion.grabarEsq:
				mensaje = esqComAperNominaDAO.comApertConvenioGrabar(esqComAperNominaBean,detalleGrid(esqComAperNominaBean));
			break;
		}
		return mensaje;
	}
	
	private List detalleGrid(EsqComAperNominaBean esqComAperNominaBean){
		// Separa las listas del grid en beans individuales	
		List listaDetalle = new ArrayList<EsqComAperNominaBean>();
		
		if (!esqComAperNominaBean.getFila().isEmpty() && esqComAperNominaBean.getFila()!="") {
			int filas = esqComAperNominaBean.getFila().split(",").length;
			String[] convenios = esqComAperNominaBean.getConvenioNominaID().split(",");
			String[] formasCob = esqComAperNominaBean.getFormCobroComAper().split(",");
			String[] tiposCom = esqComAperNominaBean.getTipoComApert().split(",");
			String[] montosMin = esqComAperNominaBean.getMontoMin().split(",");
			String[] montosMax = esqComAperNominaBean.getMontoMax().split(",");
			String[] valores = esqComAperNominaBean.getValor().split(",");
			
			
			EsqComAperNominaBean esqComAperNomina= null;
			for(int i=0;i<filas;i++)
			{
				//Plazos
				String[] listaPlazos =  (esqComAperNominaBean.getLisPlazoID().get(i)+",").replace("[","").replace("]","").split(",");
			    for(String s:listaPlazos)
			    {
			    	if(s!="")
			    	{
			    	esqComAperNomina = new EsqComAperNominaBean();
			    	esqComAperNomina.setEsqComApertID(esqComAperNominaBean.getEsqComApertID());
			    	esqComAperNomina.setConvenioNominaID(convenios[i]);
			    	esqComAperNomina.setFormCobroComAper(formasCob[i]);
			    	esqComAperNomina.setTipoComApert(tiposCom[i]);
			    	esqComAperNomina.setMontoMin(montosMin[i]);
			    	esqComAperNomina.setMontoMax(montosMax[i]);
			    	esqComAperNomina.setValor((valores[i]+"%$").replace("%","").replace("$",""));
			    	esqComAperNomina.setPlazoID(s.trim());
			    	esqComAperNomina.setFila(i+"");
			    	listaDetalle.add(esqComAperNomina);
			    	}
			    }
			}
		}
		return listaDetalle;
	}
	
	
	public EsqComAperNominaBean consulta(int tipoConsulta, EsqComAperNominaBean esqComAperNominaBean) {
		EsqComAperNominaBean resultado = null;

		switch (tipoConsulta) {
		case Enum_Con_Esquema.ConPrincipal:
			resultado = esqComAperNominaDAO.consultaPrincipal(tipoConsulta, esqComAperNominaBean);
			break;
			
		}

		return resultado;
	}
	// =========== GETTER & SETTER =========== //


	public EsqComAperNominaDAO getEsqComAperNominaDAO() {
		return esqComAperNominaDAO;
	}


	public void setEsqComAperNominaDAO(EsqComAperNominaDAO esqComAperNominaDAO) {
		this.esqComAperNominaDAO = esqComAperNominaDAO;
	}
}
