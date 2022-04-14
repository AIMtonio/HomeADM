package tesoreria.servicio;

import java.util.Iterator;
import java.util.List;

import bancaEnLinea.beanWS.request.ConsultaSaldoBloqueoBERequest;
import bancaEnLinea.beanWS.response.ConsultaSaldoBloqueoBEResponse;

import tesoreria.bean.BloqueoBean;
import tesoreria.dao.BloqueoDAO;
import general.servicio.BaseServicio;

public class BloqueoServicio extends BaseServicio{

	private BloqueoServicio(){
		super();
	}
	BloqueoDAO bloqueoDAO = null;
	
	public static interface Enum_Lis_Bloqueo{
		int principal 	= 1;
		int foranea 	= 2;
		int saldoBloq	= 3;
		
	}
	

	public static interface Enum_Con_Bloqueo{
		int principal = 1;
	}
	
	public List lista(int tipoLista, BloqueoBean bloqueo){
		List bloqueoLista = null;

		switch (tipoLista) {
	        case  Enum_Lis_Bloqueo.principal:
				bloqueoLista = bloqueoDAO.listaPrincipal(bloqueo, tipoLista);
	        break;
	        case  Enum_Lis_Bloqueo.saldoBloq:
				bloqueoLista = bloqueoDAO.listaSaldoBloq(bloqueo, tipoLista);
	        break;
		}
		return bloqueoLista;
	}

	
	public BloqueoBean consulta(int tipoConsulta, BloqueoBean bloqueo){
		BloqueoBean bloqueoBean = null;
		switch (tipoConsulta) {
			case Enum_Con_Bloqueo.principal:		
				bloqueoBean = bloqueoDAO.consultaPrincipal(bloqueo, tipoConsulta);				
				break;				
		}
		if(bloqueoBean!=null){
			bloqueoBean.setAuxMonto(bloqueoBean.getAuxMonto());
		}
		
		return bloqueoBean;
	
		}
	
	
	

	// Lista de saldos bloqueados  WS
   	public Object listaSaldoBloqueoWS( ConsultaSaldoBloqueoBERequest consultaSaldoBloqueoBERequest){
			Object obj= null;
			String cadena = "";
			
			ConsultaSaldoBloqueoBEResponse respuestaLista = new ConsultaSaldoBloqueoBEResponse();
			List<ConsultaSaldoBloqueoBEResponse> listaDescuentosNomina = bloqueoDAO.listaSaldosBloqueadosWS(consultaSaldoBloqueoBERequest);
			if (listaDescuentosNomina != null ){
				cadena = transformArray(listaDescuentosNomina);
			}
					respuestaLista.setListaSaldos(cadena);
					respuestaLista.setCodigoRespuesta("0");
					respuestaLista.setMensajeRespuesta("Consulta Exitosa");
					
					obj=(Object)respuestaLista;
					return obj;
			}	

   	// Separador de campos y registros de la lista de saldos Bloqueados WS
		private String transformArray(List listaSaldos)
	    {
	        String resultado= "";
	        String separadorCampos = "[";
	 		String separadorRegistro = "]";
	 		
	 		BloqueoBean bloqueoBean;
	        if(listaSaldos!= null)
	        {   
	            Iterator<BloqueoBean> it = listaSaldos.iterator();
	            while(it.hasNext())
	            {    
	            	bloqueoBean = (BloqueoBean)it.next();             	
	            	resultado += bloqueoBean.getCuentaAhoID()+separadorCampos+
	            			bloqueoBean.getNatMovimiento()+ separadorCampos +
	            			bloqueoBean.getFechaMov()+ separadorCampos +
	            			bloqueoBean.getDescripcion()+ separadorCampos ;
	            			if(bloqueoBean.getMontoBloq() == null || bloqueoBean.getMontoBloq().isEmpty()){
	            				resultado += "   "+ separadorCampos+
	        	            				bloqueoBean.getAuxMonto()+ separadorRegistro;
	            			}else{
	            			resultado +=bloqueoBean.getMontoBloq()+ separadorCampos+
	            			bloqueoBean.getAuxMonto()+ separadorRegistro;
	            			}
	            }
	        }
	 		if(resultado.length() !=0){
	 				resultado = resultado.substring(0,resultado.length()-1);
	 		}
	        return resultado;
	    }

	
	
	
//-------------GETTER Y SETTER--------------	
	public BloqueoDAO getBloqueoDAO() {
		return bloqueoDAO;
	}

	public void setBloqueoDAO(BloqueoDAO bloqueoDAO) {
		this.bloqueoDAO = bloqueoDAO;
	}
	
}
	
