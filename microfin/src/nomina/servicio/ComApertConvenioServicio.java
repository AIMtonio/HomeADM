package nomina.servicio;
import java.util.ArrayList;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import nomina.bean.ComApertConvenioBean;
import nomina.bean.EsqComAperNominaBean;
import nomina.dao.ComApertConvenioDAO;
import nomina.servicio.EsqComAperNominaServicio.Enum_Con_Esquema;



public class ComApertConvenioServicio extends BaseServicio{
	
	ComApertConvenioDAO comApertConvenioDAO = null;

	// -------------- Tipo Transaccion ----------------
	public static interface Enum_Tipo_Transaccion{
		int grabar     	= 1;			// Grabar Esquema Convenio
	}
	
	// -------------- Tipo Consulta ----------------
	public static interface Enum_Con_Eaquema{
		int conPrincipal	= 1;
	}
		
	// -------------- Tipo Lista ----------------
	public static interface Enum_Lis_Esquema{
		int lisEsquemaConvenios	= 1;		// Lista de Esquemas de Convenio
	}
	
	public static interface Enum_Con_Esquema{
		int ConPrincipal	= 1;		// Consulta principal Esquema Convenio
		int ConOriginacion  = 2;
	}
	
	
	/**
	 * 
	 * @param tipoTransaccion : Tipo de Transacción 
	 * @param comApertConvenioBean : Bean de Esquema de Comisión por Apertura por Convenio
	 * @return
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,ComApertConvenioBean comApertConvenioBean) {
	 	MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tipo_Transaccion.grabar:
				ArrayList listaDetalleGrid = (ArrayList) detalleGrid(comApertConvenioBean);
				mensaje = comApertConvenioDAO.comApertConvenioGrabar(comApertConvenioBean,listaDetalleGrid);
			break;
		}
		return mensaje;
	}
	
	
	/**
	 * 
	 * @param comApertConvenioBean : Bean de Esquema de Comisión por Apertura por Convenio
	 * @return
	 */
	private List detalleGrid(ComApertConvenioBean comApertConvenioBean){
		// Separa las listas del grid en beans individuales	
		List<String> listaConvenio = comApertConvenioBean.getLisConvenioId();
		List<String> listaPlazo = comApertConvenioBean.getLisPlazoID();
		
		ArrayList listaDetalle = new ArrayList();
		ComApertConvenioBean iterComApertConvenioBean  = null; 
		int tamanioConvenios = 0;
		int tamanioPlazo = 0;
		
		if(listaConvenio != null){
			tamanioConvenios = listaConvenio.size();
		}
		if(listaPlazo != null){
			tamanioPlazo = listaPlazo.size();
		}
		for(int i = 0; i < tamanioConvenios; i++){
			for(int j=0;j<tamanioPlazo;j++)
			{
				iterComApertConvenioBean = new ComApertConvenioBean();
				iterComApertConvenioBean.setEsqComApertID(comApertConvenioBean.getEsqComApertID());
				iterComApertConvenioBean.setConvenioNominaID(listaConvenio.get(i));
				iterComApertConvenioBean.setFormCobroComAper(comApertConvenioBean.getFormCobroComAper());
				iterComApertConvenioBean.setTipoComApert(comApertConvenioBean.getTipoComApert());
				iterComApertConvenioBean.setMontoMin(comApertConvenioBean.getMontoMin());
				iterComApertConvenioBean.setMontoMax(comApertConvenioBean.getMontoMax());
				iterComApertConvenioBean.setValor(comApertConvenioBean.getValor());
				iterComApertConvenioBean.setPlazoID(listaPlazo.get(j));
				listaDetalle.add(iterComApertConvenioBean);
			}
		}
		return listaDetalle;
	}
	
	/**
	 * 
	 * @param tipoLista : Tipo de Lista
	 * @param comApertConvenioBean : Bean de Esquema de Comisión por Apertura por Convenio
	 * @return
	 */
	public List lista(int tipoLista, ComApertConvenioBean comApertConvenioBean){
		List comApertConvenioLista = null;
		 switch (tipoLista) {
		    case  Enum_Lis_Esquema.lisEsquemaConvenios:          
		    	comApertConvenioLista = comApertConvenioDAO.listaEsquemaConvenios(comApertConvenioBean, tipoLista);
		    	comApertConvenioLista = listaAgrupadaPorFila(comApertConvenioLista);
		    break;
		}
		return comApertConvenioLista;
	}
	
	private List listaAgrupadaPorFila(List comApertConvenioLista)
	{
		List comApertConvenioListaAgrup = new ArrayList<ComApertConvenioBean>();
		ComApertConvenioBean comApertConvenioBean = null;
		boolean enLista = false;
		for(int i=0;i<comApertConvenioLista.size();i++)
		{
			comApertConvenioBean = null;
			for(int j=0;j<comApertConvenioListaAgrup.size();j++)
			{
				if(((ComApertConvenioBean)comApertConvenioListaAgrup.get(j)).getFila().equals(
				   ((ComApertConvenioBean)comApertConvenioLista.get(i)).getFila()))
				{
					comApertConvenioBean = (ComApertConvenioBean)comApertConvenioListaAgrup.get(j);
					break;
				}
			}
			if(comApertConvenioBean!=null)
			{
				enLista = false;
				for(int k=0;k<comApertConvenioBean.getLisPlazoID().size();k++)
				{
					if(comApertConvenioBean.getLisPlazoID().get(k)==((ComApertConvenioBean)comApertConvenioLista.get(i)).getPlazoID())
					{	
						enLista = true;
						break;
					}
				}
				if(!enLista)
				comApertConvenioBean.getLisPlazoID().add(((ComApertConvenioBean)comApertConvenioLista.get(i)).getPlazoID());
			}
			else
			{
				((ComApertConvenioBean)comApertConvenioLista.get(i)).setLisPlazoID(new ArrayList<String>());
				((ComApertConvenioBean)comApertConvenioLista.get(i)).getLisPlazoID().add(
						((ComApertConvenioBean)comApertConvenioLista.get(i)).getPlazoID()
				);
				comApertConvenioListaAgrup.add(comApertConvenioLista.get(i));
			}
		}
		
		return comApertConvenioListaAgrup;
	}
	
	public ComApertConvenioBean consulta(int tipoConsulta, ComApertConvenioBean comApertConvenioBean) {
		ComApertConvenioBean resultado = null;

		switch (tipoConsulta) {
		case Enum_Con_Esquema.ConOriginacion:
			resultado = comApertConvenioDAO.consulta(tipoConsulta, comApertConvenioBean);
			break;
			
		}

		return resultado;
	}

	public ComApertConvenioDAO getComApertConvenioDAO() {
		return comApertConvenioDAO;
	}


	public void setComApertConvenioDAO(ComApertConvenioDAO comApertConvenioDAO) {
		this.comApertConvenioDAO = comApertConvenioDAO;
	}

}
